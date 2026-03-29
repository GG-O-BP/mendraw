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

import mendraw/mendix.{type ObjectItem}
import mendraw/mendix/list_attribute.{
  type ListAttributeValue, type ListExpressionValue,
}
import mendraw/mendix/list_value.{type ListValue}

// ── ObjectItem ──────────────────────────────────────────────────

/// Create a single synthetic ObjectItem with the given id
@external(javascript, "./synthetic_ffi.mjs", "make_object_item")
pub fn object_item(id: String) -> ObjectItem

/// Create N synthetic ObjectItems with ids "synth_0", "synth_1", ...
@external(javascript, "./synthetic_ffi.mjs", "make_object_items")
pub fn object_items(count: Int) -> List(ObjectItem)

// ── ListValue ───────────────────────────────────────────────────

/// Create a synthetic ListValue from a list of ObjectItems.
/// Status is "available", mutation methods are no-ops.
@external(javascript, "./synthetic_ffi.mjs", "make_list_value")
pub fn list_value(items: List(ObjectItem)) -> ListValue

// ── ListAttributeValue ──────────────────────────────────────────

/// Create a synthetic ListAttributeValue.
/// `get(item)` returns an EditableValue with the corresponding value.
///
/// - items: ObjectItems (must match list_value items)
/// - values: parallel list of values, one per item
/// - display_fn: converts a value to display string
/// - attr_type: Mendix attribute type ("Decimal", "String", "DateTime", etc.)
@external(javascript, "./synthetic_ffi.mjs", "make_list_attribute")
pub fn list_attribute(
  items: List(ObjectItem),
  values: List(a),
  display_fn: fn(a) -> String,
  attr_type: String,
) -> ListAttributeValue

// ── TextTemplate ────────────────────────────────────────────────

/// Create a static text template (not bound to a datasource).
/// Returns { value: text } matching Mendix textTemplate shape.
@external(javascript, "./synthetic_ffi.mjs", "make_text_template")
pub fn text_template(value: String) -> a

// ── ListExpressionValue / ListTextTemplate ──────────────────────

/// Create a list-bound text template.
/// `get(item)` returns { status: "available", value: "text for this item" }.
@external(javascript, "./synthetic_ffi.mjs", "make_list_text_template")
pub fn list_text_template(
  items: List(ObjectItem),
  values: List(String),
) -> ListExpressionValue

/// Create a list-bound expression value.
/// `get(item)` returns { status: "available", value: val }.
@external(javascript, "./synthetic_ffi.mjs", "make_list_expression")
pub fn list_expression(
  items: List(ObjectItem),
  values: List(a),
) -> ListExpressionValue

// ── Association (DynamicDataGrid cell→row/column) ───────────────

/// Create a synthetic association linking items to target items.
/// `get(sourceItem)` returns { value: targetItem }.
/// Used for DynamicDataGrid referenceRow/referenceColumn.
@external(javascript, "./synthetic_ffi.mjs", "make_association")
pub fn association(items: List(ObjectItem), targets: List(ObjectItem)) -> a

// ── Chart series builders ───────────────────────────────────────

/// Build a static chart series config object for Line/Area/Column/TimeSeries.
/// Returns a JS object with { dataSet:"static", staticDataSource, ... }.
@external(javascript, "./synthetic_ffi.mjs", "make_chart_series_static")
pub fn chart_series_static(
  data_source: ListValue,
  x_attr: ListAttributeValue,
  y_attr: ListAttributeValue,
  name: a,
  aggregation: String,
  interpolation: String,
  line_style: String,
  line_color: String,
  bar_color: String,
) -> b

// ── Utility ─────────────────────────────────────────────────────

/// Convert a Gleam List to a JS Array.
/// Needed for chart widget `lines`/`series` props which expect JS arrays.
@external(javascript, "./synthetic_ffi.mjs", "to_js_array")
pub fn to_js_array(items: List(a)) -> b
