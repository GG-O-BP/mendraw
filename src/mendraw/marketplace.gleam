// Mendix Marketplace 위젯 검색 + 다운로드 — Sidecar TUI 스텁
// 실제 TUI는 sidecar (Erlang 타겟, Shore) 에서 실행됨

import gleam/io
import mendraw/cmd

// ── FFI 선언 ──

@external(javascript, "./marketplace_ffi.mjs", "run_marketplace_tui")
fn run_marketplace_tui() -> Nil

// ── 메인 ──

pub fn main() {
  run_marketplace_tui()
  io.println("")
  cmd.resolve_toml_widgets()
  cmd.generate_widget_bindings()
}
