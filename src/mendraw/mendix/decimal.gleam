//// Provides typed operations for Mendix decimal values.
////

/// A typed `Decimal` value used by the decimal capability.
pub type Decimal

/// Parses a decimal from text.
pub fn from_string(s s: String) -> Decimal {
  from_string_raw(s)
}

/// Creates a decimal from an integer.
pub fn from_int(n n: Int) -> Decimal {
  from_int_raw(n)
}

/// Creates a decimal from a floating-point value.
pub fn from_float(f f: Float) -> Decimal {
  from_float_raw(f)
}

/// Serializes a decimal as text.
pub fn to_string(d d: Decimal) -> String {
  to_string_raw(d)
}

/// Converts a decimal to a floating-point value.
pub fn to_float(d d: Decimal) -> Float {
  to_float_raw(d)
}

/// Converts a decimal to an integer.
pub fn to_int(d d: Decimal) -> Int {
  to_int_raw(d)
}

/// Formats a decimal with a fixed number of fraction digits.
pub fn to_fixed(d d: Decimal, dp dp: Int) -> String {
  to_fixed_raw(d, dp)
}

// -- FFI --
@external(javascript, "./decimal_ffi.mjs", "decimal_from_string")
fn from_string_raw(s s: String) -> Decimal

@external(javascript, "./decimal_ffi.mjs", "decimal_from_int")
fn from_int_raw(n n: Int) -> Decimal

@external(javascript, "./decimal_ffi.mjs", "decimal_from_float")
fn from_float_raw(f f: Float) -> Decimal

@external(javascript, "./decimal_ffi.mjs", "decimal_to_string")
fn to_string_raw(d d: Decimal) -> String

@external(javascript, "./decimal_ffi.mjs", "decimal_to_float")
fn to_float_raw(d d: Decimal) -> Float

@external(javascript, "./decimal_ffi.mjs", "decimal_to_int")
fn to_int_raw(d d: Decimal) -> Int

@external(javascript, "./decimal_ffi.mjs", "decimal_to_fixed")
fn to_fixed_raw(d d: Decimal, dp dp: Int) -> String
