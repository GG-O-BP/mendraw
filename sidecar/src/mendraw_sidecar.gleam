// mendraw 사이드카 — Mendix Marketplace 브라우저 자동화 HTTP 서버
// Erlang 타겟에서 실행되며, mendraw(JS 타겟)와 HTTP로 통신

import gleam/erlang/process
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import mendraw_sidecar/router
import mist

pub fn main() {
  // escript 모드에서는 스크립트 경로도 인자에 포함되므로,
  // 정수로 파싱 가능한 첫 인자를 포트로 사용
  let port =
    get_arguments()
    |> list.find_map(int.parse)
    |> result.unwrap(0)

  let assert Ok(_) =
    router.handler()
    |> mist.new
    |> mist.port(port)
    |> mist.start

  io.println("SIDECAR_PORT=" <> int.to_string(port))
  process.sleep_forever()
}

// CLI 인자 취득 — charlist(gleam run)와 binary(escript) 양쪽 처리
@external(erlang, "mendraw_sidecar_ffi", "get_arguments")
fn get_arguments() -> List(String)
