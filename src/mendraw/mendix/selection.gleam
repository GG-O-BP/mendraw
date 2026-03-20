// Mendix Selection 타입 — 단일/다중 선택
// 사용: 데이터 그리드 선택, 리스트 선택 등

import gleam/option.{type Option}
import mendraw/mendix.{type ObjectItem}

// === 타입 ===

pub type SelectionSingleValue

pub type SelectionMultiValue

// === 단일 선택 ===

/// 현재 선택된 아이템 (없으면 None)
@external(javascript, "../mendix_ffi.mjs", "get_selection_single")
pub fn selection(sel: SelectionSingleValue) -> Option(ObjectItem)

/// 선택 설정 (None → 선택 해제)
@external(javascript, "../mendix_ffi.mjs", "set_selection_single")
pub fn set_selection(sel: SelectionSingleValue, item: Option(ObjectItem)) -> Nil

// === 다중 선택 ===

/// 현재 선택된 아이템 목록
@external(javascript, "../mendix_ffi.mjs", "get_selection_multi")
pub fn selections(sel: SelectionMultiValue) -> List(ObjectItem)

/// 선택 목록 설정
@external(javascript, "../mendix_ffi.mjs", "set_selection_multi")
pub fn set_selections(sel: SelectionMultiValue, items: List(ObjectItem)) -> Nil
