// 외부 JS React 컴포넌트 → redraw Element 변환 FFI
import { createElement } from "react";

// redraw_dom Attribute({key, content}) 리스트 → React props 객체
// className 자동 병합, none_ 무시
function to_props(attributes) {
  const props = {};
  const classNames = [];
  for (const attr of attributes.toArray()) {
    if (attr.key === "none_") continue;
    if (attr.key === "className") {
      classNames.push(attr.content);
    } else {
      props[attr.key] = attr.content;
    }
  }
  if (classNames.length > 0) props.className = classNames.join(" ");
  return props;
}

export function component_el(comp, attrs, children) {
  return createElement(comp, to_props(attrs), ...children.toArray());
}

export function component_el_(comp, children) {
  return createElement(comp, null, ...children.toArray());
}

export function void_component_el(comp, attrs) {
  return createElement(comp, to_props(attrs));
}
