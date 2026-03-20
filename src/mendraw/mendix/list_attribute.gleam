// Mendix List-linked 타입 — ListValue의 아이템별 접근자
// ListAttributeValue, ListActionValue, ListExpressionValue, ListWidgetValue

import gleam/option.{type Option}
import mendraw/mendix.{type ObjectItem}
import mendraw/mendix/formatter.{type ValueFormatter}
import redraw.{type Element}

// === 타입 ===

pub type ListAttributeValue

pub type ListActionValue

pub type ListExpressionValue

pub type ListWidgetValue

// === 아이템별 값 접근 (공용 FFI: list_type_get) ===

/// 특정 아이템의 속성 값 가져오기 (EditableValue 반환)
@external(javascript, "../mendix_ffi.mjs", "list_type_get")
pub fn get_attribute(attr: ListAttributeValue, item: ObjectItem) -> a

/// 특정 아이템의 액션 가져오기 (Option(ActionValue) 반환)
@external(javascript, "../mendix_ffi.mjs", "list_type_get")
pub fn get_action(action: ListActionValue, item: ObjectItem) -> Option(a)

/// 특정 아이템의 표현식 값 가져오기 (DynamicValue 반환)
@external(javascript, "../mendix_ffi.mjs", "list_type_get")
pub fn get_expression(expr: ListExpressionValue, item: ObjectItem) -> a

/// 특정 아이템의 위젯 렌더링 가져오기 (Element 반환)
@external(javascript, "../mendix_ffi.mjs", "list_type_get")
pub fn get_widget(widget: ListWidgetValue, item: ObjectItem) -> Element

// === ListAttributeValue 메타데이터 ===

/// 속성 ID
@external(javascript, "../mendix_ffi.mjs", "get_list_attr_id")
pub fn attr_id(attr: ListAttributeValue) -> String

/// 정렬 가능 여부
@external(javascript, "../mendix_ffi.mjs", "get_list_attr_sortable")
pub fn attr_sortable(attr: ListAttributeValue) -> Bool

/// 필터링 가능 여부
@external(javascript, "../mendix_ffi.mjs", "get_list_attr_filterable")
pub fn attr_filterable(attr: ListAttributeValue) -> Bool

/// 속성 타입 문자열 ("String", "Integer", "DateTime" 등)
@external(javascript, "../mendix_ffi.mjs", "get_list_attr_type")
pub fn attr_type(attr: ListAttributeValue) -> String

/// 속성 포매터
@external(javascript, "../mendix_ffi.mjs", "get_list_attr_formatter")
pub fn attr_formatter(attr: ListAttributeValue) -> ValueFormatter
