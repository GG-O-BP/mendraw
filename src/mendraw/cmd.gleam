//// Generates Mendraw bindings from package assets already present on disk.
////
//// Package discovery, downloading, locking, and caching belong to mxpak. This
//// module only converts extracted `build/widgets/*` assets into typed Gleam and
//// JavaScript bindings for Mendraw consumers.

import gleam/io
import gleam/result

/// Describes a Mendraw binding-generation failure.
pub type CommandError {
  /// A named generation operation failed with the supplied JavaScript reason.
  CommandFailed(operation: String, reason: String)
}

/// Reports whether a file exists.
pub fn file_exists(path path: String) -> Bool {
  file_exists_raw(path)
}

/// Generates widget bindings from extracted package assets.
pub fn generate_widget_bindings() -> Result(Nil, CommandError) {
  generate_widget_bindings_raw()
  |> map_raw_error("generate widget bindings")
}

/// Prints a tooling error at a command-line boundary.
@internal
pub fn report(result result: Result(Nil, CommandError)) -> Nil {
  case result {
    Ok(Nil) -> Nil
    Error(CommandFailed(operation, reason)) ->
      io.println_error(operation <> " failed: " <> reason)
  }
}

/// Returns a human-readable tooling error.
pub fn error_message(error error: CommandError) -> String {
  case error {
    CommandFailed(operation, reason) -> operation <> " failed: " <> reason
  }
}

type RawCommandError

fn map_raw_error(
  raw_result: Result(value, RawCommandError),
  operation: String,
) -> Result(value, CommandError) {
  raw_result
  |> result.map_error(fn(error) {
    CommandFailed(
      operation: operation,
      reason: raw_command_error_message(error),
    )
  })
}

// -- FFI --
@external(javascript, "./cmd_ffi.mjs", "file_exists")
fn file_exists_raw(path path: String) -> Bool

@external(javascript, "./cmd_ffi.mjs", "generate_widget_bindings")
fn generate_widget_bindings_raw() -> Result(Nil, RawCommandError)

@external(javascript, "./cmd_ffi.mjs", "command_error_message")
fn raw_command_error_message(error: RawCommandError) -> String
