// Mendix Marketplace TUI — sidecar 실행 스텁
// 실제 TUI는 sidecar (Erlang, Shore) 에서 실행됨
import { spawnSync } from "node:child_process";
import { existsSync, readFileSync, unlinkSync } from "node:fs";
import { resolve, join } from "node:path";

// ── 사이드카 바이너리 탐색 ──

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
    return { mode: "gleam", dir: resolve("sidecar"), module: "mendraw_sidecar" };
  }
  const escriptPath = findEscriptPath();
  if (escriptPath) {
    return { mode: "escript", path: escriptPath };
  }
  throw new Error(
    "사이드카를 찾을 수 없습니다.\n" +
      "  - 로컬 개발: sidecar/ 디렉토리가 필요합니다\n" +
      "  - 프로덕션: priv/mendraw_sidecar escript가 필요합니다\n" +
      "  빌드: cd sidecar && gleam run -m gleescript -- --out ../priv",
  );
}

// ── Marketplace TUI 실행 ──

export function run_marketplace_tui() {
  const config = getSidecarConfig();
  const projectRoot = resolve(".");
  const resultPath = join(projectRoot, ".marketplace-result.json");

  // stdio 모두 inherit — Shore TUI가 터미널 직접 접근 필요
  if (config.mode === "gleam") {
    spawnSync(
      "gleam",
      ["run", "-m", config.module, "--", "marketplace", projectRoot, resultPath],
      { cwd: config.dir, stdio: "inherit" },
    );
  } else {
    spawnSync(
      "escript",
      [config.path, "marketplace", projectRoot, resultPath],
      { stdio: "inherit" },
    );
  }

  // Shore TUI 종료 후 터미널 복원 (Ctrl+C 등 비정상 종료 대응)
  process.stdout.write("\x1b[?25h\x1b[?1049l");

  // 결과 파일에서 JSON 읽기
  try {
    if (existsSync(resultPath)) {
      const content = readFileSync(resultPath, "utf-8").trim();
      try { unlinkSync(resultPath); } catch {}
      return JSON.parse(content);
    }
  } catch {}
  return { downloaded: [] };
}

export function result_downloaded_count(result) {
  return result?.downloaded?.length || 0;
}
