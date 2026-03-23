// Shore TUI 뷰 — Marketplace 화면 렌더링
// Shore의 row 레이아웃이 자동 패딩을 추가하므로,
// 각 행은 단일 ui.text()에 ANSI 코드로 스타일링

import gleam/int
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import mendraw_sidecar/marketplace/content_api.{type Widget}
import mendraw_sidecar/marketplace/version_merger.{type MergedVersion}
import shore
import shore/style
import shore/ui

// ── ANSI 스타일 헬퍼 ──

fn bold(text: String) -> String {
  "\u{001b}[1m" <> text <> "\u{001b}[0m"
}

fn dim(text: String) -> String {
  "\u{001b}[2m" <> text <> "\u{001b}[0m"
}

fn cyan(text: String) -> String {
  "\u{001b}[36m" <> text <> "\u{001b}[0m"
}

fn green(text: String) -> String {
  "\u{001b}[32m" <> text <> "\u{001b}[0m"
}

fn yellow(text: String) -> String {
  "\u{001b}[33m" <> text <> "\u{001b}[0m"
}

fn red(text: String) -> String {
  "\u{001b}[31m" <> text <> "\u{001b}[0m"
}

fn white(text: String) -> String {
  "\u{001b}[37;1m" <> text <> "\u{001b}[0m"
}

// ── Browse 화면 ──

pub fn view_browse(
  items: List(Widget),
  cursor: Int,
  selected: List(Int),
  page: Int,
  total_pages: String,
  status_msg: Option(String),
  all_loaded: Bool,
) -> shore.Node(msg) {
  let header = "  " <> bold(cyan("── Mendix Marketplace ──"))

  let widget_rows =
    list.index_map(items, fn(w, idx) {
      let is_cursor = idx == cursor
      let is_selected = list.contains(selected, idx)
      let marker = case is_cursor, is_selected {
        True, True -> green(" ▸●")
        True, False -> cyan(" ▸ ")
        False, True -> green("  ●")
        False, False -> "   "
      }

      let name = option.unwrap(w.name, "?")
      let version = case w.latest_version {
        Some(v) -> " v" <> v
        None -> ""
      }
      let publisher = case w.publisher {
        Some(p) -> dim(" — " <> p)
        None -> ""
      }
      let id_str = dim(" [" <> int.to_string(w.content_id) <> "]")

      let content = " " <> bold(name) <> version <> publisher <> id_str
      let line = case is_cursor {
        True -> marker <> white(content)
        False -> marker <> content
      }
      ui.text(line)
    })

  let page_info =
    dim("  페이지 " <> int.to_string(page) <> "/" <> total_pages)
  let loading_indicator = case all_loaded {
    True -> ""
    False -> dim(" (로드 중...)")
  }

  let status_line = case status_msg {
    Some(msg) -> msg
    None -> ""
  }

  let help =
    dim(
      "  Tab:검색  ↑↓:이동  ←→:페이지  Space:선택  Enter:다운로드  Ctrl+X:종료",
    )

  ui.col(
    list.flatten([
      [ui.text(header), ui.br()],
      widget_rows,
      [
        ui.br(),
        ui.text(page_info <> loading_indicator),
        ui.text(status_line),
        ui.br(),
        ui.text(help),
      ],
    ]),
  )
}

// ── SelectVersion 화면 ──

pub fn view_version(
  name: String,
  versions: List(MergedVersion),
  ver_cursor: Int,
  status_msg: Option(String),
) -> shore.Node(msg) {
  let header = "  " <> bold(cyan("── " <> name <> " — 버전 선택 ──"))

  let version_rows =
    list.index_map(versions, fn(v, idx) {
      let is_cursor = idx == ver_cursor
      let marker = case is_cursor {
        True -> cyan(" ▸ ")
        False -> "   "
      }

      let date = case v.publication_date {
        Some(d) -> string.slice(d, at_index: 0, length: 10)
        None -> "?"
      }
      let mendix = case v.min_mendix_version {
        Some(m) -> " (Mendix ≥" <> m <> ")"
        None -> ""
      }
      let type_label = case v.downloadable, v.react_ready {
        False, _ -> red(" [다운로드 불가]")
        True, Some(True) -> green(" [Pluggable]")
        True, Some(False) -> yellow(" [Classic]")
        True, None -> ""
      }

      let content =
        "v" <> v.version_number <> " (" <> date <> ")" <> mendix <> type_label
      let line = case is_cursor {
        True -> marker <> white(content)
        False -> marker <> content
      }
      ui.text(line)
    })

  let status_line = case status_msg {
    Some(msg) -> msg
    None -> ""
  }

  let help = dim("  ↑↓:이동  Enter:다운로드  Esc:목록으로  Ctrl+X:종료")

  ui.col(
    list.flatten([
      [ui.text(header), ui.br()],
      version_rows,
      [ui.br(), ui.text(status_line), ui.br(), ui.text(help)],
    ]),
  )
}

// ── Loading 화면 ──
// on_update() 모드 — 정적 텍스트만, 애니메이션 없음 (플리커 방지)

pub fn view_loading(label: String) -> shore.Node(msg) {
  ui.col([
    ui.br(),
    ui.text_styled("  -- Mendix Marketplace --", Some(style.Cyan), None),
    ui.br(),
    ui.text_styled("  " <> label, Some(style.Cyan), None),
    ui.br(),
    ui.text("  Ctrl+X: 종료"),
  ])
}
