//// Converts between Mendix date values and JavaScript dates.
////

import gleam/option

/// A typed `JsDate` value used by the date capability.
pub type JsDate

/// Returns the current JavaScript date.
pub fn now() -> JsDate {
  now_raw()
}

/// Parses an ISO-8601 date string.
pub fn from_iso(iso_string iso_string: String) -> JsDate {
  from_iso_raw(iso_string)
}

/// Creates a date from a Unix timestamp.
pub fn from_timestamp(ms ms: Int) -> JsDate {
  from_timestamp_raw(ms)
}

/// Creates a date from calendar and clock components.
pub fn create(
  year year: Int,
  month month: Int,
  day day: Int,
  hours hours: Int,
  minutes minutes: Int,
  seconds seconds: Int,
  milliseconds milliseconds: Int,
) -> JsDate {
  create_raw(year, month, day, hours, minutes, seconds, milliseconds)
}

/// Serializes a date as ISO-8601 text.
pub fn to_iso(date date: JsDate) -> String {
  to_iso_raw(date)
}

/// Returns the Unix timestamp for a date.
pub fn to_timestamp(date date: JsDate) -> Int {
  to_timestamp_raw(date)
}

/// Returns the JavaScript string representation of a date.
pub fn to_string(date date: JsDate) -> String {
  to_string_raw(date)
}

/// Returns the local calendar year.
pub fn year(date date: JsDate) -> Int {
  year_raw(date)
}

/// Returns the local calendar month.
pub fn month(date date: JsDate) -> Int {
  month_raw(date)
}

/// Returns the local day of the month.
pub fn day(date date: JsDate) -> Int {
  day_raw(date)
}

/// Returns the local hour.
pub fn hours(date date: JsDate) -> Int {
  hours_raw(date)
}

/// Returns the local minute.
pub fn minutes(date date: JsDate) -> Int {
  minutes_raw(date)
}

/// Returns the local second.
pub fn seconds(date date: JsDate) -> Int {
  seconds_raw(date)
}

/// Returns the local millisecond.
pub fn milliseconds(date date: JsDate) -> Int {
  milliseconds_raw(date)
}

/// Returns the local day-of-week index.
pub fn day_of_week(date date: JsDate) -> Int {
  day_of_week_raw(date)
}

/// Formats a date for an HTML date or time input.
pub fn to_input_value(date date: JsDate) -> String {
  to_input_value_raw(date)
}

/// Parses a date from an HTML input value.
pub fn from_input_value(
  date_string date_string: String,
) -> option.Option(JsDate) {
  from_input_value_raw(date_string)
}

// -- FFI --
@external(javascript, "../mendix_ffi.mjs", "date_now")
fn now_raw() -> JsDate

@external(javascript, "../mendix_ffi.mjs", "date_from_iso")
fn from_iso_raw(iso_string iso_string: String) -> JsDate

@external(javascript, "../mendix_ffi.mjs", "date_from_timestamp")
fn from_timestamp_raw(ms ms: Int) -> JsDate

@external(javascript, "../mendix_ffi.mjs", "date_create")
fn create_raw(
  year year: Int,
  month month: Int,
  day day: Int,
  hours hours: Int,
  minutes minutes: Int,
  seconds seconds: Int,
  milliseconds milliseconds: Int,
) -> JsDate

@external(javascript, "../mendix_ffi.mjs", "date_to_iso")
fn to_iso_raw(date date: JsDate) -> String

@external(javascript, "../mendix_ffi.mjs", "date_get_time")
fn to_timestamp_raw(date date: JsDate) -> Int

@external(javascript, "../mendix_ffi.mjs", "date_to_string")
fn to_string_raw(date date: JsDate) -> String

@external(javascript, "../mendix_ffi.mjs", "date_get_full_year")
fn year_raw(date date: JsDate) -> Int

@external(javascript, "../mendix_ffi.mjs", "date_get_month")
fn month_raw(date date: JsDate) -> Int

@external(javascript, "../mendix_ffi.mjs", "date_get_date")
fn day_raw(date date: JsDate) -> Int

@external(javascript, "../mendix_ffi.mjs", "date_get_hours")
fn hours_raw(date date: JsDate) -> Int

@external(javascript, "../mendix_ffi.mjs", "date_get_minutes")
fn minutes_raw(date date: JsDate) -> Int

@external(javascript, "../mendix_ffi.mjs", "date_get_seconds")
fn seconds_raw(date date: JsDate) -> Int

@external(javascript, "../mendix_ffi.mjs", "date_get_milliseconds")
fn milliseconds_raw(date date: JsDate) -> Int

@external(javascript, "../mendix_ffi.mjs", "date_get_day")
fn day_of_week_raw(date date: JsDate) -> Int

@external(javascript, "../mendix_ffi.mjs", "date_to_input_value")
fn to_input_value_raw(date date: JsDate) -> String

@external(javascript, "../mendix_ffi.mjs", "input_value_to_date")
fn from_input_value_raw(
  date_string date_string: String,
) -> option.Option(JsDate)
