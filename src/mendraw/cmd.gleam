// widgets/ 디렉토리의 .mpk + build/widgets/ 캐시에서 위젯 컴포넌트 바인딩을 생성한다

import gleam/option.{type Option}

/// 파일 존재 여부를 확인한다.
@external(javascript, "./cmd_ffi.mjs", "file_exists")
pub fn file_exists(path: String) -> Bool

/// widgets/ 디렉토리의 .mpk + build/widgets/ 캐시에서 위젯 컴포넌트 바인딩을 생성한다.
/// mendraw 빌드 경로에 widget_ffi.mjs와 위젯 에셋을 생성한다.
@external(javascript, "./cmd_ffi.mjs", "generate_widget_bindings")
pub fn generate_widget_bindings() -> Nil

/// gleam.toml [tools.mendraw.widgets.*]에 등록된 위젯을 다운로드/캐시한다.
@external(javascript, "./cmd_ffi.mjs", "resolve_toml_widgets")
pub fn resolve_toml_widgets() -> Nil

/// gleam.toml에 위젯 항목을 쓰기/업데이트한다.
@external(javascript, "./cmd_ffi.mjs", "write_widget_toml")
pub fn write_widget_toml(
  name: String,
  version: String,
  id: Option(Int),
  s3_id: Option(String),
) -> Nil

/// .mpk를 다운로드하고 build/widgets/{name}/에 추출한다.
@external(javascript, "./cmd_ffi.mjs", "download_to_cache")
pub fn download_to_cache(
  url: String,
  name: String,
  version: String,
  id: Option(Int),
) -> Bool
