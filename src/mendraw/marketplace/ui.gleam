// Marketplace TUI — etch 스타일링 출력 함수

import etch/style
import gleam/int
import gleam/io
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string

/// 위젯 표시 데이터
pub type WidgetItem {
  WidgetItem(
    name: String,
    content_id: Int,
    version: Option(String),
    publisher: Option(String),
  )
}

// ── TUI: 위젯 목록 화면 ──

/// 위젯 목록 화면을 문자열로 생성한다.
pub fn render_browse_screen(
  items: List(WidgetItem),
  cursor: Int,
  selected: List(Int),
  page_num: Int,
  total_pages_str: String,
  search_query: String,
  status_msg: Option(String),
) -> String {
  let header =
    "  "
    <> style.bold(style.cyan(
      "── Mendix Marketplace ── 페이지 "
      <> int.to_string(page_num)
      <> "/"
      <> total_pages_str
      <> " ──",
    ))

  let body = case items {
    [] ->
      "    "
      <> style.dim("결과 없음")
      <> case search_query {
        "" -> ""
        _ -> " — Esc로 검색 초기화"
      }
    _ ->
      items
      |> list.index_map(fn(item, idx) {
        render_widget_item(
          item,
          idx,
          idx == cursor,
          list.contains(selected, idx),
        )
      })
      |> string.join("\n")
  }

  let search_line = case search_query {
    "" -> ""
    q -> "\n  " <> style.dim("검색: ") <> style.cyan(q) <> style.dim("█")
  }

  let status_line = case status_msg {
    Some(msg) -> "\n  " <> msg
    None -> ""
  }

  let help =
    "\n  "
    <> style.dim("↑↓ 이동 · ←→ 페이지 · Enter 다운로드 · Space 선택 · Esc 초기화 · q 종료")

  header <> "\n\n" <> body <> "\n" <> search_line <> status_line <> help <> "\n"
}

fn render_widget_item(
  item: WidgetItem,
  idx: Int,
  is_cursor: Bool,
  is_selected: Bool,
) -> String {
  let marker = case is_cursor, is_selected {
    True, True -> style.green(" ▸●")
    True, False -> style.cyan(" ▸ ")
    False, True -> style.green("  ●")
    False, False -> "   "
  }
  let idx_str = style.bold(style.cyan("[" <> int.to_string(idx) <> "]"))
  let ver_str = case item.version {
    Some(v) -> " " <> style.green("v" <> v)
    None -> ""
  }
  let pub_str = case item.publisher {
    Some(p) -> " — " <> style.dim(p)
    None -> ""
  }
  let name_str = case is_cursor {
    True -> style.bold(style.cyan(item.name))
    False -> style.bold(item.name)
  }
  let cid = style.dim("(" <> int.to_string(item.content_id) <> ")")

  marker
  <> " "
  <> idx_str
  <> " "
  <> name_str
  <> " "
  <> cid
  <> ver_str
  <> pub_str
}

// ── TUI: 버전 선택 화면 ──

/// 버전 선택 화면을 문자열로 생성한다.
pub fn render_version_screen(
  name: String,
  versions: List(
    #(Int, String, Option(String), Option(String), Bool, Option(Bool)),
  ),
  cursor: Int,
  status_msg: Option(String),
) -> String {
  let header = "  " <> style.bold(style.cyan("── " <> name <> " — 버전 선택 ──"))

  let body =
    versions
    |> list.map(fn(v) {
      let #(idx, ver_num, date, min_mendix, downloadable, react_ready) = v
      let is_cursor = idx == cursor
      let marker = case is_cursor {
        True -> style.cyan("  ▸ ")
        False -> "    "
      }
      let date_str = option.unwrap(date, "?")
      let mx_str = case min_mendix {
        Some(mx) -> " (Mendix ≥" <> mx <> ")"
        None -> ""
      }
      let type_label = case downloadable, react_ready {
        False, _ -> " " <> style.red("[다운로드 불가]")
        True, Some(True) -> " " <> style.green("[Pluggable]")
        True, Some(False) -> " " <> style.yellow("[Classic]")
        True, None -> ""
      }
      let default_mark = case idx {
        0 -> "  " <> style.dim(style.green("← 기본"))
        _ -> ""
      }
      let ver_styled = case is_cursor {
        True -> style.bold(style.cyan("v" <> ver_num))
        False -> style.green("v" <> ver_num)
      }
      marker
      <> style.bold(style.cyan("[" <> int.to_string(idx) <> "]"))
      <> " "
      <> ver_styled
      <> " ("
      <> date_str
      <> ")"
      <> mx_str
      <> type_label
      <> default_mark
    })
    |> string.join("\n")

  let status_line = case status_msg {
    Some(msg) -> "\n  " <> msg
    None -> ""
  }

  let help = "\n  " <> style.dim("↑↓ 이동 · Enter 다운로드 · Esc 취소")

  header <> "\n\n" <> body <> "\n" <> status_line <> help <> "\n"
}

// ── TUI: 로딩/상태 화면 ──

/// 상태 메시지 화면을 생성한다.
pub fn render_status_screen(msg: String) -> String {
  "\n  " <> style.bold(style.cyan(msg)) <> "\n"
}

// ── 프롬프트 모드 출력 (비-TTY 폴백) ──

/// 에러 메시지를 출력한다.
pub fn print_error(msg: String) -> Nil {
  io.println("  " <> style.red(msg))
}

/// 성공 메시지를 출력한다.
pub fn print_success(msg: String) -> Nil {
  io.println("  " <> style.green(msg))
}

/// 정보 메시지를 출력한다.
pub fn print_info(msg: String) -> Nil {
  io.println("  " <> style.cyan(msg))
}

/// 경고 메시지를 출력한다.
pub fn print_warning(msg: String) -> Nil {
  io.println("  " <> style.yellow(msg))
}
