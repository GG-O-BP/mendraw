// 외부 JS React 컴포넌트를 redraw Element로 렌더링하는 브릿지

import redraw.{type Element}
import redraw/dom/attribute.{type Attribute}

/// 외부 JS React 컴포넌트 참조
pub type JsComponent

/// 속성 + 자식을 가진 컴포넌트 렌더링
@external(javascript, "./interop_ffi.mjs", "component_el")
pub fn component_el(
  comp: JsComponent,
  attrs: List(Attribute),
  children: List(Element),
) -> Element

/// 속성 없이 자식만으로 컴포넌트 렌더링
@external(javascript, "./interop_ffi.mjs", "component_el_")
pub fn component_el_(comp: JsComponent, children: List(Element)) -> Element

/// self-closing 컴포넌트 (children 없음)
@external(javascript, "./interop_ffi.mjs", "void_component_el")
pub fn void_component_el(comp: JsComponent, attrs: List(Attribute)) -> Element
