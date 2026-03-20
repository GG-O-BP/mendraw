// HTTP 라우팅 — path_segments 매칭으로 핸들러 분기

import gleam/dynamic
import gleam/erlang/process
import gleam/http
import gleam/http/request.{type Request}
import gleam/http/response.{type Response}
import gleam/json
import mendraw_sidecar/http_utils
import mendraw_sidecar/session_handler
import mendraw_sidecar/version_handler
import mist.{type Connection, type ResponseData}

pub fn handler() -> fn(Request(Connection)) -> Response(ResponseData) {
  fn(req: Request(Connection)) -> Response(ResponseData) {
    case request.path_segments(req), req.method {
      ["health"], http.Get -> handle_health()
      ["shutdown"], http.Post -> handle_shutdown()
      ["session", "ensure"], http.Post -> session_handler.handle(req)
      ["versions", "all"], http.Post -> version_handler.handle_all(req)
      ["versions", "single"], http.Post -> version_handler.handle_single(req)
      _, _ -> not_found()
    }
  }
}

fn handle_health() -> Response(ResponseData) {
  http_utils.json_response(200, json.object([#("status", json.string("ok"))]))
}

fn handle_shutdown() -> Response(ResponseData) {
  let resp =
    http_utils.json_response(
      200,
      json.object([#("status", json.string("shutting_down"))]),
    )
  // 200ms 후 VM 종료
  let _ =
    spawn_fn(fn() {
      process.sleep(200)
      init_stop()
    })
  resp
}

fn not_found() -> Response(ResponseData) {
  http_utils.json_response(
    404,
    json.object([#("error", json.string("not found"))]),
  )
}

@external(erlang, "erlang", "spawn")
fn spawn_fn(fun: fn() -> a) -> dynamic.Dynamic

@external(erlang, "init", "stop")
fn init_stop() -> Nil
