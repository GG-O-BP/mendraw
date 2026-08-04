//// Resolves generated Mendix widget bindings and constructs their properties.
////
//// ```gleam
//// import gleam/result
//// import mendraw/widget
//// import mendraw/interop
////
//// use component <- result.try(widget.component("Switch"))
//// Ok(interop.component_el(component, [
////   widget.editable_prop("textAttr", value, display, set_value),
////   widget.action_prop("onClick", handler),
//// ], []))
//// ```

import gleam/result
import mendraw/interop
import redraw/dom/attribute

/// Describes a generated widget-binding lookup failure.
pub type WidgetError {
  /// The requested widget is not registered in the generated binding table.
  ComponentWasNotFound(name: String, reason: String)
}

/// Resolves a Mendix widget component by name.
pub fn component(
  name name: String,
) -> Result(interop.JsComponent, WidgetError) {
  component_raw(name)
  |> result.map_error(fn(error) {
    ComponentWasNotFound(name: name, reason: raw_widget_error_message(error))
  })
}

/// Creates a dynamic widget property.
pub fn prop(key key: String, value value: a) -> attribute.Attribute {
  attribute.attribute(key, to_mendix_dynamic(value))
}

/// Creates an editable widget property.
pub fn editable_prop(
  key key: String,
  value value: a,
  display_value display_value: String,
  set_value set_value: fn(a) -> Nil,
) -> attribute.Attribute {
  attribute.attribute(key, to_mendix_editable(value, display_value, set_value))
}

/// Creates an action widget property.
pub fn action_prop(
  key key: String,
  handler handler: fn() -> Nil,
) -> attribute.Attribute {
  attribute.attribute(key, to_mendix_action(handler))
}

type RawWidgetError

// -- FFI --
@external(javascript, "./widget_ffi.mjs", "get_widget")
fn component_raw(
  name name: String,
) -> Result(interop.JsComponent, RawWidgetError)

@external(javascript, "./widget_ffi.mjs", "widget_error_message")
fn raw_widget_error_message(error: RawWidgetError) -> String

@external(javascript, "./widget_prop_ffi.mjs", "dynamic_value")
fn to_mendix_dynamic(value: a) -> a

@external(javascript, "./widget_prop_ffi.mjs", "editable_value")
fn to_mendix_editable(
  value: a,
  display_value: String,
  set_value: fn(a) -> Nil,
) -> a

@external(javascript, "./widget_prop_ffi.mjs", "action_value")
fn to_mendix_action(handler: fn() -> Nil) -> a
