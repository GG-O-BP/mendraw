// 위젯 .mpk 파일 파싱 + 바인딩 생성 + TOML 위젯 관리 FFI 어댑터
import { execSync, spawn } from "node:child_process";
import { existsSync, readFileSync, writeFileSync, mkdirSync, readdirSync, statSync, readSync } from "node:fs";
import { resolve } from "node:path";
import { inflateRawSync } from "node:zlib";
import { Some, None } from "../../gleam_stdlib/gleam/option.mjs";

// ── 사이드카 HTTP 클라이언트 (cmd 전용) ──

let _sidecarProc = null;
let _sidecarPort = null;

function findEscriptPath() {
  const cwdPriv = resolve("priv/mendraw_sidecar");
  if (existsSync(cwdPriv)) return cwdPriv;
  const devPriv = resolve("build/dev/javascript/mendraw/priv/mendraw_sidecar");
  if (existsSync(devPriv)) return devPriv;
  const pkgPriv = resolve("build/packages/mendraw/priv/mendraw_sidecar");
  if (existsSync(pkgPriv)) return pkgPriv;
  return null;
}

function getSidecarConfig() {
  if (existsSync("sidecar/gleam.toml")) {
    return { mode: "gleam", dir: "sidecar", module: "mendraw_sidecar" };
  }
  const escriptPath = findEscriptPath();
  if (escriptPath) {
    return { mode: "escript", path: escriptPath };
  }
  throw new Error(
    "사이드카를 찾을 수 없습니다.\n" +
    "  - 로컬 개발: sidecar/ 디렉토리가 필요합니다\n" +
    "  - 프로덕션: priv/mendraw_sidecar escript가 필요합니다\n" +
    "  빌드: cd sidecar && gleam run -m gleescript -- --out ../priv"
  );
}

function startSidecar() {
  if (_sidecarProc && _sidecarPort) return _sidecarPort;
  const config = getSidecarConfig();
  const port = 10000 + Math.floor(Math.random() * 50000);
  let proc;
  if (config.mode === "gleam") {
    proc = spawn("gleam", ["run", "-m", config.module, "--", String(port)], {
      cwd: config.dir, stdio: ["ignore", "pipe", "inherit"],
    });
  } else {
    proc = spawn("escript", [config.path, String(port)], {
      stdio: ["ignore", "pipe", "inherit"],
    });
  }
  const deadline = Date.now() + 30000;
  while (Date.now() < deadline) {
    try {
      const result = execSync(
        `curl -s "http://127.0.0.1:${port}/health"`,
        { encoding: "utf-8", timeout: 3000, shell: true },
      );
      if (JSON.parse(result).status === "ok") {
        _sidecarProc = proc;
        _sidecarPort = port;
        proc.on("exit", () => { _sidecarProc = null; _sidecarPort = null; });
        return port;
      }
    } catch {}
    Atomics.wait(new Int32Array(new SharedArrayBuffer(4)), 0, 0, 500);
  }
  try { proc.kill(); } catch {}
  throw new Error("사이드카 시작 실패 (30초 타임아웃)");
}

function callSidecar(path, body, timeout) {
  const port = startSidecar();
  const result = execSync(
    `curl -s -X POST -H "Content-Type: application/json" -d @- "http://127.0.0.1:${port}${path}"`,
    { input: JSON.stringify(body), encoding: "utf-8", timeout: timeout || 300000, shell: true },
  );
  const trimmed = result.trim();
  if (!trimmed) throw new Error("사이드카 응답 없음");
  return JSON.parse(trimmed);
}

function stopSidecar() {
  if (!_sidecarPort) return;
  try {
    execSync(
      `curl -s -X POST "http://127.0.0.1:${_sidecarPort}/shutdown"`,
      { encoding: "utf-8", timeout: 3000, shell: true },
    );
  } catch {}
  try { _sidecarProc?.kill(); } catch {}
  _sidecarProc = null;
  _sidecarPort = null;
}

process.on("exit", stopSidecar);

export function file_exists(path) {
  return existsSync(path);
}

// ── TOML 파서/라이터 (tools.mendraw 섹션) ──

const TOML_MX_DIR = ".marketplace-cache";
const TOML_SESSION_PATH = `${TOML_MX_DIR}/session.json`;
const TOML_API_BASE = "https://marketplace-api.mendix.com/v1";

function parseTomlValue(raw) {
  if (raw.startsWith('"') && raw.endsWith('"')) return raw.slice(1, -1);
  if (raw.startsWith('[') && raw.endsWith(']')) {
    const inner = raw.slice(1, -1).trim();
    if (inner === "") return [];
    return inner.split(',').map(s => {
      s = s.trim();
      if (s.startsWith('"') && s.endsWith('"')) return s.slice(1, -1);
      return s;
    });
  }
  const num = parseInt(raw, 10);
  if (!isNaN(num) && String(num) === raw) return num;
  if (raw === "true") return true;
  if (raw === "false") return false;
  return raw;
}

function parseMendrawToml() {
  if (!existsSync("gleam.toml")) return null;
  const content = readFileSync("gleam.toml", "utf-8");
  const lines = content.split(/\r?\n/);
  const result = { widgets: {} };
  let currentSection = null;

  for (const line of lines) {
    const trimmed = line.trim();
    if (trimmed === "" || trimmed.startsWith("#")) continue;

    const sectionMatch = trimmed.match(/^\[(.+)\]$/);
    if (sectionMatch) {
      const path = sectionMatch[1];
      if (path === "tools.mendraw") currentSection = "root";
      else if (path.startsWith("tools.mendraw.widgets.")) {
        let wn = path.slice("tools.mendraw.widgets.".length);
        if (wn.startsWith('"') && wn.endsWith('"')) wn = wn.slice(1, -1);
        currentSection = "widgets." + wn;
        if (!result.widgets[wn]) result.widgets[wn] = {};
      } else currentSection = null;
      continue;
    }

    if (!currentSection) continue;

    const kvMatch = trimmed.match(/^("(?:[^"\\]|\\.)*"|[A-Za-z0-9_-]+)\s*=\s*(.+)$/);
    if (!kvMatch) continue;

    let key = kvMatch[1].trim();
    if (key.startsWith('"') && key.endsWith('"')) key = key.slice(1, -1);
    const value = parseTomlValue(kvMatch[2].trim());

    if (currentSection.startsWith("widgets.")) {
      const wn = currentSection.slice("widgets.".length);
      result.widgets[wn][key] = value;
    }
  }

  return result;
}

function quoteTomlSegment(key) {
  return /[^A-Za-z0-9_-]/.test(key) ? `"${key}"` : key;
}

function formatTomlValue(value) {
  if (typeof value === "string") return `"${value}"`;
  if (typeof value === "number") return String(value);
  if (typeof value === "boolean") return value ? "true" : "false";
  if (Array.isArray(value)) return "[" + value.map(v => `"${v}"`).join(", ") + "]";
  return String(value);
}

function writeTomlKey(sectionPath, key, value) {
  const content = readFileSync("gleam.toml", "utf-8");
  const lines = content.split(/\r?\n/);
  const sectionHeader = `[${sectionPath}]`;
  let sectionStart = -1;
  let sectionEnd = lines.length;

  for (let i = 0; i < lines.length; i++) {
    const trimmed = lines[i].trim();
    if (trimmed === sectionHeader) sectionStart = i;
    else if (sectionStart >= 0 && /^\[/.test(trimmed)) { sectionEnd = i; break; }
  }

  if (sectionStart === -1) {
    writeTomlSection(sectionPath, [[key, value]]);
    return;
  }

  const needsQuote = /[^A-Za-z0-9_-]/.test(key);
  const formattedKey = needsQuote ? `"${key}"` : key;
  const newLine = `${formattedKey} = ${formatTomlValue(value)}`;

  let keyLine = -1;
  let commentedKeyLine = -1;
  for (let i = sectionStart + 1; i < sectionEnd; i++) {
    const trimmed = lines[i].trim();
    const kvMatch = trimmed.match(/^("(?:[^"\\]|\\.)*"|[A-Za-z0-9_-]+)\s*=\s*/);
    if (kvMatch) {
      let k = kvMatch[1].trim();
      if (k.startsWith('"') && k.endsWith('"')) k = k.slice(1, -1);
      if (k === key) { keyLine = i; break; }
    }
    const commentMatch = trimmed.match(/^#\s*("(?:[^"\\]|\\.)*"|[A-Za-z0-9_-]+)\s*=\s*/);
    if (commentMatch) {
      let k = commentMatch[1].trim();
      if (k.startsWith('"') && k.endsWith('"')) k = k.slice(1, -1);
      if (k === key) commentedKeyLine = i;
    }
  }

  if (keyLine >= 0) lines[keyLine] = newLine;
  else if (commentedKeyLine >= 0) lines[commentedKeyLine] = newLine;
  else lines.splice(sectionEnd, 0, newLine);

  writeFileSync("gleam.toml", lines.join("\n"));
}

function writeTomlSection(sectionPath, entries) {
  const content = readFileSync("gleam.toml", "utf-8");
  const lines = content.split(/\r?\n/);
  const sectionHeader = `[${sectionPath}]`;

  for (const line of lines) {
    if (line.trim() === sectionHeader) {
      for (const [key, value] of entries) writeTomlKey(sectionPath, key, value);
      return;
    }
  }

  let lastMendrawEnd = -1;
  let inMendraw = false;
  for (let i = 0; i < lines.length; i++) {
    const trimmed = lines[i].trim();
    if (trimmed.startsWith("[tools.mendraw")) { inMendraw = true; lastMendrawEnd = i; }
    else if (inMendraw && /^\[/.test(trimmed) && !trimmed.startsWith("[tools.mendraw")) break;
    else if (inMendraw) lastMendrawEnd = i;
  }

  const block = [`\n${sectionHeader}`];
  for (const [key, value] of entries) {
    const needsQuote = /[^A-Za-z0-9_-]/.test(key);
    const fk = needsQuote ? `"${key}"` : key;
    block.push(`${fk} = ${formatTomlValue(value)}`);
  }

  if (lastMendrawEnd >= 0) lines.splice(lastMendrawEnd + 1, 0, ...block);
  else lines.push(...block);

  writeFileSync("gleam.toml", lines.join("\n"));
}

// ── TOML 위젯 다운로드 헬퍼 ──

function curlJsonSimple(url, pat) {
  try {
    const result = execSync(
      `curl -s -H "Authorization: MxToken ${pat}" "${url}"`,
      { encoding: "utf-8", shell: true },
    );
    return JSON.parse(result);
  } catch { return null; }
}

function ensureSessionForResolve() {
  if (!existsSync(TOML_MX_DIR)) mkdirSync(TOML_MX_DIR, { recursive: true });
  const sessionPath = resolve(TOML_SESSION_PATH);
  try {
    const result = callSidecar(
      "/session/ensure",
      { session_path: sessionPath },
      310000,
    );
    if (result.ok === true) return true;
    console.log(`  세션 실패: ${result.error || "알 수 없는 오류"}`);
    return false;
  } catch (e) {
    console.log(`  세션 확인 실패: ${e.message}`);
    return false;
  }
}

function searchContentByName(name, pat) {
  const url = `${TOML_API_BASE}/content?name=${encodeURIComponent(name)}`;
  const data = curlJsonSimple(url, pat);
  if (!data?.items) return null;
  const match = data.items.find(i => i.type === "Widget" || i.type === "Module");
  return match ? match.contentId : null;
}

function getS3IdForVersion(contentId, targetVersion) {
  const sessionPath = resolve(TOML_SESSION_PATH);
  try {
    const result = callSidecar(
      "/versions/single",
      { session_path: sessionPath, content_id: contentId, target_version: targetVersion },
      180000,
    );
    return result?.s3_id || null;
  } catch (e) {
    console.log(`  버전 조회 실패: ${e.message}`);
    return null;
  }
}

function promptSyncSimple(question) {
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
    } catch { break; }
  }
  return input.trim();
}

function readEnvValueSimple(key) {
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

// 간단한 TOML key=value 파싱 (meta.toml 읽기용)
function parseMetaToml(path) {
  const content = readFileSync(path, "utf-8");
  const result = {};
  for (const line of content.split(/\r?\n/)) {
    const m = line.match(/^(\w+)\s*=\s*(.+)$/);
    if (m) result[m[1]] = parseTomlValue(m[2].trim());
  }
  return result;
}

function downloadAndExtractToCache(name, version, id, url) {
  const cacheDir = `build/widgets/${name}`;
  if (!existsSync(cacheDir)) mkdirSync(cacheDir, { recursive: true });

  const tmpPath = `${cacheDir}/_tmp.mpk`;
  try {
    execSync(`curl -s -L -o "${tmpPath}" "${url}"`, { shell: true });
  } catch {
    console.log(`${name} — 다운로드 실패`);
    return false;
  }
  if (!existsSync(tmpPath)) {
    console.log(`${name} — 다운로드 실패`);
    return false;
  }

  try {
    const buf = readFileSync(tmpPath);
    const entries = listZipEntries(buf);

    // package.xml 저장
    try {
      writeFileSync(`${cacheDir}/package.xml`, readZipEntry(buf, "package.xml"));
    } catch {}

    // 위젯 XML 경로 추출 + 저장
    const pkgXml = readZipEntry(buf, "package.xml").toString("utf-8");
    const widgetFilePaths = extractAllWidgetFilePaths(pkgXml);
    for (const xmlPath of widgetFilePaths) {
      try {
        const xml = readZipEntry(buf, xmlPath);
        const fn = xmlPath.substring(xmlPath.lastIndexOf("/") + 1);
        writeFileSync(`${cacheDir}/${fn}`, xml);
      } catch {}
    }

    // .mjs 추출
    for (const entry of entries) {
      if (entry.endsWith(".mjs")) {
        try {
          const content = readZipEntry(buf, entry);
          const fn = entry.substring(entry.lastIndexOf("/") + 1);
          writeFileSync(`${cacheDir}/${fn}`, content);
        } catch {}
      }
    }

    // .css 추출 (editorPreview 제외)
    for (const entry of entries) {
      if (entry.endsWith(".css") && !entry.includes("editorPreview")) {
        try {
          const content = readZipEntry(buf, entry);
          const fn = entry.substring(entry.lastIndexOf("/") + 1);
          writeFileSync(`${cacheDir}/${fn}`, content);
        } catch {}
      }
    }

    // Classic 위젯 감지 (.mjs가 없으면 Classic)
    const isClassic = !entries.some(e => e.endsWith(".mjs"));
    if (isClassic) {
      // Classic: .js, .html 파일을 ZIP 경로 구조 유지하여 추출
      for (const entry of entries) {
        if (entry.endsWith("/")) continue;
        if (entry.endsWith(".js") || entry.endsWith(".html")) {
          try {
            const outPath = `${cacheDir}/${entry}`;
            const dir = outPath.substring(0, outPath.lastIndexOf("/"));
            mkdirSync(dir, { recursive: true });
            writeFileSync(outPath, readZipEntry(buf, entry));
          } catch {}
        }
      }
    }

    // meta.toml 기록
    let toml = `version = "${version}"\n`;
    if (id != null) toml += `id = ${id}\n`;
    if (isClassic) toml += `classic = true\n`;
    writeFileSync(`${cacheDir}/meta.toml`, toml);

    try { unlinkSync(tmpPath); } catch {}
    console.log(`${name} v${version} — 캐시 완료`);
    return true;
  } catch (e) {
    console.log(`${name} — 추출 실패: ${e.message}`);
    try { unlinkSync(tmpPath); } catch {}
    return false;
  }
}

// gleam.toml [tools.mendraw.widgets.*]에 등록된 위젯을 다운로드/캐시한다
export function resolve_toml_widgets() {
  const config = parseMendrawToml();
  if (!config?.widgets || Object.keys(config.widgets).length === 0) return;

  for (const [name, widget] of Object.entries(config.widgets)) {
    if (!widget.version) {
      console.log(`경고: ${name} 위젯에 version이 지정되지 않았습니다`);
      continue;
    }

    // 캐시 확인
    const metaPath = `build/widgets/${name}/meta.toml`;
    if (existsSync(metaPath)) {
      try {
        const meta = parseMetaToml(metaPath);
        if (meta.version === widget.version) {
          console.log(`${name} v${widget.version} — 캐시 사용`);
          continue;
        }
      } catch {}
    }

    // s3_id 직접 다운로드
    if (widget.s3_id) {
      const url = `https://files.appstore.mendix.com/${widget.s3_id}`;
      downloadAndExtractToCache(name, widget.version, widget.id || null, url);
      continue;
    }

    // id 없으면 Content API 검색
    let contentId = widget.id;
    if (!contentId) {
      const pat = readEnvValueSimple("MENDIX_PAT");
      if (!pat) {
        console.log(`${name} — PAT 필요: .env에 MENDIX_PAT 설정`);
        continue;
      }
      contentId = searchContentByName(name, pat);
      if (!contentId) {
        console.log(`'${name}' 위젯을 찾을 수 없습니다`);
        continue;
      }
      writeTomlKey(`tools.mendraw.widgets.${quoteTomlSegment(name)}`, "id", contentId);
    }

    // 사이드카 세션 + s3_id 확보
    if (!ensureSessionForResolve()) {
      console.log("로그인 실패");
      continue;
    }
    const s3_id = getS3IdForVersion(contentId, widget.version);
    if (!s3_id) {
      console.log(`'${name}' v${widget.version} s3_id 확보 실패`);
      continue;
    }

    // s3_id 저장 여부 확인
    const answer = promptSyncSimple(`  ${name}의 s3_id를 gleam.toml에 저장하시겠습니까? (y/n): `);
    if (answer.toLowerCase() === "y") {
      writeTomlKey(`tools.mendraw.widgets.${quoteTomlSegment(name)}`, "s3_id", s3_id);
    }

    // 다운로드 + 추출
    downloadAndExtractToCache(name, widget.version, contentId, `https://files.appstore.mendix.com/${s3_id}`);
  }
}

// gleam.toml에 위젯 항목을 쓰기/업데이트한다
export function write_widget_toml(name, version, id_option, s3_id_option) {
  const entries = [["version", version]];
  if (id_option instanceof Some) entries.push(["id", id_option[0]]);
  if (s3_id_option instanceof Some) entries.push(["s3_id", s3_id_option[0]]);

  const sectionPath = `tools.mendraw.widgets.${quoteTomlSegment(name)}`;
  const config = parseMendrawToml();
  const existing = config?.widgets?.[name];

  if (existing) {
    for (const [key, value] of entries) writeTomlKey(sectionPath, key, value);
  } else {
    writeTomlSection(sectionPath, entries);
  }
}

// .mpk를 다운로드하고 build/widgets/{name}/에 추출한다 (marketplace용)
export function download_to_cache(url, name, version, id_option) {
  const id = (id_option instanceof Some) ? id_option[0] : null;
  return downloadAndExtractToCache(name, version, id, url);
}

// ZIP 엔트리 목록을 반환한다 (Central Directory 기반)
function listZipEntries(buf) {
  let eocdOff = -1;
  for (let i = buf.length - 22; i >= 0; i--) {
    if (buf.readUInt32LE(i) === 0x06054b50) { eocdOff = i; break; }
  }
  if (eocdOff === -1) throw new Error("EOCD를 찾을 수 없습니다");

  const cdOff = buf.readUInt32LE(eocdOff + 16);
  const totalEntries = buf.readUInt16LE(eocdOff + 10);
  const entries = [];
  let off = cdOff;

  for (let i = 0; i < totalEntries; i++) {
    const nameLen = buf.readUInt16LE(off + 28);
    const extraLen = buf.readUInt16LE(off + 30);
    const commentLen = buf.readUInt16LE(off + 32);
    entries.push(buf.toString("utf-8", off + 46, off + 46 + nameLen));
    off += 46 + nameLen + extraLen + commentLen;
  }

  return entries;
}

// ZIP에서 특정 파일의 내용을 읽는다 (deflate/store 지원)
function readZipEntry(buf, fileName) {
  let eocdOff = -1;
  for (let i = buf.length - 22; i >= 0; i--) {
    if (buf.readUInt32LE(i) === 0x06054b50) { eocdOff = i; break; }
  }
  if (eocdOff === -1) throw new Error("EOCD를 찾을 수 없습니다");

  const cdOff = buf.readUInt32LE(eocdOff + 16);
  const totalEntries = buf.readUInt16LE(eocdOff + 10);
  let off = cdOff;

  for (let i = 0; i < totalEntries; i++) {
    const nameLen = buf.readUInt16LE(off + 28);
    const extraLen = buf.readUInt16LE(off + 30);
    const commentLen = buf.readUInt16LE(off + 32);
    const name = buf.toString("utf-8", off + 46, off + 46 + nameLen);
    const method = buf.readUInt16LE(off + 10);
    const compSize = buf.readUInt32LE(off + 20);
    const localOff = buf.readUInt32LE(off + 42);

    if (name === fileName) {
      const localNameLen = buf.readUInt16LE(localOff + 26);
      const localExtraLen = buf.readUInt16LE(localOff + 28);
      const dataOff = localOff + 30 + localNameLen + localExtraLen;
      const raw = buf.subarray(dataOff, dataOff + compSize);

      if (method === 0) return raw;
      if (method === 8) return inflateRawSync(raw);
      throw new Error("지원하지 않는 압축 방식: " + method);
    }

    off += 46 + nameLen + extraLen + commentLen;
  }

  throw new Error("ZIP 엔트리를 찾을 수 없습니다: " + fileName);
}

// XML 문자열에서 <name>...</name> 추출
function parseWidgetName(xmlString) {
  const match = xmlString.match(/<name>([^<]+)<\/name>/);
  return match ? match[1] : null;
}

// 위젯 이름을 유효한 JS 식별자로 변환한다 ("Progress Bar" → "ProgressBar")
function toSafeIdentifier(name) {
  return name.replace(/[^a-zA-Z0-9_$]/g, "");
}

// 위젯 XML에서 속성 정보(key, required)를 파싱한다
function parseProperties(widgetXml) {
  const properties = [];
  const regex = /<property\s+([^>]*)(?:\/>|>[\s\S]*?<\/property>)/g;
  let match;
  while ((match = regex.exec(widgetXml)) !== null) {
    const attrs = match[1];
    const keyMatch = attrs.match(/key="([^"]+)"/);
    const requiredMatch = attrs.match(/required="([^"]+)"/);
    if (keyMatch) {
      properties.push({
        key: keyMatch[1],
        required: requiredMatch ? requiredMatch[1] === "true" : false,
      });
    }
  }
  return properties;
}

// default export가 존재하는지 판별한다
function hasDefaultExport(src) {
  return /\bexport\s+default\b/.test(src) ||
    /\bexport\s*\{[^}]*\bas\s+default\b/.test(src);
}

// 첫 번째 named export 이름을 추출한다
function findNamedExport(src) {
  // export { Name, ... } — "as default" 항목 제외
  const blockMatch = src.match(/\bexport\s*\{([^}]+)\}/);
  if (blockMatch) {
    for (const entry of blockMatch[1].split(",")) {
      const parts = entry.trim().split(/\s+as\s+/);
      const name = parts.length === 2 ? parts[1].trim() : parts[0].trim();
      if (name && name !== "default") return name;
    }
  }
  // export const/let/var/function/class Name
  const declMatch = src.match(/\bexport\s+(?:const|let|var|function|class)\s+(\w+)/);
  if (declMatch) return declMatch[1];
  return null;
}

// camelCase → snake_case 변환
function toSnakeCase(str) {
  return str
    .replace(/([a-z0-9])([A-Z])/g, "$1_$2")
    .replace(/([A-Z])([A-Z][a-z])/g, "$1_$2")
    .toLowerCase();
}

// 위젯 이름 → Gleam 모듈 파일명 ("Progress Bar" → "progress_bar", "Switch" → "switch")
function toModuleFileName(name) {
  return name
    .replace(/\s+/g, "_")
    .replace(/([a-z0-9])([A-Z])/g, "$1_$2")
    .replace(/([A-Z])([A-Z][a-z])/g, "$1_$2")
    .toLowerCase();
}

const GLEAM_KEYWORDS = new Set([
  "as", "assert", "auto", "case", "const", "delegate", "derive", "echo",
  "else", "fn", "if", "implement", "import", "let", "macro", "opaque",
  "panic", "pub", "return", "test", "todo", "type", "use",
]);

// 속성 key를 Gleam 변수명으로 변환 (snake_case + 예약어 회피)
function toGleamVar(key) {
  const snake = toSnakeCase(key);
  return GLEAM_KEYWORDS.has(snake) ? snake + "_" : snake;
}

// .mpk 위젯의 .gleam 바인딩 파일을 src/widgets/에 생성한다
function generateWidgetGleamFile(widgetName, widgetXml) {
  const props = parseProperties(widgetXml);
  if (props.length === 0) return;

  const requiredProps = props.filter((p) => p.required);
  const optionalProps = props.filter((p) => !p.required);
  const hasOptional = optionalProps.length > 0;
  const moduleFileName = toModuleFileName(widgetName);
  const filePath = `src/widgets/${moduleFileName}.gleam`;

  // 이미 존재하면 덮어쓰지 않는다
  if (existsSync(filePath)) return;

  // 디렉토리 생성
  if (!existsSync("src/widgets")) {
    mkdirSync("src/widgets", { recursive: true });
  }

  // import 섹션
  let imports = "";
  if (hasOptional) {
    imports += "import gleam/option.{None, Some}\n";
  }
  imports += "import mendraw/mendix.{type JsProps}\n";
  imports += "import redraw.{type Element}\n";
  imports += "import redraw/dom/attribute\n";
  imports += "import mendraw/interop\n";
  imports += "import mendraw/widget\n";

  // render 함수 본문
  let body = "";
  for (const prop of requiredProps) {
    body += `  let ${toGleamVar(prop.key)} = mendix.get_prop_required(props, "${prop.key}")\n`;
  }

  body += `\n  let comp = widget.component("${widgetName}")\n`;
  body += "  interop.component_el(\n    comp,\n    [\n";

  for (const prop of requiredProps) {
    body += `      attribute.attribute("${prop.key}", ${toGleamVar(prop.key)}),\n`;
  }
  for (const prop of optionalProps) {
    body += `      optional_attr(props, "${prop.key}"),\n`;
  }

  body += "    ],\n    [],\n  )\n";

  // 파일 내용 조합
  let content = `// ${widgetName} 위젯 바인딩 컴포넌트\n\n`;
  content += imports;
  content += "\n";
  content += `/// ${widgetName} 위젯 렌더링 - props에서 속성을 읽어 위젯에 전달\n`;
  content += "pub fn render(props: JsProps) -> Element {\n";
  content += body;
  content += "}\n";

  if (hasOptional) {
    content += "\n";
    content += "/// optional prop을 조건부 attribute로 변환\n";
    content += "fn optional_attr(props: JsProps, key: String) -> attribute.Attribute {\n";
    content += "  case mendix.get_prop(props, key) {\n";
    content += "    Some(val) -> attribute.attribute(key, val)\n";
    content += "    None -> attribute.none()\n";
    content += "  }\n";
    content += "}\n";
  }

  writeFileSync(filePath, content);
  console.log(`위젯 바인딩 Gleam 파일 생성: ${filePath}`);
}

// package.xml에서 모든 widgetFile path를 추출한다
function extractAllWidgetFilePaths(packageXml) {
  const paths = [];
  const regex = /widgetFile\s+path="([^"]+)"/g;
  let match;
  while ((match = regex.exec(packageXml)) !== null) {
    paths.push(match[1]);
  }
  return paths;
}

// 공통: [경로, 내용] 배열 → 분류된 객체
function classifyClassicFiles(fileEntries) {
  const jsFiles = {}, templateFiles = {}, libFiles = {};
  let css = "";
  for (const [path, content] of fileEntries) {
    if (path.endsWith(".js")) {
      if (path.includes("/lib/")) libFiles[path] = content;
      else jsFiles[path] = content;
    } else if (path.endsWith(".html")) {
      templateFiles[path] = content;
    } else if (path.endsWith(".css")) {
      css += content + "\n";
    }
  }
  return { jsFiles, templateFiles, css: css.trim(), libFiles };
}

// 캐시 디렉토리에서 Classic 에셋을 읽어 분류한다
function readClassicFromCache(cacheDir) {
  const fileEntries = [];
  function walk(dir) {
    for (const name of readdirSync(dir)) {
      const full = `${dir}/${name}`;
      if (statSync(full).isDirectory()) { walk(full); continue; }
      if (name.endsWith(".js") || name.endsWith(".html") || name.endsWith(".css")) {
        const rel = full.substring(cacheDir.length + 1).replace(/\\/g, "/");
        fileEntries.push([rel, readFileSync(full, "utf-8")]);
      }
    }
  }
  walk(cacheDir);
  return classifyClassicFiles(fileEntries);
}

// Classic 위젯 에셋 추출
function extractClassicWidget(buf, entries) {
  const packageXml = readZipEntry(buf, "package.xml").toString("utf-8");

  // widgetFile path에서 위젯 XML 경로 추출
  const widgetFileMatch = packageXml.match(/widgetFile\s+path="([^"]+)"/);
  if (!widgetFileMatch) return null;

  const widgetXmlPath = widgetFileMatch[1];
  let widgetXml;
  try {
    widgetXml = readZipEntry(buf, widgetXmlPath).toString("utf-8");
  } catch {
    return null;
  }

  // 위젯 이름
  const name = parseWidgetName(widgetXml);
  if (!name) return null;

  // 위젯 ID (widget id="..." 속성)
  const idMatch = widgetXml.match(/widget\s+[^>]*id="([^"]+)"/);
  const widgetId = idMatch ? idMatch[1] : null;
  if (!widgetId) return null;

  // 속성 파싱
  const properties = parseProperties(widgetXml);

  // 파일 분류 (classifyClassicFiles 활용)
  const fileEntries = [];
  for (const entry of entries) {
    if (entry.endsWith("/") || entry === "package.xml" || entry === widgetXmlPath) continue;
    try {
      const content = readZipEntry(buf, entry).toString("utf-8");
      fileEntries.push([entry, content]);
    } catch {
      // 추출 실패한 파일은 무시
    }
  }
  const { jsFiles, templateFiles, css, libFiles } = classifyClassicFiles(fileEntries);

  return { name, widgetId, widgetXml, jsFiles, templateFiles, css, libFiles, properties };
}

// Classic 위젯의 .gleam 바인딩 파일을 src/widgets/에 생성한다
function generateClassicGleamFile(widgetName, widgetId, properties) {
  const moduleFileName = toModuleFileName(widgetName);
  const filePath = `src/widgets/${moduleFileName}.gleam`;

  // 이미 존재하면 덮어쓰지 않는다
  if (existsSync(filePath)) return;

  // 디렉토리 생성
  if (!existsSync("src/widgets")) {
    mkdirSync("src/widgets", { recursive: true });
  }

  const requiredProps = properties.filter((p) => p.required);
  const optionalProps = properties.filter((p) => !p.required);
  const hasOptional = optionalProps.length > 0;

  // import 섹션
  let imports = "";
  if (hasOptional) {
    imports += "import gleam/dynamic\n";
    imports += "import gleam/option.{None, Some}\n";
  }
  imports += "import mendraw/classic\n";
  imports += "import mendraw/mendix.{type JsProps}\n";
  imports += "import redraw.{type Element}\n";

  // render 함수 본문
  let body = "";
  for (const prop of requiredProps) {
    body += `  let ${toGleamVar(prop.key)} = mendix.get_prop_required(props, "${prop.key}")\n`;
  }

  body += `\n  classic.render("${widgetId}", [\n`;

  for (const prop of requiredProps) {
    body += `    #("${prop.key}", classic.to_dynamic(${toGleamVar(prop.key)})),\n`;
  }
  for (const prop of optionalProps) {
    body += `    optional_prop(props, "${prop.key}"),\n`;
  }

  body += "  ])\n";

  // 파일 내용 조합
  let content = `// ${widgetName} Classic 위젯 바인딩 컴포넌트\n\n`;
  content += imports;
  content += "\n";
  content += `/// ${widgetName} Classic 위젯 렌더링\n`;
  content += "pub fn render(props: JsProps) -> Element {\n";
  content += body;
  content += "}\n";

  if (hasOptional) {
    content += "\n";
    content += "/// optional prop을 #(key, Dynamic) 튜플로 변환\n";
    content += "fn optional_prop(props: JsProps, key: String) -> #(String, dynamic.Dynamic) {\n";
    content += "  case mendix.get_prop(props, key) {\n";
    content += "    Some(val) -> #(key, classic.to_dynamic(val))\n";
    content += "    None -> #(key, classic.to_dynamic(Nil))\n";
    content += "  }\n";
    content += "}\n";
  }

  writeFileSync(filePath, content);
  console.log(`Classic 위젯 바인딩 Gleam 파일 생성: ${filePath}`);
}

// JS 문자열을 이스케이프한다 (템플릿 리터럴용)
function escapeForTemplate(str) {
  return str.replace(/\\/g, "\\\\").replace(/`/g, "\\`").replace(/\$/g, "\\$");
}

// classic_ffi.mjs 생성
function generateClassicFfi(classicWidgets) {
  if (classicWidgets.length === 0) return;

  // 위젯 에셋 데이터 구조체
  const widgetEntries = [];
  for (const w of classicWidgets) {
    const jsEntries = Object.entries(w.jsFiles)
      .map(([path, code]) => `      "${path}": \`${escapeForTemplate(code)}\``)
      .join(",\n");
    const templateEntries = Object.entries(w.templateFiles)
      .map(([path, html]) => `      "${path}": \`${escapeForTemplate(html)}\``)
      .join(",\n");
    const libEntries = Object.entries(w.libFiles)
      .map(([path, code]) => `      "${path}": \`${escapeForTemplate(code)}\``)
      .join(",\n");

    widgetEntries.push(
      `  "${w.safeId}": {\n` +
      `    widgetId: "${w.widgetId}",\n` +
      `    js: {\n${jsEntries}\n    },\n` +
      `    templates: {\n${templateEntries}\n    },\n` +
      `    css: \`${escapeForTemplate(w.css)}\`,\n` +
      `    libs: {\n${libEntries}\n    },\n` +
      `  }`,
    );
  }

  const content =
    `// @generated mendraw/install — 직접 수정 금지\n` +
    `import * as React from "react";\n\n` +

    `const _classicWidgets = {\n${widgetEntries.join(",\n")}\n};\n\n` +

    // CSS 주입 (한 번만)
    `const _injectedCss = new Set();\n` +
    `function injectCss(name, css) {\n` +
    `  if (!css || _injectedCss.has(name)) return;\n` +
    `  _injectedCss.add(name);\n` +
    `  const style = document.createElement("style");\n` +
    `  style.setAttribute("data-classic-widget", name);\n` +
    `  style.textContent = css;\n` +
    `  document.head.appendChild(style);\n` +
    `}\n\n` +

    // AMD 모듈 등록 (script tag injection)
    `const _registeredModules = new Set();\n` +
    `function registerAmdModules(widget) {\n` +
    `  // lib 파일 먼저 등록\n` +
    `  for (const [path, code] of Object.entries(widget.libs)) {\n` +
    `    const moduleId = path.replace(/\\.js$/, "");\n` +
    `    if (_registeredModules.has(moduleId)) continue;\n` +
    `    _registeredModules.add(moduleId);\n` +
    `    const script = document.createElement("script");\n` +
    `    script.textContent = code;\n` +
    `    document.head.appendChild(script);\n` +
    `  }\n` +
    `  // 위젯 JS 파일 등록\n` +
    `  for (const [path, code] of Object.entries(widget.js)) {\n` +
    `    const moduleId = path.replace(/\\.js$/, "");\n` +
    `    if (_registeredModules.has(moduleId)) continue;\n` +
    `    _registeredModules.add(moduleId);\n` +
    `    const script = document.createElement("script");\n` +
    `    script.textContent = code;\n` +
    `    document.head.appendChild(script);\n` +
    `  }\n` +
    `}\n\n` +

    // Template 캐시 등록
    `function registerTemplates(widget) {\n` +
    `  if (typeof window.require === "undefined" || !window.require.cache) return;\n` +
    `  for (const [path, html] of Object.entries(widget.templates)) {\n` +
    `    const cacheKey = "url:dojo/text!" + path;\n` +
    `    if (!window.require.cache[cacheKey]) {\n` +
    `      window.require.cache[cacheKey] = html;\n` +
    `    }\n` +
    `  }\n` +
    `}\n\n` +

    // Classic 위젯 마운트
    `function mountClassicWidget(widgetId, container, properties) {\n` +
    `  // 위젯 이름에서 에셋 키 추출 ("CameraWidget.widget.CameraWidget" → "CameraWidget")\n` +
    `  const assetKey = widgetId.split(".")[0];\n` +
    `  const widget = _classicWidgets[assetKey];\n` +
    `  if (!widget) {\n` +
    `    console.error("Classic 위젯을 찾을 수 없습니다: " + assetKey);\n` +
    `    return Promise.resolve(null);\n` +
    `  }\n\n` +
    `  // 에셋 등록\n` +
    `  injectCss(assetKey, widget.css);\n` +
    `  registerTemplates(widget);\n` +
    `  registerAmdModules(widget);\n\n` +
    `  // AMD require로 위젯 모듈 로드\n` +
    `  return new Promise((resolve) => {\n` +
    `    if (typeof window.require !== "function") {\n` +
    `      console.error("AMD 로더(window.require)가 없습니다. Mendix 런타임 내에서 실행하세요.");\n` +
    `      resolve(null);\n` +
    `      return;\n` +
    `    }\n` +
    `    window.require([widgetId], (WidgetClass) => {\n` +
    `      try {\n` +
    `        const props = {};\n` +
    `        for (const [key, value] of properties) {\n` +
    `          props[key] = value;\n` +
    `        }\n` +
    `        const instance = new WidgetClass(props, container);\n` +
    `        if (typeof instance.startup === "function") instance.startup();\n` +
    `        resolve(instance);\n` +
    `      } catch (e) {\n` +
    `        console.error("Classic 위젯 마운트 실패: " + e.message);\n` +
    `        resolve(null);\n` +
    `      }\n` +
    `    }, (err) => {\n` +
    `      console.error("Classic 위젯 AMD 로드 실패: " + err);\n` +
    `      resolve(null);\n` +
    `    });\n` +
    `  });\n` +
    `}\n\n` +

    // React 래퍼 컴포넌트
    `function ClassicWidgetWrapper({ widgetId, properties, className }) {\n` +
    `  const containerRef = React.useRef(null);\n` +
    `  const instanceRef = React.useRef(null);\n\n` +
    `  React.useEffect(() => {\n` +
    `    if (!containerRef.current) return;\n` +
    `    let cancelled = false;\n\n` +
    `    mountClassicWidget(widgetId, containerRef.current, properties).then((inst) => {\n` +
    `      if (cancelled) {\n` +
    `        if (inst) destroyWidget(inst);\n` +
    `        return;\n` +
    `      }\n` +
    `      instanceRef.current = inst;\n` +
    `    });\n\n` +
    `    return () => {\n` +
    `      cancelled = true;\n` +
    `      if (instanceRef.current) {\n` +
    `        destroyWidget(instanceRef.current);\n` +
    `        instanceRef.current = null;\n` +
    `      }\n` +
    `    };\n` +
    `  }, [widgetId]);\n\n` +
    `  return React.createElement("div", { ref: containerRef, className: className || undefined });\n` +
    `}\n\n` +

    `function destroyWidget(instance) {\n` +
    `  try {\n` +
    `    if (typeof instance.uninitialize === "function") instance.uninitialize();\n` +
    `    if (typeof instance.destroyRecursive === "function") instance.destroyRecursive();\n` +
    `    else if (typeof instance.destroy === "function") instance.destroy();\n` +
    `  } catch {}\n` +
    `}\n\n` +

    `const MemoizedWrapper = React.memo(ClassicWidgetWrapper);\n\n` +

    // 공개 API
    `export function classic_widget_element(widget_id, properties) {\n` +
    `  const props = properties.toArray();\n` +
    `  return React.createElement(MemoizedWrapper, {\n` +
    `    widgetId: widget_id,\n` +
    `    properties: props,\n` +
    `  });\n` +
    `}\n\n` +

    `export function classic_widget_element_with_class(widget_id, properties, class_name) {\n` +
    `  const props = properties.toArray();\n` +
    `  return React.createElement(MemoizedWrapper, {\n` +
    `    widgetId: widget_id,\n` +
    `    properties: props,\n` +
    `    className: class_name,\n` +
    `  });\n` +
    `}\n`;

  // 빌드 경로에 쓰기
  const basePaths = [
    "build/packages/mendraw/src/mendraw",
    "build/dev/javascript/mendraw/mendraw",
  ];

  let written = 0;
  for (const base of basePaths) {
    try {
      if (!existsSync(base)) {
        try {
          mkdirSync(base, { recursive: true });
        } catch {
          continue;
        }
      }
      writeFileSync(`${base}/classic_ffi.mjs`, content);
      written++;
    } catch {
      continue;
    }
  }

  if (written > 0) {
    const names = classicWidgets.map((w) => w.name).join(", ");
    console.log(`Classic 위젯 바인딩 생성 완료: ${names}`);
  }
}

// build/widgets/ 캐시에서 위젯 바인딩을 생성한다
export function generate_widget_bindings() {
  const hasCacheDir = existsSync("build/widgets");
  if (!hasCacheDir) return;

  const widgets = []; // pluggable: { name, safeId, mjsContent, cssContent }
  const classicWidgets = []; // classic: { name, safeId, widgetId, jsFiles, templateFiles, css, libFiles }
  const processedNames = new Set();

  // ── build/widgets/ 캐시에서 읽기 (TOML 기반) ──
  try {
    const cacheDirs = readdirSync("build/widgets");
    for (const dirName of cacheDirs) {
      const cacheDir = `build/widgets/${dirName}`;
      try {
        if (!statSync(cacheDir).isDirectory()) continue;
      } catch { continue; }
      const metaPath = `${cacheDir}/meta.toml`;
      if (!existsSync(metaPath)) continue;

      const files = readdirSync(cacheDir);
      const mjsFile = files.find(f => f.endsWith(".mjs"));
      if (!mjsFile) {
        // Classic 위젯: meta.toml의 classic 플래그 확인
        try {
          const meta = parseMetaToml(metaPath);
          if (!meta.classic) continue;
        } catch { continue; }

        // widget XML에서 이름/ID/속성 파싱
        const xmlFile = files.find(f => f.endsWith(".xml") && f !== "package.xml");
        if (!xmlFile) continue;
        const widgetXml = readFileSync(`${cacheDir}/${xmlFile}`, "utf-8");
        const widgetName = parseWidgetName(widgetXml);
        if (!widgetName || processedNames.has(widgetName)) continue;
        const idMatch = widgetXml.match(/widget\s+[^>]*id="([^"]+)"/);
        if (!idMatch) continue;

        const { jsFiles, templateFiles, css, libFiles } = readClassicFromCache(cacheDir);
        const properties = parseProperties(widgetXml);
        generateClassicGleamFile(widgetName, idMatch[1], properties);
        classicWidgets.push({
          name: widgetName,
          safeId: toSafeIdentifier(widgetName),
          widgetId: idMatch[1],
          jsFiles, templateFiles, css, libFiles,
        });
        processedNames.add(widgetName);
        continue;
      }

      const mjsContent = readFileSync(`${cacheDir}/${mjsFile}`);
      const cssFile = files.find(f => f.endsWith(".css") && !f.includes("editorPreview"));
      const cssContent = cssFile ? readFileSync(`${cacheDir}/${cssFile}`) : null;

      const xmlFile = files.find(f => f.endsWith(".xml") && f !== "package.xml");
      let widgetName = dirName;
      if (xmlFile) {
        const widgetXml = readFileSync(`${cacheDir}/${xmlFile}`, "utf-8");
        const parsed = parseWidgetName(widgetXml);
        if (parsed) widgetName = parsed;
        generateWidgetGleamFile(widgetName, widgetXml);
      }

      const safeId = toSafeIdentifier(widgetName);
      widgets.push({ name: widgetName, safeId, mjsContent, cssContent });
      processedNames.add(widgetName);
    }
  } catch {}

  if (widgets.length === 0 && classicWidgets.length === 0) return;

  // Pluggable 위젯 바인딩 (widget_ffi.mjs)
  if (widgets.length > 0) {
    const cssImports = widgets
      .filter((w) => w.cssContent)
      .map((w) => `import "./widgets/${w.safeId}.css";`)
      .join("\n");
    const mjsImports = widgets
      .map((w) => {
        const src = w.mjsContent ? w.mjsContent.toString("utf8") : "";
        const path = `./widgets/${w.safeId}.mjs`;
        if (hasDefaultExport(src)) {
          return `import ${w.safeId} from "${path}";`;
        }
        const exportName = findNamedExport(src);
        if (exportName && exportName !== w.safeId) {
          return `import { ${exportName} as ${w.safeId} } from "${path}";`;
        }
        if (exportName) {
          return `import { ${w.safeId} } from "${path}";`;
        }
        return `import ${w.safeId} from "${path}";`;
      })
      .join("\n");
    const widgetEntries = widgets
      .map((w) => `  "${w.name}": ${w.safeId}`)
      .join(",\n");

    const content =
      `// @generated mendraw/install — 직접 수정 금지\n` +
      (cssImports ? cssImports + "\n" : "") +
      mjsImports +
      "\n\n" +
      `const _widgets = {\n${widgetEntries}\n};\n\n` +
      `export function get_widget(name) {\n` +
      `  const w = _widgets[name];\n` +
      `  if (!w) throw new Error("위젯 바인딩에 등록되지 않은 위젯: " + name + ". gleam.toml [tools.mendraw.widgets] 설정을 확인하세요.");\n` +
      `  return w;\n` +
      `}\n`;

    // 빌드 경로에 쓰기
    const basePaths = [
      "build/packages/mendraw/src/mendraw",
      "build/dev/javascript/mendraw/mendraw",
    ];

    let written = 0;
    for (const base of basePaths) {
      try {
        // widget_ffi.mjs
        const dir = base;
        if (!existsSync(dir)) {
          try {
            mkdirSync(dir, { recursive: true });
          } catch {
            continue;
          }
        }
        writeFileSync(`${base}/widget_ffi.mjs`, content);

        // widgets/ 서브 디렉토리
        const widgetsDir = `${base}/widgets`;
        if (!existsSync(widgetsDir)) {
          mkdirSync(widgetsDir, { recursive: true });
        }

        for (const w of widgets) {
          writeFileSync(`${widgetsDir}/${w.safeId}.mjs`, w.mjsContent);
          if (w.cssContent) {
            writeFileSync(`${widgetsDir}/${w.safeId}.css`, w.cssContent);
          }
        }

        written++;
      } catch {
        continue;
      }
    }

    if (written > 0) {
      const names = widgets.map((w) => w.name).join(", ");
      console.log(`위젯 바인딩 생성 완료: ${names}`);
    }
  }

  // Classic 위젯 바인딩 (classic_ffi.mjs)
  generateClassicFfi(classicWidgets);
}
