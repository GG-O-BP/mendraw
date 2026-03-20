// Mendix Marketplace Content API + Playwright 브라우저 다운로드 FFI 어댑터
import { execSync, spawn, fork } from "node:child_process";
import {
  existsSync,
  readFileSync,
  readSync,
  writeFileSync,
  mkdirSync,
  unlinkSync,
} from "node:fs";
import { Some, None } from "../../gleam_stdlib/gleam/option.mjs";
import { toList } from "../gleam.mjs";

// ── 동기 stdin 입력 (Windows/Unix 호환) ──

export function prompt_sync(question) {
  process.stdout.write(question);
  let input = "";
  const buf = Buffer.alloc(1);
  while (true) {
    try {
      const bytesRead = readSync(0, buf, 0, 1);
      if (bytesRead === 0) break;
      const char = buf.toString("utf-8");
      if (char === "\n") break;
      if (char === "\r") continue;
      input += char;
    } catch {
      break;
    }
  }
  return input.trim();
}

// ── .env에서 값 읽기 ──

function readEnvValue(key) {
  if (!existsSync(".env")) return null;
  const lines = readFileSync(".env", "utf-8").split("\n");
  for (const line of lines) {
    const trimmed = line.trim();
    if (trimmed === "" || trimmed.startsWith("#")) continue;
    const re = new RegExp(`^${key}\\s*=\\s*(.+)$`);
    const match = trimmed.match(re);
    if (match) return match[1].replace(/^["']|["']$/g, "").trim();
  }
  return null;
}

export function read_pat() {
  const v = readEnvValue("MENDIX_PAT");
  return v ? new Some(v) : new None();
}

// ── Content API 호출 ──

function curlJson(url, pat) {
  try {
    const result = execSync(
      `curl -s -H "Authorization: MxToken ${pat}" "${url}"`,
      { encoding: "utf-8", shell: true },
    );
    return JSON.parse(result);
  } catch {
    return null;
  }
}

const API_BASE = "https://marketplace-api.mendix.com/v1";
const FETCH_SIZE = 40;
const MX_DIR = ".marketplace-cache";

// ── 모듈 수준 로더 상태 (IPC로 갱신) ──

let loaderWidgets = [];
let loaderOffset = 0;
let loaderDone = false;

// ── 디렉토리 보장 ──

export function ensure_cache_dir() {
  if (!existsSync(MX_DIR)) mkdirSync(MX_DIR, { recursive: true });
}

export function ensure_widgets_dir() {
  if (!existsSync("widgets")) mkdirSync("widgets", { recursive: true });
}

// ── 첫 배치 로드 ──

export function load_first_batch(pat) {
  const url = `${API_BASE}/content?limit=${FETCH_SIZE}&offset=0`;
  const data = curlJson(url, pat);
  if (!data) return [toList([]), 0, true];

  if (data.error) {
    if (data.error.code === 401) {
      console.log("인증 실패 — MENDIX_PAT를 확인하세요");
    } else {
      console.log(`API 에러: ${data.error.message}`);
    }
    return [toList([]), 0, true];
  }

  const items = data.items || [];
  if (items.length === 0) return [toList([]), 0, true];

  const widgets = items.filter((item) => item.type === "Widget" || item.type === "Module");
  const nextOffset = FETCH_SIZE;
  const allDone = items.length < FETCH_SIZE;
  return [toList(widgets), nextOffset, allDone];
}

// ── 백그라운드 로더 ──

export function spawn_loader(pat, offset, widgetsJson) {
  const seedWidgets = JSON.parse(widgetsJson);

  // 초기 상태를 모듈 변수에 저장
  loaderWidgets = seedWidgets;
  loaderOffset = offset;
  loaderDone = false;

  const script = [
    'import { execSync } from "node:child_process";',
    '',
    `const pat = ${JSON.stringify(pat)};`,
    `const FETCH_SIZE = ${FETCH_SIZE};`,
    `let offset = ${offset};`,
    `let widgets = ${JSON.stringify(seedWidgets)};`,
    '',
    'function curlJson(url) {',
    '  try {',
    '    return JSON.parse(execSync(',
    '      \'curl -s -H "Authorization: MxToken \' + pat + \'" "\' + url + \'"\',',
    '      { encoding: "utf-8", shell: true }',
    '    ));',
    '  } catch { return null; }',
    '}',
    '',
    'while (true) {',
    `  const data = curlJson("${API_BASE}/content?limit=" + FETCH_SIZE + "&offset=" + offset);`,
    '  if (!data || data.error || !(data.items?.length)) {',
    '    process.send({ type: "update", widgets, offset, done: true });',
    '    break;',
    '  }',
    '  for (const item of data.items) {',
    '    if (item.type === "Widget" || item.type === "Module") widgets.push(item);',
    '  }',
    '  offset += FETCH_SIZE;',
    '  const done = data.items.length < FETCH_SIZE;',
    '  process.send({ type: "update", widgets, offset, done });',
    '  if (done) break;',
    '}',
  ].join('\n');

  const scriptPath = `${MX_DIR}/loader_${Date.now()}.mjs`;
  writeFileSync(scriptPath, script);
  const child = fork(scriptPath, [], {
    stdio: ['ignore', 'ignore', 'ignore', 'ipc'],
  });
  child.on('message', (msg) => {
    if (msg && msg.type === "update") {
      loaderWidgets = msg.widgets;
      loaderOffset = msg.offset;
      loaderDone = !!msg.done;
    }
  });
  child.on('exit', () => {
    loaderDone = true;
  });
  return { child, scriptPath };
}

// ── 로더 상태 동기화 ──

export function sync_from_loader() {
  return [toList(loaderWidgets), loaderOffset, loaderDone];
}

// ── 로더 관리 ──

export function cleanup_loader(loader) {
  if (!loader) return;
  try { loader.child.kill(); } catch {}
  try { unlinkSync(loader.scriptPath); } catch {}
  loaderWidgets = [];
  loaderOffset = 0;
  loaderDone = false;
}

export function kill_loader(loader) {
  if (!loader) return;
  try { loader.child.kill(); } catch {}
}

// ── SIGINT 핸들러 ──

let currentExitHandler = null;

export function register_exit_handler(loader) {
  remove_exit_handler();
  currentExitHandler = () => {
    cleanup_loader(loader);
    process.exit();
  };
  process.on("SIGINT", currentExitHandler);
}

export function remove_exit_handler() {
  if (currentExitHandler) {
    process.removeListener("SIGINT", currentExitHandler);
    currentExitHandler = null;
  }
}

// ── 위젯 접근자 ──

export function widget_name(item) {
  const n = item.latestVersion ? item.latestVersion.name : null;
  return n ? new Some(n) : new None();
}

export function widget_content_id(item) {
  return item.contentId;
}

export function widget_publisher(item) {
  const p = item.publisher;
  return p ? new Some(p) : new None();
}

export function widget_latest_version(item) {
  const v = item.latestVersion ? item.latestVersion.versionNumber : null;
  return v ? new Some(v) : new None();
}

// ── Playwright 스크립트 실행 ──

const SESSION_PATH = `${MX_DIR}/session.json`;

function esc(s) {
  return s.replace(/\\/g, "\\\\").replace(/'/g, "\\'");
}

function runPw(script, timeout) {
  const tmp = `${MX_DIR}/pw_${Date.now()}.mjs`;
  writeFileSync(tmp, script);
  try {
    return execSync(`node "${tmp}"`, {
      encoding: "utf-8",
      timeout: timeout || 300000,
      shell: true,
      stdio: ["pipe", "pipe", "inherit"],
    }).trim();
  } finally {
    try { unlinkSync(tmp); } catch {}
  }
}

// ── Mendix 로그인 세션 관리 ──

export function ensure_session() {
  if (existsSync(SESSION_PATH)) {
    try {
      const out = runPw(
        `
import { chromium } from 'playwright';
const b = await chromium.launch({ headless: true });
const c = await b.newContext({ storageState: '${esc(SESSION_PATH)}' });
const p = await c.newPage();
await p.goto('https://marketplace.mendix.com/', { waitUntil: 'domcontentloaded' });
await p.waitForTimeout(3000);
const valid = !p.url().includes('login.mendix');
await b.close();
console.log(JSON.stringify({ valid }));
`,
        30000,
      );
      if (JSON.parse(out).valid) return true;
    } catch {}
    console.log("  저장된 세션이 만료되었습니다.");
  }

  console.log("  브라우저에서 Mendix 로그인을 완료하세요...\n");
  try {
    const tmp = `${MX_DIR}/pw_${Date.now()}.mjs`;
    writeFileSync(
      tmp,
      `
import { chromium } from 'playwright';
const b = await chromium.launch({ headless: false });
const c = await b.newContext();
const p = await c.newPage();
await p.goto('https://login.mendix.com/');
await p.waitForURL(u => !u.toString().includes('login.mendix'), { timeout: 300000 });
await c.storageState({ path: '${esc(SESSION_PATH)}' });
await b.close();
`,
    );
    try {
      execSync(`node "${tmp}"`, {
        timeout: 300000,
        shell: true,
        stdio: "inherit",
      });
    } finally {
      try { unlinkSync(tmp); } catch {}
    }
    if (existsSync(SESSION_PATH)) {
      console.log("  로그인 성공!\n");
      return true;
    }
    console.log("  세션 파일이 생성되지 않았습니다.\n");
    return false;
  } catch (e) {
    console.log(`  로그인 실패: ${e.message}\n`);
    return false;
  }
}

// ── Content API로 버전 목록 조회 ──

export function fetch_versions(contentId, pat) {
  const url = `${API_BASE}/content/${contentId}/versions`;
  const data = curlJson(url, pat);
  if (!data || !data.items) return toList([]);
  const sorted = data.items.sort(
    (a, b) => new Date(b.publicationDate) - new Date(a.publicationDate),
  );
  return toList(sorted);
}

// ── Playwright로 버전별 다운로드 정보 추출 ──

export function get_all_version_info(contentIds) {
  const ids = JSON.stringify(contentIds.toArray());
  try {
    const out = runPw(
      `
import { chromium } from 'playwright';

const ids = ${ids};
const results = {};

const b = await chromium.launch({ headless: true });
const c = await b.newContext({ storageState: '${esc(SESSION_PATH)}' });
const p = await c.newPage();

for (const id of ids) {
  const responsePromises = [];

  const xasHandler = (response) => {
    if (!response.url().includes('/xas/')) return;
    responsePromises.push(response.json().catch(() => null));
  };
  p.on('response', xasHandler);

  try {
    await p.goto('https://marketplace.mendix.com/link/component/' + id, {
      waitUntil: 'networkidle',
      timeout: 30000,
    });

    let tabClicked = false;
    const tabSelectors = [
      'a.mx-name-tabPage10',
      'a[role="tab"]:has-text("Releases")',
      'text="Releases"',
    ];
    for (const sel of tabSelectors) {
      try {
        const tab = p.locator(sel).first();
        if (await tab.isVisible({ timeout: 2000 }).catch(() => false)) {
          await tab.click();
          await p.waitForLoadState('networkidle');
          tabClicked = true;
          break;
        }
      } catch {}
    }

    await p.waitForTimeout(3000);
  } catch (e) {
    process.stderr.write('  [pw] 오류 (id=' + id + '): ' + e.message + '\\n');
  }

  p.removeListener('response', xasHandler);

  const versions = [];
  const seen = new Set();
  const responses = await Promise.all(responsePromises);

  for (const json of responses) {
    if (!json || !json.objects) continue;
    for (const obj of json.objects) {
      if (obj.objectType !== 'AppStore.Version') continue;
      const attrs = obj.attributes;
      if (!attrs?.S3ObjectId?.value) continue;
      const s3Id = attrs.S3ObjectId.value;
      if (seen.has(s3Id)) continue;
      seen.add(s3Id);
      versions.push({
        s3ObjectId: s3Id,
        reactReady: !!attrs?.IsReactClientReady?.value,
        publishDate: attrs.PublishDate?.value || 0,
        versionNumber: attrs.DisplayVersionNumber?.value || null,
      });
    }
  }

  results[id] = versions;

  if (versions.length === 0) {
    process.stderr.write('  [pw] 다운로드 가능한 버전 없음 (id=' + id + ')\\n');
  }
}

await b.close();
console.log(JSON.stringify(results));
`,
      180000,
    );
    return JSON.parse(out);
  } catch (e) {
    console.log(`        Playwright 오류: ${e.message}`);
    return {};
  }
}

/// VersionInfoMap에서 특정 content_id의 XAS 버전 목록 추출
export function get_version_info_for(map, contentId) {
  return toList(map[contentId] || []);
}

// ── 버전 목록 병합 (Content API + XAS) ──

function extractS3Template(xasVersions) {
  for (const x of xasVersions) {
    if (!x.s3ObjectId) continue;
    const parts = x.s3ObjectId.split("/");
    if (parts.length >= 4) {
      return { prefix: parts.slice(0, 2).join("/"), fileName: parts.slice(3).join("/") };
    }
  }
  return null;
}

function buildXasIndex(xasVersions) {
  const byVersion = new Map();
  for (const x of xasVersions) {
    if (x.versionNumber) byVersion.set(x.versionNumber, x);
    if (x.s3ObjectId) {
      const parts = x.s3ObjectId.split("/");
      if (parts.length >= 4) byVersion.set(parts[2], x);
    }
  }
  return byVersion;
}

export function merge_version_data(apiVersions, xasVersions) {
  const apiArr = apiVersions.toArray();
  const xasArr = xasVersions.toArray();
  const xasIndex = buildXasIndex(xasArr);
  const s3Template = extractS3Template(xasArr);

  const merged = apiArr.map((api) => {
    const xas = xasIndex.get(api.versionNumber) || null;

    if (xas) {
      return {
        versionNumber: api.versionNumber,
        publicationDate: api.publicationDate,
        minMendixVersion: api.minSupportedMendixVersion || null,
        s3ObjectId: xas.s3ObjectId,
        reactReady: xas.reactReady,
        downloadable: true,
      };
    }

    if (s3Template) {
      return {
        versionNumber: api.versionNumber,
        publicationDate: api.publicationDate,
        minMendixVersion: api.minSupportedMendixVersion || null,
        s3ObjectId: `${s3Template.prefix}/${api.versionNumber}/${s3Template.fileName}`,
        reactReady: null,
        downloadable: true,
      };
    }

    return {
      versionNumber: api.versionNumber,
      publicationDate: api.publicationDate,
      minMendixVersion: api.minSupportedMendixVersion || null,
      s3ObjectId: null,
      reactReady: null,
      downloadable: false,
    };
  });

  return toList(merged);
}

// ── 버전 접근자 ──

export function version_number(v) {
  return v.versionNumber;
}

export function version_date(v) {
  return v.publicationDate ? new Some(v.publicationDate) : new None();
}

export function version_min_mendix(v) {
  return v.minMendixVersion ? new Some(v.minMendixVersion) : new None();
}

export function version_downloadable(v) {
  return !!v.downloadable;
}

export function version_react_ready(v) {
  if (v.reactReady === true) return new Some(true);
  if (v.reactReady === false) return new Some(false);
  return new None();
}

export function version_s3_id(v) {
  return v.s3ObjectId ? new Some(v.s3ObjectId) : new None();
}

// ── S3 URL에서 다운로드 ──

export function download_from_url(url) {
  const fileName = url.split("/").pop();
  const dest = `widgets/${fileName}`;

  if (existsSync(dest)) {
    console.log(`        → ${fileName} 이미 존재 (스킵)`);
    return new Some(fileName);
  }

  try {
    execSync(`curl -s -L -o "${dest}" "${url}"`, { shell: true });
    return new Some(fileName);
  } catch {
    console.log(`        ✗ 다운로드 실패`);
    return new None();
  }
}

// ── 위젯 JSON 변환 ──

export function widgets_to_json(widgets) {
  return JSON.stringify(widgets.toArray());
}

// ── TUI 입력 ──

export function is_tty() {
  return !!process.stdin.isTTY;
}

// ── 비동기 키 리더 (stdin flowing 유지) ──

let stdinActive = false;
let keyQueue = [];
let keyResolver = null;
let keyTimer = null;

function ensureStdin() {
  if (stdinActive) return;
  stdinActive = true;
  process.stdin.on('data', onStdinData);
  process.stdin.resume();
}

function onStdinData(data) {
  const buf = Buffer.isBuffer(data) ? data : Buffer.from(String(data), 'utf8');
  const key = parseKeyBuf(buf);
  if (keyResolver) {
    if (keyTimer) { clearTimeout(keyTimer); keyTimer = null; }
    const r = keyResolver;
    keyResolver = null;
    r(key);
  } else {
    keyQueue.push(key);
  }
}

function parseKeyBuf(buf) {
  if (buf.length === 0) return [0, ""];
  const b = buf[0];

  if (b === 0x1b) {
    if (buf.length >= 3 && buf[1] === 0x5b) {
      if (buf[2] === 65) return [1, ""];  // Up
      if (buf[2] === 66) return [2, ""];  // Down
      if (buf[2] === 67) return [3, ""];  // Right
      if (buf[2] === 68) return [4, ""];  // Left
      if (buf[2] === 72) return [10, ""]; // Home
      if (buf[2] === 70) return [11, ""]; // End
      if (buf.length >= 4 && buf[3] === 0x7e) {
        if (buf[2] === 53) return [12, ""];  // PageUp
        if (buf[2] === 54) return [13, ""];  // PageDown
      }
    }
    return [6, ""];  // Escape
  }

  if (b === 0x0d || b === 0x0a) return [5, ""];  // Enter
  if (b === 0x7f || b === 0x08) return [7, ""];   // Backspace
  if (b === 0x03) return [8, ""];                  // Ctrl+C
  if (b === 0x09) return [9, "\t"];                // Tab

  // UTF-8 (전체 버퍼)
  let totalBytes = 1;
  if (b >= 0xc0 && b < 0xe0) totalBytes = 2;
  else if (b >= 0xe0 && b < 0xf0) totalBytes = 3;
  else if (b >= 0xf0) totalBytes = 4;
  return [9, buf.slice(0, totalBytes).toString("utf-8")];
}

// timeout_ms: 0 = 무한 대기, >0 = 타임아웃(ms) 후 [0,""] 반환
export function poll_key_raw(timeout_ms) {
  ensureStdin();
  if (keyQueue.length > 0) {
    return Promise.resolve(keyQueue.shift());
  }
  return new Promise(resolve => {
    if (timeout_ms > 0) {
      keyTimer = setTimeout(() => {
        keyResolver = null;
        keyTimer = null;
        resolve([0, ""]);
      }, timeout_ms);
    }
    keyResolver = resolve;
  });
}

export function exit_process() {
  process.exit(0);
}

// ── 스피너 애니메이션 ──

let spinnerChild = null;

export function start_spinner(label, row) {
  stop_spinner();
  const safeLabel = label
    .replace(/\\/g, "\\\\")
    .replace(/'/g, "\\'")
    .replace(/\n/g, " ");
  const scriptPath = `${MX_DIR}/spinner_${Date.now()}.mjs`;
  writeFileSync(
    scriptPath,
    `const f='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'.split('');let i=0;
setInterval(()=>{process.stdout.write('\\x1b[${row};1H\\x1b[2K  '+f[i++%f.length]+' ${safeLabel}')},80);`,
  );
  spinnerChild = spawn(process.execPath, [scriptPath], {
    stdio: ["pipe", "inherit", "pipe"],
  });
  spinnerChild.unref();
  spinnerChild._scriptPath = scriptPath;
}

export function stop_spinner() {
  if (spinnerChild) {
    try { spinnerChild.kill(); } catch {}
    try { unlinkSync(spinnerChild._scriptPath); } catch {}
    spinnerChild = null;
  }
}

// 프로세스 종료 시 스피너 정리
process.on("exit", () => { stop_spinner(); });
