// mendraw 사이드카 — Mendix Marketplace 브라우저 자동화 + TUI
// Erlang 타겟에서 실행
// HTTP 서버 모드: escript priv/mendraw_sidecar 9999
// Marketplace TUI 모드: escript priv/mendraw_sidecar marketplace /path/to/project

import envoy
import gleam/erlang/process
import gleam/int
import gleam/io
import gleam/list
import gleam/option.{None, Some}
import gleam/result
import mendraw_sidecar/marketplace
import mendraw_sidecar/marketplace/downloader
import mendraw_sidecar/router
import mist

pub fn main() {
  let args = get_arguments()

  case list.find(args, fn(a) { a == "marketplace" }) {
    Ok(_) -> run_marketplace(args)
    Error(_) -> run_http_server(args)
  }
}

/// HTTP 서버 모드 (기존 동작)
fn run_http_server(args: List(String)) -> Nil {
  let port =
    args
    |> list.find_map(int.parse)
    |> result.unwrap(0)

  let assert Ok(_) =
    router.handler()
    |> mist.new
    |> mist.port(port)
    |> mist.start

  io.println("SIDECAR_PORT=" <> int.to_string(port))
  process.sleep_forever()
}

/// chrobot_extra가 Windows에서 필요로 하는 OTP 앱 시작
/// HTTP 서버 모드에서는 mist가 처리하지만, TUI 모드에서는 명시적 필요
@external(erlang, "mendraw_sidecar_ffi", "ensure_apps_started")
fn ensure_apps_started() -> Nil

/// Marketplace TUI 모드
/// 인자: marketplace <project_root>
fn run_marketplace(args: List(String)) -> Nil {
  ensure_apps_started()
  // Shore TUI 모드에서는 chrobot 로그가 화면을 망가뜨리므로 억제
  envoy.set("CHROBOT_LOG_LEVEL", "silent")
  let project_root = case find_arg_after(args, "marketplace") {
    Some(path) -> path
    None -> "."
  }

  // .env에서 PAT 읽기
  case downloader.read_env_value("MENDIX_PAT", project_root) {
    None -> {
      io.println("")
      io.println(
        ".env 파일에 MENDIX_PAT가 필요합니다.\n\n"
        <> "  예시 (.env):\n"
        <> "    MENDIX_PAT=your_personal_access_token\n\n"
        <> "  PAT는 Mendix Portal → Settings → Personal Access Tokens에서 발급합니다.\n"
        <> "  필요한 scope: mx:marketplace-content:read",
      )
    }
    Some(pat) -> marketplace.run(pat, project_root)
  }
}

fn find_arg_after(args: List(String), target: String) -> option.Option(String) {
  case args {
    [] -> None
    [a] if a == target -> None
    [a, next, ..] if a == target -> Some(next)
    [_, ..rest] -> find_arg_after(rest, target)
  }
}

// CLI 인자 취득 — charlist(gleam run)와 binary(escript) 양쪽 처리
@external(erlang, "mendraw_sidecar_ffi", "get_arguments")
fn get_arguments() -> List(String)
