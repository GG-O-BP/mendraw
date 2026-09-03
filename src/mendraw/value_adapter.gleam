//// Adapts list-bound editable values to typed Gleam values.
////
//// Table-style widgets can read one editable value, classify it without
//// application-local `instanceof` probes, parse edited text back into the
//// same value type, compare old and new values, and write the result while
//// preserving failures:
////
//// ```gleam
//// import gleam/option
//// import gleam/result
//// import mendraw/datasource
//// import mendraw/value_adapter
////
//// let editable = datasource.attribute_value(attribute, item)
//// let snapshot = value_adapter.snapshot(editable)
////
//// case value_adapter.parse(snapshot.kind, edited_text) {
////   Ok(option.Some(next)) ->
////     case snapshot.value {
////       option.Some(current) ->
////         case value_adapter.values_equal(current, next) {
////           True -> Ok(Nil)
////           False -> value_adapter.write(editable, option.Some(next))
////         }
////       option.None -> value_adapter.write(editable, option.Some(next))
////     }
////   Ok(option.None) -> value_adapter.write(editable, option.None)
////   Error(error) -> Error(error)
//// }
//// ```
////

import gleam/float
import gleam/int
import gleam/option
import gleam/string
import mendraw/mendix
import mendraw/mendix/date
import mendraw/mendix/editable_value
import mendraw/mendix/list_attribute

/// The value type stored by one Mendix attribute.
pub type ValueKind {
  /// A Mendix Boolean attribute.
  BooleanKind
  /// A Mendix DateTime attribute.
  DateKind
  /// A JavaScript number with an integral value.
  IntegerKind
  /// A JavaScript number with a fractional value.
  FloatKind
  /// A decimal-like Mendix value such as a Big.js instance.
  DecimalKind
  /// A Mendix String attribute.
  StringKind
}

/// A decimal-like Mendix value such as a Big.js instance.
pub type DecimalValue

/// One classified Mendix attribute value.
pub type TypedValue {
  Boolean(value: Bool)
  Date(value: date.JsDate)
  Integer(value: Int)
  Float(value: Float)
  Decimal(value: DecimalValue)
  Text(value: String)
}

/// One immutable capture of an editable value.
pub type Snapshot {
  Snapshot(
    kind: ValueKind,
    value: option.Option(TypedValue),
    display_text: String,
    read_only: Bool,
  )
}

/// Describes why an editable value could not be adapted.
pub type ValueAdapterError {
  /// The editable value is loading or otherwise unavailable.
  EditableValueUnavailable(status: mendix.ValueStatus)
  /// The stored value has a shape Mendraw cannot classify.
  UnsupportedEditableValue
  /// Edited text could not be converted to the expected value kind.
  InvalidTextInput(kind: ValueKind, text: String, reason: String)
  /// The editable value cannot be written because it is read-only.
  ReadOnlyEditableValue(kind: ValueKind)
  /// The Mendix runtime rejected the written value.
  EditableWriteFailed(reason: String)
  /// The decimal-like value cannot be represented as a finite float.
  DecimalNotFinite(text: String)
}

/// Captures one editable value using its stored value shape.
///
/// Empty values use `StringKind`; use `attribute_snapshot` when the declared
/// attribute type should classify empty values.
pub fn snapshot(
  ev ev: editable_value.EditableValue,
) -> Result(Snapshot, ValueAdapterError) {
  case editable_value.status(ev) {
    mendix.Available ->
      case editable_value.value(ev) {
        option.Some(raw) ->
          case classify_raw(raw) {
            "boolean" ->
              Ok(build_boolean_snapshot(raw, editable_value.read_only(ev)))
            "date" -> Ok(build_date_snapshot(raw, editable_value.read_only(ev)))
            "integer" ->
              Ok(build_integer_snapshot(raw, editable_value.read_only(ev)))
            "float" ->
              Ok(build_float_snapshot(raw, editable_value.read_only(ev)))
            "decimal" ->
              Ok(build_decimal_snapshot(raw, editable_value.read_only(ev)))
            "string" ->
              Ok(build_string_snapshot(raw, editable_value.read_only(ev)))
            _ -> Error(UnsupportedEditableValue)
          }
        option.None ->
          Ok(empty_snapshot(StringKind, editable_value.read_only(ev)))
      }
    mendix.Loading -> Error(EditableValueUnavailable(mendix.Loading))
    mendix.Unavailable -> Error(EditableValueUnavailable(mendix.Unavailable))
  }
}

/// Captures one item-bound attribute value.
///
/// Empty values are classified from the declared Mendix attribute type;
/// non-empty values are classified from their stored value shape.
pub fn attribute_snapshot(
  attr attr: list_attribute.ListAttributeValue,
  item item: mendix.ObjectItem,
) -> Result(Snapshot, ValueAdapterError) {
  let ev = list_attribute.get_attribute(attr, item)
  case snapshot(ev) {
    Ok(Snapshot(kind: StringKind, value: option.None, ..) as empty) ->
      Ok(
        Snapshot(
          ..empty,
          kind: kind_from_attribute_type(list_attribute.attr_type(attr)),
        ),
      )
    Ok(Snapshot(value: option.None, ..) as empty) -> Ok(empty)
    Ok(Snapshot(value: option.Some(_), ..) as captured) -> Ok(captured)
    Error(error) -> Error(error)
  }
}

/// Converts edited text into one typed value.
///
/// Surrounding whitespace is trimmed. Empty text becomes `Ok(None)` so an
/// empty attribute never collides with an invalid conversion.
pub fn parse(
  kind kind: ValueKind,
  text text: String,
) -> Result(option.Option(TypedValue), ValueAdapterError) {
  let trimmed = string.trim(text)
  case trimmed {
    "" -> Ok(option.None)
    _ ->
      case kind {
        BooleanKind -> parse_boolean(trimmed)
        IntegerKind -> parse_integer(trimmed)
        FloatKind -> parse_float(trimmed)
        DecimalKind -> parse_decimal(trimmed)
        DateKind -> parse_date(trimmed)
        StringKind -> Ok(option.Some(Text(trimmed)))
      }
  }
}

/// Compares two typed values with kind-stable semantics.
///
/// Values of different kinds are never equal. Dates compare by timestamp and
/// decimals compare numerically, so `1.0` and `1.00` are equal.
pub fn values_equal(left left: TypedValue, right right: TypedValue) -> Bool {
  case left, right {
    Boolean(left_value), Boolean(right_value) -> left_value == right_value
    Date(left_value), Date(right_value) ->
      date.to_timestamp(left_value) == date.to_timestamp(right_value)
    Integer(left_value), Integer(right_value) -> left_value == right_value
    Float(left_value), Float(right_value) -> left_value == right_value
    Decimal(left_value), Decimal(right_value) ->
      decimal_values_equal_raw(left_value, right_value)
    Text(left_value), Text(right_value) -> left_value == right_value
    _, _ -> False
  }
}

/// Writes one typed value through the editable-value handle.
///
/// Empty values clear the attribute. Read-only, unavailable, and runtime
/// write failures are reported explicitly.
pub fn write(
  ev ev: editable_value.EditableValue,
  value value: option.Option(TypedValue),
) -> Result(Nil, ValueAdapterError) {
  let kind = case value {
    option.Some(written) -> typed_value_kind(written)
    option.None -> StringKind
  }
  case editable_value.status(ev) {
    mendix.Available ->
      case editable_value.read_only(ev) {
        True -> Error(ReadOnlyEditableValue(kind))
        False ->
          case write_raw(ev, value) {
            Ok(_) -> Ok(Nil)
            Error(reason) -> Error(EditableWriteFailed(reason))
          }
      }
    mendix.Loading -> Error(EditableValueUnavailable(mendix.Loading))
    mendix.Unavailable -> Error(EditableValueUnavailable(mendix.Unavailable))
  }
}

/// Serializes one decimal-like value as text.
pub fn decimal_to_string(value value: DecimalValue) -> String {
  decimal_to_string_raw(value)
}

/// Converts one decimal-like value to a finite float.
pub fn decimal_to_float(
  value value: DecimalValue,
) -> Result(Float, ValueAdapterError) {
  case decimal_to_float_raw(value) {
    option.Some(number) -> Ok(number)
    option.None -> Error(DecimalNotFinite(decimal_to_string_raw(value)))
  }
}

fn write_raw(
  ev ev: editable_value.EditableValue,
  value value: option.Option(TypedValue),
) -> Result(Nil, String) {
  case value {
    option.Some(Boolean(boolean)) ->
      editable_set_value_checked_raw(ev, option.Some(boolean))
    option.Some(Date(date_value)) ->
      editable_set_value_checked_raw(ev, option.Some(date_value))
    option.Some(Integer(integer)) ->
      editable_set_value_checked_raw(ev, option.Some(integer))
    option.Some(Float(number)) ->
      editable_set_value_checked_raw(ev, option.Some(number))
    option.Some(Decimal(decimal)) ->
      editable_set_value_checked_raw(ev, option.Some(decimal))
    option.Some(Text(string)) ->
      editable_set_value_checked_raw(ev, option.Some(string))
    option.None -> editable_set_value_checked_raw(ev, option.None)
  }
}

fn typed_value_kind(value value: TypedValue) -> ValueKind {
  case value {
    Boolean(_) -> BooleanKind
    Date(_) -> DateKind
    Integer(_) -> IntegerKind
    Float(_) -> FloatKind
    Decimal(_) -> DecimalKind
    Text(_) -> StringKind
  }
}

fn kind_from_attribute_type(type_name type_name: String) -> ValueKind {
  case type_name {
    "Boolean" -> BooleanKind
    "DateTime" | "Date" -> DateKind
    "Integer" | "Long" | "AutoNumber" -> IntegerKind
    "Float" -> FloatKind
    "Decimal" -> DecimalKind
    _ -> StringKind
  }
}

fn build_boolean_snapshot(raw raw: a, read_only read_only: Bool) -> Snapshot {
  let value = boolean_raw(raw)
  Snapshot(
    kind: BooleanKind,
    value: option.Some(Boolean(value)),
    display_text: case value {
      True -> "true"
      False -> "false"
    },
    read_only: read_only,
  )
}

fn build_date_snapshot(raw raw: a, read_only read_only: Bool) -> Snapshot {
  let value = date_raw(raw)
  Snapshot(
    kind: DateKind,
    value: option.Some(Date(value)),
    display_text: date.to_iso(value),
    read_only: read_only,
  )
}

fn build_integer_snapshot(raw raw: a, read_only read_only: Bool) -> Snapshot {
  let value = integer_raw(raw)
  Snapshot(
    kind: IntegerKind,
    value: option.Some(Integer(value)),
    display_text: int.to_string(value),
    read_only: read_only,
  )
}

fn build_float_snapshot(raw raw: a, read_only read_only: Bool) -> Snapshot {
  let value = float_raw(raw)
  Snapshot(
    kind: FloatKind,
    value: option.Some(Float(value)),
    display_text: float.to_string(value),
    read_only: read_only,
  )
}

fn build_decimal_snapshot(raw raw: a, read_only read_only: Bool) -> Snapshot {
  let value = decimal_raw(raw)
  Snapshot(
    kind: DecimalKind,
    value: option.Some(Decimal(value)),
    display_text: decimal_to_string(value),
    read_only: read_only,
  )
}

fn build_string_snapshot(raw raw: a, read_only read_only: Bool) -> Snapshot {
  let value = string_raw(raw)
  Snapshot(
    kind: StringKind,
    value: option.Some(Text(value)),
    display_text: value,
    read_only: read_only,
  )
}

fn empty_snapshot(kind kind: ValueKind, read_only read_only: Bool) -> Snapshot {
  Snapshot(
    kind: kind,
    value: option.None,
    display_text: "",
    read_only: read_only,
  )
}

fn parse_boolean(
  text text: String,
) -> Result(option.Option(TypedValue), ValueAdapterError) {
  let normalized = string.lowercase(text)
  case normalized {
    "true" | "yes" | "1" -> Ok(option.Some(Boolean(True)))
    "false" | "no" | "0" -> Ok(option.Some(Boolean(False)))
    _ ->
      Error(InvalidTextInput(
        BooleanKind,
        text,
        "expected true, yes, or 1 for true and false, no, or 0 for false",
      ))
  }
}

fn parse_integer(
  text text: String,
) -> Result(option.Option(TypedValue), ValueAdapterError) {
  case int.parse(text) {
    Ok(value) -> Ok(option.Some(Integer(value)))
    Error(_) ->
      Error(InvalidTextInput(IntegerKind, text, "expected an integer"))
  }
}

fn parse_float(
  text text: String,
) -> Result(option.Option(TypedValue), ValueAdapterError) {
  case float.parse(text) {
    Ok(value) -> Ok(option.Some(Float(value)))
    Error(_) -> Error(InvalidTextInput(FloatKind, text, "expected a number"))
  }
}

fn parse_decimal(
  text text: String,
) -> Result(option.Option(TypedValue), ValueAdapterError) {
  case make_decimal_from_text_raw(text) {
    option.Some(value) -> Ok(option.Some(Decimal(value)))
    option.None ->
      Error(InvalidTextInput(
        DecimalKind,
        text,
        "expected a plain decimal such as -12.5",
      ))
  }
}

fn parse_date(
  text text: String,
) -> Result(option.Option(TypedValue), ValueAdapterError) {
  case parse_date_text_raw(text) {
    option.Some(value) -> Ok(option.Some(Date(value)))
    option.None ->
      Error(InvalidTextInput(
        DateKind,
        text,
        "expected an ISO 8601 date or date-time without a timezone offset",
      ))
  }
}

// -- FFI --
@external(javascript, "./mendix_ffi.mjs", "classify_editable_value")
fn classify_raw(raw raw: a) -> String

@external(javascript, "./mendix_ffi.mjs", "editable_value_boolean")
fn boolean_raw(raw raw: a) -> Bool

@external(javascript, "./mendix_ffi.mjs", "editable_value_date")
fn date_raw(raw raw: a) -> date.JsDate

@external(javascript, "./mendix_ffi.mjs", "editable_value_integer")
fn integer_raw(raw raw: a) -> Int

@external(javascript, "./mendix_ffi.mjs", "editable_value_float")
fn float_raw(raw raw: a) -> Float

@external(javascript, "./mendix_ffi.mjs", "editable_value_decimal")
fn decimal_raw(raw raw: a) -> DecimalValue

@external(javascript, "./mendix_ffi.mjs", "editable_value_string")
fn string_raw(raw raw: a) -> String

@external(javascript, "./mendix_ffi.mjs", "make_decimal_from_text")
fn make_decimal_from_text_raw(text text: String) -> option.Option(DecimalValue)

@external(javascript, "./mendix_ffi.mjs", "parse_date_text")
fn parse_date_text_raw(text text: String) -> option.Option(date.JsDate)

@external(javascript, "./mendix_ffi.mjs", "decimal_value_to_string")
fn decimal_to_string_raw(value value: DecimalValue) -> String

@external(javascript, "./mendix_ffi.mjs", "decimal_value_to_float")
fn decimal_to_float_raw(value value: DecimalValue) -> option.Option(Float)

@external(javascript, "./mendix_ffi.mjs", "decimal_values_equal")
fn decimal_values_equal_raw(
  left left: DecimalValue,
  right right: DecimalValue,
) -> Bool

@external(javascript, "./mendix_ffi.mjs", "editable_set_value_checked")
fn editable_set_value_checked_raw(
  ev ev: editable_value.EditableValue,
  value value: option.Option(a),
) -> Result(Nil, String)
