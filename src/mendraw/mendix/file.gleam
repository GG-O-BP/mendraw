// Mendix FileValue / WebImage 타입 — 파일 및 이미지 속성
// FileValue: 일반 파일, WebImage: 이미지 (altText 추가)

import gleam/option.{type Option}

// === 타입 ===

pub type FileValue

pub type WebImage

// === FileValue 접근자 ===

/// 파일 URI
@external(javascript, "../mendix_ffi.mjs", "get_file_uri")
pub fn uri(f: FileValue) -> String

/// 파일 이름 (없으면 None)
@external(javascript, "../mendix_ffi.mjs", "get_file_name")
pub fn name(f: FileValue) -> Option(String)

// === WebImage 접근자 (FileValue 확장) ===

/// 이미지 URI
@external(javascript, "../mendix_ffi.mjs", "get_file_uri")
pub fn image_uri(img: WebImage) -> String

/// 이미지 파일 이름 (없으면 None)
@external(javascript, "../mendix_ffi.mjs", "get_file_name")
pub fn image_name(img: WebImage) -> Option(String)

/// 이미지 대체 텍스트 (없으면 None)
@external(javascript, "../mendix_ffi.mjs", "get_image_alt_text")
pub fn alt_text(img: WebImage) -> Option(String)
