//// Provides typed access to Mendix editable values.
////

import gleam/option
import mendraw/mendix
import mendraw/mendix/formatter

/// A typed `EditableValue` value used by the editable value capability.
pub type EditableValue

/// Returns the editable value loading status.
pub fn status(ev ev: EditableValue) -> mendix.ValueStatus {
  mendix.to_value_status(get_status_raw(ev))
}

/// Returns the current editable value when available.
pub fn value(ev ev: EditableValue) -> option.Option(a) {
  value_raw(ev)
}

/// Reports whether the value is read-only.
pub fn read_only(ev ev: EditableValue) -> Bool {
  read_only_raw(ev)
}

/// Returns the current validation message.
pub fn validation(ev ev: EditableValue) -> option.Option(String) {
  validation_raw(ev)
}

/// Returns the current display text.
pub fn display_value(ev ev: EditableValue) -> String {
  display_value_raw(ev)
}

/// Returns the value formatter.
pub fn formatter(ev ev: EditableValue) -> formatter.ValueFormatter {
  formatter_raw(ev)
}

/// Returns the allowed value universe when available.
pub fn universe(ev ev: EditableValue) -> option.Option(List(a)) {
  universe_raw(ev)
}

/// Sets the value.
pub fn set_value(ev ev: EditableValue, value value: option.Option(a)) -> Nil {
  set_value_raw(ev, value)
}

/// Sets the text value.
pub fn set_text_value(ev ev: EditableValue, text text: String) -> Nil {
  set_text_value_raw(ev, text)
}

/// Sets the validator.
pub fn set_validator(
  ev ev: EditableValue,
  validator validator: option.Option(
    fn(option.Option(a)) -> option.Option(String),
  ),
) -> Nil {
  set_validator_raw(ev, validator)
}

/// Reports whether the editable value is available.
pub fn is_available(ev ev: EditableValue) -> Bool {
  status(ev) == mendix.Available
}

/// Reports whether the value is available and writable.
pub fn is_editable(ev ev: EditableValue) -> Bool {
  is_available(ev) && !read_only(ev)
}

// -- FFI --
@external(javascript, "../mendix_ffi.mjs", "get_status")
fn get_status_raw(ev: EditableValue) -> String

@external(javascript, "../mendix_ffi.mjs", "get_editable_value")
fn value_raw(ev ev: EditableValue) -> option.Option(a)

@external(javascript, "../mendix_ffi.mjs", "get_editable_read_only")
fn read_only_raw(ev ev: EditableValue) -> Bool

@external(javascript, "../mendix_ffi.mjs", "get_editable_validation")
fn validation_raw(ev ev: EditableValue) -> option.Option(String)

@external(javascript, "../mendix_ffi.mjs", "get_editable_display_value")
fn display_value_raw(ev ev: EditableValue) -> String

@external(javascript, "../mendix_ffi.mjs", "get_editable_formatter")
fn formatter_raw(ev ev: EditableValue) -> formatter.ValueFormatter

@external(javascript, "../mendix_ffi.mjs", "get_editable_universe")
fn universe_raw(ev ev: EditableValue) -> option.Option(List(a))

@external(javascript, "../mendix_ffi.mjs", "editable_set_value")
fn set_value_raw(ev ev: EditableValue, value value: option.Option(a)) -> Nil

@external(javascript, "../mendix_ffi.mjs", "editable_set_text_value")
fn set_text_value_raw(ev ev: EditableValue, text text: String) -> Nil

@external(javascript, "../mendix_ffi.mjs", "editable_set_validator")
fn set_validator_raw(
  ev ev: EditableValue,
  validator validator: option.Option(
    fn(option.Option(a)) -> option.Option(String),
  ),
) -> Nil
