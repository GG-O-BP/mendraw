//// Generates Mendraw bindings from package assets installed by mxpak.

import mendraw/cmd

/// Runs the binding-generation entrypoint.
pub fn main() -> Nil {
  cmd.generate_widget_bindings()
  |> cmd.report
}
