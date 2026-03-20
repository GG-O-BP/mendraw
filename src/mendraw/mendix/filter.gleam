// Mendix Filter 조건 빌더 — mendix/filters/builders 래핑
// 사용: ListValue의 필터 조건 프로그래매틱 구성

import mendraw/mendix/list_value.{type FilterCondition}

// === 타입 ===

/// 필터 표현식 (attribute, literal, association, empty)
pub type ValueExpression

// === Boolean 조합 ===

/// AND 조합 (모든 조건 충족)
@external(javascript, "./filter_ffi.mjs", "filter_and")
pub fn and_(conditions: List(FilterCondition)) -> FilterCondition

/// OR 조합 (하나 이상 충족)
@external(javascript, "./filter_ffi.mjs", "filter_or")
pub fn or_(conditions: List(FilterCondition)) -> FilterCondition

/// NOT 부정
@external(javascript, "./filter_ffi.mjs", "filter_not")
pub fn not_(condition: FilterCondition) -> FilterCondition

// === 동등 비교 ===

@external(javascript, "./filter_ffi.mjs", "filter_equals")
pub fn equals(a: ValueExpression, b: ValueExpression) -> FilterCondition

@external(javascript, "./filter_ffi.mjs", "filter_not_equal")
pub fn not_equal(a: ValueExpression, b: ValueExpression) -> FilterCondition

// === 크기 비교 ===

@external(javascript, "./filter_ffi.mjs", "filter_greater_than")
pub fn greater_than(a: ValueExpression, b: ValueExpression) -> FilterCondition

@external(javascript, "./filter_ffi.mjs", "filter_greater_than_or_equal")
pub fn greater_than_or_equal(
  a: ValueExpression,
  b: ValueExpression,
) -> FilterCondition

@external(javascript, "./filter_ffi.mjs", "filter_less_than")
pub fn less_than(a: ValueExpression, b: ValueExpression) -> FilterCondition

@external(javascript, "./filter_ffi.mjs", "filter_less_than_or_equal")
pub fn less_than_or_equal(
  a: ValueExpression,
  b: ValueExpression,
) -> FilterCondition

// === 문자열 검색 ===

@external(javascript, "./filter_ffi.mjs", "filter_contains")
pub fn contains(a: ValueExpression, b: ValueExpression) -> FilterCondition

@external(javascript, "./filter_ffi.mjs", "filter_starts_with")
pub fn starts_with(a: ValueExpression, b: ValueExpression) -> FilterCondition

@external(javascript, "./filter_ffi.mjs", "filter_ends_with")
pub fn ends_with(a: ValueExpression, b: ValueExpression) -> FilterCondition

// === 날짜 비교 ===

@external(javascript, "./filter_ffi.mjs", "filter_day_equals")
pub fn day_equals(a: ValueExpression, b: ValueExpression) -> FilterCondition

@external(javascript, "./filter_ffi.mjs", "filter_day_not_equal")
pub fn day_not_equal(a: ValueExpression, b: ValueExpression) -> FilterCondition

@external(javascript, "./filter_ffi.mjs", "filter_day_greater_than")
pub fn day_greater_than(
  a: ValueExpression,
  b: ValueExpression,
) -> FilterCondition

@external(javascript, "./filter_ffi.mjs", "filter_day_greater_than_or_equal")
pub fn day_greater_than_or_equal(
  a: ValueExpression,
  b: ValueExpression,
) -> FilterCondition

@external(javascript, "./filter_ffi.mjs", "filter_day_less_than")
pub fn day_less_than(a: ValueExpression, b: ValueExpression) -> FilterCondition

@external(javascript, "./filter_ffi.mjs", "filter_day_less_than_or_equal")
pub fn day_less_than_or_equal(
  a: ValueExpression,
  b: ValueExpression,
) -> FilterCondition

// === 표현식 생성 ===

/// 속성 참조 표현식 (속성 ID로 지정)
@external(javascript, "./filter_ffi.mjs", "filter_attribute")
pub fn attribute(id: String) -> ValueExpression

/// 연관 관계 참조 표현식 (연관 ID로 지정)
@external(javascript, "./filter_ffi.mjs", "filter_association")
pub fn association(id: String) -> ValueExpression

/// 리터럴 값 표현식
@external(javascript, "./filter_ffi.mjs", "filter_literal")
pub fn literal(value: a) -> ValueExpression

/// 빈 값 표현식
@external(javascript, "./filter_ffi.mjs", "filter_empty")
pub fn empty() -> ValueExpression
