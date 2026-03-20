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
  let port = case get_plain_arguments() {
    [port_str, ..] -> int.parse(port_str) |> result.unwrap(0)
    _ -> 0
  }

  let assert Ok(_) =
    router.handler()
    |> mist.new
    |> mist.port(port)
    |> mist.start

  io.println("SIDECAR_PORT=" <> int.to_string(port))
  process.sleep_forever()
}

// Erlang init:get_plain_arguments() — gleam run -- <args>
fn get_plain_arguments() -> List(String) {
  do_get_plain_arguments()
  |> list.filter_map(fn(charlist) {
    case charlist_to_string(charlist) {
      Ok(s) -> Ok(s)
      Error(_) -> Error(Nil)
    }
  })
}

type Charlist

@external(erlang, "init", "get_plain_arguments")
fn do_get_plain_arguments() -> List(Charlist)

@external(erlang, "unicode", "characters_to_binary")
fn charlist_to_string(charlist: Charlist) -> Result(String, Nil)
