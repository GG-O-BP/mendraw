// Mendix Marketplace TUI — Shore TEA 앱

import gleam/dict.{type Dict}
import gleam/erlang/process.{type Subject}
import gleam/int
import gleam/json
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import mendraw_sidecar/marketplace/content_api.{
  type ContentApiVersion, type Widget, fetch_size,
}
import mendraw_sidecar/marketplace/downloader
import mendraw_sidecar/marketplace/loader.{type LoaderHandle, type LoaderMsg}
import mendraw_sidecar/marketplace/version_merger.{type MergedVersion}
import mendraw_sidecar/marketplace/view
import mendraw_sidecar/session_handler
import mendraw_sidecar/version_handler
import mendraw_sidecar/xas_parser.{type XasVersion}
import shore
import shore/key
import shore/style
import shore/ui
import simplifile

// ── 상수 ──

const display_size = 10

// ── 타입 ──

type ViewMode {
  Browse
  SelectVersion(
    name: String,
    versions: List(MergedVersion),
    ver_cursor: Int,
    queue: List(#(Int, String)),
    xas_data: Dict(Int, List(XasVersion)),
    content_id: Int,
  )
  /// 첫 배치 로딩 (LoaderUpdated로 Browse 전환)
  InitialLoading(label: String)
  /// 세션/버전/다운로드 작업 중 (비동기 command 결과로 전환)
  Working(label: String)
}

type Model {
  Model(
    pat: String,
    project_root: String,
    result_path: String,
    all_widgets: List(Widget),
    filtered: Option(List(Widget)),
    page_index: Int,
    cursor: Int,
    selected: List(Int),
    all_loaded: Bool,
    loader: Option(LoaderHandle),
    offset: Int,
    downloaded: List(downloader.DownloadResult),
    search_query: String,
    view_mode: ViewMode,
    status_msg: Option(String),
    shore_subject: Option(Subject(Msg)),
    exit_subject: Option(Subject(Nil)),
  )
}

type Msg {
  // 네비게이션
  MoveCursor(Int)
  ChangePage(Int)
  GoHome
  GoEnd
  ToggleSelection
  // 검색 (ui.input 위젯에서 전체 쿼리 문자열 수신)
  SearchChanged(String)
  // 액션
  StartDownload
  ConfirmVersion
  GoBack
  Quit
  // 비동기 결과
  LoaderUpdated(loader.LoaderMsg)
  SessionReady(Result(Nil, String))
  VersionInfoReady(
    widgets: List(#(Int, String)),
    result: Result(Dict(Int, List(XasVersion)), String),
  )
  ApiVersionsReady(
    name: String,
    content_id: Int,
    queue: List(#(Int, String)),
    xas_data: Dict(Int, List(XasVersion)),
    result: Result(List(ContentApiVersion), String),
  )
  DownloadDone(
    name: String,
    queue: List(#(Int, String)),
    xas_data: Dict(Int, List(XasVersion)),
    result: Result(downloader.DownloadResult, String),
  )
}

// ── 공개 API ──

/// Marketplace TUI 실행 (Shore TEA)
/// result_path: JSON 결과를 쓸 파일 경로
pub fn run(pat: String, project_root: String, result_path: String) -> Nil {
  let exit = process.new_subject()

  let assert Ok(_) =
    shore.spec_with_subject(
      init: fn(subject) { init(pat, project_root, result_path, subject, exit) },
      view: view_fn,
      update: update,
      exit: exit,
      keybinds: shore.keybinds(
        exit: key.Ctrl("X"),
        submit: key.Enter,
        focus_clear: key.Esc,
        focus_next: key.Tab,
        focus_prev: key.BackTab,
      ),
      redraw: shore.on_update(),
    )
    |> shore.start

  // 종료 대기
  let _ = process.receive_forever(exit)
  Nil
}

// ── TEA: init ──

fn init(
  pat: String,
  project_root: String,
  result_path: String,
  shore_subject: Subject(Msg),
  exit_subject: Subject(Nil),
) -> #(Model, List(fn() -> Msg)) {
  let model =
    Model(
      pat: pat,
      project_root: project_root,
      result_path: result_path,
      all_widgets: [],
      filtered: None,
      page_index: 0,
      cursor: 0,
      selected: [],
      all_loaded: False,
      loader: None,
      offset: 0,
      downloaded: [],
      search_query: "",
      view_mode: InitialLoading("위젯 목록 불러오는 중..."),
      status_msg: None,
      shore_subject: Some(shore_subject),
      exit_subject: Some(exit_subject),
    )

  // 첫 배치 로드를 command로 실행
  let load_first = fn() {
    case content_api.fetch_content_page(pat, 0, fetch_size) {
      Ok(page) ->
        LoaderUpdated(loader.LoaderUpdate(
          page.widgets,
          fetch_size,
          page.all_done,
        ))
      Error(_) -> LoaderUpdated(loader.LoaderUpdate([], 0, True))
    }
  }

  #(model, [load_first])
}

// ── TEA: view ──

fn view_fn(model: Model) -> shore.Node(Msg) {
  case model.view_mode {
    InitialLoading(label) -> view.view_loading(label)
    Working(label) -> view.view_loading(label)
    Browse ->
      ui.col([
        view.view_browse(
          current_page_items(model),
          model.cursor,
          model.selected,
          model.page_index + 1,
          total_pages_str(model),
          model.status_msg,
          model.all_loaded,
        ),
        // 검색 입력 (Shore input 위젯)
        ui.input("  검색: ", model.search_query, style.Fill, SearchChanged),
        // 키바인드
        ui.keybind(key.Up, MoveCursor(-1)),
        ui.keybind(key.Down, MoveCursor(1)),
        ui.keybind(key.Left, ChangePage(-1)),
        ui.keybind(key.Right, ChangePage(1)),
        ui.keybind(key.PageUp, ChangePage(-1)),
        ui.keybind(key.PageDown, ChangePage(1)),
        ui.keybind(key.Home, GoHome),
        ui.keybind(key.End, GoEnd),
        ui.keybind(key.Char(" "), ToggleSelection),
        ui.keybind(key.Enter, StartDownload),
      ])
    SelectVersion(name, versions, ver_cursor, _, _, _) ->
      ui.col([
        view.view_version(name, versions, ver_cursor, model.status_msg),
        ui.keybind(key.Up, MoveCursor(-1)),
        ui.keybind(key.Down, MoveCursor(1)),
        ui.keybind(key.Home, GoHome),
        ui.keybind(key.End, GoEnd),
        ui.keybind(key.Enter, ConfirmVersion),
        ui.keybind(key.Esc, GoBack),
      ])
  }
}

// ── TEA: update ──

fn update(model: Model, msg: Msg) -> #(Model, List(fn() -> Msg)) {
  // Working/InitialLoading 상태에서는 비동기 결과와 Quit만 처리
  case model.view_mode {
    Working(_) | InitialLoading(_) ->
      case msg {
        Quit | SessionReady(_) | VersionInfoReady(..) | ApiVersionsReady(..)
        | DownloadDone(..) | LoaderUpdated(_)
        -> update_inner(model, msg)
        _ -> #(model, [])
      }
    _ -> update_inner(model, msg)
  }
}

fn update_inner(model: Model, msg: Msg) -> #(Model, List(fn() -> Msg)) {
  case msg {
    Quit -> {
      output_results(model)
      cleanup(model)
      case model.exit_subject {
        Some(exit) -> process.send(exit, Nil)
        None -> Nil
      }
      #(model, [])
    }

    // ── 로더 업데이트 ──
    LoaderUpdated(loader.LoaderUpdate(widgets, offset, done)) -> {
      let was_initial_loading = case model.view_mode {
        InitialLoading(_) -> True
        _ -> False
      }
      let new_model = case was_initial_loading {
        True -> model
        False -> model
      }
      let new_model =
        Model(
          ..new_model,
          all_widgets: widgets,
          offset: offset,
          all_loaded: done,
          view_mode: case was_initial_loading {
            True -> Browse
            False -> model.view_mode
          },
        )
      // 로더 시작 (첫 배치 후)
      let new_model = case done, new_model.loader {
        False, None -> start_loader(new_model)
        _, _ -> new_model
      }
      // 검색 필터 갱신
      let new_model = case new_model.search_query {
        "" -> new_model
        q ->
          Model(
            ..new_model,
            filtered: Some(filter_widgets(new_model.all_widgets, q)),
          )
      }
      #(new_model, [])
    }

    // ── Browse 네비게이션 ──
    MoveCursor(delta) -> {
      case model.view_mode {
        Browse -> {
          let page_len = list.length(current_page_items(model))
          case page_len {
            0 -> #(model, [])
            _ -> {
              let new_cursor = int.clamp(model.cursor + delta, 0, page_len - 1)
              #(Model(..model, cursor: new_cursor), [])
            }
          }
        }
        SelectVersion(n, vs, vc, q, x, cid) -> {
          let max = int.max(0, list.length(vs) - 1)
          let new_vc = int.clamp(vc + delta, 0, max)
          #(
            Model(
              ..model,
              view_mode: SelectVersion(n, vs, new_vc, q, x, cid),
              status_msg: None,
            ),
            [],
          )
        }
        _ -> #(model, [])
      }
    }

    ChangePage(delta) -> {
      let source_len = list.length(get_source(model))
      let max_page = case source_len {
        0 -> 0
        _ -> { source_len - 1 } / display_size
      }
      let new_page = model.page_index + delta
      case new_page < 0 || new_page > max_page {
        True -> #(model, [])
        False -> #(
          Model(
            ..model,
            page_index: new_page,
            cursor: 0,
            selected: [],
            status_msg: None,
          ),
          [],
        )
      }
    }

    GoHome -> {
      case model.view_mode {
        Browse -> #(Model(..model, cursor: 0), [])
        SelectVersion(n, vs, _, q, x, cid) -> #(
          Model(..model, view_mode: SelectVersion(n, vs, 0, q, x, cid)),
          [],
        )
        _ -> #(model, [])
      }
    }

    GoEnd -> {
      case model.view_mode {
        Browse -> {
          let page_len = list.length(current_page_items(model))
          #(Model(..model, cursor: int.max(0, page_len - 1)), [])
        }
        SelectVersion(n, vs, _, q, x, cid) -> {
          let max = int.max(0, list.length(vs) - 1)
          #(Model(..model, view_mode: SelectVersion(n, vs, max, q, x, cid)), [])
        }
        _ -> #(model, [])
      }
    }

    ToggleSelection -> {
      let page_len = list.length(current_page_items(model))
      case model.cursor < page_len {
        False -> #(model, [])
        True -> {
          let new_selected = case list.contains(model.selected, model.cursor) {
            True -> list.filter(model.selected, fn(i) { i != model.cursor })
            False -> [model.cursor, ..model.selected]
          }
          #(Model(..model, selected: new_selected), [])
        }
      }
    }

    // ── 검색 (ui.input 위젯에서 전체 쿼리 문자열 수신) ──
    SearchChanged(query) -> {
      let filtered = case query {
        "" -> None
        _ -> Some(filter_widgets(model.all_widgets, query))
      }
      #(
        Model(
          ..model,
          search_query: query,
          filtered: filtered,
          page_index: 0,
          cursor: 0,
          selected: [],
        ),
        [],
      )
    }

    // ── 다운로드 시작 ──
    StartDownload -> {
      let page = current_page_items(model)
      let page_len = list.length(page)
      case page_len {
        0 -> #(model, [])
        _ -> {
          let indices = case model.selected {
            [] -> [model.cursor]
            sel -> list.sort(sel, int.compare)
          }
          let selected_widgets =
            list.filter_map(indices, fn(idx) {
              case idx >= 0 && idx < page_len {
                False -> Error(Nil)
                True ->
                  case list.drop(page, idx) |> list.first {
                    Ok(w) -> Ok(#(w.content_id, option.unwrap(w.name, "?")))
                    Error(_) -> Error(Nil)
                  }
              }
            })

          // 로더 중지, 애니메이션 시작
          let model = stop_loader(model)
          let model =
            Model(..model, view_mode: Working("세션 확인 중..."), status_msg: None)
          let model = model

          let widgets = selected_widgets
          // 세션 확인 + 버전 정보 조회를 하나의 command로 실행
          let cmd = fn() {
            case session_handler.ensure_session() {
              Ok(_) -> {
                let content_ids = list.map(widgets, fn(s) { s.0 })
                let result = version_handler.get_all_versions(content_ids)
                VersionInfoReady(widgets, result)
              }
              Error(msg) -> SessionReady(Error(msg))
            }
          }

          #(model, [cmd])
        }
      }
    }

    // ── 세션 결과 ──
    SessionReady(result) -> {
      case result {
        Ok(_) -> #(model, [])
        Error(msg) -> {
          let model = start_loader(model)
          #(
            Model(
              ..model,
              view_mode: Browse,
              status_msg: Some("  세션 확인 실패: " <> msg),
            ),
            [],
          )
        }
      }
    }

    // ── 버전 정보 결과 ──
    VersionInfoReady(widgets, result) -> {
      case result {
        Ok(xas_data) -> {
          let model = model
          enter_version_mode(model, widgets, xas_data)
        }
        Error(msg) -> {
          let model = start_loader(model)
          #(
            Model(
              ..model,
              view_mode: Browse,
              status_msg: Some("  버전 정보 조회 실패: " <> msg),
            ),
            [],
          )
        }
      }
    }

    // ── API 버전 결과 ──
    ApiVersionsReady(name, content_id, queue, xas_data, result) -> {
      case result {
        Ok(api_versions) -> {
          case api_versions {
            [] ->
              // 버전 없음 → 다음 위젯
              enter_version_mode(
                Model(
                  ..model,
                  status_msg: Some("  " <> name <> " — 버전 정보를 가져올 수 없습니다"),
                ),
                queue,
                xas_data,
              )
            _ -> {
              let xas_versions = case dict.get(xas_data, content_id) {
                Ok(v) -> v
                Error(_) -> []
              }
              let merged = version_merger.merge(api_versions, xas_versions)
              let model = model
              #(
                Model(
                  ..model,
                  view_mode: SelectVersion(
                    name,
                    merged,
                    0,
                    queue,
                    xas_data,
                    content_id,
                  ),
                  status_msg: None,
                ),
                [],
              )
            }
          }
        }
        Error(_) ->
          enter_version_mode(
            Model(
              ..model,
              status_msg: Some("  " <> name <> " — 버전 정보를 가져올 수 없습니다"),
            ),
            queue,
            xas_data,
          )
      }
    }

    // ── 버전 확정 ──
    ConfirmVersion -> {
      case model.view_mode {
        SelectVersion(name, versions, ver_cursor, queue, xas_data, content_id) -> {
          case list.drop(versions, ver_cursor) |> list.first {
            Error(_) -> #(model, [])
            Ok(selected) ->
              case selected.downloadable, selected.s3_object_id {
                True, Some(s3_id) -> {
                  let url = "https://files.appstore.mendix.com/" <> s3_id
                  let model =
                    Model(..model, view_mode: Working(name <> " 다운로드 중..."))
                  let root = model.project_root
                  let version = selected.version_number
                  let react = selected.react_ready

                  let cmd = fn() {
                    let result =
                      downloader.download_and_extract(
                        url,
                        name,
                        version,
                        Some(content_id),
                        root,
                      )
                    case result {
                      Ok(dl) -> {
                        let _ =
                          downloader.write_widget_toml(
                            name,
                            version,
                            Some(content_id),
                            Some(s3_id),
                            root,
                          )
                        let type_label = case react {
                          Some(True) -> " (Pluggable)"
                          Some(False) -> " (Classic)"
                          None -> ""
                        }
                        DownloadDone(
                          name,
                          queue,
                          xas_data,
                          Ok(
                            downloader.DownloadResult(
                              ..dl,
                              s3_id: "✓ " <> name <> " 다운로드 완료" <> type_label,
                            ),
                          ),
                        )
                      }
                      Error(msg) ->
                        DownloadDone(name, queue, xas_data, Error(msg))
                    }
                  }

                  #(model, [cmd])
                }
                _, _ -> #(
                  Model(
                    ..model,
                    status_msg: Some(
                      "  v" <> selected.version_number <> "은 다운로드할 수 없습니다",
                    ),
                  ),
                  [],
                )
              }
          }
        }
        _ -> #(model, [])
      }
    }

    // ── 다운로드 완료 ──
    DownloadDone(_name, queue, xas_data, result) -> {
      case result {
        Ok(dl) -> {
          let model =
            Model(
              ..model,
              downloaded: [dl, ..model.downloaded],
              status_msg: Some("  " <> dl.s3_id),
            )
          enter_version_mode(model, queue, xas_data)
        }
        Error(msg) -> {
          let model = Model(..model, status_msg: Some("  ✗ 다운로드 실패: " <> msg))
          enter_version_mode(model, queue, xas_data)
        }
      }
    }

    // ── 뒤로 가기 ──
    GoBack -> {
      case model.view_mode {
        SelectVersion(..) -> {
          let model =
            start_loader(Model(..model, view_mode: Browse, status_msg: None))
          #(model, [])
        }
        _ -> #(model, [])
      }
    }
  }
}

// ── 버전 선택 모드 진입 ──

fn enter_version_mode(
  model: Model,
  widgets: List(#(Int, String)),
  xas_data: Dict(Int, List(XasVersion)),
) -> #(Model, List(fn() -> Msg)) {
  case widgets {
    [] -> {
      // 큐 완료 → Browse 복귀
      let model =
        start_loader(Model(..model, view_mode: Browse, selected: []))
      #(model, [])
    }
    [#(cid, name), ..rest] -> {
      let model_pat = model.pat
      let model =
        Model(..model, view_mode: Working(name <> " 버전 조회 중..."))
      let cmd = fn() {
        ApiVersionsReady(
          name,
          cid,
          rest,
          xas_data,
          content_api.fetch_versions(model_pat, cid),
        )
      }
      #(model, [cmd])
    }
  }
}

// ── 헬퍼 ──

fn get_source(model: Model) -> List(Widget) {
  case model.filtered {
    Some(f) -> f
    None -> model.all_widgets
  }
}

fn current_page_items(model: Model) -> List(Widget) {
  get_source(model)
  |> list.drop(model.page_index * display_size)
  |> list.take(display_size)
}

fn total_pages_str(model: Model) -> String {
  let len = list.length(get_source(model))
  let total = case len {
    0 -> 1
    _ -> { len + display_size - 1 } / display_size
  }
  let suffix = case model.all_loaded || option.is_some(model.filtered) {
    True -> ""
    False -> "+"
  }
  int.to_string(total) <> suffix
}

fn filter_widgets(widgets: List(Widget), query: String) -> List(Widget) {
  let q = string.lowercase(query)
  list.filter(widgets, fn(w) {
    let name = string.lowercase(option.unwrap(w.name, ""))
    let publisher = string.lowercase(option.unwrap(w.publisher, ""))
    string.contains(name, q) || string.contains(publisher, q)
  })
}

fn start_loader(model: Model) -> Model {
  case model.all_loaded {
    True -> model
    False -> {
      case model.shore_subject {
        Some(shore_subject) -> {
          // 모든 Subject는 사용하는 프로세스 안에서 생성 (Gleam 소유권 규칙)
          let handle_ready = process.new_subject()
          let pat = model.pat
          let offset = model.offset
          let widgets = model.all_widgets
          let _ =
            process.spawn(fn() {
              // relay 프로세스가 소유하는 Subject
              let loader_subject = process.new_subject()
              let loader_handle_ready = process.new_subject()
              // loader.start 내부에서 loader 프로세스가 control Subject 생성
              loader.start(pat, offset, widgets, loader_subject, loader_handle_ready)
              // 로더 핸들 수신 (relay 프로세스가 loader_handle_ready 소유)
              case process.receive(loader_handle_ready, 10_000) {
                Ok(handle) -> {
                  // 핸들을 부모(Shore actor)에게 전달
                  process.send(handle_ready, handle)
                  // 중계 루프
                  relay_loop(loader_subject, shore_subject)
                }
                Error(_) -> Nil
              }
            })
          // Shore actor에서 핸들 수신
          case process.receive(handle_ready, 15_000) {
            Ok(handle) -> Model(..model, loader: Some(handle))
            Error(_) -> model
          }
        }
        None -> model
      }
    }
  }
}

fn relay_loop(from: Subject(LoaderMsg), to: Subject(Msg)) -> Nil {
  case process.receive(from, 60_000) {
    Ok(msg) -> {
      process.send(to, LoaderUpdated(msg))
      case msg {
        loader.LoaderUpdate(_, _, True) -> Nil
        _ -> relay_loop(from, to)
      }
    }
    Error(_) -> Nil
  }
}

fn stop_loader(model: Model) -> Model {
  case model.loader {
    Some(handle) -> {
      loader.stop(handle)
      Model(..model, loader: None)
    }
    None -> model
  }
}

fn cleanup(model: Model) -> Nil {
  let _ = stop_loader(model)
  Nil
}

fn output_results(model: Model) -> Nil {
  let downloaded_json =
    json.object([
      #(
        "downloaded",
        json.array(model.downloaded, fn(dl) {
          json.object([
            #("name", json.string(dl.name)),
            #("version", json.string(dl.version)),
            #("content_id", case dl.content_id {
              Some(id) -> json.int(id)
              None -> json.null()
            }),
            #("s3_id", json.string(dl.s3_id)),
          ])
        }),
      ),
    ])
  let _ = simplifile.write(model.result_path, json.to_string(downloaded_json))
  Nil
}
