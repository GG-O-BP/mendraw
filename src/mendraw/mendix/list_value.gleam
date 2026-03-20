// Mendix ListValue 타입 — 데이터 소스에서 가져온 객체 목록
// 사용: 데이터 그리드, 리스트 뷰 등

import gleam/option.{type Option}
import mendraw/mendix.{type ObjectItem, type ValueStatus}

// === 타입 ===

pub type ListValue

pub type FilterCondition

pub type SortInstruction

pub type SortDirection {
  Asc
  Desc
}

// === 접근자 ===

@external(javascript, "../mendix_ffi.mjs", "get_status")
fn get_status_raw(lv: ListValue) -> String

/// 현재 상태 (Available, Loading, Unavailable)
pub fn status(lv: ListValue) -> ValueStatus {
  mendix.to_value_status(get_status_raw(lv))
}

/// 아이템 목록 (로딩 중이면 None)
@external(javascript, "../mendix_ffi.mjs", "get_list_items")
pub fn items(lv: ListValue) -> Option(List(ObjectItem))

/// 현재 오프셋
@external(javascript, "../mendix_ffi.mjs", "get_list_offset")
pub fn offset(lv: ListValue) -> Int

/// 현재 페이지 크기
@external(javascript, "../mendix_ffi.mjs", "get_list_limit")
pub fn limit(lv: ListValue) -> Int

/// 더 많은 아이템이 있는지 (불확실하면 None)
@external(javascript, "../mendix_ffi.mjs", "get_list_has_more_items")
pub fn has_more_items(lv: ListValue) -> Option(Bool)

/// 전체 아이템 수 (요청하지 않았으면 None)
@external(javascript, "../mendix_ffi.mjs", "get_list_total_count")
pub fn total_count(lv: ListValue) -> Option(Int)

/// 현재 정렬 순서
@external(javascript, "../mendix_ffi.mjs", "get_list_sort_order")
pub fn sort_order(lv: ListValue) -> List(SortInstruction)

/// 현재 필터 조건 (없으면 None)
@external(javascript, "../mendix_ffi.mjs", "get_list_filter")
pub fn filter(lv: ListValue) -> Option(FilterCondition)

// === 메서드 ===

/// 오프셋 설정 (페이지네이션)
@external(javascript, "../mendix_ffi.mjs", "list_set_offset")
pub fn set_offset(lv: ListValue, offset: Int) -> Nil

/// 페이지 크기 설정
@external(javascript, "../mendix_ffi.mjs", "list_set_limit")
pub fn set_limit(lv: ListValue, limit: Int) -> Nil

/// 필터 조건 설정 (None → 필터 해제)
@external(javascript, "../mendix_ffi.mjs", "list_set_filter")
pub fn set_filter(lv: ListValue, filter: Option(FilterCondition)) -> Nil

/// 정렬 순서 설정
@external(javascript, "../mendix_ffi.mjs", "list_set_sort_order")
pub fn set_sort_order(lv: ListValue, order: List(SortInstruction)) -> Nil

/// 데이터 새로고침
@external(javascript, "../mendix_ffi.mjs", "list_reload")
pub fn reload(lv: ListValue) -> Nil

/// 전체 아이템 수 요청 (True → 요청, False → 해제)
@external(javascript, "../mendix_ffi.mjs", "list_request_total_count")
pub fn request_total_count(lv: ListValue, need: Bool) -> Nil

// === 편의 함수 (순수 Gleam) ===

/// 값이 사용 가능한지 확인
pub fn is_available(lv: ListValue) -> Bool {
  status(lv) == mendix.Available
}

// === SortInstruction 빌더 ===

@external(javascript, "../mendix_ffi.mjs", "make_sort_instruction")
fn make_sort_raw(id: String, asc: Bool) -> SortInstruction

/// 정렬 명령 생성
pub fn sort(id: String, direction: SortDirection) -> SortInstruction {
  make_sort_raw(id, direction == Asc)
}

@external(javascript, "../mendix_ffi.mjs", "get_sort_id")
pub fn sort_id(instr: SortInstruction) -> String

@external(javascript, "../mendix_ffi.mjs", "get_sort_asc")
fn sort_asc_raw(instr: SortInstruction) -> Bool

/// 정렬 방향 조회
pub fn sort_direction(instr: SortInstruction) -> SortDirection {
  case sort_asc_raw(instr) {
    True -> Asc
    False -> Desc
  }
}
