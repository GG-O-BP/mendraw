// XAS JSON 응답에서 AppStore.Version 객체 추출
// Mendix Marketplace의 /xas/ 엔드포인트가 반환하는 JSON을 파싱

import gleam/dynamic/decode
import gleam/json
import gleam/list
import gleam/option.{None, Some}
import gleam/result

pub type XasVersion {
  XasVersion(
    s3_object_id: String,
    react_ready: Bool,
    publish_date: String,
    version_number: String,
  )
}

// XAS 응답 본문에서 AppStore.Version 객체들을 추출
pub fn parse_xas_body(body: String) -> List(XasVersion) {
  case json.parse(body, decode_xas_response()) {
    Ok(versions) -> versions
    Error(_) -> []
  }
}

fn decode_xas_response() -> decode.Decoder(List(XasVersion)) {
  use objects <- decode.field("objects", decode.list(decode_maybe_version()))
  decode.success(list.filter_map(objects, fn(x) { x }))
}

fn decode_maybe_version() -> decode.Decoder(Result(XasVersion, Nil)) {
  use object_type <- decode.field("objectType", decode.string)
  case object_type {
    "AppStore.Version" -> {
      // attributes를 Dynamic으로 읽어서 수동 추출
      use attrs_opt <- decode.optional_field(
        "attributes",
        None,
        decode.optional(decode.dynamic),
      )
      case attrs_opt {
        None -> decode.success(Error(Nil))
        Some(attrs) -> extract_version(attrs)
      }
    }
    _ -> decode.success(Error(Nil))
  }
}

fn extract_version(
  attrs: decode.Dynamic,
) -> decode.Decoder(Result(XasVersion, Nil)) {
  // S3ObjectId 필수
  case decode.run(attrs, decode.at(["S3ObjectId", "value"], decode.string)) {
    Error(_) -> decode.success(Error(Nil))
    Ok(s3_id) -> {
      let react =
        decode.run(
          attrs,
          decode.at(["IsReactClientReady", "value"], decode.bool),
        )
        |> result.unwrap(False)

      let date =
        decode.run(attrs, decode.at(["PublishDate", "value"], decode.string))
        |> result.unwrap("")

      let ver =
        decode.run(
          attrs,
          decode.at(["DisplayVersionNumber", "value"], decode.string),
        )
        |> result.unwrap("")

      decode.success(
        Ok(XasVersion(
          s3_object_id: s3_id,
          react_ready: react,
          publish_date: date,
          version_number: ver,
        )),
      )
    }
  }
}

// XasVersion → JSON 인코딩
pub fn encode_version(v: XasVersion) -> json.Json {
  json.object([
    #("s3ObjectId", json.string(v.s3_object_id)),
    #("reactReady", json.bool(v.react_ready)),
    #("publishDate", json.string(v.publish_date)),
    #("versionNumber", json.string(v.version_number)),
  ])
}
