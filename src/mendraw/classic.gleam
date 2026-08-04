//// Resolves generated classic Mendix widget bindings.
////
//// ```gleam
//// import mendraw/classic
////
//// classic.render(
////   "CameraWidget.widget.CameraWidget",
////   [
////     #("mfToExecute", classic.to_value(mf_value)),
////     #("preferRearCamera", classic.to_value(true)),
////   ],
//// )
//// ```

import gleam/result
import redraw

/// Represents a JavaScript value passed to a classic Mendix widget.
pub type ClassicValue

/// Describes a classic widget-binding lookup or render failure.
pub type ClassicError {
  /// The requested classic widget is not registered in the generated binding table.
  ClassicWidgetWasNotFound(widget_id: String, reason: String)
}

/// Converts a Gleam value into a classic-widget property value.
pub fn to_value(value value: a) -> ClassicValue {
  to_value_raw(value)
}

/// Renders a classic Mendix widget with typed properties.
pub fn render(
  widget_id widget_id: String,
  properties properties: List(#(String, ClassicValue)),
) -> Result(redraw.Element, ClassicError) {
  render_raw(widget_id, properties)
  |> map_render_error(widget_id)
}

/// Renders a classic Mendix widget with a CSS class.
pub fn render_with_class(
  widget_id widget_id: String,
  properties properties: List(#(String, ClassicValue)),
  class_name class_name: String,
) -> Result(redraw.Element, ClassicError) {
  render_with_class_raw(widget_id, properties, class_name)
  |> map_render_error(widget_id)
}

type RawClassicError

fn map_render_error(
  raw_result: Result(redraw.Element, RawClassicError),
  widget_id: String,
) -> Result(redraw.Element, ClassicError) {
  raw_result
  |> result.map_error(fn(error) {
    ClassicWidgetWasNotFound(
      widget_id: widget_id,
      reason: raw_classic_error_message(error),
    )
  })
}

// -- FFI --
@external(javascript, "./classic_ffi.mjs", "to_dynamic")
fn to_value_raw(value value: a) -> ClassicValue

@external(javascript, "./classic_ffi.mjs", "classic_widget_element")
fn render_raw(
  widget_id widget_id: String,
  properties properties: List(#(String, ClassicValue)),
) -> Result(redraw.Element, RawClassicError)

@external(javascript, "./classic_ffi.mjs", "classic_widget_element_with_class")
fn render_with_class_raw(
  widget_id widget_id: String,
  properties properties: List(#(String, ClassicValue)),
  class_name class_name: String,
) -> Result(redraw.Element, RawClassicError)

@external(javascript, "./classic_ffi.mjs", "classic_error_message")
fn raw_classic_error_message(error: RawClassicError) -> String
