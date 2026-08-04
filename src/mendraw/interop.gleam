//// Adapts typed JavaScript components to Redraw elements.
////

import redraw
import redraw/dom/attribute

/// A typed `JsComponent` value used by the interop capability.
pub type JsComponent

/// Creates a component element with attributes and children.
pub fn component_el(
  comp comp: JsComponent,
  attrs attrs: List(attribute.Attribute),
  children children: List(redraw.Element),
) -> redraw.Element {
  component_el_raw(comp, attrs, children)
}

/// Creates a component element with children.
pub fn component_el_(
  comp comp: JsComponent,
  children children: List(redraw.Element),
) -> redraw.Element {
  component_el__raw(comp, children)
}

/// Creates a component element without children.
pub fn void_component_el(
  comp comp: JsComponent,
  attrs attrs: List(attribute.Attribute),
) -> redraw.Element {
  void_component_el_raw(comp, attrs)
}

// -- FFI --
@external(javascript, "./interop_ffi.mjs", "component_el")
fn component_el_raw(
  comp comp: JsComponent,
  attrs attrs: List(attribute.Attribute),
  children children: List(redraw.Element),
) -> redraw.Element

@external(javascript, "./interop_ffi.mjs", "component_el_")
fn component_el__raw(
  comp comp: JsComponent,
  children children: List(redraw.Element),
) -> redraw.Element

@external(javascript, "./interop_ffi.mjs", "void_component_el")
fn void_component_el_raw(
  comp comp: JsComponent,
  attrs attrs: List(attribute.Attribute),
) -> redraw.Element
