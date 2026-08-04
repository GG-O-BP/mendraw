//// Synthetic Mendix data objects for external API data.
////
//// Creates fake ListValue, ObjectItem, ListAttributeValue etc. that
//// satisfy the interface expected by Mendix chart/grid widgets,
//// allowing external API data (e.g. CoinGecko) to be rendered
//// through real Mendix marketplace widgets.
////
//// ```gleam
//// let items = synthetic.object_items(3)
//// let lv = synthetic.list_value(items)
//// let attr = synthetic.list_attribute(items, [1.0, 2.0, 3.0], float.to_string, "Decimal")
//// ```

import mendraw/mendix
import mendraw/mendix/list_attribute
import mendraw/mendix/list_value

/// Represents a synthetic static text template.
pub type TextTemplate

/// Represents a synthetic association value.
pub type Association

/// Represents a synthetic chart series configuration.
pub type ChartSeries

/// Represents a JavaScript array containing a known Gleam value type.
pub type JsArray(value)

// -- Objectitem --
/// Create a single synthetic ObjectItem with the given id
pub fn object_item(id id: String) -> mendix.ObjectItem {
  object_item_raw(id)
}

/// Create N synthetic ObjectItems with ids "synth_0", "synth_1", ...
pub fn object_items(count count: Int) -> List(mendix.ObjectItem) {
  object_items_raw(count)
}

// -- Listvalue --
/// Create a synthetic ListValue from a list of ObjectItems.
/// Status is "available", mutation methods are no-ops.
pub fn list_value(
  items items: List(mendix.ObjectItem),
) -> list_value.ListValue {
  list_value_raw(items)
}

// -- Listattributevalue --
/// Create a synthetic ListAttributeValue.
/// `get(item)` returns an EditableValue with the corresponding value.
///
/// - items: ObjectItems (must match list_value items)
/// - values: parallel list of values, one per item
/// - display_fn: converts a value to display string
/// - attr_type: Mendix attribute type ("Decimal", "String", "DateTime", etc.)
pub fn list_attribute(
  items items: List(mendix.ObjectItem),
  values values: List(a),
  display_fn display_fn: fn(a) -> String,
  attr_type attr_type: String,
) -> list_attribute.ListAttributeValue {
  list_attribute_raw(items, values, display_fn, attr_type)
}

// -- Texttemplate --
/// Create a static text template (not bound to a datasource).
/// Returns { value: text } matching Mendix textTemplate shape.
pub fn text_template(value value: String) -> TextTemplate {
  text_template_raw(value)
}

// -- Listexpressionvalue / Listtexttemplate --
/// Create a list-bound text template.
/// `get(item)` returns { status: "available", value: "text for this item" }.
pub fn list_text_template(
  items items: List(mendix.ObjectItem),
  values values: List(String),
) -> list_attribute.ListExpressionValue {
  list_text_template_raw(items, values)
}

/// Create a list-bound expression value.
/// `get(item)` returns { status: "available", value: val }.
pub fn list_expression(
  items items: List(mendix.ObjectItem),
  values values: List(a),
) -> list_attribute.ListExpressionValue {
  list_expression_raw(items, values)
}

// -- Association (dynamicdatagrid Cell→row/column) --
/// Create a synthetic association linking items to target items.
/// `get(sourceItem)` returns { value: targetItem }.
/// Used for DynamicDataGrid referenceRow/referenceColumn.
pub fn association(
  items items: List(mendix.ObjectItem),
  targets targets: List(mendix.ObjectItem),
) -> Association {
  association_raw(items, targets)
}

// -- Chart Series Builders --
/// Build a static chart series config object for Line/Area/Column/TimeSeries.
/// Returns a JS object with { dataSet:"static", staticDataSource, ... }.
pub fn chart_series_static(
  data_source data_source: list_value.ListValue,
  x_attr x_attr: list_attribute.ListAttributeValue,
  y_attr y_attr: list_attribute.ListAttributeValue,
  name name: TextTemplate,
  aggregation aggregation: String,
  interpolation interpolation: String,
  line_style line_style: String,
  line_color line_color: String,
  bar_color bar_color: String,
) -> ChartSeries {
  chart_series_static_raw(
    data_source,
    x_attr,
    y_attr,
    name,
    aggregation,
    interpolation,
    line_style,
    line_color,
    bar_color,
  )
}

// -- Utility --
/// Convert a Gleam List to a JS Array.
/// Needed for chart widget `lines`/`series` props which expect JS arrays.
pub fn to_js_array(items items: List(value)) -> JsArray(value) {
  to_js_array_raw(items)
}

// -- FFI --
@external(javascript, "./synthetic_ffi.mjs", "make_object_item")
fn object_item_raw(id id: String) -> mendix.ObjectItem

@external(javascript, "./synthetic_ffi.mjs", "make_object_items")
fn object_items_raw(count count: Int) -> List(mendix.ObjectItem)

@external(javascript, "./synthetic_ffi.mjs", "make_list_value")
fn list_value_raw(items items: List(mendix.ObjectItem)) -> list_value.ListValue

@external(javascript, "./synthetic_ffi.mjs", "make_list_attribute")
fn list_attribute_raw(
  items items: List(mendix.ObjectItem),
  values values: List(a),
  display_fn display_fn: fn(a) -> String,
  attr_type attr_type: String,
) -> list_attribute.ListAttributeValue

@external(javascript, "./synthetic_ffi.mjs", "make_text_template")
fn text_template_raw(value value: String) -> TextTemplate

@external(javascript, "./synthetic_ffi.mjs", "make_list_text_template")
fn list_text_template_raw(
  items items: List(mendix.ObjectItem),
  values values: List(String),
) -> list_attribute.ListExpressionValue

@external(javascript, "./synthetic_ffi.mjs", "make_list_expression")
fn list_expression_raw(
  items items: List(mendix.ObjectItem),
  values values: List(a),
) -> list_attribute.ListExpressionValue

@external(javascript, "./synthetic_ffi.mjs", "make_association")
fn association_raw(
  items items: List(mendix.ObjectItem),
  targets targets: List(mendix.ObjectItem),
) -> Association

@external(javascript, "./synthetic_ffi.mjs", "make_chart_series_static")
fn chart_series_static_raw(
  data_source data_source: list_value.ListValue,
  x_attr x_attr: list_attribute.ListAttributeValue,
  y_attr y_attr: list_attribute.ListAttributeValue,
  name name: TextTemplate,
  aggregation aggregation: String,
  interpolation interpolation: String,
  line_style line_style: String,
  line_color line_color: String,
  bar_color bar_color: String,
) -> ChartSeries

@external(javascript, "./synthetic_ffi.mjs", "to_js_array")
fn to_js_array_raw(items items: List(value)) -> JsArray(value)
