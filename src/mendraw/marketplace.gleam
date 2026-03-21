// Mendix Marketplace 위젯 검색 + 다운로드 — TUI 인터페이스

import etch/command
import etch/stdout
import etch/style
import etch/terminal
import gleam/int
import gleam/io
import gleam/javascript/promise.{type Promise}
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import mendraw/cmd
import mendraw/marketplace/ui

// ── Opaque 타입 ──

pub type MarketplaceWidget

pub type WidgetLoader

pub type WidgetVersion

pub type VersionInfoMap

pub type XasVersion

// ── 키 입력 ──

type KeyInput {
  KeyNone
  KeyUp
  KeyDown
  KeyRight
  KeyLeft
  KeyEnter
  KeyEscape
  KeyBackspace
  KeyCtrlC
  KeyChar(String)
  KeyHome
  KeyEnd
  KeyPageUp
  KeyPageDown
}

fn parse_key(raw: #(Int, String)) -> KeyInput {
  case raw.0 {
    1 -> KeyUp
    2 -> KeyDown
    3 -> KeyRight
    4 -> KeyLeft
    5 -> KeyEnter
    6 -> KeyEscape
    7 -> KeyBackspace
    8 -> KeyCtrlC
    9 -> KeyChar(raw.1)
    10 -> KeyHome
    11 -> KeyEnd
    12 -> KeyPageUp
    13 -> KeyPageDown
    _ -> KeyNone
  }
}

// ── 뷰 모드 ──

type ViewMode {
  Browse
  SelectVersion(
    name: String,
    versions: List(WidgetVersion),
    ver_cursor: Int,
    queue: List(#(Int, String)),
    xas_data: VersionInfoMap,
    content_id: Int,
  )
}

// ── 상태 ──

const display_size = 10

type MarketplaceState {
  MarketplaceState(
    pat: String,
    all_widgets: List(MarketplaceWidget),
    filtered: Option(List(MarketplaceWidget)),
    page_index: Int,
    cursor: Int,
    selected: List(Int),
    all_loaded: Bool,
    loader: Option(WidgetLoader),
    offset: Int,
    downloaded: Int,
    search_query: String,
    view_mode: ViewMode,
    status_msg: Option(String),
  )
}

// ── FFI 선언 ──

@external(javascript, "./marketplace_ffi.mjs", "read_pat")
fn read_pat() -> Option(String)

@external(javascript, "./marketplace_ffi.mjs", "ensure_cache_dir")
fn ensure_cache_dir() -> Nil

@external(javascript, "./marketplace_ffi.mjs", "load_first_batch")
fn load_first_batch(pat: String) -> #(List(MarketplaceWidget), Int, Bool)

@external(javascript, "./marketplace_ffi.mjs", "fetch_versions")
fn fetch_versions(content_id: Int, pat: String) -> List(WidgetVersion)

@external(javascript, "./marketplace_ffi.mjs", "spawn_loader")
fn spawn_loader(pat: String, offset: Int, widgets_json: String) -> WidgetLoader

@external(javascript, "./marketplace_ffi.mjs", "sync_from_loader")
fn sync_from_loader() -> #(List(MarketplaceWidget), Int, Bool)

@external(javascript, "./marketplace_ffi.mjs", "cleanup_loader")
fn cleanup_loader(loader: WidgetLoader) -> Nil

@external(javascript, "./marketplace_ffi.mjs", "kill_loader")
fn kill_loader(loader: WidgetLoader) -> Nil

@external(javascript, "./marketplace_ffi.mjs", "register_exit_handler")
fn register_exit_handler(loader: WidgetLoader) -> Nil

@external(javascript, "./marketplace_ffi.mjs", "remove_exit_handler")
fn remove_exit_handler() -> Nil

@external(javascript, "./marketplace_ffi.mjs", "widget_name")
fn widget_name(w: MarketplaceWidget) -> Option(String)

@external(javascript, "./marketplace_ffi.mjs", "widget_content_id")
fn widget_content_id(w: MarketplaceWidget) -> Int

@external(javascript, "./marketplace_ffi.mjs", "widget_publisher")
fn widget_publisher(w: MarketplaceWidget) -> Option(String)

@external(javascript, "./marketplace_ffi.mjs", "widget_latest_version")
fn widget_latest_version(w: MarketplaceWidget) -> Option(String)

@external(javascript, "./marketplace_ffi.mjs", "ensure_session")
fn ensure_session() -> String

@external(javascript, "./marketplace_ffi.mjs", "get_all_version_info")
fn get_all_version_info(content_ids: List(Int)) -> VersionInfoMap

@external(javascript, "./marketplace_ffi.mjs", "get_version_info_for")
fn get_version_info_for(
  map: VersionInfoMap,
  content_id: Int,
) -> List(XasVersion)

@external(javascript, "./marketplace_ffi.mjs", "merge_version_data")
fn merge_version_data(
  api: List(WidgetVersion),
  xas: List(XasVersion),
) -> List(WidgetVersion)

@external(javascript, "./marketplace_ffi.mjs", "version_number")
fn version_number(v: WidgetVersion) -> String

@external(javascript, "./marketplace_ffi.mjs", "version_date")
fn version_date(v: WidgetVersion) -> Option(String)

@external(javascript, "./marketplace_ffi.mjs", "version_min_mendix")
fn version_min_mendix(v: WidgetVersion) -> Option(String)

@external(javascript, "./marketplace_ffi.mjs", "version_downloadable")
fn version_downloadable(v: WidgetVersion) -> Bool

@external(javascript, "./marketplace_ffi.mjs", "version_react_ready")
fn version_react_ready(v: WidgetVersion) -> Option(Bool)

@external(javascript, "./marketplace_ffi.mjs", "version_s3_id")
fn version_s3_id(v: WidgetVersion) -> Option(String)

@external(javascript, "./marketplace_ffi.mjs", "prompt_sync")
fn prompt_sync(question: String) -> String

@external(javascript, "./marketplace_ffi.mjs", "widgets_to_json")
fn widgets_to_json(widgets: List(MarketplaceWidget)) -> String

@external(javascript, "./marketplace_ffi.mjs", "is_tty")
fn is_tty() -> Bool

@external(javascript, "./marketplace_ffi.mjs", "exit_process")
fn exit_process() -> Nil

@external(javascript, "./marketplace_ffi.mjs", "poll_key_raw")
fn poll_key_raw(timeout_ms: Int) -> Promise(#(Int, String))

@external(javascript, "./marketplace_ffi.mjs", "start_spinner")
fn start_spinner(label: String, row: Int) -> Nil

@external(javascript, "./marketplace_ffi.mjs", "stop_spinner")
fn stop_spinner() -> Nil

// ── TUI 제어 ──

fn enter_tui() -> Nil {
  let _ = terminal.enter_raw()
  stdout.execute([command.EnterAlternateScreen, command.HideCursor])
}

fn exit_tui() -> Nil {
  stop_spinner()
  stdout.execute([command.ShowCursor, command.LeaveAlternateScreen])
  let _ = terminal.exit_raw()
  Nil
}

/// 로딩 화면 렌더 + 스피너 시작 (row 3에 애니메이션)
fn show_loading(title: String, label: String) -> Nil {
  let screen =
    "  "
    <> style.bold(style.cyan("── " <> title <> " ──"))
    <> "\n\n  "
    <> style.cyan(label)
    <> "\n"
  stdout.execute([
    command.Clear(terminal.All),
    command.MoveTo(0, 0),
    command.Print(screen),
  ])
  start_spinner(label, 3)
}

fn render(state: MarketplaceState) -> Nil {
  let screen = case state.view_mode {
    Browse -> {
      let page = current_page_items(state)
      let items =
        list.index_map(page, fn(w, _idx) {
          ui.WidgetItem(
            name: option.unwrap(widget_name(w), "?"),
            content_id: widget_content_id(w),
            version: widget_latest_version(w),
            publisher: widget_publisher(w),
          )
        })
      ui.render_browse_screen(
        items,
        state.cursor,
        state.selected,
        state.page_index + 1,
        total_pages_str(state),
        state.search_query,
        state.status_msg,
      )
    }
    SelectVersion(name, versions, ver_cursor, _, _, _) -> {
      let version_items =
        list.index_map(versions, fn(v, idx) {
          let date = case version_date(v) {
            Some(d) -> Some(string.slice(d, at_index: 0, length: 10))
            None -> None
          }
          #(
            idx,
            version_number(v),
            date,
            version_min_mendix(v),
            version_downloadable(v),
            version_react_ready(v),
          )
        })
      ui.render_version_screen(
        name,
        version_items,
        ver_cursor,
        state.status_msg,
      )
    }
  }
  stdout.execute([
    command.Clear(terminal.All),
    command.MoveTo(0, 0),
    command.Print(screen),
  ])
}

// ── 메인 ──

pub fn main() {
  case read_pat() {
    None -> {
      io.println("")
      ui.print_error(
        ".env 파일에 MENDIX_PAT가 필요합니다.\n\n"
        <> "  예시 (.env):\n"
        <> "    MENDIX_PAT=your_personal_access_token\n\n"
        <> "  PAT는 Mendix Portal → Settings → Personal Access Tokens에서 발급합니다.\n"
        <> "  필요한 scope: mx:marketplace-content:read",
      )
      Nil
    }
    Some(pat) -> {
      ensure_cache_dir()
      let #(widgets, offset, all_loaded) = load_first_batch(pat)
      case widgets {
        [] -> {
          ui.print_info("위젯을 불러올 수 없습니다.")
          Nil
        }
        _ -> {
          let loader = case all_loaded {
            True -> None
            False -> {
              let json = widgets_to_json(widgets)
              let l = spawn_loader(pat, offset, json)
              register_exit_handler(l)
              Some(l)
            }
          }
          let state =
            MarketplaceState(
              pat: pat,
              all_widgets: widgets,
              filtered: None,
              page_index: 0,
              cursor: 0,
              selected: [],
              all_loaded: all_loaded,
              loader: loader,
              offset: offset,
              downloaded: 0,
              search_query: "",
              view_mode: Browse,
              status_msg: None,
            )
          case is_tty() {
            True -> {
              enter_tui()
              {
                use final_state <- promise.await(tui_loop(state))
                exit_tui()
                finish(final_state)
                exit_process()
                promise.resolve(Nil)
              }
              Nil
            }
            False -> {
              let final_state = prompt_loop(state)
              finish(final_state)
            }
          }
        }
      }
    }
  }
}

fn finish(state: MarketplaceState) -> Nil {
  case state.loader {
    Some(l) -> {
      remove_exit_handler()
      cleanup_loader(l)
    }
    None -> Nil
  }
  case state.downloaded > 0 {
    True -> {
      io.println("\n다운로드 완료: " <> int.to_string(state.downloaded) <> "개")
      cmd.generate_widget_bindings()
    }
    False -> Nil
  }
}

// ── TUI 이벤트 루프 ──

fn tui_loop(state: MarketplaceState) -> Promise(MarketplaceState) {
  let state = sync_state(state)
  render(state)
  // 로딩 중이면 500ms 폴링으로 화면 실시간 갱신, 완료 후에는 키 입력 대기
  let timeout = case state.all_loaded {
    True -> 0
    False -> 500
  }
  use raw <- promise.await(poll_key_raw(timeout))
  let key = parse_key(raw)
  case key {
    KeyNone -> tui_loop(state)
    _ ->
      case state.view_mode {
        Browse -> handle_browse_key(state, key)
        SelectVersion(..) -> handle_version_key(state, key)
      }
  }
}

// ── Browse 모드 키 처리 ──

fn handle_browse_key(
  state: MarketplaceState,
  key: KeyInput,
) -> Promise(MarketplaceState) {
  // 이전 상태 메시지 클리어
  let state = MarketplaceState(..state, status_msg: None)
  case key {
    KeyCtrlC -> promise.resolve(state)
    KeyChar("q") if state.search_query == "" -> promise.resolve(state)
    KeyUp -> tui_loop(move_cursor(state, -1))
    KeyDown -> tui_loop(move_cursor(state, 1))
    KeyLeft -> tui_loop(change_page(state, -1))
    KeyRight -> tui_loop(change_page(state, 1))
    KeyPageUp -> tui_loop(change_page(state, -1))
    KeyPageDown -> tui_loop(change_page(state, 1))
    KeyHome -> tui_loop(MarketplaceState(..state, cursor: 0))
    KeyEnd -> {
      let page_len = list.length(current_page_items(state))
      tui_loop(MarketplaceState(..state, cursor: int.max(0, page_len - 1)))
    }
    KeyChar(" ") -> tui_loop(toggle_selection(state))
    KeyEnter -> {
      let new_state = start_download(state)
      tui_loop(new_state)
    }
    KeyEscape -> tui_loop(clear_search_and_selection(state))
    KeyBackspace -> tui_loop(delete_search_char(state))
    KeyChar(c) -> tui_loop(add_search_char(state, c))
    _ -> tui_loop(state)
  }
}

// ── SelectVersion 모드 키 처리 ──

fn handle_version_key(
  state: MarketplaceState,
  key: KeyInput,
) -> Promise(MarketplaceState) {
  case key {
    KeyCtrlC -> promise.resolve(state)
    KeyEscape -> {
      let s = MarketplaceState(..state, view_mode: Browse, status_msg: None)
      tui_loop(restart_loader(s))
    }
    KeyUp -> {
      case state.view_mode {
        SelectVersion(n, vs, vc, q, x, cid) -> {
          let new_vc = int.max(0, vc - 1)
          tui_loop(
            MarketplaceState(
              ..state,
              view_mode: SelectVersion(n, vs, new_vc, q, x, cid),
              status_msg: None,
            ),
          )
        }
        _ -> tui_loop(state)
      }
    }
    KeyDown -> {
      case state.view_mode {
        SelectVersion(n, vs, vc, q, x, cid) -> {
          let max = int.max(0, list.length(vs) - 1)
          let new_vc = int.min(max, vc + 1)
          tui_loop(
            MarketplaceState(
              ..state,
              view_mode: SelectVersion(n, vs, new_vc, q, x, cid),
              status_msg: None,
            ),
          )
        }
        _ -> tui_loop(state)
      }
    }
    KeyHome -> {
      case state.view_mode {
        SelectVersion(n, vs, _, q, x, cid) ->
          tui_loop(
            MarketplaceState(
              ..state,
              view_mode: SelectVersion(n, vs, 0, q, x, cid),
              status_msg: None,
            ),
          )
        _ -> tui_loop(state)
      }
    }
    KeyEnd -> {
      case state.view_mode {
        SelectVersion(n, vs, _, q, x, cid) -> {
          let max = int.max(0, list.length(vs) - 1)
          tui_loop(
            MarketplaceState(
              ..state,
              view_mode: SelectVersion(n, vs, max, q, x, cid),
              status_msg: None,
            ),
          )
        }
        _ -> tui_loop(state)
      }
    }
    KeyEnter -> {
      let new_state = confirm_version(state)
      tui_loop(new_state)
    }
    _ -> tui_loop(state)
  }
}

// ── 다운로드 시작 (Browse → SelectVersion 전환) ──

fn start_download(state: MarketplaceState) -> MarketplaceState {
  let page = current_page_items(state)
  let page_len = list.length(page)
  case page_len {
    0 -> state
    _ -> {
      let indices = case state.selected {
        [] -> [state.cursor]
        sel -> list.sort(sel, int.compare)
      }
      let selected_widgets =
        list.filter_map(indices, fn(idx) {
          case idx >= 0 && idx < page_len {
            False -> Error(Nil)
            True ->
              case list.drop(page, idx) |> list.first {
                Ok(w) ->
                  Ok(#(widget_content_id(w), option.unwrap(widget_name(w), "?")))
                Error(_) -> Error(Nil)
              }
          }
        })

      // 세션 확인 (스피너 애니메이션)
      show_loading("Mendix Marketplace", "세션 확인 중...")
      let _ = terminal.exit_raw()
      let session_err = ensure_session()
      let _ = terminal.enter_raw()
      stop_spinner()

      case session_err {
        "" -> {
          // 로더 중지
          let state = case state.loader {
            Some(l) -> {
              let s = sync_state(state)
              kill_loader(l)
              MarketplaceState(..s, loader: None)
            }
            None -> state
          }

          // 버전 정보 조회 (스피너 애니메이션)
          let content_ids = list.map(selected_widgets, fn(s) { s.0 })
          show_loading("Mendix Marketplace", "버전 정보 조회 중...")
          let xas_data = get_all_version_info(content_ids)
          stop_spinner()
          enter_version_mode(state, selected_widgets, xas_data)
        }
        msg ->
          MarketplaceState(
            ..state,
            status_msg: Some(style.red("세션 확인 실패: " <> msg)),
            view_mode: Browse,
          )
      }
    }
  }
}

/// 큐의 첫 위젯에 대해 SelectVersion 모드 진입
fn enter_version_mode(
  state: MarketplaceState,
  widgets: List(#(Int, String)),
  xas_data: VersionInfoMap,
) -> MarketplaceState {
  case widgets {
    [] -> {
      // 큐 완료 → Browse로 복귀, 로더 재시작
      let new_state = restart_loader(state)
      MarketplaceState(..new_state, view_mode: Browse, selected: [])
    }
    [#(cid, name), ..rest] -> {
      show_loading(name, "버전 목록 조회 중...")
      let api_versions = fetch_versions(cid, state.pat)
      let xas_versions = get_version_info_for(xas_data, cid)
      stop_spinner()
      case api_versions {
        [] -> {
          // 버전 없음 → 다음 위젯으로
          let state =
            MarketplaceState(
              ..state,
              status_msg: Some(style.yellow(name <> " — 버전 정보를 가져올 수 없습니다")),
            )
          enter_version_mode(state, rest, xas_data)
        }
        _ -> {
          let merged = merge_version_data(api_versions, xas_versions)
          MarketplaceState(
            ..state,
            view_mode: SelectVersion(name, merged, 0, rest, xas_data, cid),
            status_msg: None,
          )
        }
      }
    }
  }
}

/// 버전 확정 → 다운로드 → 다음 위젯 또는 Browse 복귀
fn confirm_version(state: MarketplaceState) -> MarketplaceState {
  case state.view_mode {
    Browse -> state
    SelectVersion(name, versions, ver_cursor, queue, xas_data, content_id) -> {
      case list.drop(versions, ver_cursor) |> list.first {
        Error(_) -> state
        Ok(selected) -> {
          case version_downloadable(selected), version_s3_id(selected) {
            True, Some(s3_id) -> {
              // 다운로드 진행 (스피너)
              show_loading(name, "다운로드 중...")
              let url = "https://files.appstore.mendix.com/" <> s3_id
              case
                cmd.download_to_cache(
                  url,
                  name,
                  version_number(selected),
                  Some(content_id),
                )
              {
                True -> {
                  stop_spinner()
                  cmd.write_widget_toml(
                    name,
                    version_number(selected),
                    Some(content_id),
                    Some(s3_id),
                  )
                  let type_label = case version_react_ready(selected) {
                    Some(True) -> " (Pluggable)"
                    Some(False) -> " (Classic)"
                    None -> ""
                  }
                  let state =
                    MarketplaceState(
                      ..state,
                      downloaded: state.downloaded + 1,
                      status_msg: Some(style.green(
                        "✓ " <> name <> " 다운로드 완료" <> type_label,
                      )),
                    )
                  enter_version_mode(state, queue, xas_data)
                }
                False -> {
                  stop_spinner()
                  let state =
                    MarketplaceState(
                      ..state,
                      status_msg: Some(style.red("✗ 다운로드 실패")),
                    )
                  enter_version_mode(state, queue, xas_data)
                }
              }
            }
            _, _ -> {
              MarketplaceState(
                ..state,
                status_msg: Some(style.yellow(
                  "v" <> version_number(selected) <> "은 다운로드할 수 없습니다",
                )),
              )
            }
          }
        }
      }
    }
  }
}

// ── 커서/페이지/검색 ──

fn move_cursor(state: MarketplaceState, delta: Int) -> MarketplaceState {
  let page_len = list.length(current_page_items(state))
  case page_len {
    0 -> state
    _ -> {
      let new_cursor = int.clamp(state.cursor + delta, 0, page_len - 1)
      MarketplaceState(..state, cursor: new_cursor)
    }
  }
}

fn change_page(state: MarketplaceState, delta: Int) -> MarketplaceState {
  let source_len = list.length(get_source(state))
  let max_page = case source_len {
    0 -> 0
    _ -> { source_len - 1 } / display_size
  }
  let new_page = state.page_index + delta
  case new_page < 0 || new_page > max_page {
    True -> state
    False ->
      MarketplaceState(..state, page_index: new_page, cursor: 0, selected: [])
  }
}

fn toggle_selection(state: MarketplaceState) -> MarketplaceState {
  let page_len = list.length(current_page_items(state))
  case state.cursor < page_len {
    False -> state
    True -> {
      let new_selected = case list.contains(state.selected, state.cursor) {
        True -> list.filter(state.selected, fn(i) { i != state.cursor })
        False -> [state.cursor, ..state.selected]
      }
      MarketplaceState(..state, selected: new_selected)
    }
  }
}

fn add_search_char(state: MarketplaceState, c: String) -> MarketplaceState {
  let query = state.search_query <> c
  MarketplaceState(
    ..state,
    search_query: query,
    filtered: Some(filter_widgets(state.all_widgets, query)),
    page_index: 0,
    cursor: 0,
    selected: [],
  )
}

fn delete_search_char(state: MarketplaceState) -> MarketplaceState {
  case state.search_query {
    "" -> state
    q -> {
      let new_query = string.drop_end(q, 1)
      let filtered = case new_query {
        "" -> None
        _ -> Some(filter_widgets(state.all_widgets, new_query))
      }
      MarketplaceState(
        ..state,
        search_query: new_query,
        filtered: filtered,
        page_index: 0,
        cursor: 0,
        selected: [],
      )
    }
  }
}

fn clear_search_and_selection(state: MarketplaceState) -> MarketplaceState {
  MarketplaceState(
    ..state,
    search_query: "",
    filtered: None,
    page_index: 0,
    cursor: 0,
    selected: [],
  )
}

fn filter_widgets(
  widgets: List(MarketplaceWidget),
  query: String,
) -> List(MarketplaceWidget) {
  let q = string.lowercase(query)
  list.filter(widgets, fn(w) {
    let name = string.lowercase(option.unwrap(widget_name(w), ""))
    let publisher = string.lowercase(option.unwrap(widget_publisher(w), ""))
    string.contains(name, q) || string.contains(publisher, q)
  })
}

// ── 공통 헬퍼 ──

fn get_source(state: MarketplaceState) -> List(MarketplaceWidget) {
  case state.filtered {
    Some(f) -> f
    None -> state.all_widgets
  }
}

fn current_page_items(state: MarketplaceState) -> List(MarketplaceWidget) {
  get_source(state)
  |> list.drop(state.page_index * display_size)
  |> list.take(display_size)
}

fn total_pages_str(state: MarketplaceState) -> String {
  let len = list.length(get_source(state))
  let total = case len {
    0 -> 1
    _ -> { len + display_size - 1 } / display_size
  }
  let suffix = case state.all_loaded || option.is_some(state.filtered) {
    True -> ""
    False -> "+"
  }
  int.to_string(total) <> suffix
}

fn sync_state(state: MarketplaceState) -> MarketplaceState {
  case state.all_loaded {
    True -> state
    False -> {
      let #(widgets, new_offset, done) = sync_from_loader()
      case new_offset > state.offset {
        True ->
          MarketplaceState(
            ..state,
            all_widgets: widgets,
            offset: new_offset,
            all_loaded: done,
          )
        False ->
          case done {
            True -> MarketplaceState(..state, all_loaded: True)
            False -> state
          }
      }
    }
  }
}

fn restart_loader(state: MarketplaceState) -> MarketplaceState {
  case state.all_loaded {
    True -> state
    False -> {
      let json = widgets_to_json(state.all_widgets)
      let l = spawn_loader(state.pat, state.offset, json)
      register_exit_handler(l)
      MarketplaceState(..state, loader: Some(l))
    }
  }
}

// ── 프롬프트 모드 폴백 (비-TTY) ──

fn prompt_loop(state: MarketplaceState) -> MarketplaceState {
  show_prompt_page(state)
  prompt_loop_inner(state)
}

fn prompt_loop_inner(state: MarketplaceState) -> MarketplaceState {
  let input = prompt_sync("> ")
  let state = sync_state(state)
  case input {
    "q" -> state
    "" -> prompt_loop_inner(state)
    "n" -> {
      let new_state = change_page(state, 1)
      case new_state.page_index == state.page_index {
        True -> {
          ui.print_info("마지막 페이지입니다.")
          prompt_loop_inner(state)
        }
        False -> {
          io.println("")
          show_prompt_page(new_state)
          prompt_loop_inner(new_state)
        }
      }
    }
    "p" -> {
      let new_state = change_page(state, -1)
      case new_state.page_index == state.page_index {
        True -> {
          ui.print_info("첫 페이지입니다.")
          prompt_loop_inner(state)
        }
        False -> {
          io.println("")
          show_prompt_page(new_state)
          prompt_loop_inner(new_state)
        }
      }
    }
    "r" -> {
      let new_state = clear_search_and_selection(state)
      io.println("")
      ui.print_info("검색 초기화")
      io.println("")
      show_prompt_page(new_state)
      prompt_loop_inner(new_state)
    }
    _ -> {
      case parse_indices(input) {
        Some(indices) -> {
          let page = current_page_items(state)
          let page_len = list.length(page)
          let valid = list.filter(indices, fn(i) { i >= 0 && i < page_len })
          case valid {
            [] -> {
              let new_state = handle_prompt_search(state, input)
              prompt_loop_inner(new_state)
            }
            _ -> {
              let state = stop_loader(state)
              let selected_widgets =
                list.filter_map(valid, fn(idx) {
                  case list.drop(page, idx) |> list.first {
                    Ok(w) ->
                      Ok(#(
                        widget_content_id(w),
                        option.unwrap(widget_name(w), "?"),
                      ))
                    Error(_) -> Error(Nil)
                  }
                })
              let content_ids = list.map(selected_widgets, fn(s) { s.0 })
              let session_err = ensure_session()
              let new_state = case session_err {
                "" -> {
                  io.println("")
                  ui.print_info("버전 정보 조회 중...")
                  let xas = get_all_version_info(content_ids)
                  let dl =
                    list.fold(selected_widgets, state.downloaded, fn(d, s) {
                      prompt_download_one(s.0, s.1, state.pat, xas, d)
                    })
                  MarketplaceState(..state, downloaded: dl)
                }
                msg -> {
                  ui.print_warning("세션 확인 실패: " <> msg)
                  state
                }
              }
              let new_state = restart_loader(new_state)
              io.println("")
              show_prompt_page(new_state)
              prompt_loop_inner(new_state)
            }
          }
        }
        None -> {
          let new_state = handle_prompt_search(state, input)
          prompt_loop_inner(new_state)
        }
      }
    }
  }
}

fn stop_loader(state: MarketplaceState) -> MarketplaceState {
  case state.loader {
    Some(l) -> {
      let s = sync_state(state)
      kill_loader(l)
      MarketplaceState(..s, loader: None)
    }
    None -> state
  }
}

fn prompt_download_one(
  content_id: Int,
  name: String,
  pat: String,
  xas_data: VersionInfoMap,
  downloaded: Int,
) -> Int {
  let api_versions = fetch_versions(content_id, pat)
  let xas_versions = get_version_info_for(xas_data, content_id)
  case api_versions {
    [] -> {
      io.println("")
      ui.print_warning(name <> " — 버전 정보를 가져올 수 없습니다.")
      downloaded
    }
    _ -> {
      let merged = merge_version_data(api_versions, xas_versions)
      let version_items =
        list.index_map(merged, fn(v, idx) {
          let date = case version_date(v) {
            Some(d) -> Some(string.slice(d, at_index: 0, length: 10))
            None -> None
          }
          #(
            idx,
            version_number(v),
            date,
            version_min_mendix(v),
            version_downloadable(v),
            version_react_ready(v),
          )
        })
      // 프롬프트 모드에서는 io로 직접 출력
      io.println("")
      io.println("  " <> style.bold(name) <> " — 버전 선택:")
      io.println("")
      list.each(version_items, fn(v) {
        let #(idx, vn, d, mx, dl, rr) = v
        let ds = option.unwrap(d, "?")
        let ms = case mx {
          Some(m) -> " (Mendix ≥" <> m <> ")"
          None -> ""
        }
        let tl = case dl, rr {
          False, _ -> " " <> style.red("[다운로드 불가]")
          True, Some(True) -> " " <> style.green("[Pluggable]")
          True, Some(False) -> " " <> style.yellow("[Classic]")
          True, None -> ""
        }
        let dm = case idx {
          0 -> "  " <> style.dim(style.green("← 기본"))
          _ -> ""
        }
        io.println(
          "    "
          <> style.bold(style.cyan("[" <> int.to_string(idx) <> "]"))
          <> " "
          <> style.green("v" <> vn)
          <> " ("
          <> ds
          <> ")"
          <> ms
          <> tl
          <> dm,
        )
      })
      io.println("")
      let input = prompt_sync("  버전 번호 (Enter=최신): ")
      let idx = case input {
        "" -> 0
        _ ->
          case int.parse(input) {
            Ok(i) -> i
            Error(_) -> -1
          }
      }
      let merged_len = list.length(merged)
      case idx >= 0 && idx < merged_len {
        False -> {
          ui.print_warning("잘못된 선택입니다. 건너뜁니다.")
          downloaded
        }
        True ->
          case list.drop(merged, idx) |> list.first {
            Error(_) -> downloaded
            Ok(sel) ->
              case version_downloadable(sel), version_s3_id(sel) {
                True, Some(s3) -> {
                  let url = "https://files.appstore.mendix.com/" <> s3
                  case
                    cmd.download_to_cache(
                      url,
                      name,
                      version_number(sel),
                      Some(content_id),
                    )
                  {
                    True -> {
                      cmd.write_widget_toml(
                        name,
                        version_number(sel),
                        Some(content_id),
                        Some(s3),
                      )
                      let tl = case version_react_ready(sel) {
                        Some(True) -> " (Pluggable)"
                        Some(False) -> " (Classic)"
                        None -> ""
                      }
                      ui.print_success("→ " <> name <> " 다운로드 완료" <> tl)
                      downloaded + 1
                    }
                    False -> downloaded
                  }
                }
                _, _ -> {
                  ui.print_warning(
                    "v" <> version_number(sel) <> "은 다운로드할 수 없습니다.",
                  )
                  downloaded
                }
              }
          }
      }
    }
  }
}

fn handle_prompt_search(
  state: MarketplaceState,
  query: String,
) -> MarketplaceState {
  let result = filter_widgets(state.all_widgets, query)
  case result {
    [] -> {
      let suffix = case state.all_loaded {
        True -> ""
        False -> " (로드 중 — 더 있을 수 있음)"
      }
      ui.print_warning("\"" <> query <> "\" 검색 결과가 없습니다." <> suffix)
      state
    }
    _ -> {
      let count = list.length(result)
      let suffix = case state.all_loaded {
        True -> ""
        False -> " (로드 중 — 더 있을 수 있음)"
      }
      io.println("")
      ui.print_info(
        "\""
        <> query
        <> "\" 검색 결과: "
        <> int.to_string(count)
        <> "개"
        <> suffix
        <> " — r: 전체 목록으로 복귀",
      )
      io.println("")
      let new_state =
        MarketplaceState(
          ..state,
          filtered: Some(result),
          page_index: 0,
          search_query: query,
        )
      show_prompt_page(new_state)
      new_state
    }
  }
}

fn show_prompt_page(state: MarketplaceState) -> Nil {
  let page = current_page_items(state)
  let items =
    list.index_map(page, fn(w, _idx) {
      ui.WidgetItem(
        name: option.unwrap(widget_name(w), "?"),
        content_id: widget_content_id(w),
        version: widget_latest_version(w),
        publisher: widget_publisher(w),
      )
    })
  io.print(ui.render_browse_screen(
    items,
    -1,
    [],
    state.page_index + 1,
    total_pages_str(state),
    state.search_query,
    None,
  ))
  io.println(
    "  " <> style.dim("번호: 다운로드 | 검색어: 이름 검색 | n: 다음 | p: 이전 | r: 초기화 | q: 종료"),
  )
  io.println("")
}

fn parse_indices(input: String) -> Option(List(Int)) {
  let is_numeric_csv =
    string.to_graphemes(input)
    |> list.all(fn(c) {
      c == "0"
      || c == "1"
      || c == "2"
      || c == "3"
      || c == "4"
      || c == "5"
      || c == "6"
      || c == "7"
      || c == "8"
      || c == "9"
      || c == ","
      || c == " "
    })
  case is_numeric_csv {
    False -> None
    True -> {
      let indices =
        string.split(input, ",")
        |> list.filter_map(fn(s) { int.parse(string.trim(s)) })
      case indices {
        [] -> None
        _ -> Some(indices)
      }
    }
  }
}
