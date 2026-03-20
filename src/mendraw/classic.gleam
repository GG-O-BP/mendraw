//// Classic (Dojo 기반) Mendix 위젯을 React 내부에서 사용한다.
//// build/widgets/ 캐시의 Classic .mpk 위젯을 DOM 컨테이너에 임페러티브하게 마운트한다.
//// gleam run -m mendraw/install 실행 시 바인딩이 자동 생성된다.
////
//// ```gleam
//// import mendraw/classic
////
//// classic.render("CameraWidget.widget.CameraWidget", [
////   #("mfToExecute", classic.to_dynamic(mf_value)),
////   #("preferRearCamera", classic.to_dynamic(true)),
//// ])
//// ```

import gleam/dynamic.{type Dynamic}
import redraw.{type Element}

/// 임의의 값을 Dynamic으로 변환한다 (JS 타겟에서는 identity)
@external(javascript, "./classic_ffi.mjs", "to_dynamic")
pub fn to_dynamic(value: a) -> Dynamic

/// Classic 위젯을 React 엘리먼트로 렌더링하는 편의 함수
/// DOM 컨테이너를 자동 생성하고, useEffect로 마운트/언마운트를 관리한다
@external(javascript, "./classic_ffi.mjs", "classic_widget_element")
pub fn render(
  widget_id: String,
  properties: List(#(String, Dynamic)),
) -> Element

/// CSS 클래스를 지정하여 렌더링
@external(javascript, "./classic_ffi.mjs", "classic_widget_element_with_class")
pub fn render_with_class(
  widget_id: String,
  properties: List(#(String, Dynamic)),
  class_name: String,
) -> Element
