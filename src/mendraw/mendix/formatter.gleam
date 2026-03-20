// Mendix ValueFormatter 타입 — 값 포맷팅/파싱
// 사용: EditableValue, ListAttributeValue 등의 포매터

import gleam/option.{type Option}

// === 타입 ===

pub type ValueFormatter

// === 메서드 ===

/// 값을 표시 문자열로 포맷팅 (None → 빈 값 포맷)
@external(javascript, "../mendix_ffi.mjs", "formatter_format")
pub fn format(fmt: ValueFormatter, value: Option(a)) -> String

/// 문자열을 값으로 파싱 (실패 시 Error(Nil))
@external(javascript, "../mendix_ffi.mjs", "formatter_parse")
pub fn parse(fmt: ValueFormatter, text: String) -> Result(Option(a), Nil)
