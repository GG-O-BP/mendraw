// /session/ensure 핸들러 — Mendix 세션 검증/생성
// 프로필 기반: chrobot의 공유 프로필(C:/tmp/chrobot-ws-profile)에 쿠키가 유지됨
// 1. headless로 home.mendix.com 접근 → 리다이렉트 여부로 로그인 상태 확인
// 2. 미로그인 시 visible 브라우저로 사용자 로그인 유도 → 프로필에 쿠키 자동 저장

import chrobot_extra
import chrobot_extra/browser_utils
import gleam/http/request.{type Request}
import gleam/http/response.{type Response}
import gleam/json
import gleam/result
import gleam/string
import mendraw_sidecar/http_utils
import mist.{type Connection, type ResponseData}
import simplifile

pub fn handle(req: Request(Connection)) -> Response(ResponseData) {
  case http_utils.read_body(req) {
    Error(resp) -> resp
    Ok(_body) -> do_ensure_session()
  }
}

fn do_ensure_session() -> Response(ResponseData) {
  case validate_profile_session() {
    Ok(True) -> ok_response()
    _ -> do_interactive_login()
  }
}

/// marketplace 모듈에서 HTTP 경유 없이 직접 호출
pub fn ensure_session() -> Result(Nil, String) {
  // Chrome 프로필 lockfile 정리 (좀비 프로세스가 남긴 stale lock 대응)
  cleanup_stale_lockfile()
  case validate_profile_session() {
    Ok(True) -> Ok(Nil)
    _ ->
      case interactive_login() {
        Ok(Nil) -> Ok(Nil)
        Error(msg) -> Error(msg)
      }
  }
}

fn cleanup_stale_lockfile() -> Nil {
  let lockfile = "C:/tmp/chrobot-ws-profile/lockfile"
  case simplifile.delete(lockfile) {
    Ok(_) -> Nil
    Error(_) -> {
      // lockfile이 잠겨있으면 Chrome 좀비 프로세스가 남아있으므로 강제 종료
      kill_zombie_chrome()
      // 삭제 재시도
      let _ = simplifile.delete(lockfile)
      Nil
    }
  }
}

@external(erlang, "mendraw_sidecar_ffi", "kill_zombie_chrome")
fn kill_zombie_chrome() -> Nil

// headless 브라우저로 프로필 쿠키 유효성 검증
fn validate_profile_session() -> Result(Bool, String) {
  use browser <- result.try(
    chrobot_extra.launch()
    |> result.map_error(fn(e) { "브라우저 시작 실패: " <> string.inspect(e) }),
  )

  let result = {
    // home.mendix.com → 미로그인 시 login으로 리다이렉트됨
    use page <- result.try(
      chrobot_extra.open(browser, "https://home.mendix.com/", 30_000)
      |> result.map_error(fn(e) { "페이지 열기 실패: " <> string.inspect(e) }),
    )

    use _ <- result.try(
      browser_utils.wait_for_url(
        page: chrobot_extra.with_timeout(page, 30_000),
        matching: fn(url) { url != "about:blank" },
        time_out: 30_000,
      )
      |> result.map_error(fn(e) { "페이지 로드 대기 실패: " <> string.inspect(e) }),
    )

    use _ <- result.try(
      chrobot_extra.await_selector(
        on: chrobot_extra.with_timeout(page, 30_000),
        select: "body",
      )
      |> result.map_error(fn(e) { "페이지 렌더링 대기 실패: " <> string.inspect(e) }),
    )

    use url <- result.try(
      browser_utils.get_url(page)
      |> result.map_error(fn(e) { "URL 확인 실패: " <> string.inspect(e) }),
    )

    Ok(string.contains(url, "home.mendix"))
  }

  let _ = chrobot_extra.quit(browser)
  result
}

// visible 브라우저로 인터랙티브 로그인 — 프로필에 쿠키 자동 저장
fn do_interactive_login() -> Response(ResponseData) {
  case interactive_login() {
    Ok(Nil) -> ok_response()
    Error(msg) ->
      http_utils.json_response(
        200,
        json.object([
          #("ok", json.bool(False)),
          #("error", json.string(msg)),
        ]),
      )
  }
}

fn interactive_login() -> Result(Nil, String) {
  use browser <- result.try(
    chrobot_extra.launch_window()
    |> result.map_error(fn(e) { "visible 브라우저 시작 실패: " <> string.inspect(e) }),
  )

  let result = {
    use page <- result.try(
      chrobot_extra.open(browser, "https://login.mendix.com/", 30_000)
      |> result.map_error(fn(e) { "로그인 페이지 열기 실패: " <> string.inspect(e) }),
    )

    // 로그인 완료 대기 — 완료 시 home.mendix.com으로 이동됨
    use _ <- result.try(
      browser_utils.wait_for_url(
        page: chrobot_extra.with_timeout(page, 300_000),
        matching: fn(url) { string.starts_with(url, "https://home.mendix.com") },
        time_out: 300_000,
      )
      |> result.map_error(fn(e) { "로그인 타임아웃 (5분): " <> string.inspect(e) }),
    )

    Ok(Nil)
  }

  let _ = chrobot_extra.quit(browser)
  result
}

fn ok_response() -> Response(ResponseData) {
  http_utils.json_response(200, json.object([#("ok", json.bool(True))]))
}
