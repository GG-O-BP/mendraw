//// Provides typed access to Mendix reference-set values.
////

import gleam/option

/// A typed `ReferenceSetValue` value used by the reference set capability.
pub type ReferenceSetValue

/// Returns the referenced values.
pub fn value(rset rset: ReferenceSetValue) -> option.Option(List(a)) {
  value_raw(rset)
}

/// Sets the value.
pub fn set_value(
  rset rset: ReferenceSetValue,
  value value: option.Option(List(a)),
) -> Nil {
  set_value_raw(rset, value)
}

/// Reads the only.
pub fn read_only(rset rset: ReferenceSetValue) -> Bool {
  read_only_raw(rset)
}

/// Returns the current validation message.
pub fn validation(rset rset: ReferenceSetValue) -> option.Option(String) {
  validation_raw(rset)
}

// -- FFI --
@external(javascript, "../mendix_ffi.mjs", "get_reference_set_value")
fn value_raw(rset rset: ReferenceSetValue) -> option.Option(List(a))

@external(javascript, "../mendix_ffi.mjs", "set_reference_set_value")
fn set_value_raw(
  rset rset: ReferenceSetValue,
  value value: option.Option(List(a)),
) -> Nil

@external(javascript, "../mendix_ffi.mjs", "get_modifiable_read_only")
fn read_only_raw(rset rset: ReferenceSetValue) -> Bool

@external(javascript, "../mendix_ffi.mjs", "get_modifiable_validation")
fn validation_raw(rset rset: ReferenceSetValue) -> option.Option(String)
