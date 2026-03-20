// 스텁 — gleam run -m mendraw/install 시 자동 교체됨
// 직접 수정 금지

export function classic_widget_element(widget_id, properties) {
  throw new Error(
    `Classic 위젯 바인딩이 생성되지 않았습니다. 'gleam run -m mendraw/install'을 실행하세요. (요청 위젯: ${widget_id})`,
  );
}

export function classic_widget_element_with_class(widget_id, properties, class_name) {
  throw new Error(
    `Classic 위젯 바인딩이 생성되지 않았습니다. 'gleam run -m mendraw/install'을 실행하세요. (요청 위젯: ${widget_id})`,
  );
}

export function to_dynamic(value) {
  return value;
}
