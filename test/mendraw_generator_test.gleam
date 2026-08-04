//// Tests Mendraw binding generation from installed package assets.

import gleeunit/should

/// Verifies empty package input removes stale generated bindings.
pub fn empty_assets_remove_stale_bindings_test() -> Nil {
  empty_assets_remove_stale_bindings()
  |> should.be_true
}

/// Verifies one installed pluggable widget produces source and runtime bindings.
pub fn pluggable_assets_generate_bindings_test() -> Nil {
  pluggable_assets_generate_bindings()
  |> should.be_true
}

// -- FFI --
@external(javascript, "./mendraw_generator_test_ffi.mjs", "empty_assets_remove_stale_bindings")
fn empty_assets_remove_stale_bindings() -> Bool

@external(javascript, "./mendraw_generator_test_ffi.mjs", "pluggable_assets_generate_bindings")
fn pluggable_assets_generate_bindings() -> Bool
