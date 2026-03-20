// Mendix EditableValue 타입 — 편집 가능한 값의 접근자와 메서드
// 사용: 텍스트, 숫자, 날짜 등 Mendix 속성 편집

import gleam/option.{type Option}
import mendraw/mendix.{type ValueStatus}
import mendraw/mendix/formatter.{type ValueFormatter}

// === 타입 ===

pub type EditableValue

// === 접근자 ===

@external(javascript, "../mendix_ffi.mjs", "get_status")
fn get_status_raw(ev: EditableValue) -> String

/// 현재 상태 (Available, Loading, Unavailable)
pub fn status(ev: EditableValue) -> ValueStatus {
  mendix.to_value_status(get_status_raw(ev))
}

/// 현재 값 (undefined → None)
@external(javascript, "../mendix_ffi.mjs", "get_editable_value")
pub fn value(ev: EditableValue) -> Option(a)

/// 읽기 전용 여부
@external(javascript, "../mendix_ffi.mjs", "get_editable_read_only")
pub fn read_only(ev: EditableValue) -> Bool

/// 유효성 검사 메시지 (없으면 None)
@external(javascript, "../mendix_ffi.mjs", "get_editable_validation")
pub fn validation(ev: EditableValue) -> Option(String)

/// 표시용 문자열 (포맷팅 적용된 값)
@external(javascript, "../mendix_ffi.mjs", "get_editable_display_value")
pub fn display_value(ev: EditableValue) -> String

/// 값 포매터
@external(javascript, "../mendix_ffi.mjs", "get_editable_formatter")
pub fn formatter(ev: EditableValue) -> ValueFormatter

/// 가능한 값 목록 (열거형 속성 등)
@external(javascript, "../mendix_ffi.mjs", "get_editable_universe")
pub fn universe(ev: EditableValue) -> Option(List(a))

// === 메서드 ===

/// 값 설정 (None → undefined 전달)
@external(javascript, "../mendix_ffi.mjs", "editable_set_value")
pub fn set_value(ev: EditableValue, value: Option(a)) -> Nil

/// 텍스트 값 직접 설정 (파싱은 Mendix가 처리)
@external(javascript, "../mendix_ffi.mjs", "editable_set_text_value")
pub fn set_text_value(ev: EditableValue, text: String) -> Nil

/// 유효성 검사기 설정 (None → 검사기 제거)
@external(javascript, "../mendix_ffi.mjs", "editable_set_validator")
pub fn set_validator(
  ev: EditableValue,
  validator: Option(fn(Option(a)) -> Option(String)),
) -> Nil

// === 편의 함수 (순수 Gleam) ===

/// 값이 사용 가능한지 확인
pub fn is_available(ev: EditableValue) -> Bool {
  status(ev) == mendix.Available
}

/// 편집 가능한 상태인지 확인 (사용 가능 + 읽기 전용 아님)
pub fn is_editable(ev: EditableValue) -> Bool {
  is_available(ev) && !read_only(ev)
}
