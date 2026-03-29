# mendraw

Mendix widget `.mpk` file bindings for Gleam, compatible with [redraw](https://hexdocs.pm/redraw/).

`.mpk` 파일을 파싱하여 Gleam/redraw 프로젝트에서 바로 사용할 수 있는 위젯 바인딩을 자동 생성한다.
Pluggable(React) 위젯과 Classic(Dojo) 위젯 모두 지원한다.

## 설치

```sh
gleam add mendraw@1
```

## 사용법

### 1. 위젯 등록

`gleam.toml`로 자동 다운로드:

```toml
[tools.mendraw.widgets.Charts]
version = "3.0.0"
# s3_id = "com/..."   ← 있으면 인증 없이 직접 다운로드
```

### 2. 바인딩 생성

```sh
gleam run -m mendraw/install
```

TOML 위젯 다운로드 + `src/widgets/`에 위젯별 `.gleam` 파일 생성 + 빌드 경로에 `widget_ffi.mjs`(컴포넌트 레지스트리) 생성.

```
src/widgets/
  area_chart.gleam
  bar_chart.gleam
  switch.gleam
  ...
```

### 3. 위젯 사용

#### Pluggable 위젯

생성된 바인딩 파일을 import하여 `render(props)`를 호출하거나,
`mendraw/widget` + `mendraw/interop`로 직접 조립할 수 있다.

```gleam
import mendraw/widget
import mendraw/interop
import mendraw/mendix.{type JsProps}
import redraw.{type Element}

pub fn my_component(props: JsProps) -> Element {
  let value = mendix.get_prop_required(props, "textAttr")
  let comp = widget.component("Switch")
  interop.component_el(comp, [
    widget.prop("caption", "제목"),
    widget.editable_prop("textAttr", value, "표시값", set_value),
    widget.action_prop("onClick", handler),
  ], [])
}
```

#### Classic (Dojo) 위젯

```gleam
import mendraw/classic

classic.render("CameraWidget.widget.CameraWidget", [
  #("mfToExecute", classic.to_dynamic(mf_value)),
  #("preferRearCamera", classic.to_dynamic(True)),
])
```

### 4. Mendix 타입 활용

생성된 바인딩에서 받는 Mendix 값들을 `mendraw/mendix/*` 모듈로 다룬다.

```gleam
import mendraw/mendix
import mendraw/mendix/editable_value.{type EditableValue}
import mendraw/mendix/action

// EditableValue 읽기/쓰기
let display = editable_value.display_value(text_attr)
let is_editable = editable_value.is_editable(text_attr)
editable_value.set_text_value(text_attr, "새 값")

// Option(ActionValue) 실행
action.execute_action(on_click)

// CSS 클래스 조건부 조합
let class = mendix.cx([
  #("active", is_selected),
  #("disabled", !is_editable),
])
```

데이터 소스와 필터:

```gleam
import mendraw/mendix/list_value
import mendraw/mendix/list_attribute
import mendraw/mendix/filter

// ListValue 페이지네이션
list_value.set_offset(data_source, 20)
list_value.set_limit(data_source, 10)

// 필터 조건 구성
let cond = filter.and_([
  filter.contains(filter.attribute("Name"), filter.literal("검색어")),
  filter.greater_than(filter.attribute("Age"), filter.literal(18)),
])
list_value.set_filter(data_source, option.Some(cond))
```

### 6. 외부 API 데이터를 Mendix 위젯에 전달 (Synthetic Data)

Mendix 런타임 없이도 외부 API 데이터를 Mendix 차트/그리드 위젯에 직접 전달할 수 있다.
`mendraw/synthetic` 모듈이 Mendix `ListValue`, `ObjectItem`, `ListAttributeValue` 인터페이스를 모사하는 객체를 생성한다.

```gleam
import mendraw/synthetic
import mendraw/interop
import mendraw/widget
import redraw/dom/attribute
import gleam/float

// 1. 데이터 준비
let prices = [100.0, 105.5, 98.3, 110.2]
let items = synthetic.object_items(4)

// 2. Mendix 호환 객체 생성
let lv = synthetic.list_value(items)
let x_attr = synthetic.list_attribute(items, [1.0, 2.0, 3.0, 4.0], float.to_string, "Decimal")
let y_attr = synthetic.list_attribute(items, prices, float.to_string, "Decimal")

// 3. 차트 시리즈 구성
let series = synthetic.chart_series_static(
  lv, x_attr, y_attr,
  synthetic.text_template("Price"),
  "none", "linear", "line", "", "",
)

// 4. Mendix Line chart 위젯에 전달
let comp = widget.component("Line chart")
interop.component_el(comp, [
  attribute.attribute("lines", synthetic.to_js_array([series])),
  attribute.attribute("showLegend", True),
], [])
```

### 5. Marketplace에서 위젯 다운로드

Mendix Marketplace에서 위젯을 검색하고 다운로드할 수 있는 TUI를 제공한다.

```sh
gleam run -m mendraw/marketplace
```

`.env` 파일에 Mendix Personal Access Token이 필요하다.

```
MENDIX_PAT=your_personal_access_token
```

PAT는 Mendix Portal → Settings → Personal Access Tokens에서 발급한다 (scope: `mx:marketplace-content:read`).

다운로드한 위젯은 `build/widgets/`에 캐시되고 `gleam.toml`에 자동 추가된다. 완료 후 자동으로 바인딩이 생성된다.

> **참고**: 첫 실행 시 chrobot_extra 기반 사이드카가 자동 설정된다. Erlang/OTP가 설치되어 있어야 한다 (Gleam 개발 환경에서는 이미 설치되어 있음).

## 모듈 구조

### 코어

| 모듈 | 설명 |
|---|---|
| `mendraw/install` | 진입점 — `gleam run -m mendraw/install` |
| `mendraw/cmd` | `generate_widget_bindings`, `resolve_toml_widgets`, `download_to_cache`, `write_widget_toml`, `file_exists` API |
| `mendraw/mendix` | `JsProps`, `ValueStatus`, `ObjectItem`, prop 접근자, Option 변환, `cx` CSS 유틸리티 |
| `mendraw/interop` | `JsComponent` → redraw `Element` 브릿지 (`component_el`, `component_el_`, `void_component_el`) |
| `mendraw/widget` | 위젯 컴포넌트 조회 + prop 래핑 (`prop`, `editable_prop`, `action_prop`) |
| `mendraw/classic` | Classic(Dojo) 위젯 React 래퍼 (`render`, `render_with_class`) |
| `mendraw/synthetic` | 외부 API 데이터 → Mendix 위젯 호환 객체 생성 (`list_value`, `list_attribute`, `chart_series_static` 등) |

### Mendix 타입 (`mendraw/mendix/*`)

Mendix Pluggable Widget API의 타입을 Gleam opaque type으로 래핑한다.

| 모듈 | 타입 | 설명 |
|---|---|---|
| `mendraw/mendix/action` | `ActionValue` | 실행 가능한 액션 (마이크로플로우, 나노플로우) |
| `mendraw/mendix/dynamic_value` | `DynamicValue` | 읽기 전용 동적 값 (expression 속성) |
| `mendraw/mendix/editable_value` | `EditableValue` | 편집 가능한 값 (텍스트, 숫자, 날짜 등) |
| `mendraw/mendix/list_value` | `ListValue` | 데이터 소스 객체 목록 (페이지네이션, 정렬, 필터) |
| `mendraw/mendix/list_attribute` | `ListAttributeValue`, `ListActionValue`, `ListExpressionValue`, `ListWidgetValue` | ListValue 아이템별 접근자 |
| `mendraw/mendix/filter` | `FilterCondition`, `ValueExpression` | 필터 조건 빌더 (and/or/not, 비교, 문자열 검색, 날짜 비교) |
| `mendraw/mendix/reference` | `ReferenceValue` | 단일 연관 관계 |
| `mendraw/mendix/reference_set` | `ReferenceSetValue` | 다중 연관 관계 |
| `mendraw/mendix/selection` | `SelectionSingleValue`, `SelectionMultiValue` | 단일/다중 선택 |
| `mendraw/mendix/formatter` | `ValueFormatter` | 값 포맷팅/파싱 |
| `mendraw/mendix/decimal` | `Decimal` | Big.js 래퍼 (경계 변환 전용) |
| `mendraw/mendix/date` | `JsDate` | JS Date 래퍼 (생성, 변환, 접근자) |
| `mendraw/mendix/icon` | `WebIcon` | 아이콘 (Glyph, Image, IconFont) |
| `mendraw/mendix/file` | `FileValue`, `WebImage` | 파일 및 이미지 속성 |

### Marketplace

| 모듈 | 설명 |
|---|---|
| `mendraw/marketplace` | Mendix Marketplace 위젯 검색·다운로드 TUI (TTY + 프롬프트 폴백) |
| `mendraw/marketplace/ui` | Marketplace TUI 스타일링 출력 함수 |

### 사이드카 (`sidecar/`)

Mendix 로그인 및 버전 정보 추출에 필요한 브라우저 자동화를 담당하는 Erlang 타겟 HTTP 서버. mendraw(JS 타겟)와 HTTP로 통신한다.

| 모듈 | 설명 |
|---|---|
| `mendraw_sidecar` | 진입점 — CLI 포트, mist HTTP 서버 |
| `mendraw_sidecar/router` | HTTP 라우팅 (`/health`, `/shutdown`, `/session/ensure`, `/versions/*`) |
| `mendraw_sidecar/session_handler` | Mendix 세션 검증·인터랙티브 로그인 |
| `mendraw_sidecar/version_handler` | XAS 응답 기반 버전 정보 수집 |
| `mendraw_sidecar/xas_parser` | XAS JSON → `AppStore.Version` 파싱 |

## 의존성

### mendraw (JS 타겟)

- [gleam_stdlib](https://hexdocs.pm/gleam_stdlib/) — 표준 라이브러리
- [gleam_javascript](https://hexdocs.pm/gleam_javascript/) — JS 타겟 유틸리티
- [redraw](https://hexdocs.pm/redraw/) — React 바인딩 (위젯 렌더링)
- [redraw_dom](https://hexdocs.pm/redraw_dom/) — DOM 속성/이벤트
- [etch](https://hexdocs.pm/etch/) — 터미널 TUI (Marketplace CLI)

### 사이드카 (Erlang 타겟)

- [chrobot_extra](https://hexdocs.pm/chrobot_extra/) — Chrome DevTools Protocol 브라우저 자동화
- [mist](https://hexdocs.pm/mist/) — HTTP 서버
- [gleam_json](https://hexdocs.pm/gleam_json/) — JSON 인코딩/디코딩

## 라이선스

이 프로젝트는 [Blue Oak Model License 1.0.0](https://blueoakcouncil.org/license/1.0.0) 하에 배포된다.

## glendix 연동

glendix 프로젝트에서 mendraw를 의존성으로 추가하면 MPK 처리를 위임할 수 있다.

```gleam
// glendix/install.gleam
import mendraw/cmd as mendraw_cmd

pub fn main() {
  cmd.exec(cmd.detect_install_command())
  cmd.generate_bindings()
  mendraw_cmd.generate_widget_bindings()
}
```
