import { Error as GleamError } from "../gleam.mjs";

export function get_widget(name) {
  return new GleamError(
    `위젯 바인딩이 생성되지 않았습니다. 'gleam run -m mendraw/install'을 실행하세요. (요청 위젯: ${name})`,
  );
}

export function widget_error_message(error) {
  return error instanceof globalThis.Error ? error.message : String(error);
}
