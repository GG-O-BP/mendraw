// /versions/all, /versions/single 핸들러
// headless 브라우저로 Marketplace 컴포넌트 페이지 → Releases 탭 → XAS 응답 수집

import chrobot_extra
import chrobot_extra/chrome
import chrobot_extra/network_idle
import chrobot_extra/network_listener
import chrobot_extra/protocol/page as page_protocol
import chrobot_extra/protocol/runtime
import chrobot_extra/session
import gleam/dict.{type Dict}
import gleam/dynamic/decode
import gleam/erlang/process
import gleam/http/request.{type Request}
import gleam/http/response.{type Response}
import gleam/int
import gleam/io
import gleam/json
import gleam/list
import gleam/option
import gleam/result
import gleam/string
import mendraw_sidecar/http_utils
import mendraw_sidecar/xas_parser.{type XasVersion}
import mist.{type Connection, type ResponseData}

// ── /versions/all ──

pub fn handle_all(req: Request(Connection)) -> Response(ResponseData) {
  case http_utils.read_body(req) {
    Error(resp) -> resp
    Ok(body) -> {
      case parse_all_request(body) {
        Error(msg) -> http_utils.error_response(msg)
        Ok(#(session_path, content_ids)) ->
          do_get_all_versions(session_path, content_ids)
      }
    }
  }
}

fn parse_all_request(body: String) -> Result(#(String, List(Int)), String) {
  let decoder = {
    use session_path <- decode.field("session_path", decode.string)
    use content_ids <- decode.field("content_ids", decode.list(decode.int))
    decode.success(#(session_path, content_ids))
  }
  case json.parse(body, decoder) {
    Ok(result) -> Ok(result)
    Error(_) -> Error("session_path, content_ids 필드가 필요합니다")
  }
}

fn do_get_all_versions(
  session_path: String,
  content_ids: List(Int),
) -> Response(ResponseData) {
  case get_all_versions(session_path, content_ids) {
    Ok(results) -> {
      let entries =
        dict.to_list(results)
        |> list.map(fn(entry) {
          let #(id, versions) = entry
          #(int.to_string(id), json.array(versions, xas_parser.encode_version))
        })
      http_utils.json_response(200, json.object(entries))
    }
    Error(msg) -> http_utils.error_response(msg)
  }
}

fn get_all_versions(
  session_path: String,
  content_ids: List(Int),
) -> Result(Dict(Int, List(XasVersion)), String) {
  // 세션 로드
  use state <- result.try(
    session.load_from_file(session_path)
    |> result.map_error(fn(_) { "세션 파일 로드 실패" }),
  )

  // headless 브라우저 시작
  use browser <- result.try(
    chrobot_extra.launch()
    |> result.map_error(fn(_) { "브라우저 시작 실패" }),
  )

  let result = {
    // 초기 페이지 열기 + 세션 복원
    use page <- result.try(
      chrobot_extra.open(browser, "https://marketplace.mendix.com/", 30_000)
      |> result.map_error(fn(_) { "페이지 열기 실패" }),
    )

    use _ <- result.try(
      session.restore(page, state)
      |> result.map_error(fn(_) { "세션 복원 실패" }),
    )

    // 각 content_id에 대해 버전 정보 수집
    let results =
      list.fold(content_ids, dict.new(), fn(acc, content_id) {
        let versions = collect_versions_for_id(browser, content_id)
        dict.insert(acc, content_id, versions)
      })

    Ok(results)
  }

  let _ = chrobot_extra.quit(browser)
  result
}

// 단일 content_id에 대한 버전 정보 수집
fn collect_versions_for_id(
  browser: process.Subject(chrome.Message),
  content_id: Int,
) -> List(XasVersion) {
  let url =
    "https://marketplace.mendix.com/link/component/"
    <> int.to_string(content_id)

  case collect_versions_impl(browser, url) {
    Ok(versions) -> versions
    Error(msg) -> {
      io.println(
        "  [sidecar] 오류 (id=" <> int.to_string(content_id) <> "): " <> msg,
      )
      []
    }
  }
}

fn collect_versions_impl(
  browser: process.Subject(chrome.Message),
  url: String,
) -> Result(List(XasVersion), String) {
  // 새 페이지 열기 (network listener 시작 전에 빈 페이지)
  use page <- result.try(
    chrobot_extra.open(browser, "about:blank", 30_000)
    |> result.map_error(fn(_) { "페이지 생성 실패" }),
  )

  let result = {
    // network listener 시작 (XAS 응답 수집용)
    use response_listener <- result.try(
      network_listener.start(page)
      |> result.map_error(fn(_) { "network listener 시작 실패" }),
    )

    let inner_result = {
      // network idle listener 시작
      use idle_listener <- result.try(
        network_idle.start(page)
        |> result.map_error(fn(_) { "network idle listener 시작 실패" }),
      )

      // 페이지 네비게이션
      let caller = chrobot_extra.page_caller(page)
      use _ <- result.try(
        page_protocol.navigate(
          caller,
          url: url,
          referrer: option.None,
          transition_type: option.None,
          frame_id: option.None,
        )
        |> result.map_error(fn(_) { "네비게이션 실패" }),
      )

      // network idle 대기
      let _ =
        network_idle.wait_for_idle(
          idle_listener,
          quiet_ms: 500,
          time_out: 30_000,
        )
      network_idle.stop(idle_listener)

      // Releases 탭 클릭 시도
      try_click_releases_tab(page)

      // 탭 클릭 후 network idle 대기
      case network_idle.start(page) {
        Ok(idle2) -> {
          let _ =
            network_idle.wait_for_idle(idle2, quiet_ms: 500, time_out: 30_000)
          network_idle.stop(idle2)
        }
        Error(_) -> Nil
      }

      // 추가 XAS 응답 대기
      process.sleep(3000)

      // XAS 응답 수집
      let xas_responses =
        network_listener.collect_responses(response_listener, filter: fn(event) {
          string.contains(event.response.url, "/xas/")
        })
        |> result.unwrap([])

      // XAS 응답 파싱
      let versions =
        list.flat_map(xas_responses, fn(resp) {
          xas_parser.parse_xas_body(resp.body)
        })

      // 중복 제거 (s3_object_id 기준)
      let unique = deduplicate_versions(versions)

      Ok(unique)
    }

    network_listener.stop(response_listener)
    inner_result
  }

  let _ = chrobot_extra.close(page)
  result
}

// s3_object_id 기준 중복 제거
fn deduplicate_versions(versions: List(XasVersion)) -> List(XasVersion) {
  list.fold(versions, #([], dict.new()), fn(acc, v) {
    let #(result_list, seen) = acc
    case dict.has_key(seen, v.s3_object_id) {
      True -> acc
      False -> #(
        list.append(result_list, [v]),
        dict.insert(seen, v.s3_object_id, True),
      )
    }
  }).0
}

// Releases 탭 클릭 — 3개 셀렉터 순차 시도
fn try_click_releases_tab(page: chrobot_extra.Page) -> Nil {
  // 1. a.mx-name-tabPage10
  case chrobot_extra.click_selector(on: page, target: "a.mx-name-tabPage10") {
    Ok(_) -> Nil
    Error(_) -> {
      // 2. a[role="tab"] 중 Releases 텍스트 포함 탭
      case try_click_tab_by_text(page) {
        Ok(_) -> Nil
        Error(_) -> {
          // 3. JavaScript 폴백
          let _ =
            chrobot_extra.eval(
              on: page,
              js: "(() => { const tabs = document.querySelectorAll('a[role=\"tab\"]'); for (const t of tabs) { if (t.textContent.includes('Releases')) { t.click(); return true; } } return false; })()",
            )
          Nil
        }
      }
    }
  }
}

fn try_click_tab_by_text(
  page: chrobot_extra.Page,
) -> Result(Nil, chrome.RequestError) {
  use tabs <- result.try(chrobot_extra.select_all(
    on: page,
    matching: "a[role=\"tab\"]",
  ))
  find_and_click_releases(page, tabs)
}

fn find_and_click_releases(
  page: chrobot_extra.Page,
  tabs: List(runtime.RemoteObjectId),
) -> Result(Nil, chrome.RequestError) {
  case tabs {
    [] -> Error(chrome.NotFoundError)
    [tab, ..rest] -> {
      case chrobot_extra.get_text(on: page, from: tab) {
        Ok(text) -> {
          case string.contains(text, "Releases") {
            True ->
              chrobot_extra.click(on: page, target: tab)
              |> result.map(fn(_) { Nil })
            False -> find_and_click_releases(page, rest)
          }
        }
        Error(_) -> find_and_click_releases(page, rest)
      }
    }
  }
}

// ── /versions/single ──

pub fn handle_single(req: Request(Connection)) -> Response(ResponseData) {
  case http_utils.read_body(req) {
    Error(resp) -> resp
    Ok(body) -> {
      case parse_single_request(body) {
        Error(msg) -> http_utils.error_response(msg)
        Ok(#(session_path, content_id, target_version)) ->
          do_get_single_version(session_path, content_id, target_version)
      }
    }
  }
}

fn parse_single_request(body: String) -> Result(#(String, Int, String), String) {
  let decoder = {
    use session_path <- decode.field("session_path", decode.string)
    use content_id <- decode.field("content_id", decode.int)
    use target_version <- decode.field("target_version", decode.string)
    decode.success(#(session_path, content_id, target_version))
  }
  case json.parse(body, decoder) {
    Ok(result) -> Ok(result)
    Error(_) -> Error("session_path, content_id, target_version 필드가 필요합니다")
  }
}

fn do_get_single_version(
  session_path: String,
  content_id: Int,
  target_version: String,
) -> Response(ResponseData) {
  case
    get_all_versions(session_path, [content_id])
    |> result.map(fn(results) {
      let versions = result.unwrap(dict.get(results, content_id), [])
      list.find(versions, fn(v) { v.version_number == target_version })
    })
  {
    Ok(Ok(version)) ->
      http_utils.json_response(
        200,
        json.object([#("s3_id", json.string(version.s3_object_id))]),
      )
    _ -> http_utils.json_response(200, json.object([#("s3_id", json.null())]))
  }
}
