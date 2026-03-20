// Mendix Reference 타입 — 단일 연관 관계 값

import gleam/option.{type Option}

pub type ReferenceValue

/// 참조 값 (없으면 None)
@external(javascript, "../mendix_ffi.mjs", "get_modifiable_value")
pub fn value(ref: ReferenceValue) -> Option(a)

/// 참조 설정 (None → 참조 해제)
@external(javascript, "../mendix_ffi.mjs", "modifiable_set_value")
pub fn set_value(ref: ReferenceValue, value: Option(a)) -> Nil

/// 읽기 전용 여부
@external(javascript, "../mendix_ffi.mjs", "get_modifiable_read_only")
pub fn read_only(ref: ReferenceValue) -> Bool

/// 유효성 검사 메시지 (없으면 None)
@external(javascript, "../mendix_ffi.mjs", "get_modifiable_validation")
pub fn validation(ref: ReferenceValue) -> Option(String)
