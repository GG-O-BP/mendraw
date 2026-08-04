//// Provides typed access to Mendix list data sources.
////

import gleam/option
import mendraw/mendix

/// A typed `ListValue` value used by the list value capability.
pub type ListValue

/// A typed `FilterCondition` value used by the list value capability.
pub type FilterCondition

/// A typed `SortInstruction` value used by the list value capability.
pub type SortInstruction

/// A typed `SortDirection` value used by the list value capability.
pub type SortDirection {
  /// The `Asc` variant.
  Asc
  /// The `Desc` variant.
  Desc
}

/// Controls whether Mendix should calculate the total item count.
pub type TotalCountRequest {
  /// Requests total-count calculation.
  RequestTotalCount
  /// Skips total-count calculation.
  SkipTotalCount
}

/// Returns the list loading status.
pub fn status(lv lv: ListValue) -> mendix.ValueStatus {
  mendix.to_value_status(get_status_raw(lv))
}

/// Returns the loaded list items.
pub fn items(lv lv: ListValue) -> option.Option(List(mendix.ObjectItem)) {
  items_raw(lv)
}

/// Returns the current page offset.
pub fn offset(lv lv: ListValue) -> Int {
  offset_raw(lv)
}

/// Returns the current page size.
pub fn limit(lv lv: ListValue) -> Int {
  limit_raw(lv)
}

/// Reports whether more items are available.
pub fn has_more_items(lv lv: ListValue) -> option.Option(Bool) {
  has_more_items_raw(lv)
}

/// Returns the total item count when requested.
pub fn total_count(lv lv: ListValue) -> option.Option(Int) {
  total_count_raw(lv)
}

/// Returns the current sort instructions.
pub fn sort_order(lv lv: ListValue) -> List(SortInstruction) {
  sort_order_raw(lv)
}

/// Returns the current filter condition.
pub fn filter(lv lv: ListValue) -> option.Option(FilterCondition) {
  filter_raw(lv)
}

/// Sets the offset.
pub fn set_offset(lv lv: ListValue, offset offset: Int) -> Nil {
  set_offset_raw(lv, offset)
}

/// Sets the limit.
pub fn set_limit(lv lv: ListValue, limit limit: Int) -> Nil {
  set_limit_raw(lv, limit)
}

/// Sets the filter.
pub fn set_filter(
  lv lv: ListValue,
  filter filter: option.Option(FilterCondition),
) -> Nil {
  set_filter_raw(lv, filter)
}

/// Sets the sort order.
pub fn set_sort_order(
  lv lv: ListValue,
  order order: List(SortInstruction),
) -> Nil {
  set_sort_order_raw(lv, order)
}

/// Reloads the list data source.
pub fn reload(lv lv: ListValue) -> Nil {
  reload_raw(lv)
}

/// Controls whether Mendix calculates the total item count.
pub fn request_total_count(
  lv lv: ListValue,
  request request: TotalCountRequest,
) -> Nil {
  request_total_count_raw(lv, case request {
    RequestTotalCount -> True
    SkipTotalCount -> False
  })
}

/// Reports whether the list data source is available.
pub fn is_available(lv lv: ListValue) -> Bool {
  status(lv) == mendix.Available
}

/// Creates a sort instruction.
pub fn sort(
  id id: String,
  direction direction: SortDirection,
) -> SortInstruction {
  make_sort_raw(id, direction == Asc)
}

/// Returns the attribute identifier from a sort instruction.
pub fn sort_id(instr instr: SortInstruction) -> String {
  sort_id_raw(instr)
}

/// Returns the direction from a sort instruction.
pub fn sort_direction(instr instr: SortInstruction) -> SortDirection {
  case sort_asc_raw(instr) {
    True -> Asc
    False -> Desc
  }
}

// -- FFI --
@external(javascript, "../mendix_ffi.mjs", "get_status")
fn get_status_raw(lv: ListValue) -> String

@external(javascript, "../mendix_ffi.mjs", "get_list_items")
fn items_raw(lv lv: ListValue) -> option.Option(List(mendix.ObjectItem))

@external(javascript, "../mendix_ffi.mjs", "get_list_offset")
fn offset_raw(lv lv: ListValue) -> Int

@external(javascript, "../mendix_ffi.mjs", "get_list_limit")
fn limit_raw(lv lv: ListValue) -> Int

@external(javascript, "../mendix_ffi.mjs", "get_list_has_more_items")
fn has_more_items_raw(lv lv: ListValue) -> option.Option(Bool)

@external(javascript, "../mendix_ffi.mjs", "get_list_total_count")
fn total_count_raw(lv lv: ListValue) -> option.Option(Int)

@external(javascript, "../mendix_ffi.mjs", "get_list_sort_order")
fn sort_order_raw(lv lv: ListValue) -> List(SortInstruction)

@external(javascript, "../mendix_ffi.mjs", "get_list_filter")
fn filter_raw(lv lv: ListValue) -> option.Option(FilterCondition)

@external(javascript, "../mendix_ffi.mjs", "list_set_offset")
fn set_offset_raw(lv lv: ListValue, offset offset: Int) -> Nil

@external(javascript, "../mendix_ffi.mjs", "list_set_limit")
fn set_limit_raw(lv lv: ListValue, limit limit: Int) -> Nil

@external(javascript, "../mendix_ffi.mjs", "list_set_filter")
fn set_filter_raw(
  lv lv: ListValue,
  filter filter: option.Option(FilterCondition),
) -> Nil

@external(javascript, "../mendix_ffi.mjs", "list_set_sort_order")
fn set_sort_order_raw(
  lv lv: ListValue,
  order order: List(SortInstruction),
) -> Nil

@external(javascript, "../mendix_ffi.mjs", "list_reload")
fn reload_raw(lv lv: ListValue) -> Nil

@external(javascript, "../mendix_ffi.mjs", "list_request_total_count")
fn request_total_count_raw(lv lv: ListValue, need need: Bool) -> Nil

@external(javascript, "../mendix_ffi.mjs", "make_sort_instruction")
fn make_sort_raw(id: String, asc: Bool) -> SortInstruction

@external(javascript, "../mendix_ffi.mjs", "get_sort_id")
fn sort_id_raw(instr instr: SortInstruction) -> String

@external(javascript, "../mendix_ffi.mjs", "get_sort_asc")
fn sort_asc_raw(instr: SortInstruction) -> Bool
