//// Formats and parses values through a Mendix value formatter handle.
////

import gleam/option
import gleam/result

/// A typed `ValueFormatter` value used by the formatter capability.
pub type ValueFormatter

/// Describes a value that a Mendix formatter rejected.
pub type ParseError {
  /// The formatter could not interpret the supplied text.
  InvalidFormattedValue(input: String)
}

/// Formats an optional value for display.
pub fn format(
  fmt fmt: ValueFormatter,
  value value: option.Option(a),
) -> String {
  format_raw(fmt, value)
}

/// Parses user-facing text through the Mendix formatter.
pub fn parse(
  fmt fmt: ValueFormatter,
  text text: String,
) -> Result(option.Option(a), ParseError) {
  parse_raw(fmt, text)
  |> result.map_error(fn(_reason) { InvalidFormattedValue(input: text) })
}

type RawParseError

// -- FFI --
@external(javascript, "../mendix_ffi.mjs", "formatter_format")
fn format_raw(fmt fmt: ValueFormatter, value value: option.Option(a)) -> String

@external(javascript, "../mendix_ffi.mjs", "formatter_parse")
fn parse_raw(
  fmt fmt: ValueFormatter,
  text text: String,
) -> Result(option.Option(a), RawParseError)
