// HTTP 유틸리티 — JSON 응답, 요청 본문 읽기

import gleam/bit_array
import gleam/bytes_tree
import gleam/http/request.{type Request}
import gleam/http/response.{type Response}
import gleam/json
import mist.{type Connection, type ResponseData}

pub fn json_response(status: Int, body: json.Json) -> Response(ResponseData) {
  response.new(status)
  |> response.set_body(mist.Bytes(bytes_tree.from_string(json.to_string(body))))
  |> response.set_header("content-type", "application/json")
}

pub fn read_body(
  req: Request(Connection),
) -> Result(String, Response(ResponseData)) {
  case mist.read_body(req, 1_048_576) {
    Ok(req_with_body) -> {
      case bit_array.to_string(req_with_body.body) {
        Ok(str) -> Ok(str)
        Error(_) ->
          Error(json_response(
            400,
            json.object([#("error", json.string("잘못된 요청 본문"))]),
          ))
      }
    }
    Error(_) ->
      Error(json_response(
        400,
        json.object([#("error", json.string("요청 본문 읽기 실패"))]),
      ))
  }
}

pub fn error_response(message: String) -> Response(ResponseData) {
  json_response(
    500,
    json.object([#("ok", json.bool(False)), #("error", json.string(message))]),
  )
}
