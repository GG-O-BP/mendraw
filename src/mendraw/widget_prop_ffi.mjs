// 위젯 prop 래핑 — Mendix 값 객체 생성 FFI

export function dynamic_value(value) {
  return { status: "available", value };
}

export function editable_value(value, displayValue, setValue) {
  return {
    status: "available",
    value,
    displayValue,
    readOnly: false,
    validation: undefined,
    setValue,
    setValidator: () => {},
  };
}

export function action_value(handler) {
  return {
    canExecute: true,
    isExecuting: false,
    execute: handler,
  };
}
