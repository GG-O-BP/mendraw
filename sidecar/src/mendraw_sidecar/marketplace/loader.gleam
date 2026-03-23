// 백그라운드 위젯 로더 — Erlang 프로세스 기반

import gleam/erlang/process.{type Subject}
import gleam/list
import mendraw_sidecar/marketplace/content_api.{
  type Widget, fetch_content_page, fetch_size,
}

// ── 타입 ──

/// 로더가 TUI에 보내는 업데이트 메시지
pub type LoaderMsg {
  LoaderUpdate(widgets: List(Widget), offset: Int, done: Bool)
}

/// 로더 핸들 (중지용)
pub type LoaderHandle {
  LoaderHandle(control: Subject(LoaderControl))
}

/// 로더 제어 메시지
pub type LoaderControl {
  StopLoader
}

// ── 공개 API ──

/// 백그라운드 로더 시작 — Erlang 프로세스에서 Content API 페이지별 fetch
/// control Subject는 로더 프로세스 안에서 생성 (소유권 규칙)
pub fn start(
  pat: String,
  initial_offset: Int,
  initial_widgets: List(Widget),
  notify: Subject(LoaderMsg),
  ready: Subject(LoaderHandle),
) -> Nil {
  let _ =
    process.spawn(fn() {
      // 이 프로세스가 소유하는 control Subject 생성
      let control = process.new_subject()
      process.send(ready, LoaderHandle(control))
      loader_loop(pat, initial_offset, initial_widgets, notify, control)
    })
  Nil
}

/// 로더 중지
pub fn stop(handle: LoaderHandle) -> Nil {
  process.send(handle.control, StopLoader)
}

// ── 내부 루프 ──

fn loader_loop(
  pat: String,
  offset: Int,
  widgets: List(Widget),
  notify: Subject(LoaderMsg),
  control: Subject(LoaderControl),
) -> Nil {
  // 중지 요청 확인 (non-blocking)
  case process.receive(control, 0) {
    Ok(StopLoader) -> Nil
    Error(_) -> {
      case fetch_content_page(pat, offset, fetch_size) {
        Ok(page) -> {
          let new_widgets = list.append(widgets, page.widgets)
          let new_offset = offset + fetch_size
          process.send(
            notify,
            LoaderUpdate(new_widgets, new_offset, page.all_done),
          )
          case page.all_done {
            True -> Nil
            False -> loader_loop(pat, new_offset, new_widgets, notify, control)
          }
        }
        Error(_) -> {
          // API 오류 시 현재까지 결과로 완료 처리
          process.send(notify, LoaderUpdate(widgets, offset, True))
        }
      }
    }
  }
}
