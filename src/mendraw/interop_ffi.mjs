import { createElement } from "react";
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
