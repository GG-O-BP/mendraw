// Mendix Pluggable Widget API - 핵심 타입 + JsProps 접근자
// ValueStatus, ObjectItem 타입과 props 접근 유틸리티

import gleam/list
import gleam/option.{type Option}
import gleam/string

/// Mendix가 전달하는 props 객체
pub type JsProps

// === ValueStatus ===

pub type ValueStatus {
  Available
  Unavailable
  Loading
}

pub fn to_value_status(status: String) -> ValueStatus {
  case status {
    "available" -> Available
    "loading" -> Loading
    _ -> Unavailable
  }
}

// === ObjectItem ===

pub type ObjectItem

@external(javascript, "./mendix_ffi.mjs", "get_object_id")
pub fn object_id(item: ObjectItem) -> String

// === JsProps 접근자 ===

/// Mendix props에서 값 추출 (undefined → None)
@external(javascript, "./mendix_ffi.mjs", "get_mendix_prop")
pub fn get_prop(props: JsProps, key: String) -> Option(a)

/// Mendix props에서 항상 존재하는 값 추출
@external(javascript, "./mendix_ffi.mjs", "get_mendix_prop_required")
pub fn get_prop_required(props: JsProps, key: String) -> a

/// Mendix props에서 문자열 속성값 추출 (undefined → "")
@external(javascript, "./mendix_ffi.mjs", "get_string_prop")
pub fn get_string_prop(props: JsProps, key: String) -> String

/// Mendix props에서 키 존재 확인
@external(javascript, "./mendix_ffi.mjs", "has_prop")
pub fn has_prop(props: JsProps, key: String) -> Bool

// === Status 접근 (status 속성을 가진 모든 Mendix 객체) ===

@external(javascript, "./mendix_ffi.mjs", "get_status")
fn get_status_raw(obj: a) -> String

pub fn get_status(obj: a) -> ValueStatus {
  to_value_status(get_status_raw(obj))
}

// === Option 변환 유틸리티 (FFI 경계 처리) ===

/// JS 값을 Gleam Option으로 변환 (undefined/null → None)
@external(javascript, "./mendix_ffi.mjs", "to_option")
pub fn to_option(value: a) -> Option(a)

/// Gleam Option을 JS 값으로 변환 (None → undefined)
@external(javascript, "./mendix_ffi.mjs", "from_option")
pub fn from_option(option: Option(a)) -> a

// === CSS 유틸리티 ===

/// CSS 클래스명 조건부 조합
pub fn cx(classes: List(#(String, Bool))) -> String {
  classes
  |> list.filter_map(fn(pair) {
    case pair.1 {
      True -> Ok(pair.0)
      False -> Error(Nil)
    }
  })
  |> string.join(" ")
}
