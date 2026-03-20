// Mendix DynamicValue 타입 — 동적으로 계산되는 읽기 전용 값
// 사용: 표현식 속성 (expression property)

import gleam/option.{type Option}
import mendraw/mendix.{type ValueStatus}

// === 타입 ===

pub type DynamicValue

// === 접근자 ===

@external(javascript, "../mendix_ffi.mjs", "get_status")
fn get_status_raw(dv: DynamicValue) -> String

/// 현재 상태 (Available, Loading, Unavailable)
pub fn status(dv: DynamicValue) -> ValueStatus {
  mendix.to_value_status(get_status_raw(dv))
}

/// 현재 값 (undefined → None)
@external(javascript, "../mendix_ffi.mjs", "get_dynamic_value")
pub fn value(dv: DynamicValue) -> Option(a)

// === 편의 함수 (순수 Gleam) ===

/// 값이 사용 가능한지 확인
pub fn is_available(dv: DynamicValue) -> Bool {
  status(dv) == mendix.Available
}
