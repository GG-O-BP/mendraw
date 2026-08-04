//// Tests mendraw behavior for Mendraw.
////

import gleeunit
import gleeunit/should
import mendraw/classic
import mendraw/mendix
import mendraw/mendix/list_value
import mendraw/synthetic
import mendraw/widget

/// Runs this module's test suite.
pub fn main() -> Nil {
  gleeunit.main()
}

/// Verifies cx empty behavior.
pub fn cx_empty_test() -> Nil {
  mendix.cx([])
  |> should.equal("")
}

/// Verifies cx all true behavior.
pub fn cx_all_true_test() -> Nil {
  mendix.cx([#("foo", True), #("bar", True)])
  |> should.equal("foo bar")
}

/// Verifies cx mixed behavior.
pub fn cx_mixed_test() -> Nil {
  mendix.cx([#("active", True), #("hidden", False), #("bold", True)])
  |> should.equal("active bold")
}

/// Verifies cx all false behavior.
pub fn cx_all_false_test() -> Nil {
  mendix.cx([#("a", False), #("b", False)])
  |> should.equal("")
}

/// Verifies cx single true behavior.
pub fn cx_single_true_test() -> Nil {
  mendix.cx([#("only", True)])
  |> should.equal("only")
}

/// Verifies to value status available behavior.
pub fn to_value_status_available_test() -> Nil {
  mendix.to_value_status("available")
  |> should.equal(mendix.Available)
}

/// Verifies to value status loading behavior.
pub fn to_value_status_loading_test() -> Nil {
  mendix.to_value_status("loading")
  |> should.equal(mendix.Loading)
}

/// Verifies to value status unavailable behavior.
pub fn to_value_status_unavailable_test() -> Nil {
  mendix.to_value_status("unavailable")
  |> should.equal(mendix.Unavailable)
}

/// Verifies to value status unknown behavior.
pub fn to_value_status_unknown_test() -> Nil {
  mendix.to_value_status("something_else")
  |> should.equal(mendix.Unavailable)
}

/// Verifies synthetic object handles satisfy the Mendix object identifier contract.
pub fn synthetic_object_item_contract_test() -> Nil {
  let item = synthetic.object_item("contract-item")
  mendix.object_id(item)
  |> should.equal("contract-item")
}

/// Verifies synthetic list values report the available state.
pub fn synthetic_list_value_contract_test() -> Nil {
  [synthetic.object_item("one")]
  |> synthetic.list_value
  |> list_value.is_available
  |> should.be_true
}

/// Verifies a missing generated widget binding returns its lookup context.
pub fn widget_missing_component_contract_test() -> Nil {
  case widget.component("missing-widget") {
    Error(widget.ComponentWasNotFound(name, reason)) -> {
      name
      |> should.equal("missing-widget")
      reason
      |> should.not_equal("")
    }
    Ok(_) -> should.fail()
  }
}

/// Verifies a missing generated classic binding returns its widget identifier.
pub fn classic_missing_widget_contract_test() -> Nil {
  case classic.render("Missing.widget.Missing", []) {
    Error(classic.ClassicWidgetWasNotFound(widget_id, reason)) -> {
      widget_id
      |> should.equal("Missing.widget.Missing")
      reason
      |> should.not_equal("")
    }
    Ok(_) -> should.fail()
  }
}
