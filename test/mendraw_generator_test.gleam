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

/// Verifies hostile widget and property names generate valid bindings.
pub fn hostile_widget_names_generate_bindings_test() -> Nil {
  hostile_widget_names_generate_valid_bindings()
  |> should.be_true
}

/// Verifies commented classic metadata still enables classic bindings.
pub fn classic_meta_with_comments_generate_bindings_test() -> Nil {
  classic_meta_with_comments_generate_bindings()
  |> should.be_true
}

/// Verifies TOML escapes and literal strings decode exactly once.
pub fn meta_toml_escape_decoding_contract_test() -> Nil {
  meta_toml_escape_decoding_contract()
  |> should.be_true
}

// -- FFI --
@external(javascript, "./mendraw_generator_test_ffi.mjs", "empty_assets_remove_stale_bindings")
fn empty_assets_remove_stale_bindings() -> Bool

@external(javascript, "./mendraw_generator_test_ffi.mjs", "pluggable_assets_generate_bindings")
fn pluggable_assets_generate_bindings() -> Bool

@external(javascript, "./mendraw_generator_test_ffi.mjs", "hostile_widget_names_generate_valid_bindings")
fn hostile_widget_names_generate_valid_bindings() -> Bool

@external(javascript, "./mendraw_generator_test_ffi.mjs", "classic_meta_with_comments_generate_bindings")
fn classic_meta_with_comments_generate_bindings() -> Bool

@external(javascript, "./mendraw_generator_test_ffi.mjs", "meta_toml_escape_decoding_contract")
fn meta_toml_escape_decoding_contract() -> Bool
