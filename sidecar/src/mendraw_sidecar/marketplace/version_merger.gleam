// Content API 버전 + XAS 버전 데이터 병합 로직

import gleam/dict
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import mendraw_sidecar/marketplace/content_api.{type ContentApiVersion}
import mendraw_sidecar/xas_parser.{type XasVersion}

// ── 타입 ──

pub type MergedVersion {
  MergedVersion(
    version_number: String,
    publication_date: Option(String),
    min_mendix_version: Option(String),
    s3_object_id: Option(String),
    react_ready: Option(Bool),
    downloadable: Bool,
  )
}

// ── 병합 ──

/// Content API 버전 목록과 XAS 버전 데이터를 병합
pub fn merge(
  api_versions: List(ContentApiVersion),
  xas_versions: List(XasVersion),
) -> List(MergedVersion) {
  let xas_index = build_xas_index(xas_versions)
  let s3_template = extract_s3_template(xas_versions)

  list.map(api_versions, fn(api) {
    case dict.get(xas_index, api.version_number) {
      // XAS에서 정확히 매치된 경우
      Ok(xas) ->
        MergedVersion(
          version_number: api.version_number,
          publication_date: api.publication_date,
          min_mendix_version: api.min_supported_mendix_version,
          s3_object_id: Some(xas.s3_object_id),
          react_ready: Some(xas.react_ready),
          downloadable: True,
        )
      Error(_) ->
        case s3_template {
          // S3 템플릿으로 추정 가능한 경우
          Some(#(prefix, file_name)) ->
            MergedVersion(
              version_number: api.version_number,
              publication_date: api.publication_date,
              min_mendix_version: api.min_supported_mendix_version,
              s3_object_id: Some(
                prefix <> "/" <> api.version_number <> "/" <> file_name,
              ),
              react_ready: None,
              downloadable: True,
            )
          // 다운로드 불가
          None ->
            MergedVersion(
              version_number: api.version_number,
              publication_date: api.publication_date,
              min_mendix_version: api.min_supported_mendix_version,
              s3_object_id: None,
              react_ready: None,
              downloadable: False,
            )
        }
    }
  })
}

// ── 내부 함수 ──

/// XAS 버전 인덱스 생성 (버전 번호 → XasVersion)
fn build_xas_index(
  xas_versions: List(XasVersion),
) -> dict.Dict(String, XasVersion) {
  list.fold(xas_versions, dict.new(), fn(acc, xas) {
    let acc = case xas.version_number {
      "" -> acc
      vn -> dict.insert(acc, vn, xas)
    }
    // S3 경로에서 버전 번호 추출 (prefix/version/file 형식)
    let parts = string.split(xas.s3_object_id, "/")
    case list.length(parts) >= 4 {
      True ->
        case list.drop(parts, 2) |> list.first {
          Ok(ver) -> dict.insert(acc, ver, xas)
          Error(_) -> acc
        }
      False -> acc
    }
  })
}

/// XAS 버전에서 S3 경로 패턴 추출 (prefix, file_name)
fn extract_s3_template(
  xas_versions: List(XasVersion),
) -> Option(#(String, String)) {
  list.find_map(xas_versions, fn(xas) {
    let parts = string.split(xas.s3_object_id, "/")
    case list.length(parts) >= 4 {
      True -> {
        let prefix =
          list.take(parts, 2)
          |> string.join("/")
        let file_name =
          list.drop(parts, 3)
          |> string.join("/")
        Ok(#(prefix, file_name))
      }
      False -> Error(Nil)
    }
  })
  |> option.from_result
}
