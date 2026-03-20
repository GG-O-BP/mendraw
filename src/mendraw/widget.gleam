//// .mpk 위젯 컴포넌트 바인딩
//// build/widgets/ 캐시의 Mendix 위젯을 React 컴포넌트로 사용한다.
//// gleam run -m mendraw/install 실행 시 바인딩이 자동 생성된다.
////
//// ```gleam
//// import mendraw/widget
//// import mendraw/interop
////
//// let comp = widget.component("Switch")
//// interop.component_el(comp, [
////   widget.prop("caption", "제목"),
////   widget.editable_prop("textAttr", value, display, set_value),
////   widget.action_prop("onClick", handler),
//// ], [])
//// ```

import mendraw/interop.{type JsComponent}
import redraw/dom/attribute.{type Attribute}

/// .mpk 위젯의 React 컴포넌트를 가져온다
@external(javascript, "./widget_ffi.mjs", "get_widget")
pub fn component(name: String) -> JsComponent

@external(javascript, "./widget_prop_ffi.mjs", "dynamic_value")
fn to_mendix_dynamic(value: a) -> a

@external(javascript, "./widget_prop_ffi.mjs", "editable_value")
fn to_mendix_editable(
  value: a,
  display_value: String,
  set_value: fn(a) -> Nil,
) -> a

@external(javascript, "./widget_prop_ffi.mjs", "action_value")
fn to_mendix_action(handler: fn() -> Nil) -> a

/// 값을 DynamicValue로 감싸서 위젯 prop으로 전달한다
/// 읽기 전용 속성 (expression, textTemplate 등)
pub fn prop(key: String, value: a) -> Attribute {
  attribute.attribute(key, to_mendix_dynamic(value))
}

/// 값을 EditableValue로 감싸서 위젯 prop으로 전달한다
/// 편집 가능한 속성에 사용
pub fn editable_prop(
  key: String,
  value: a,
  display_value: String,
  set_value: fn(a) -> Nil,
) -> Attribute {
  attribute.attribute(key, to_mendix_editable(value, display_value, set_value))
}

/// ActionValue를 만들어 위젯 prop으로 전달한다
/// 액션 속성 (onClick 등)
pub fn action_prop(key: String, handler: fn() -> Nil) -> Attribute {
  attribute.attribute(key, to_mendix_action(handler))
}
