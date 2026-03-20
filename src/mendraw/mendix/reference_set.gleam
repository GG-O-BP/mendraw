// Mendix ReferenceSet 타입 — 다중 연관 관계 값

import gleam/option.{type Option}

pub type ReferenceSetValue

/// 참조 목록 (없으면 None)
@external(javascript, "../mendix_ffi.mjs", "get_reference_set_value")
pub fn value(rset: ReferenceSetValue) -> Option(List(a))

/// 참조 목록 설정 (None → 전체 해제)
@external(javascript, "../mendix_ffi.mjs", "set_reference_set_value")
pub fn set_value(rset: ReferenceSetValue, value: Option(List(a))) -> Nil

/// 읽기 전용 여부
@external(javascript, "../mendix_ffi.mjs", "get_modifiable_read_only")
pub fn read_only(rset: ReferenceSetValue) -> Bool

/// 유효성 검사 메시지 (없으면 None)
@external(javascript, "../mendix_ffi.mjs", "get_modifiable_validation")
pub fn validation(rset: ReferenceSetValue) -> Option(String)
