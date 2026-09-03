//// Tests synthetic Mendix value alignment contracts.
////

import gleeunit/should

/// Verifies aligned synthetic constructors keep their runtime shapes.
pub fn aligned_synthetic_constructors_succeed_test() -> Nil {
  aligned_synthetic_constructors_succeed()
  |> should.be_true
}

/// Verifies mismatched parallel lengths fail during construction.
pub fn mismatched_synthetic_constructors_fail_test() -> Nil {
  mismatched_synthetic_constructors_fail()
  |> should.be_true
}

// -- FFI --
@external(javascript, "./mendraw_synthetic_test_ffi.mjs", "aligned_synthetic_constructors_succeed")
fn aligned_synthetic_constructors_succeed() -> Bool

@external(javascript, "./mendraw_synthetic_test_ffi.mjs", "mismatched_synthetic_constructors_fail")
fn mismatched_synthetic_constructors_fail() -> Bool
