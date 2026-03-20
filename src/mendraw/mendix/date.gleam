// Mendix JS Date 타입 — Gleam opaque 래퍼
// EditableValue<Date>에서 반환되는 JS Date 객체를 타입 안전하게 다룸

import gleam/option.{type Option}

// === 타입 ===

pub type JsDate

// === 생성 ===

/// 현재 시각
@external(javascript, "../mendix_ffi.mjs", "date_now")
pub fn now() -> JsDate

/// ISO 8601 문자열로 생성
@external(javascript, "../mendix_ffi.mjs", "date_from_iso")
pub fn from_iso(iso_string: String) -> JsDate

/// Unix 타임스탬프(밀리초)로 생성
@external(javascript, "../mendix_ffi.mjs", "date_from_timestamp")
pub fn from_timestamp(ms: Int) -> JsDate

/// 날짜/시간 요소로 생성 (month: 1-12)
@external(javascript, "../mendix_ffi.mjs", "date_create")
pub fn create(
  year: Int,
  month: Int,
  day: Int,
  hours: Int,
  minutes: Int,
  seconds: Int,
  milliseconds: Int,
) -> JsDate

// === 변환 ===

/// ISO 8601 문자열로 변환
@external(javascript, "../mendix_ffi.mjs", "date_to_iso")
pub fn to_iso(date: JsDate) -> String

/// Unix 타임스탬프(밀리초) 반환
@external(javascript, "../mendix_ffi.mjs", "date_get_time")
pub fn to_timestamp(date: JsDate) -> Int

/// 사람이 읽기 쉬운 문자열로 변환
@external(javascript, "../mendix_ffi.mjs", "date_to_string")
pub fn to_string(date: JsDate) -> String

// === 접근자 ===

/// 연도 (4자리)
@external(javascript, "../mendix_ffi.mjs", "date_get_full_year")
pub fn year(date: JsDate) -> Int

/// 월 (1-12, Gleam 기준 1-based)
@external(javascript, "../mendix_ffi.mjs", "date_get_month")
pub fn month(date: JsDate) -> Int

/// 일 (1-31)
@external(javascript, "../mendix_ffi.mjs", "date_get_date")
pub fn day(date: JsDate) -> Int

/// 시 (0-23)
@external(javascript, "../mendix_ffi.mjs", "date_get_hours")
pub fn hours(date: JsDate) -> Int

/// 분 (0-59)
@external(javascript, "../mendix_ffi.mjs", "date_get_minutes")
pub fn minutes(date: JsDate) -> Int

/// 초 (0-59)
@external(javascript, "../mendix_ffi.mjs", "date_get_seconds")
pub fn seconds(date: JsDate) -> Int

/// 밀리초 (0-999)
@external(javascript, "../mendix_ffi.mjs", "date_get_milliseconds")
pub fn milliseconds(date: JsDate) -> Int

/// 요일 (0=일요일, 1=월요일, ..., 6=토요일)
@external(javascript, "../mendix_ffi.mjs", "date_get_day")
pub fn day_of_week(date: JsDate) -> Int

// === HTML input[type="date"] 변환 ===

/// JsDate → "YYYY-MM-DD" 변환 (로컬 시간 기준, input[type="date"] 용)
@external(javascript, "../mendix_ffi.mjs", "date_to_input_value")
pub fn to_input_value(date: JsDate) -> String

/// "YYYY-MM-DD" → Option(JsDate) 변환 (빈 문자열 → None)
@external(javascript, "../mendix_ffi.mjs", "input_value_to_date")
pub fn from_input_value(date_string: String) -> Option(JsDate)
