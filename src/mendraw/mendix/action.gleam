// Mendix ActionValue 타입 — 실행 가능한 액션 (마이크로플로우, 나노플로우 등)

import gleam/option.{type Option, None, Some}

// === 타입 ===

pub type ActionValue

// === 접근자 ===

/// 실행 가능 여부
@external(javascript, "../mendix_ffi.mjs", "get_action_can_execute")
pub fn can_execute(action: ActionValue) -> Bool

/// 현재 실행 중인지 여부
@external(javascript, "../mendix_ffi.mjs", "get_action_is_executing")
pub fn is_executing(action: ActionValue) -> Bool

// === 메서드 ===

/// 액션 실행
@external(javascript, "../mendix_ffi.mjs", "action_execute")
pub fn execute(action: ActionValue) -> Nil

// === 편의 함수 (순수 Gleam) ===

/// 실행 가능할 때만 실행
pub fn execute_if_can(action: ActionValue) -> Nil {
  case can_execute(action) {
    True -> execute(action)
    False -> Nil
  }
}

/// Option(ActionValue)를 받아 실행 가능하면 실행
pub fn execute_action(action: Option(ActionValue)) -> Nil {
  case action {
    Some(a) -> execute_if_can(a)
    None -> Nil
  }
}
