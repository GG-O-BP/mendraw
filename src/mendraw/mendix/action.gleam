//// Provides typed access to Mendix action values.
////

import gleam/option

/// A typed `ActionValue` value used by the action capability.
pub type ActionValue

/// Reports whether the action can currently execute.
pub fn can_execute(action action: ActionValue) -> Bool {
  can_execute_raw(action)
}

/// Reports whether the action is currently executing.
pub fn is_executing(action action: ActionValue) -> Bool {
  is_executing_raw(action)
}

/// Executes the action.
pub fn execute(action action: ActionValue) -> Nil {
  execute_raw(action)
}

/// Executes the action only when it is enabled.
pub fn execute_if_can(action action: ActionValue) -> Nil {
  case can_execute(action) {
    True -> execute(action)
    False -> Nil
  }
}

/// Executes an optional action when present and enabled.
pub fn execute_action(action action: option.Option(ActionValue)) -> Nil {
  case action {
    option.Some(a) -> execute_if_can(a)
    option.None -> Nil
  }
}

// -- FFI --
@external(javascript, "../mendix_ffi.mjs", "get_action_can_execute")
fn can_execute_raw(action action: ActionValue) -> Bool

@external(javascript, "../mendix_ffi.mjs", "get_action_is_executing")
fn is_executing_raw(action action: ActionValue) -> Bool

@external(javascript, "../mendix_ffi.mjs", "action_execute")
fn execute_raw(action action: ActionValue) -> Nil
