//// Tests typed value adaptation for list-bound editable values.
////

import gleam/list
import gleam/option
import gleeunit/should
import mendraw/mendix
import mendraw/mendix/editable_value
import mendraw/mendix/list_attribute
import mendraw/synthetic
import mendraw/value_adapter

/// Verifies boolean attributes are classified and displayed as typed values.
pub fn boolean_snapshot_test() -> Nil {
  let snapshot =
    synthetic_snapshot([True], "Boolean", fn(value) {
      case value {
        True -> "true"
        False -> "false"
      }
    })
    |> should.be_ok
  snapshot.kind
  |> should.equal(value_adapter.BooleanKind)
  snapshot.value
  |> should.equal(option.Some(value_adapter.Boolean(True)))
  snapshot.display_text
  |> should.equal("true")
  snapshot.read_only
  |> should.be_true
}

/// Verifies date attributes keep their timestamp and ISO display text.
pub fn date_snapshot_test() -> Nil {
  let snapshot =
    synthetic_snapshot([1_767_312_000_000], "DateTime", fn(_) { "" })
    |> should.be_ok
  snapshot.kind
  |> should.equal(value_adapter.DateKind)
  case snapshot.value {
    option.Some(value_adapter.Date(date_value)) -> {
      parse_date_equals(value_adapter.Date(date_value), "2026-01-02T00:00:00Z")
      |> should.be_true
    }
    _ -> should.fail()
  }
  snapshot.display_text
  |> should.equal("2026-01-02T00:00:00.000Z")
}

/// Verifies decimal-like objects stay decimal values with stable text.
pub fn decimal_snapshot_test() -> Nil {
  let snapshot =
    synthetic_snapshot([1.5], "Decimal", fn(_) { "" })
    |> should.be_ok
  snapshot.kind
  |> should.equal(value_adapter.DecimalKind)
  case snapshot.value {
    option.Some(value_adapter.Decimal(value)) -> {
      value_adapter.decimal_to_string(value)
      |> should.equal("1.5")
      value_adapter.decimal_to_float(value)
      |> should.equal(Ok(1.5))
    }
    _ -> should.fail()
  }
  snapshot.display_text
  |> should.equal("1.5")
}

/// Verifies plain numbers split into integer and float kinds.
pub fn number_snapshot_test() -> Nil {
  let integer =
    value_adapter.snapshot(fixture_editable(integer_editable(42)))
    |> should.be_ok
  integer.kind
  |> should.equal(value_adapter.IntegerKind)
  integer.value
  |> should.equal(option.Some(value_adapter.Integer(42)))
  integer.display_text
  |> should.equal("42")
  let float =
    value_adapter.snapshot(fixture_editable(float_editable(4.5)))
    |> should.be_ok
  float.kind
  |> should.equal(value_adapter.FloatKind)
  float.value
  |> should.equal(option.Some(value_adapter.Float(4.5)))
  float.display_text
  |> should.equal("4.5")
}

/// Verifies string attributes stay plain text.
pub fn string_snapshot_test() -> Nil {
  let snapshot =
    value_adapter.snapshot(fixture_editable(string_editable("hello")))
    |> should.be_ok
  snapshot.kind
  |> should.equal(value_adapter.StringKind)
  snapshot.value
  |> should.equal(option.Some(value_adapter.Text("hello")))
  snapshot.display_text
  |> should.equal("hello")
}

/// Verifies empty values are None and use the declared attribute kind.
pub fn empty_snapshot_test() -> Nil {
  let snapshot =
    value_adapter.snapshot(fixture_editable(empty_editable()))
    |> should.be_ok
  snapshot.kind
  |> should.equal(value_adapter.StringKind)
  snapshot.value
  |> should.equal(option.None)
  snapshot.display_text
  |> should.equal("")
  let attribute = decimal_attribute(empty_editable(), "Decimal")
  let declared =
    value_adapter.attribute_snapshot(attribute, synthetic.object_item("row"))
    |> should.be_ok
  declared.kind
  |> should.equal(value_adapter.DecimalKind)
  declared.value
  |> should.equal(option.None)
}

/// Verifies loading, unavailable, and unsupported states fail explicitly.
pub fn unavailable_and_unsupported_test() -> Nil {
  value_adapter.snapshot(fixture_editable(loading_editable()))
  |> should.equal(Error(value_adapter.EditableValueUnavailable(mendix.Loading)))
  value_adapter.snapshot(fixture_editable(unavailable_editable()))
  |> should.equal(
    Error(value_adapter.EditableValueUnavailable(mendix.Unavailable)),
  )
  value_adapter.snapshot(fixture_editable(unsupported_editable()))
  |> should.equal(Error(value_adapter.UnsupportedEditableValue))
}

/// Verifies boolean text parsing accepts spreadsheet-style input.
pub fn parse_boolean_test() -> Nil {
  value_adapter.parse(value_adapter.BooleanKind, " TRUE ")
  |> should.equal(Ok(option.Some(value_adapter.Boolean(True))))
  value_adapter.parse(value_adapter.BooleanKind, "yes")
  |> should.equal(Ok(option.Some(value_adapter.Boolean(True))))
  value_adapter.parse(value_adapter.BooleanKind, "0")
  |> should.equal(Ok(option.Some(value_adapter.Boolean(False))))
  value_adapter.parse(value_adapter.BooleanKind, "maybe")
  |> should.equal(error_text(value_adapter.BooleanKind, "maybe"))
  value_adapter.parse(value_adapter.BooleanKind, "  ")
  |> should.equal(Ok(option.None))
}

/// Verifies numeric text parsing rejects values of the wrong kind.
pub fn parse_number_test() -> Nil {
  value_adapter.parse(value_adapter.IntegerKind, "42")
  |> should.equal(Ok(option.Some(value_adapter.Integer(42))))
  value_adapter.parse(value_adapter.IntegerKind, "4.5")
  |> should.equal(error_text(value_adapter.IntegerKind, "4.5"))
  value_adapter.parse(value_adapter.FloatKind, "4.5")
  |> should.equal(Ok(option.Some(value_adapter.Float(4.5))))
  value_adapter.parse(value_adapter.FloatKind, "abc")
  |> should.equal(error_text(value_adapter.FloatKind, "abc"))
  case value_adapter.parse(value_adapter.DecimalKind, "-12.50") {
    Ok(option.Some(value_adapter.Decimal(value))) ->
      value_adapter.decimal_to_string(value)
      |> should.equal("-12.50")
    _ -> should.fail()
  }
  value_adapter.parse(value_adapter.DecimalKind, "1.2.3")
  |> should.equal(error_text(value_adapter.DecimalKind, "1.2.3"))
  value_adapter.parse(value_adapter.DecimalKind, "1e3")
  |> should.equal(error_text(value_adapter.DecimalKind, "1e3"))
}

/// Verifies ISO date parsing keeps offsets and rejects impossible dates.
pub fn parse_date_test() -> Nil {
  parse_dates_text_equal("2026-01-02", "2026-01-02T00:00:00Z")
  |> should.be_true
  parse_dates_text_equal("2026-01-02T03:04:05+09:00", "2026-01-01T18:04:05Z")
  |> should.be_true
  value_adapter.parse(value_adapter.DateKind, "2026-02-31")
  |> should.equal(error_text(value_adapter.DateKind, "2026-02-31"))
  value_adapter.parse(value_adapter.DateKind, "next monday")
  |> should.equal(error_text(value_adapter.DateKind, "next monday"))
}

/// Verifies equality uses kind-stable semantics.
pub fn values_equal_test() -> Nil {
  parse_decimals_text_equal("1.0", "1.00")
  |> should.be_true
  parse_dates_text_equal("2026-01-02T00:00:00Z", "2026-01-02T09:00:00+09:00")
  |> should.be_true
  value_adapter.values_equal(value_adapter.Integer(5), value_adapter.Float(5.0))
  |> should.be_false
  value_adapter.values_equal(
    value_adapter.Boolean(True),
    value_adapter.Text("true"),
  )
  |> should.be_false
}

/// Verifies writes convert typed values back to runtime values.
pub fn write_success_test() -> Nil {
  let fixture = integer_editable(10)
  let editable = fixture_editable(fixture)
  value_adapter.write(editable, option.Some(value_adapter.Integer(7)))
  |> should.equal(Ok(Nil))
  written_count(fixture)
  |> should.equal(1)
  written_integer(fixture, 0)
  |> should.equal(7)
  value_adapter.write(editable, option.None)
  |> should.equal(Ok(Nil))
  written_count(fixture)
  |> should.equal(2)
  written_is_empty(fixture, 1)
  |> should.be_true
}

/// Verifies decimal and date writes preserve their runtime shapes.
pub fn write_decimal_and_date_test() -> Nil {
  let decimal_fixture = empty_editable()
  case value_adapter.parse(value_adapter.DecimalKind, "-12.5") {
    Ok(option.Some(value)) ->
      value_adapter.write(fixture_editable(decimal_fixture), option.Some(value))
      |> should.equal(Ok(Nil))
    _ -> should.fail()
  }
  written_decimal_string(decimal_fixture, 0)
  |> should.equal("-12.5")
  let date_fixture = empty_editable()
  case value_adapter.parse(value_adapter.DateKind, "2026-01-02T00:00:00Z") {
    Ok(option.Some(value)) ->
      value_adapter.write(fixture_editable(date_fixture), option.Some(value))
      |> should.equal(Ok(Nil))
    _ -> should.fail()
  }
  written_date_milliseconds(date_fixture, 0)
  |> should.equal(1_767_312_000_000)
}

/// Verifies read-only, unavailable, and runtime write failures.
pub fn write_errors_test() -> Nil {
  value_adapter.write(
    fixture_editable(read_only_integer_editable(10)),
    option.Some(value_adapter.Integer(7)),
  )
  |> should.equal(
    Error(value_adapter.ReadOnlyEditableValue(value_adapter.IntegerKind)),
  )
  value_adapter.write(fixture_editable(loading_editable()), option.None)
  |> should.equal(Error(value_adapter.EditableValueUnavailable(mendix.Loading)))
  value_adapter.write(
    fixture_editable(failing_write_editable()),
    option.Some(value_adapter.Text("y")),
  )
  |> should.equal(Error(value_adapter.EditableWriteFailed("no writes")))
}

/// Verifies non-finite decimal-like values report a descriptive error.
pub fn decimal_to_float_failure_test() -> Nil {
  let snapshot =
    value_adapter.snapshot(fixture_editable(huge_decimal_editable()))
    |> should.be_ok
  case snapshot.value {
    option.Some(value_adapter.Decimal(value)) ->
      value_adapter.decimal_to_float(value)
      |> should.equal(Error(value_adapter.DecimalNotFinite("huge")))
    _ -> should.fail()
  }
}

type EditableFixture

fn synthetic_snapshot(
  values values: List(a),
  attribute_type attribute_type: String,
  display display: fn(a) -> String,
) -> Result(value_adapter.Snapshot, value_adapter.ValueAdapterError) {
  let items = synthetic.object_items(1)
  let attribute =
    synthetic.list_attribute(items, values, display, attribute_type)
  let item = items |> list.first |> should.be_ok
  value_adapter.attribute_snapshot(attribute, item)
}

fn parse_date_equals(
  expected expected: value_adapter.TypedValue,
  text text: String,
) -> Bool {
  case value_adapter.parse(value_adapter.DateKind, text) {
    Ok(option.Some(parsed)) -> value_adapter.values_equal(expected, parsed)
    _ -> False
  }
}

fn parse_dates_text_equal(left left: String, right right: String) -> Bool {
  case
    value_adapter.parse(value_adapter.DateKind, left),
    value_adapter.parse(value_adapter.DateKind, right)
  {
    Ok(option.Some(left_value)), Ok(option.Some(right_value)) ->
      value_adapter.values_equal(left_value, right_value)
    _, _ -> False
  }
}

fn parse_decimals_text_equal(left left: String, right right: String) -> Bool {
  case
    value_adapter.parse(value_adapter.DecimalKind, left),
    value_adapter.parse(value_adapter.DecimalKind, right)
  {
    Ok(option.Some(left_value)), Ok(option.Some(right_value)) ->
      value_adapter.values_equal(left_value, right_value)
    _, _ -> False
  }
}

fn error_text(
  kind kind: value_adapter.ValueKind,
  text text: String,
) -> Result(
  option.Option(value_adapter.TypedValue),
  value_adapter.ValueAdapterError,
) {
  Error(value_adapter.InvalidTextInput(kind, text, reason_for(kind)))
}

fn reason_for(kind kind: value_adapter.ValueKind) -> String {
  case kind {
    value_adapter.BooleanKind ->
      "expected true, yes, or 1 for true and false, no, or 0 for false"
    value_adapter.IntegerKind -> "expected an integer"
    value_adapter.FloatKind -> "expected a number"
    value_adapter.DecimalKind -> "expected a plain decimal such as -12.5"
    value_adapter.DateKind ->
      "expected an ISO 8601 date or date-time without a timezone offset"
    value_adapter.StringKind -> ""
  }
}

// -- FFI --
@external(javascript, "./mendraw_value_adapter_test_ffi.mjs", "integer_editable")
fn integer_editable(value value: Int) -> EditableFixture

@external(javascript, "./mendraw_value_adapter_test_ffi.mjs", "float_editable")
fn float_editable(value value: Float) -> EditableFixture

@external(javascript, "./mendraw_value_adapter_test_ffi.mjs", "string_editable")
fn string_editable(value value: String) -> EditableFixture

@external(javascript, "./mendraw_value_adapter_test_ffi.mjs", "empty_editable")
fn empty_editable() -> EditableFixture

@external(javascript, "./mendraw_value_adapter_test_ffi.mjs", "read_only_integer_editable")
fn read_only_integer_editable(value value: Int) -> EditableFixture

@external(javascript, "./mendraw_value_adapter_test_ffi.mjs", "loading_editable")
fn loading_editable() -> EditableFixture

@external(javascript, "./mendraw_value_adapter_test_ffi.mjs", "unavailable_editable")
fn unavailable_editable() -> EditableFixture

@external(javascript, "./mendraw_value_adapter_test_ffi.mjs", "unsupported_editable")
fn unsupported_editable() -> EditableFixture

@external(javascript, "./mendraw_value_adapter_test_ffi.mjs", "huge_decimal_editable")
fn huge_decimal_editable() -> EditableFixture

@external(javascript, "./mendraw_value_adapter_test_ffi.mjs", "failing_write_editable")
fn failing_write_editable() -> EditableFixture

@external(javascript, "./mendraw_value_adapter_test_ffi.mjs", "decimal_attribute")
fn decimal_attribute(
  fixture fixture: EditableFixture,
  type_name type_name: String,
) -> list_attribute.ListAttributeValue

@external(javascript, "./mendraw_value_adapter_test_ffi.mjs", "fixture_editable")
fn fixture_editable(
  fixture fixture: EditableFixture,
) -> editable_value.EditableValue

@external(javascript, "./mendraw_value_adapter_test_ffi.mjs", "written_count")
fn written_count(fixture fixture: EditableFixture) -> Int

@external(javascript, "./mendraw_value_adapter_test_ffi.mjs", "written_integer")
fn written_integer(fixture fixture: EditableFixture, index index: Int) -> Int

@external(javascript, "./mendraw_value_adapter_test_ffi.mjs", "written_is_empty")
fn written_is_empty(fixture fixture: EditableFixture, index index: Int) -> Bool

@external(javascript, "./mendraw_value_adapter_test_ffi.mjs", "written_date_milliseconds")
fn written_date_milliseconds(
  fixture fixture: EditableFixture,
  index index: Int,
) -> Int

@external(javascript, "./mendraw_value_adapter_test_ffi.mjs", "written_decimal_string")
fn written_decimal_string(
  fixture fixture: EditableFixture,
  index index: Int,
) -> String
