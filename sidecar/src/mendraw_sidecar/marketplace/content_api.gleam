// Mendix Marketplace Content API 클라이언트 (gleam_httpc 기반)

import gleam/dynamic/decode
import gleam/http
import gleam/http/request
import gleam/httpc
import gleam/int
import gleam/json
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/result
import gleam/string

const api_base = "https://marketplace-api.mendix.com/v1"

pub const fetch_size = 40

// ── 타입 ──

pub type Widget {
  Widget(
    name: Option(String),
    content_id: Int,
    publisher: Option(String),
    latest_version: Option(String),
    widget_type: String,
  )
}

pub type ContentApiVersion {
  ContentApiVersion(
    version_number: String,
    publication_date: Option(String),
    min_supported_mendix_version: Option(String),
  )
}

pub type ContentPage {
  ContentPage(widgets: List(Widget), total_items: Int, all_done: Bool)
}

// ── Content API 호출 ──

/// 위젯/모듈 목록 한 페이지 조회
pub fn fetch_content_page(
  pat: String,
  offset: Int,
  limit: Int,
) -> Result(ContentPage, String) {
  let url =
    api_base
    <> "/content?limit="
    <> int.to_string(limit)
    <> "&offset="
    <> int.to_string(offset)
  use resp <- result.try(api_get(url, pat))
  use body <- result.try(
    json.parse(resp, content_page_decoder())
    |> result.map_error(fn(_) { "Content API 응답 파싱 실패" }),
  )
  Ok(body)
}

/// 특정 위젯의 버전 목록 조회
pub fn fetch_versions(
  pat: String,
  content_id: Int,
) -> Result(List(ContentApiVersion), String) {
  let url = api_base <> "/content/" <> int.to_string(content_id) <> "/versions"
  use resp <- result.try(api_get(url, pat))
  use versions <- result.try(
    json.parse(resp, versions_response_decoder())
    |> result.map_error(fn(_) { "버전 목록 파싱 실패" }),
  )
  // 날짜 역순 정렬 (최신 먼저)
  let sorted =
    list.sort(versions, fn(a: ContentApiVersion, b: ContentApiVersion) {
      let da = option.unwrap(a.publication_date, "")
      let db = option.unwrap(b.publication_date, "")
      string.compare(db, da)
    })
  Ok(sorted)
}

// ── HTTP 헬퍼 ──

fn api_get(url: String, pat: String) -> Result(String, String) {
  let req =
    request.new()
    |> request.set_host("marketplace-api.mendix.com")
    |> request.set_scheme(http.Https)
    |> request.set_method(http.Get)
    |> request.set_path(extract_path(url))
    |> request.set_header("authorization", "MxToken " <> pat)

  let config =
    httpc.configure()
    |> httpc.follow_redirects(True)
    |> httpc.timeout(30_000)

  case httpc.dispatch(config, req) {
    Ok(resp) ->
      case resp.status {
        200 -> Ok(resp.body)
        401 -> Error("인증 실패 — MENDIX_PAT를 확인하세요")
        status -> Error("API 에러: HTTP " <> int.to_string(status))
      }
    Error(_) -> Error("Content API 연결 실패")
  }
}

fn extract_path(url: String) -> String {
  case string.split_once(url, "marketplace-api.mendix.com") {
    Ok(#(_, path)) -> path
    Error(_) -> url
  }
}

// ── JSON 디코더 ──

fn content_page_decoder() -> decode.Decoder(ContentPage) {
  let items_decoder =
    decode.list(
      decode.one_of(widget_decoder(), [
        // Widget/Module이 아닌 아이템은 건너뜀
        decode.success(Widget(None, -1, None, None, "")),
      ]),
    )

  use items <- decode.field("items", items_decoder)
  // Widget/Module 타입만 필터링
  let widgets =
    list.filter(items, fn(w) {
      w.widget_type == "Widget" || w.widget_type == "Module"
    })
  let all_done = list.length(items) < fetch_size
  decode.success(ContentPage(widgets, list.length(items), all_done))
}

fn widget_decoder() -> decode.Decoder(Widget) {
  use content_id <- decode.field("contentId", decode.int)
  use widget_type <- decode.field("type", decode.string)
  use publisher <- decode.field("publisher", decode.optional(decode.string))
  use latest_version <- decode.optional_field(
    "latestVersion",
    None,
    latest_version_decoder(),
  )
  let name = case latest_version {
    Some(#(n, _)) -> n
    None -> None
  }
  let version_number = case latest_version {
    Some(#(_, v)) -> v
    None -> None
  }
  decode.success(Widget(
    name,
    content_id,
    publisher,
    version_number,
    widget_type,
  ))
}

fn latest_version_decoder() -> decode.Decoder(
  Option(#(Option(String), Option(String))),
) {
  use name <- decode.optional_field(
    "name",
    None,
    decode.optional(decode.string),
  )
  use version_number <- decode.optional_field(
    "versionNumber",
    None,
    decode.optional(decode.string),
  )
  decode.success(Some(#(name, version_number)))
}

fn versions_response_decoder() -> decode.Decoder(List(ContentApiVersion)) {
  use items <- decode.field("items", decode.list(content_api_version_decoder()))
  decode.success(items)
}

fn content_api_version_decoder() -> decode.Decoder(ContentApiVersion) {
  use version_number <- decode.field("versionNumber", decode.string)
  use publication_date <- decode.optional_field(
    "publicationDate",
    None,
    decode.optional(decode.string),
  )
  use min_mendix <- decode.optional_field(
    "minSupportedMendixVersion",
    None,
    decode.optional(decode.string),
  )
  decode.success(ContentApiVersion(version_number, publication_date, min_mendix))
}
