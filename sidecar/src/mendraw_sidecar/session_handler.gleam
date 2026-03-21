// /session/ensure 핸들러 — Mendix 세션 검증/생성
// 1. 저장된 세션 파일이 있으면 headless로 유효성 확인
// 2. 유효하지 않으면 visible 브라우저로 사용자 로그인 유도
// 3. 세션 저장 후 결과 반환

import chrobot_extra
import chrobot_extra/browser_utils
import chrobot_extra/session
import gleam/dynamic/decode
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
    Ok(body) -> {
      case parse_request(body) {
        Error(msg) -> http_utils.error_response(msg)
        Ok(session_path) -> do_ensure_session(session_path)
      }
    }
  }
}

fn parse_request(body: String) -> Result(String, String) {
  let decoder = {
    use session_path <- decode.field("session_path", decode.string)
    decode.success(session_path)
  }
  case json.parse(body, decoder) {
    Ok(path) -> Ok(path)
    Error(_) -> Error("session_path 필드가 필요합니다")
  }
}

fn do_ensure_session(session_path: String) -> Response(ResponseData) {
  // 1. 저장된 세션이 있으면 검증
  case simplifile.is_file(session_path) {
    Ok(True) -> {
      case validate_existing_session(session_path) {
        Ok(True) -> ok_response()
        Ok(False) -> {
          // 세션 만료됨, 새로 생성
          do_interactive_login(session_path)
        }
        Error(_) -> {
          // 검증 실패, 새로 생성
          do_interactive_login(session_path)
        }
      }
    }
    _ -> do_interactive_login(session_path)
  }
}

// headless 브라우저로 세션 유효성 검증
fn validate_existing_session(session_path: String) -> Result(Bool, String) {
  use state <- result.try(
    session.load_from_file(session_path)
    |> result.map_error(fn(_) { "세션 파일 로드 실패" }),
  )

  use browser <- result.try(
    chrobot_extra.launch()
    |> result.map_error(fn(e) {
      "브라우저 시작 실패: " <> string.inspect(e)
    }),
  )

  let result = {
    // marketplace에서 세션 복원 (쿠키 + localStorage)
    use page <- result.try(
      chrobot_extra.open(browser, "https://marketplace.mendix.com/", 30_000)
      |> result.map_error(fn(e) {
        "페이지 열기 실패: " <> string.inspect(e)
      }),
    )

    use _ <- result.try(
      chrobot_extra.await_selector(
        on: chrobot_extra.with_timeout(page, 30_000),
        select: "body",
      )
      |> result.map_error(fn(e) {
        "페이지 로드 대기 실패: " <> string.inspect(e)
      }),
    )

    use _ <- result.try(
      session.restore(page, state)
      |> result.map_error(fn(e) {
        "세션 복원 실패: " <> string.inspect(e)
      }),
    )

    // home.mendix.com으로 검증 — 미로그인 시 login으로 리다이렉트됨
    use check_page <- result.try(
      chrobot_extra.open(browser, "https://home.mendix.com/", 30_000)
      |> result.map_error(fn(e) {
        "검증 페이지 열기 실패: " <> string.inspect(e)
      }),
    )

    use _ <- result.try(
      chrobot_extra.await_selector(
        on: chrobot_extra.with_timeout(check_page, 30_000),
        select: "body",
      )
      |> result.map_error(fn(e) {
        "검증 페이지 로드 대기 실패: " <> string.inspect(e)
      }),
    )

    use url <- result.try(
      browser_utils.get_url(check_page)
      |> result.map_error(fn(e) {
        "URL 확인 실패: " <> string.inspect(e)
      }),
    )

    Ok(string.contains(url, "home.mendix"))
  }

  let _ = chrobot_extra.quit(browser)
  result
}

// visible 브라우저로 인터랙티브 로그인
fn do_interactive_login(session_path: String) -> Response(ResponseData) {
  case interactive_login(session_path) {
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

fn interactive_login(session_path: String) -> Result(Nil, String) {
  use browser <- result.try(
    chrobot_extra.launch_window()
    |> result.map_error(fn(e) {
      "visible 브라우저 시작 실패: " <> string.inspect(e)
    }),
  )

  let result = {
    use page <- result.try(
      chrobot_extra.open(browser, "https://login.mendix.com/", 30_000)
      |> result.map_error(fn(e) {
        "로그인 페이지 열기 실패: " <> string.inspect(e)
      }),
    )

    // 로그인 완료 대기 — 완료 시 home.mendix.com으로 이동됨
    use _ <- result.try(
      browser_utils.wait_for_url(
        page: chrobot_extra.with_timeout(page, 300_000),
        matching: fn(url) { string.contains(url, "home.mendix") },
        time_out: 300_000,
      )
      |> result.map_error(fn(e) {
        "로그인 타임아웃 (5분): " <> string.inspect(e)
      }),
    )

    // 세션 캡처용 새 페이지 (cross-origin 이동 후 기존 page 컨텍스트 무효)
    use fresh_page <- result.try(
      chrobot_extra.open(browser, "https://marketplace.mendix.com/", 30_000)
      |> result.map_error(fn(e) {
        "세션 캡처 페이지 열기 실패: " <> string.inspect(e)
      }),
    )

    use _ <- result.try(
      chrobot_extra.await_selector(
        on: chrobot_extra.with_timeout(fresh_page, 30_000),
        select: "body",
      )
      |> result.map_error(fn(e) {
        "페이지 로드 대기 실패: " <> string.inspect(e)
      }),
    )

    use state <- result.try(
      session.save(fresh_page)
      |> result.map_error(fn(e) {
        "세션 저장 실패: " <> string.inspect(e)
      }),
    )

    use _ <- result.try(
      session.save_to_file(state, session_path)
      |> result.map_error(fn(e) {
        "세션 파일 쓰기 실패: " <> string.inspect(e)
      }),
    )

    Ok(Nil)
  }

  let _ = chrobot_extra.quit(browser)
  result
}

fn ok_response() -> Response(ResponseData) {
  http_utils.json_response(200, json.object([#("ok", json.bool(True))]))
}
