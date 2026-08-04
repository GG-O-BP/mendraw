//// Provides typed access to Mendix selection values.
////

import gleam/option
import mendraw/mendix

/// A typed `SelectionSingleValue` value used by the selection capability.
pub type SelectionSingleValue

/// A typed `SelectionMultiValue` value used by the selection capability.
pub type SelectionMultiValue

/// Returns the selected item.
pub fn selection(
  sel sel: SelectionSingleValue,
) -> option.Option(mendix.ObjectItem) {
  selection_raw(sel)
}

/// Sets the selection.
pub fn set_selection(
  sel sel: SelectionSingleValue,
  item item: option.Option(mendix.ObjectItem),
) -> Nil {
  set_selection_raw(sel, item)
}

/// Returns all selected items.
pub fn selections(sel sel: SelectionMultiValue) -> List(mendix.ObjectItem) {
  selections_raw(sel)
}

/// Sets the selections.
pub fn set_selections(
  sel sel: SelectionMultiValue,
  items items: List(mendix.ObjectItem),
) -> Nil {
  set_selections_raw(sel, items)
}

// -- FFI --
@external(javascript, "../mendix_ffi.mjs", "get_selection_single")
fn selection_raw(
  sel sel: SelectionSingleValue,
) -> option.Option(mendix.ObjectItem)

@external(javascript, "../mendix_ffi.mjs", "set_selection_single")
fn set_selection_raw(
  sel sel: SelectionSingleValue,
  item item: option.Option(mendix.ObjectItem),
) -> Nil

@external(javascript, "../mendix_ffi.mjs", "get_selection_multi")
fn selections_raw(sel sel: SelectionMultiValue) -> List(mendix.ObjectItem)

@external(javascript, "../mendix_ffi.mjs", "set_selection_multi")
fn set_selections_raw(
  sel sel: SelectionMultiValue,
  items items: List(mendix.ObjectItem),
) -> Nil
