//// Tests typed datasource snapshot behavior.
////

import gleam/list
import gleam/option
import gleam/string
import gleeunit/should
import mendraw/datasource
import mendraw/mendix
import mendraw/mendix/editable_value
import mendraw/synthetic

/// Verifies available snapshots keep order and page information.
pub fn capture_available_test() -> Nil {
  let snapshot = datasource.capture(available_datasource_props(), "dataSource")
  case snapshot {
    datasource.Available(key, data) -> {
      key
      |> should.equal("dataSource")
      data.items
      |> list.map(mendix.object_id)
      |> should.equal(["row-1", "row-2", "row-3"])
      data.offset
      |> should.equal(6)
      data.limit
      |> should.equal(3)
      data.has_more_items
      |> should.equal(option.Some(True))
      data.total_count
      |> should.equal(option.Some(42))
    }
    datasource.PropertyAbsent(_)
    | datasource.Loading(_)
    | datasource.Unavailable(_) -> should.fail()
  }
  datasource.count(snapshot)
  |> should.equal(3)
  Nil
}

/// Verifies non-available states stay distinguishable.
pub fn capture_state_distinctions_test() -> Nil {
  datasource.capture(loading_datasource_props(), "dataSource")
  |> should.equal(datasource.Loading("dataSource"))
  datasource.capture(unavailable_datasource_props(), "dataSource")
  |> should.equal(datasource.Unavailable("dataSource"))
  datasource.capture(missing_datasource_props(), "dataSource")
  |> should.equal(datasource.PropertyAbsent("dataSource"))
  datasource.capture(loading_datasource_props(), "dataSource")
  |> datasource.count
  |> should.equal(0)
  datasource.capture(missing_datasource_props(), "dataSource")
  |> datasource.items
  |> should.equal([])
  Nil
}

/// Verifies empty available snapshots still expose stable page data.
pub fn capture_empty_available_test() -> Nil {
  let snapshot = datasource.capture(empty_datasource_props(), "dataSource")
  snapshot
  |> datasource.items
  |> should.equal([])
  snapshot
  |> datasource.count
  |> should.equal(0)
  case snapshot {
    datasource.Available(_, data) -> {
      data.total_count
      |> should.equal(option.Some(0))
    }
    _ -> should.fail()
  }
  Nil
}

/// Verifies object-array properties expose typed column entries.
pub fn object_list_reads_column_fields_test() -> Nil {
  let entries =
    datasource.object_list(available_datasource_props(), "columns")
    |> should.be_ok
  entries
  |> list.length
  |> should.equal(2)
  entries
  |> list.first
  |> should.be_ok
  |> datasource.entry_field_string("caption")
  |> should.equal(option.Some("Name"))
  entries
  |> list.first
  |> should.be_ok
  |> datasource.entry_field_string("valueAttribute")
  |> should.equal(option.Some("fullName"))
  entries
  |> list.first
  |> should.be_ok
  |> datasource.entry_field_string("missing")
  |> should.equal(option.None)
  Nil
}

/// Verifies object-array failures are descriptive.
pub fn object_list_errors_test() -> Nil {
  datasource.object_list(missing_datasource_props(), "columns")
  |> should.equal(Error(datasource.ObjectPropertyMissing("columns")))
  datasource.object_list(columns_not_a_list_props(), "columns")
  |> should.equal(Error(datasource.ObjectPropertyNotAList("columns")))
  Nil
}

/// Verifies item-bound attributes resolve as typed editable values.
pub fn attribute_value_returns_editable_value_test() -> Nil {
  let items = synthetic.object_items(2)
  let attribute =
    synthetic.list_attribute(items, [10, 20], int_to_string, "Integer")
  let first = items |> list.first |> should.be_ok
  let value = datasource.attribute_value(attribute, first)
  value
  |> editable_value.display_value
  |> should.equal("10")
  value
  |> editable_value.read_only
  |> should.be_true
  Nil
}

fn int_to_string(value: Int) -> String {
  string.inspect(value)
}

// -- FFI --
@external(javascript, "./mendraw_datasource_test_ffi.mjs", "available_datasource_props")
fn available_datasource_props() -> mendix.JsProps

@external(javascript, "./mendraw_datasource_test_ffi.mjs", "empty_datasource_props")
fn empty_datasource_props() -> mendix.JsProps

@external(javascript, "./mendraw_datasource_test_ffi.mjs", "loading_datasource_props")
fn loading_datasource_props() -> mendix.JsProps

@external(javascript, "./mendraw_datasource_test_ffi.mjs", "unavailable_datasource_props")
fn unavailable_datasource_props() -> mendix.JsProps

@external(javascript, "./mendraw_datasource_test_ffi.mjs", "missing_datasource_props")
fn missing_datasource_props() -> mendix.JsProps

@external(javascript, "./mendraw_datasource_test_ffi.mjs", "columns_not_a_list_props")
fn columns_not_a_list_props() -> mendix.JsProps
