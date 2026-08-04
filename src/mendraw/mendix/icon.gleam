//// Provides typed access to Mendix web icons.
////

/// A typed `WebIcon` value used by the icon capability.
pub type WebIcon

/// A typed `IconType` value used by the icon capability.
pub type IconType {
  /// The `Glyph` variant.
  Glyph
  /// The `Image` variant.
  Image
  /// The `IconFont` variant.
  IconFont
}

/// Returns the typed icon kind.
pub fn icon_type(icon icon: WebIcon) -> IconType {
  case get_icon_type_raw(icon) {
    "glyph" -> Glyph
    "image" -> Image
    _ -> IconFont
  }
}

/// Returns the icon font class.
pub fn icon_class(icon icon: WebIcon) -> String {
  icon_class_raw(icon)
}

/// Returns the icon image URL.
pub fn icon_url(icon icon: WebIcon) -> String {
  icon_url_raw(icon)
}

// -- FFI --
@external(javascript, "../mendix_ffi.mjs", "get_icon_type")
fn get_icon_type_raw(icon: WebIcon) -> String

@external(javascript, "../mendix_ffi.mjs", "get_icon_class")
fn icon_class_raw(icon icon: WebIcon) -> String

@external(javascript, "../mendix_ffi.mjs", "get_icon_url")
fn icon_url_raw(icon icon: WebIcon) -> String
