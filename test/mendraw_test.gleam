import gleeunit
import mendraw/mendix

pub fn main() -> Nil {
  gleeunit.main()
}

// cx() — 조건부 클래스 조합
pub fn cx_empty_test() {
  assert mendix.cx([]) == ""
}

pub fn cx_all_true_test() {
  assert mendix.cx([#("foo", True), #("bar", True)]) == "foo bar"
}

pub fn cx_mixed_test() {
  assert mendix.cx([#("active", True), #("hidden", False), #("bold", True)])
    == "active bold"
}

pub fn cx_all_false_test() {
  assert mendix.cx([#("a", False), #("b", False)]) == ""
}

pub fn cx_single_true_test() {
  assert mendix.cx([#("only", True)]) == "only"
}

// to_value_status() — 문자열 → ValueStatus 변환
pub fn to_value_status_available_test() {
  assert mendix.to_value_status("available") == mendix.Available
}

pub fn to_value_status_loading_test() {
  assert mendix.to_value_status("loading") == mendix.Loading
}

pub fn to_value_status_unavailable_test() {
  assert mendix.to_value_status("unavailable") == mendix.Unavailable
}

pub fn to_value_status_unknown_test() {
  assert mendix.to_value_status("something_else") == mendix.Unavailable
}
