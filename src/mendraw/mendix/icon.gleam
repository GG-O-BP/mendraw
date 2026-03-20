// Mendix WebIcon 타입 — 아이콘 (글리프, 이미지, 아이콘 폰트)
// Studio Pro에서 설정한 아이콘 속성

// === 타입 ===

pub type WebIcon

pub type IconType {
  Glyph
  Image
  IconFont
}

// === 접근자 ===

@external(javascript, "../mendix_ffi.mjs", "get_icon_type")
fn get_icon_type_raw(icon: WebIcon) -> String

/// 아이콘 종류 (Glyph, Image, IconFont)
pub fn icon_type(icon: WebIcon) -> IconType {
  case get_icon_type_raw(icon) {
    "glyph" -> Glyph
    "image" -> Image
    _ -> IconFont
  }
}

/// 아이콘 CSS 클래스 (Glyph, IconFont에서 사용)
@external(javascript, "../mendix_ffi.mjs", "get_icon_class")
pub fn icon_class(icon: WebIcon) -> String

/// 아이콘 이미지 URL (Image에서 사용)
@external(javascript, "../mendix_ffi.mjs", "get_icon_url")
pub fn icon_url(icon: WebIcon) -> String
