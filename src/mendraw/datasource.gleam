//// Provides typed snapshots of datasource-bound widget properties.
////
//// A snapshot captures one data source, nested object list, or item-bound
//// attribute as an immutable Gleam value. Widgets can branch on the captured
//// state without inspecting Mendix runtime JavaScript shapes:
////
//// ```gleam
//// import mendraw/datasource
////
//// case datasource.capture(props, "dataSource") {
////   datasource.Available(_, data) -> render_rows(data.items)
////   datasource.Loading(_) -> render_loading()
////   datasource.PropertyAbsent(_) | datasource.Unavailable(_) -> render_empty()
//// }
//// ```
////

import gleam/list
import gleam/option
import mendraw/mendix
import mendraw/mendix/editable_value
import mendraw/mendix/list_attribute
import mendraw/mendix/list_value

/// One immutable capture of a datasource-bound property.
pub type Snapshot {
  /// The widget props did not contain the requested property.
  PropertyAbsent(key: String)
  /// The data source reported that items are still loading.
  Loading(key: String)
  /// The data source exists but reported an unsupported state.
  Unavailable(key: String)
  /// The data source is available and carries a stable ordered item view.
  Available(key: String, data: Data)
}

/// The stable data captured from one available data source.
pub type Data {
  Data(
    items: List(mendix.ObjectItem),
    offset: Int,
    limit: Int,
    has_more_items: option.Option(Bool),
    total_count: option.Option(Int),
  )
}

/// Describes why an object-array property could not be read.
pub type ObjectListError {
  /// The widget props did not contain the requested property.
  ObjectPropertyMissing(key: String)
  /// The property exists but is not an array of configuration objects.
  ObjectPropertyNotAList(key: String)
}

/// A typed entry of an object-array property such as widget columns.
pub type ObjectListEntry

/// Captures one datasource property with its state, ordering, and page info.
pub fn capture(props props: mendix.JsProps, key key: String) -> Snapshot {
  case mendix.get_prop(props, key) {
    option.None -> PropertyAbsent(key)
    option.Some(data_source) ->
      case list_value.status(data_source) {
        mendix.Loading -> Loading(key)
        mendix.Unavailable -> Unavailable(key)
        mendix.Available ->
          Available(
            key,
            Data(
              items: option.unwrap(list_value.items(data_source), []),
              offset: list_value.offset(data_source),
              limit: list_value.limit(data_source),
              has_more_items: list_value.has_more_items(data_source),
              total_count: list_value.total_count(data_source),
            ),
          )
      }
  }
}

/// Returns the captured items; non-available snapshots are empty.
pub fn items(snapshot snapshot: Snapshot) -> List(mendix.ObjectItem) {
  case snapshot {
    Available(_, data) -> data.items
    PropertyAbsent(_) | Loading(_) | Unavailable(_) -> []
  }
}

/// Returns the stable captured item count.
pub fn count(snapshot snapshot: Snapshot) -> Int {
  case snapshot {
    Available(_, data) -> list.length(data.items)
    PropertyAbsent(_) | Loading(_) | Unavailable(_) -> 0
  }
}

/// Reads an object-array property such as widget column definitions.
pub fn object_list(
  props props: mendix.JsProps,
  key key: String,
) -> Result(List(ObjectListEntry), ObjectListError) {
  case object_list_raw(props, key) {
    option.Some(entries) -> Ok(entries)
    option.None ->
      case mendix.has_prop(props, key) {
        True -> Error(ObjectPropertyNotAList(key))
        False -> Error(ObjectPropertyMissing(key))
      }
  }
}

/// Reads one string field of an object-array entry.
pub fn entry_field_string(
  entry entry: ObjectListEntry,
  field field: String,
) -> option.Option(String) {
  entry_field_string_raw(entry, field)
}

/// Resolves a datasource-bound attribute value for one object item.
///
/// The returned editable value reuses the typed status, value, display, and
/// read-only accessors from `mendraw/mendix/editable_value`.
pub fn attribute_value(
  attr attr: list_attribute.ListAttributeValue,
  item item: mendix.ObjectItem,
) -> editable_value.EditableValue {
  list_attribute.get_attribute(attr, item)
}

// -- FFI --
@external(javascript, "./mendix_ffi.mjs", "get_object_list_prop")
fn object_list_raw(
  props props: mendix.JsProps,
  key key: String,
) -> option.Option(List(ObjectListEntry))

@external(javascript, "./mendix_ffi.mjs", "object_entry_field_string")
fn entry_field_string_raw(
  entry entry: ObjectListEntry,
  field field: String,
) -> option.Option(String)
