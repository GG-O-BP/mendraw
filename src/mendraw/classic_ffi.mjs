import { Error as GleamError } from "../gleam.mjs";

export function classic_widget_element(widget_id, properties) {
  return new GleamError(
    `Classic 위젯 바인딩이 생성되지 않았습니다. 'gleam run -m mendraw/install'을 실행하세요. (요청 위젯: ${widget_id})`,
  );
}
export function classic_widget_element_with_class(widget_id, properties, class_name) {
  return new GleamError(
    `Classic 위젯 바인딩이 생성되지 않았습니다. 'gleam run -m mendraw/install'을 실행하세요. (요청 위젯: ${widget_id})`,
  );
}
export function to_dynamic(value) {
  return value;
}

export function classic_error_message(error) {
  return error instanceof globalThis.Error ? error.message : String(error);
}
