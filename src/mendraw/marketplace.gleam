// Mendix Marketplace 위젯 검색 + 다운로드 — Sidecar TUI 스텁
// 실제 TUI는 sidecar (Erlang 타겟, Shore) 에서 실행됨

import gleam/io
import mendraw/cmd

// ── Opaque 타입 (sidecar 결과) ──

pub type MarketplaceResult

// ── FFI 선언 ──

@external(javascript, "./marketplace_ffi.mjs", "run_marketplace_tui")
fn run_marketplace_tui() -> MarketplaceResult

@external(javascript, "./marketplace_ffi.mjs", "result_downloaded_count")
fn result_downloaded_count(result: MarketplaceResult) -> Int

// ── 메인 ──

pub fn main() {
  let result = run_marketplace_tui()
  case result_downloaded_count(result) > 0 {
    True -> {
      io.println("")
      cmd.generate_widget_bindings()
    }
    False -> Nil
  }
}
