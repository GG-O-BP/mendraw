//// Provides typed access to common Mendix client values.
////

import gleam/list
import gleam/option
import gleam/string

/// A typed `JsProps` value used by the mendix capability.
pub type JsProps

// -- Valuestatus --
/// A typed `ValueStatus` value used by the mendix capability.
pub type ValueStatus {
  /// The `Available` variant.
  Available
  /// The `Unavailable` variant.
  Unavailable
  /// The `Loading` variant.
  Loading
}

// -- Objectitem --
/// A typed `ObjectItem` value used by the mendix capability.
pub type ObjectItem

/// Converts a Mendix status string into a typed status.
pub fn to_value_status(status status: String) -> ValueStatus {
  case status {
    "available" -> Available
    "loading" -> Loading
    _ -> Unavailable
  }
}

/// Returns the Mendix object identifier.
pub fn object_id(item item: ObjectItem) -> String {
  object_id_raw(item)
}

/// Returns an optional Mendix property.
pub fn get_prop(props props: JsProps, key key: String) -> option.Option(a) {
  get_prop_raw(props, key)
}

/// Returns a required Mendix property.
pub fn get_prop_required(props props: JsProps, key key: String) -> a {
  get_prop_required_raw(props, key)
}

/// Returns a Mendix property as text.
pub fn get_string_prop(props props: JsProps, key key: String) -> String {
  get_string_prop_raw(props, key)
}

/// Reports whether a Mendix property is present.
pub fn has_prop(props props: JsProps, key key: String) -> Bool {
  has_prop_raw(props, key)
}

/// Returns the typed status of a Mendix value.
pub fn get_status(obj obj: a) -> ValueStatus {
  to_value_status(get_status_raw(obj))
}

/// Converts nullable JavaScript data into an option.
pub fn to_option(value value: a) -> option.Option(a) {
  to_option_raw(value)
}

/// Converts an option into nullable JavaScript data.
pub fn from_option(option option: option.Option(a)) -> a {
  from_option_raw(option)
}

/// Joins the class names whose conditions are enabled.
pub fn cx(classes classes: List(#(String, Bool))) -> String {
  classes
  |> list.filter_map(fn(pair) {
    case pair.1 {
      True -> Ok(pair.0)
      False -> Error(Nil)
    }
  })
  |> string.join(" ")
}

// -- FFI --
@external(javascript, "./mendix_ffi.mjs", "get_object_id")
fn object_id_raw(item item: ObjectItem) -> String

@external(javascript, "./mendix_ffi.mjs", "get_mendix_prop")
fn get_prop_raw(props props: JsProps, key key: String) -> option.Option(a)

@external(javascript, "./mendix_ffi.mjs", "get_mendix_prop_required")
fn get_prop_required_raw(props props: JsProps, key key: String) -> a

@external(javascript, "./mendix_ffi.mjs", "get_string_prop")
fn get_string_prop_raw(props props: JsProps, key key: String) -> String

@external(javascript, "./mendix_ffi.mjs", "has_prop")
fn has_prop_raw(props props: JsProps, key key: String) -> Bool

@external(javascript, "./mendix_ffi.mjs", "get_status")
fn get_status_raw(obj: a) -> String

@external(javascript, "./mendix_ffi.mjs", "to_option")
fn to_option_raw(value value: a) -> option.Option(a)

@external(javascript, "./mendix_ffi.mjs", "from_option")
fn from_option_raw(option option: option.Option(a)) -> a
