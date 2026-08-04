//// Provides typed access to Mendix file and image values.
////

import gleam/option

/// A typed `FileValue` value used by the file capability.
pub type FileValue

/// A typed `WebImage` value used by the file capability.
pub type WebImage

/// Returns the file URI.
pub fn uri(f f: FileValue) -> String {
  uri_raw(f)
}

/// Returns the file name when available.
pub fn name(f f: FileValue) -> option.Option(String) {
  name_raw(f)
}

/// Returns the image URI.
pub fn image_uri(img img: WebImage) -> String {
  image_uri_raw(img)
}

/// Returns the image file name when available.
pub fn image_name(img img: WebImage) -> option.Option(String) {
  image_name_raw(img)
}

/// Returns the image alternative text when available.
pub fn alt_text(img img: WebImage) -> option.Option(String) {
  alt_text_raw(img)
}

// -- FFI --
@external(javascript, "../mendix_ffi.mjs", "get_file_uri")
fn uri_raw(f f: FileValue) -> String

@external(javascript, "../mendix_ffi.mjs", "get_file_name")
fn name_raw(f f: FileValue) -> option.Option(String)

@external(javascript, "../mendix_ffi.mjs", "get_file_uri")
fn image_uri_raw(img img: WebImage) -> String

@external(javascript, "../mendix_ffi.mjs", "get_file_name")
fn image_name_raw(img img: WebImage) -> option.Option(String)

@external(javascript, "../mendix_ffi.mjs", "get_image_alt_text")
fn alt_text_raw(img img: WebImage) -> option.Option(String)
