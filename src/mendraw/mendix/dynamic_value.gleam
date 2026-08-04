//// Provides typed access to Mendix dynamic values.
////

import gleam/option
import mendraw/mendix

/// Represents a Mendix dynamic value containing a known Gleam value type.
pub type DynamicValue(value)

/// Returns the dynamic value loading status.
pub fn status(dv dv: DynamicValue(value)) -> mendix.ValueStatus {
  mendix.to_value_status(get_status_raw(dv))
}

/// Returns the current dynamic value when available.
pub fn value(dv dv: DynamicValue(value)) -> option.Option(value) {
  value_raw(dv)
}

/// Reports whether the dynamic value is available.
pub fn is_available(dv dv: DynamicValue(value)) -> Bool {
  status(dv) == mendix.Available
}

// -- FFI --
@external(javascript, "../mendix_ffi.mjs", "get_status")
fn get_status_raw(dv: DynamicValue(value)) -> String

@external(javascript, "../mendix_ffi.mjs", "get_dynamic_value")
fn value_raw(dv dv: DynamicValue(value)) -> option.Option(value)
