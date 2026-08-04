//// Provides typed access to Mendix reference values.
////

import gleam/option

/// A typed `ReferenceValue` value used by the reference capability.
pub type ReferenceValue

/// Returns the referenced value.
pub fn value(ref ref: ReferenceValue) -> option.Option(a) {
  value_raw(ref)
}

/// Sets the value.
pub fn set_value(
  ref ref: ReferenceValue,
  value value: option.Option(a),
) -> Nil {
  set_value_raw(ref, value)
}

/// Reads the only.
pub fn read_only(ref ref: ReferenceValue) -> Bool {
  read_only_raw(ref)
}

/// Returns the current validation message.
pub fn validation(ref ref: ReferenceValue) -> option.Option(String) {
  validation_raw(ref)
}

// -- FFI --
@external(javascript, "../mendix_ffi.mjs", "get_modifiable_value")
fn value_raw(ref ref: ReferenceValue) -> option.Option(a)

@external(javascript, "../mendix_ffi.mjs", "modifiable_set_value")
fn set_value_raw(ref ref: ReferenceValue, value value: option.Option(a)) -> Nil

@external(javascript, "../mendix_ffi.mjs", "get_modifiable_read_only")
fn read_only_raw(ref ref: ReferenceValue) -> Bool

@external(javascript, "../mendix_ffi.mjs", "get_modifiable_validation")
fn validation_raw(ref ref: ReferenceValue) -> option.Option(String)
