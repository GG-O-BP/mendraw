//// Builds typed Mendix data-source filter expressions.
////

import mendraw/mendix/list_value

/// A typed `ValueExpression` value used by the filter capability.
pub type ValueExpression

/// Combines filter conditions with logical AND.
pub fn and_(
  conditions conditions: List(list_value.FilterCondition),
) -> list_value.FilterCondition {
  and__raw(conditions)
}

/// Combines filter conditions with logical OR.
pub fn or_(
  conditions conditions: List(list_value.FilterCondition),
) -> list_value.FilterCondition {
  or__raw(conditions)
}

/// Negates a filter condition.
pub fn not_(
  condition condition: list_value.FilterCondition,
) -> list_value.FilterCondition {
  not__raw(condition)
}

/// Builds an equality filter condition.
pub fn equals(
  a a: ValueExpression,
  b b: ValueExpression,
) -> list_value.FilterCondition {
  equals_raw(a, b)
}

/// Builds an inequality filter condition.
pub fn not_equal(
  a a: ValueExpression,
  b b: ValueExpression,
) -> list_value.FilterCondition {
  not_equal_raw(a, b)
}

/// Builds a greater-than filter condition.
pub fn greater_than(
  a a: ValueExpression,
  b b: ValueExpression,
) -> list_value.FilterCondition {
  greater_than_raw(a, b)
}

/// Builds a greater-than-or-equal filter condition.
pub fn greater_than_or_equal(
  a a: ValueExpression,
  b b: ValueExpression,
) -> list_value.FilterCondition {
  greater_than_or_equal_raw(a, b)
}

/// Builds a less-than filter condition.
pub fn less_than(
  a a: ValueExpression,
  b b: ValueExpression,
) -> list_value.FilterCondition {
  less_than_raw(a, b)
}

/// Builds a less-than-or-equal filter condition.
pub fn less_than_or_equal(
  a a: ValueExpression,
  b b: ValueExpression,
) -> list_value.FilterCondition {
  less_than_or_equal_raw(a, b)
}

/// Builds a string-contains filter condition.
pub fn contains(
  a a: ValueExpression,
  b b: ValueExpression,
) -> list_value.FilterCondition {
  contains_raw(a, b)
}

/// Builds a string-prefix filter condition.
pub fn starts_with(
  a a: ValueExpression,
  b b: ValueExpression,
) -> list_value.FilterCondition {
  starts_with_raw(a, b)
}

/// Builds a string-suffix filter condition.
pub fn ends_with(
  a a: ValueExpression,
  b b: ValueExpression,
) -> list_value.FilterCondition {
  ends_with_raw(a, b)
}

/// Builds a day equality filter condition.
pub fn day_equals(
  a a: ValueExpression,
  b b: ValueExpression,
) -> list_value.FilterCondition {
  day_equals_raw(a, b)
}

/// Builds a day inequality filter condition.
pub fn day_not_equal(
  a a: ValueExpression,
  b b: ValueExpression,
) -> list_value.FilterCondition {
  day_not_equal_raw(a, b)
}

/// Builds a day greater-than filter condition.
pub fn day_greater_than(
  a a: ValueExpression,
  b b: ValueExpression,
) -> list_value.FilterCondition {
  day_greater_than_raw(a, b)
}

/// Builds a day greater-than-or-equal filter condition.
pub fn day_greater_than_or_equal(
  a a: ValueExpression,
  b b: ValueExpression,
) -> list_value.FilterCondition {
  day_greater_than_or_equal_raw(a, b)
}

/// Builds a day less-than filter condition.
pub fn day_less_than(
  a a: ValueExpression,
  b b: ValueExpression,
) -> list_value.FilterCondition {
  day_less_than_raw(a, b)
}

/// Builds a day less-than-or-equal filter condition.
pub fn day_less_than_or_equal(
  a a: ValueExpression,
  b b: ValueExpression,
) -> list_value.FilterCondition {
  day_less_than_or_equal_raw(a, b)
}

/// Creates an attribute value expression.
pub fn attribute(id id: String) -> ValueExpression {
  attribute_raw(id)
}

/// Creates an association value expression.
pub fn association(id id: String) -> ValueExpression {
  association_raw(id)
}

/// Creates a literal value expression.
pub fn literal(value value: a) -> ValueExpression {
  literal_raw(value)
}

/// Creates an empty value expression.
pub fn empty() -> ValueExpression {
  empty_raw()
}

// -- FFI --
@external(javascript, "./filter_ffi.mjs", "filter_and")
fn and__raw(
  conditions conditions: List(list_value.FilterCondition),
) -> list_value.FilterCondition

@external(javascript, "./filter_ffi.mjs", "filter_or")
fn or__raw(
  conditions conditions: List(list_value.FilterCondition),
) -> list_value.FilterCondition

@external(javascript, "./filter_ffi.mjs", "filter_not")
fn not__raw(
  condition condition: list_value.FilterCondition,
) -> list_value.FilterCondition

@external(javascript, "./filter_ffi.mjs", "filter_equals")
fn equals_raw(
  a a: ValueExpression,
  b b: ValueExpression,
) -> list_value.FilterCondition

@external(javascript, "./filter_ffi.mjs", "filter_not_equal")
fn not_equal_raw(
  a a: ValueExpression,
  b b: ValueExpression,
) -> list_value.FilterCondition

@external(javascript, "./filter_ffi.mjs", "filter_greater_than")
fn greater_than_raw(
  a a: ValueExpression,
  b b: ValueExpression,
) -> list_value.FilterCondition

@external(javascript, "./filter_ffi.mjs", "filter_greater_than_or_equal")
fn greater_than_or_equal_raw(
  a a: ValueExpression,
  b b: ValueExpression,
) -> list_value.FilterCondition

@external(javascript, "./filter_ffi.mjs", "filter_less_than")
fn less_than_raw(
  a a: ValueExpression,
  b b: ValueExpression,
) -> list_value.FilterCondition

@external(javascript, "./filter_ffi.mjs", "filter_less_than_or_equal")
fn less_than_or_equal_raw(
  a a: ValueExpression,
  b b: ValueExpression,
) -> list_value.FilterCondition

@external(javascript, "./filter_ffi.mjs", "filter_contains")
fn contains_raw(
  a a: ValueExpression,
  b b: ValueExpression,
) -> list_value.FilterCondition

@external(javascript, "./filter_ffi.mjs", "filter_starts_with")
fn starts_with_raw(
  a a: ValueExpression,
  b b: ValueExpression,
) -> list_value.FilterCondition

@external(javascript, "./filter_ffi.mjs", "filter_ends_with")
fn ends_with_raw(
  a a: ValueExpression,
  b b: ValueExpression,
) -> list_value.FilterCondition

@external(javascript, "./filter_ffi.mjs", "filter_day_equals")
fn day_equals_raw(
  a a: ValueExpression,
  b b: ValueExpression,
) -> list_value.FilterCondition

@external(javascript, "./filter_ffi.mjs", "filter_day_not_equal")
fn day_not_equal_raw(
  a a: ValueExpression,
  b b: ValueExpression,
) -> list_value.FilterCondition

@external(javascript, "./filter_ffi.mjs", "filter_day_greater_than")
fn day_greater_than_raw(
  a a: ValueExpression,
  b b: ValueExpression,
) -> list_value.FilterCondition

@external(javascript, "./filter_ffi.mjs", "filter_day_greater_than_or_equal")
fn day_greater_than_or_equal_raw(
  a a: ValueExpression,
  b b: ValueExpression,
) -> list_value.FilterCondition

@external(javascript, "./filter_ffi.mjs", "filter_day_less_than")
fn day_less_than_raw(
  a a: ValueExpression,
  b b: ValueExpression,
) -> list_value.FilterCondition

@external(javascript, "./filter_ffi.mjs", "filter_day_less_than_or_equal")
fn day_less_than_or_equal_raw(
  a a: ValueExpression,
  b b: ValueExpression,
) -> list_value.FilterCondition

@external(javascript, "./filter_ffi.mjs", "filter_attribute")
fn attribute_raw(id id: String) -> ValueExpression

@external(javascript, "./filter_ffi.mjs", "filter_association")
fn association_raw(id id: String) -> ValueExpression

@external(javascript, "./filter_ffi.mjs", "filter_literal")
fn literal_raw(value value: a) -> ValueExpression

@external(javascript, "./filter_ffi.mjs", "filter_empty")
fn empty_raw() -> ValueExpression
