//// Provides typed access to Mendix list attributes.
////

// ListAttributeValue, ListActionValue, ListExpressionValue, ListWidgetValue
import gleam/option
import mendraw/mendix
import mendraw/mendix/formatter
import redraw

/// A typed `ListAttributeValue` value used by the list attribute capability.
pub type ListAttributeValue

/// A typed `ListActionValue` value used by the list attribute capability.
pub type ListActionValue

/// A typed `ListExpressionValue` value used by the list attribute capability.
pub type ListExpressionValue

/// A typed `ListWidgetValue` value used by the list attribute capability.
pub type ListWidgetValue

/// Returns the list attribute for an item.
pub fn get_attribute(
  attr attr: ListAttributeValue,
  item item: mendix.ObjectItem,
) -> a {
  get_attribute_raw(attr, item)
}

/// Returns the list action for an item.
pub fn get_action(
  action action: ListActionValue,
  item item: mendix.ObjectItem,
) -> option.Option(a) {
  get_action_raw(action, item)
}

/// Returns the list expression for an item.
pub fn get_expression(
  expr expr: ListExpressionValue,
  item item: mendix.ObjectItem,
) -> a {
  get_expression_raw(expr, item)
}

/// Returns the list widget for an item.
pub fn get_widget(
  widget widget: ListWidgetValue,
  item item: mendix.ObjectItem,
) -> redraw.Element {
  get_widget_raw(widget, item)
}

/// Returns the attribute identifier.
pub fn attr_id(attr attr: ListAttributeValue) -> String {
  attr_id_raw(attr)
}

/// Reports whether the attribute is sortable.
pub fn attr_sortable(attr attr: ListAttributeValue) -> Bool {
  attr_sortable_raw(attr)
}

/// Reports whether the attribute is filterable.
pub fn attr_filterable(attr attr: ListAttributeValue) -> Bool {
  attr_filterable_raw(attr)
}

/// Returns the attribute type name.
pub fn attr_type(attr attr: ListAttributeValue) -> String {
  attr_type_raw(attr)
}

/// Returns the attribute value formatter.
pub fn attr_formatter(
  attr attr: ListAttributeValue,
) -> formatter.ValueFormatter {
  attr_formatter_raw(attr)
}

// -- FFI --
@external(javascript, "../mendix_ffi.mjs", "list_type_get")
fn get_attribute_raw(
  attr attr: ListAttributeValue,
  item item: mendix.ObjectItem,
) -> a

@external(javascript, "../mendix_ffi.mjs", "list_type_get")
fn get_action_raw(
  action action: ListActionValue,
  item item: mendix.ObjectItem,
) -> option.Option(a)

@external(javascript, "../mendix_ffi.mjs", "list_type_get")
fn get_expression_raw(
  expr expr: ListExpressionValue,
  item item: mendix.ObjectItem,
) -> a

@external(javascript, "../mendix_ffi.mjs", "list_type_get")
fn get_widget_raw(
  widget widget: ListWidgetValue,
  item item: mendix.ObjectItem,
) -> redraw.Element

@external(javascript, "../mendix_ffi.mjs", "get_list_attr_id")
fn attr_id_raw(attr attr: ListAttributeValue) -> String

@external(javascript, "../mendix_ffi.mjs", "get_list_attr_sortable")
fn attr_sortable_raw(attr attr: ListAttributeValue) -> Bool

@external(javascript, "../mendix_ffi.mjs", "get_list_attr_filterable")
fn attr_filterable_raw(attr attr: ListAttributeValue) -> Bool

@external(javascript, "../mendix_ffi.mjs", "get_list_attr_type")
fn attr_type_raw(attr attr: ListAttributeValue) -> String

@external(javascript, "../mendix_ffi.mjs", "get_list_attr_formatter")
fn attr_formatter_raw(attr attr: ListAttributeValue) -> formatter.ValueFormatter
