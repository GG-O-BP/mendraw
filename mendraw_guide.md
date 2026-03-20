# mendraw 사용 가이드

Mendix 위젯 `.mpk` 파일에서 Gleam/[redraw](https://hexdocs.pm/redraw/) 바인딩을 자동 생성하는 라이브러리.
Pluggable(React) 위젯과 Classic(Dojo) 위젯을 모두 지원한다.

---

## 목차

- [사전 준비](#사전-준비)
- [설치](#설치)
- [빠른 시작](#빠른-시작)
- [Marketplace에서 위젯 다운로드](#marketplace에서-위젯-다운로드)
- [생성된 바인딩 사용하기](#생성된-바인딩-사용하기)
  - [Pluggable 위젯](#pluggable-위젯)
  - [Classic (Dojo) 위젯](#classic-dojo-위젯)
- [저수준 API로 직접 조립하기](#저수준-api로-직접-조립하기)
  - [위젯 컴포넌트 조회](#위젯-컴포넌트-조회)
  - [Prop 래핑](#prop-래핑)
  - [컴포넌트 렌더링](#컴포넌트-렌더링)
- [JsProps 다루기](#jsprops-다루기)
  - [Prop 접근자](#prop-접근자)
  - [ValueStatus](#valuestatus)
  - [Option 변환](#option-변환)
- [생성된 코드 구조](#생성된-코드-구조)
  - [Pluggable 위젯 바인딩 예시](#pluggable-위젯-바인딩-예시)
  - [Classic 위젯 바인딩 예시](#classic-위젯-바인딩-예시)
  - [파일명 변환 규칙](#파일명-변환-규칙)
- [생성된 바인딩 커스터마이징](#생성된-바인딩-커스터마이징)
- [API 레퍼런스](#api-레퍼런스)
  - [mendraw/mendix](#mendrawmendix)
  - [mendraw/widget](#mendrawwidget)
  - [mendraw/interop](#mendrawinterop)
  - [mendraw/classic](#mendrawclassic)
  - [mendraw/marketplace](#mendrawmarketplace)
- [glendix 프로젝트에서 사용하기](#glendix-프로젝트에서-사용하기)
- [문제 해결](#문제-해결)

---

## 사전 준비

- [Gleam](https://gleam.run/) v1.15 이상
- [Erlang/OTP](https://www.erlang.org/) 28 이상
- Gleam 프로젝트의 타겟이 `javascript`여야 한다 (`gleam.toml`의 `target = "javascript"`)
- [redraw](https://hexdocs.pm/redraw/) 기반 UI 프로젝트

---

## 설치

```sh
gleam add mendraw@1
```

`gleam.toml`에 다음 의존성이 추가된다:

```toml
[dependencies]
mendraw = ">= 1.0.0 and < 2.0.0"
```

mendraw는 `gleam_stdlib`, `gleam_javascript`, `redraw`, `redraw_dom`을 함께 가져온다.
이미 프로젝트에 이들이 있다면 버전 호환성만 확인하면 된다.

---

## 빠른 시작

### 1단계: 위젯 등록

**`gleam.toml`로 자동 다운로드**

```toml
[tools.mendraw.widgets.Charts]
version = "3.0.0"
# s3_id = "com/..."   ← 있으면 인증 없이 직접 다운로드
```

`gleam run -m mendraw/install` 실행 시 `build/widgets/`에 캐시하고 바인딩을 자동 생성한다.
Marketplace TUI(`gleam run -m mendraw/marketplace`)에서 다운로드하면 gleam.toml에 자동 추가된다.

### 2단계: 바인딩 생성

```sh
gleam run -m mendraw/install
```

실행 결과:

- TOML에 등록된 위젯을 `build/widgets/`에 다운로드/캐시
- `src/widgets/`에 위젯별 `.gleam` 바인딩 파일이 생성된다
- 빌드 경로에 `widget_ffi.mjs`(컴포넌트 레지스트리)가 생성된다
- Classic 위젯이 있으면 `classic_ffi.mjs`(런타임)도 생성된다

```
src/widgets/
├── switch.gleam           ← Pluggable 위젯
├── area_chart.gleam       ← Charts.mpk에서 추출
├── bar_chart.gleam
└── camera_widget.gleam    ← Classic 위젯
```

### 3단계: 바인딩 사용

```gleam
import widgets/switch
import mendraw/mendix.{type JsProps}
import redraw.{type Element}

pub fn my_view(props: JsProps) -> Element {
  switch.render(props)
}
```

이것으로 끝이다. 아래에서 각 단계를 자세히 설명한다.

---

## Marketplace에서 위젯 다운로드

`.mpk` 파일을 직접 구하는 대신, Mendix Marketplace에서 위젯을 검색하고 다운로드할 수 있는 TUI를 제공한다.

### 사전 설정

`.env` 파일에 Mendix Personal Access Token을 설정한다:

```
MENDIX_PAT=your_personal_access_token
```

PAT는 Mendix Portal → Settings → Personal Access Tokens에서 발급한다.
필요한 scope: `mx:marketplace-content:read`

### 실행

```sh
gleam run -m mendraw/marketplace
```

### TUI 모드 (터미널)

터미널에서 실행하면 인터랙티브 TUI가 표시된다:

| 키 | 동작 |
|---|---|
| `↑` `↓` | 위젯 목록 이동 |
| `←` `→` | 페이지 이동 |
| `Space` | 위젯 선택/해제 (복수 선택) |
| `Enter` | 선택한 위젯 다운로드 → 버전 선택 화면 |
| `Esc` | 검색/선택 초기화 |
| 문자 입력 | 이름/퍼블리셔 검색 |
| `q` | 종료 |

버전 선택 화면에서:

| 키 | 동작 |
|---|---|
| `↑` `↓` | 버전 이동 |
| `Enter` | 선택한 버전 다운로드 |
| `Esc` | 목록으로 돌아가기 |

### 프롬프트 모드 (비-TTY)

파이프 등 비-TTY 환경에서는 텍스트 프롬프트 모드로 동작한다:

```
> 0        ← 0번 위젯 다운로드
> 0,3,5    ← 여러 위젯 동시 선택
> switch   ← "switch" 검색
> n        ← 다음 페이지
> p        ← 이전 페이지
> r        ← 검색 초기화
> q        ← 종료
```

### 다운로드 후

다운로드한 위젯은 `build/widgets/`에 캐시되고 `gleam.toml`의 `[tools.mendraw.widgets.*]`에 자동 추가된다.
다운로드가 1개 이상 완료되면 자동으로 `cmd.generate_widget_bindings()`가 실행되어 바인딩이 생성된다.

> **참고**: 첫 다운로드 시 Playwright 브라우저를 통한 Mendix 로그인이 필요할 수 있다.
> 로그인 세션은 `.marketplace-cache/session.json`에 캐시된다.

---

## 생성된 바인딩 사용하기

`gleam run -m mendraw/install`이 생성하는 `.gleam` 파일에는 `render` 함수가 포함된다.
이 함수는 Mendix가 전달하는 `JsProps`를 받아 `redraw` `Element`를 반환한다.

### Pluggable 위젯

Pluggable 위젯(React 기반)의 생성된 바인딩:

```gleam
import widgets/switch
import mendraw/mendix.{type JsProps}
import redraw.{type Element}

/// Mendix가 위젯에 전달하는 props를 그대로 넘긴다
pub fn view(props: JsProps) -> Element {
  switch.render(props)
}
```

생성된 `render` 함수는 내부적으로:
1. `mendix.get_prop_required`/`mendix.get_prop`으로 props에서 속성을 추출
2. `widget.component`로 원본 React 컴포넌트를 가져옴
3. `interop.component_el`로 redraw Element를 생성

### Classic (Dojo) 위젯

Classic 위젯(Dojo 기반)의 생성된 바인딩:

```gleam
import widgets/camera_widget
import mendraw/mendix.{type JsProps}
import redraw.{type Element}

pub fn view(props: JsProps) -> Element {
  camera_widget.render(props)
}
```

Classic 위젯은 내부적으로 DOM 컨테이너를 생성하고, `useEffect`로 위젯의 마운트/언마운트를 관리한다.

---

## 저수준 API로 직접 조립하기

생성된 바인딩 대신, `mendraw/widget`과 `mendraw/interop` 모듈을 직접 사용하여
위젯 렌더링을 세밀하게 제어할 수 있다.

### 위젯 컴포넌트 조회

```gleam
import mendraw/widget

// 위젯 이름으로 React 컴포넌트를 가져온다
let comp = widget.component("Switch")
```

위젯 이름은 `.mpk` 파일의 `widget.xml`에 정의된 `<name>` 값이다.

### Prop 래핑

Mendix 위젯은 일반 값이 아닌 래핑된 값 객체를 기대한다.
mendraw는 세 가지 prop 래퍼를 제공한다:

```gleam
import mendraw/widget

// 1. 읽기 전용 prop (DynamicValue)
// expression, textTemplate 등 읽기 전용 속성에 사용
widget.prop("caption", "제목 텍스트")

// 2. 편집 가능한 prop (EditableValue)
// 사용자 입력이 필요한 속성에 사용
widget.editable_prop("textAttr", current_value, "표시값", fn(new_val) {
  // 값이 변경되었을 때의 처리
  Nil
})

// 3. 액션 prop (ActionValue)
// onClick, onLeave 등 이벤트 핸들러에 사용
widget.action_prop("onClick", fn() {
  // 클릭 시 처리
  Nil
})
```

각 래퍼가 생성하는 Mendix 값 객체:

| 래퍼 | Mendix 타입 | 구조 |
|------|------------|------|
| `prop` | `DynamicValue` | `{ status: "available", value }` |
| `editable_prop` | `EditableValue` | `{ status: "available", value, displayValue, readOnly: false, setValue, ... }` |
| `action_prop` | `ActionValue` | `{ canExecute: true, isExecuting: false, execute }` |

### 컴포넌트 렌더링

```gleam
import mendraw/interop
import mendraw/widget
import redraw/dom/attribute

let comp = widget.component("Switch")

// 속성 + 자식 엘리먼트
interop.component_el(comp, [
  widget.prop("caption", "제목"),
  widget.editable_prop("textAttr", value, "표시값", set_value),
  widget.action_prop("onClick", handler),
], [])

// 속성 없이 자식만
interop.component_el_(comp, [child1, child2])

// 자식 없는 self-closing 컴포넌트
interop.void_component_el(comp, [
  widget.prop("caption", "읽기 전용"),
])
```

### Classic 위젯 직접 렌더링

```gleam
import mendraw/classic

// 기본 렌더링
classic.render("CameraWidget.widget.CameraWidget", [
  #("mfToExecute", classic.to_dynamic(mf_value)),
  #("preferRearCamera", classic.to_dynamic(True)),
])

// CSS 클래스 지정
classic.render_with_class(
  "CameraWidget.widget.CameraWidget",
  [#("mfToExecute", classic.to_dynamic(mf_value))],
  "my-camera-wrapper",
)
```

`widget_id`는 Classic 위젯의 정규화된 ID이다 (예: `"CameraWidget.widget.CameraWidget"`).

---

## JsProps 다루기

Mendix 런타임이 위젯에 전달하는 props 객체를 `JsProps` 타입으로 다룬다.

### Prop 접근자

```gleam
import mendraw/mendix.{type JsProps}
import gleam/option.{type Option, None, Some}

fn handle_props(props: JsProps) {
  // 필수 속성 — 항상 존재한다고 가정
  let name: String = mendix.get_prop_required(props, "name")

  // 선택 속성 — 없으면 None
  let caption: Option(String) = mendix.get_prop(props, "caption")

  // 문자열 속성 — 없으면 빈 문자열 ""
  let label: String = mendix.get_string_prop(props, "label")

  // 속성 존재 여부 확인
  let has_icon: Bool = mendix.has_prop(props, "icon")
}
```

| 함수 | 반환 타입 | 없을 때 |
|------|----------|---------|
| `get_prop_required(props, key)` | `a` | 런타임 에러 |
| `get_prop(props, key)` | `Option(a)` | `None` |
| `get_string_prop(props, key)` | `String` | `""` |
| `has_prop(props, key)` | `Bool` | `False` |

### ValueStatus

Mendix의 `DynamicValue`, `EditableValue` 등은 `status` 속성을 가진다.
데이터 로딩 상태를 확인할 때 사용한다:

```gleam
import mendraw/mendix

let value = mendix.get_prop_required(props, "textAttr")

case mendix.get_status(value) {
  mendix.Available -> // 값 사용 가능
    use_value(value)
  mendix.Loading -> // 로딩 중
    show_spinner()
  mendix.Unavailable -> // 사용 불가
    show_placeholder()
}
```

### Option 변환

JS/Gleam 경계에서 `undefined`/`null`을 안전하게 처리한다:

```gleam
import mendraw/mendix

// JS undefined/null → Gleam None, 값이 있으면 Some(값)
let maybe_value = mendix.to_option(js_value)

// Gleam Option → JS 값 (None → undefined)
let js_value = mendix.from_option(gleam_option)
```

---

## 생성된 코드 구조

### Pluggable 위젯 바인딩 예시

Switch 위젯에서 생성되는 `src/widgets/switch.gleam`:

```gleam
// @generated mendraw/install — 직접 수정 금지

import gleam/option.{None, Some}
import mendraw/interop
import mendraw/mendix.{type JsProps}
import mendraw/widget
import redraw.{type Element}
import redraw/dom/attribute

pub fn render(props: JsProps) -> Element {
  // 필수 속성
  let text_attr = mendix.get_prop_required(props, "textAttr")
  // 선택 속성
  let caption = mendix.get_prop(props, "caption")

  let comp = widget.component("Switch")
  interop.component_el(
    comp,
    [
      attribute.attribute("textAttr", text_attr),
      // 선택 속성은 있을 때만 전달
      ..optional_attr("caption", caption)
    ],
    [],
  )
}

fn optional_attr(key: String, value: option.Option(a)) -> List(attribute.Attribute) {
  case value {
    Some(v) -> [attribute.attribute(key, v)]
    None -> []
  }
}
```

### Classic 위젯 바인딩 예시

CameraWidget 위젯에서 생성되는 `src/widgets/camera_widget.gleam`:

```gleam
// @generated mendraw/install — 직접 수정 금지

import gleam/option.{None, Some}
import mendraw/classic
import mendraw/mendix.{type JsProps}
import redraw.{type Element}

pub fn render(props: JsProps) -> Element {
  let mf_to_execute = mendix.get_prop_required(props, "mfToExecute")
  let prefer_rear_camera = mendix.get_prop_required(props, "preferRearCamera")

  classic.render("CameraWidget.widget.CameraWidget", [
    #("mfToExecute", classic.to_dynamic(mf_to_execute)),
    #("preferRearCamera", classic.to_dynamic(prefer_rear_camera)),
  ])
}
```

### 파일명 변환 규칙

위젯 이름은 Gleam 모듈명 규칙에 맞게 snake_case로 변환된다:

| 위젯 이름 | 파일명 | 모듈 경로 |
|-----------|--------|----------|
| `Switch` | `switch.gleam` | `widgets/switch` |
| `AreaChart` | `area_chart.gleam` | `widgets/area_chart` |
| `BarChart` | `bar_chart.gleam` | `widgets/bar_chart` |
| `CameraWidget` | `camera_widget.gleam` | `widgets/camera_widget` |
| `Progress Bar` | `progress_bar.gleam` | `widgets/progress_bar` |

---

## 생성된 바인딩 커스터마이징

생성된 `src/widgets/*.gleam` 파일은 한 번 생성된 후 **덮어쓰지 않는다**.
따라서 생성된 파일을 직접 수정하여 커스터마이징할 수 있다:

```gleam
// src/widgets/switch.gleam — 사용자가 수정한 버전
import mendraw/interop
import mendraw/mendix.{type JsProps}
import mendraw/widget
import redraw.{type Element}
import redraw/dom/attribute

pub fn render(props: JsProps) -> Element {
  let text_attr = mendix.get_prop_required(props, "textAttr")
  let comp = widget.component("Switch")
  interop.component_el(
    comp,
    [
      widget.editable_prop("textAttr", text_attr, "표시값", fn(v) { Nil }),
      // 커스텀: 고정 캡션 추가
      widget.prop("caption", "내 스위치"),
    ],
    [],
  )
}
```

> **주의**: 수정한 파일은 `gleam run -m mendraw/install`을 다시 실행해도 덮어쓰지 않는다.
> 바인딩을 재생성하려면 해당 파일을 삭제한 후 install을 다시 실행한다.

---

## API 레퍼런스

### mendraw/mendix

Mendix Pluggable Widget API의 핵심 타입과 props 접근자.

#### 타입

| 타입 | 설명 |
|------|------|
| `JsProps` | Mendix가 위젯에 전달하는 props 객체 (opaque) |
| `ValueStatus` | `Available \| Unavailable \| Loading` |
| `ObjectItem` | Mendix 데이터 객체 (opaque) |

#### 함수

| 함수 | 시그니처 | 설명 |
|------|----------|------|
| `get_prop` | `(JsProps, String) -> Option(a)` | 선택 속성 추출 (없으면 `None`) |
| `get_prop_required` | `(JsProps, String) -> a` | 필수 속성 추출 |
| `get_string_prop` | `(JsProps, String) -> String` | 문자열 속성 (없으면 `""`) |
| `has_prop` | `(JsProps, String) -> Bool` | 속성 존재 여부 |
| `get_status` | `(a) -> ValueStatus` | 값 객체의 로딩 상태 |
| `object_id` | `(ObjectItem) -> String` | 데이터 객체 ID |
| `to_value_status` | `(String) -> ValueStatus` | 문자열 → `ValueStatus` 변환 |
| `to_option` | `(a) -> Option(a)` | JS undefined/null → `None` |
| `from_option` | `(Option(a)) -> a` | Gleam `Option` → JS 값 (`None` → undefined) |

### mendraw/widget

Pluggable 위젯 컴포넌트 조회 및 prop 래핑.

| 함수 | 시그니처 | 설명 |
|------|----------|------|
| `component` | `(String) -> JsComponent` | 이름으로 위젯 컴포넌트 조회 |
| `prop` | `(String, a) -> Attribute` | `DynamicValue`로 래핑 (읽기 전용) |
| `editable_prop` | `(String, a, String, fn(a) -> Nil) -> Attribute` | `EditableValue`로 래핑 (편집 가능) |
| `action_prop` | `(String, fn() -> Nil) -> Attribute` | `ActionValue`로 래핑 (이벤트 핸들러) |

### mendraw/interop

외부 JS React 컴포넌트를 redraw Element로 변환하는 브릿지.

| 함수 | 시그니처 | 설명 |
|------|----------|------|
| `component_el` | `(JsComponent, List(Attribute), List(Element)) -> Element` | 속성 + 자식으로 렌더링 |
| `component_el_` | `(JsComponent, List(Element)) -> Element` | 자식만으로 렌더링 |
| `void_component_el` | `(JsComponent, List(Attribute)) -> Element` | self-closing 렌더링 |

#### 타입

| 타입 | 설명 |
|------|------|
| `JsComponent` | 외부 React 컴포넌트 참조 (opaque) |

### mendraw/classic

Classic (Dojo) 위젯을 React 내부에서 렌더링.

| 함수 | 시그니처 | 설명 |
|------|----------|------|
| `render` | `(String, List(#(String, Dynamic))) -> Element` | Classic 위젯 렌더링 |
| `render_with_class` | `(String, List(#(String, Dynamic)), String) -> Element` | CSS 클래스 지정 렌더링 |
| `to_dynamic` | `(a) -> Dynamic` | 값을 `Dynamic`으로 변환 |

### mendraw/cmd

위젯 바인딩 생성 + TOML 위젯 관리 API.

| 함수 | 시그니처 | 설명 |
|------|----------|------|
| `file_exists` | `(String) -> Bool` | 파일 존재 여부 |
| `generate_widget_bindings` | `() -> Nil` | build/widgets/ 캐시에서 바인딩 생성 |
| `resolve_toml_widgets` | `() -> Nil` | gleam.toml [tools.mendraw.widgets.*] 다운로드/캐시 |
| `write_widget_toml` | `(String, String, Option(Int), Option(String)) -> Nil` | gleam.toml에 위젯 항목 쓰기 |
| `download_to_cache` | `(String, String, String, Option(Int)) -> Bool` | URL에서 build/widgets/{name}/에 다운로드+추출 |

### mendraw/marketplace

Mendix Marketplace 위젯 검색·다운로드 TUI. `gleam run -m mendraw/marketplace`로 실행한다.

#### 주요 기능

| 기능 | 설명 |
|------|------|
| 위젯 검색 | 이름/퍼블리셔로 실시간 필터링 |
| 백그라운드 로딩 | 전체 위젯 목록을 백그라운드에서 점진적으로 로드 |
| 버전 선택 | Content API + Playwright(XAS)로 버전별 다운로드 정보 조회 |
| 자동 TOML 기록 | 다운로드 시 gleam.toml에 위젯 항목 자동 추가 |
| 캐시 다운로드 | build/widgets/에 캐시 (소스 컨트롤에 .mpk 불필요) |
| 자동 바인딩 | 다운로드 완료 후 `generate_widget_bindings()` 자동 호출 |

#### 의존성

- `etch` — 터미널 raw mode, 커서 제어, ANSI 스타일링
- `playwright` — Mendix 로그인 세션 관리, 버전 다운로드 정보 추출 (런타임 의존)
- `curl` — Content API 호출 (시스템 명령)

---

## glendix 프로젝트에서 사용하기

[glendix](https://github.com/) 프로젝트에서 mendraw를 의존성으로 추가하면,
MPK 바인딩 생성을 mendraw에 위임할 수 있다:

```gleam
// glendix의 install.gleam
import mendraw/cmd as mendraw_cmd

pub fn main() {
  cmd.exec(cmd.detect_install_command())
  cmd.generate_bindings()
  // MPK 위젯 바인딩 생성을 mendraw에 위임
  mendraw_cmd.generate_widget_bindings()
}
```

---

## 문제 해결

### `gleam run -m mendraw/install` 실행 시 아무것도 생성되지 않는다

- `gleam.toml`에 `[tools.mendraw.widgets.*]` 섹션이 있는지 확인
- `.mpk` 파일이 유효한 ZIP 형식인지 확인
- 콘솔 출력을 확인하여 파싱 오류가 없는지 점검

### 이미 존재하는 바인딩 파일이 업데이트되지 않는다

mendraw는 `src/widgets/`에 이미 존재하는 `.gleam` 파일을 **덮어쓰지 않는다** (사용자 수정 보호).
바인딩을 재생성하려면:

```sh
# 특정 파일만 재생성
rm src/widgets/switch.gleam
gleam run -m mendraw/install

# 전체 재생성
rm src/widgets/*.gleam
gleam run -m mendraw/install
```

### "widget_ffi.mjs not generated" 에러

`widget_ffi.mjs`와 `classic_ffi.mjs`는 스텁 파일로 시작한다.
`gleam run -m mendraw/install`을 실행하면 빌드 경로에 실제 파일이 생성된다.
install을 실행하지 않고 위젯 모듈을 import하면 이 에러가 발생한다.

### Classic 위젯이 렌더링되지 않는다

- Classic 위젯은 DOM 컨테이너를 생성하고 imperative하게 마운트한다
- `classic_ffi.mjs`가 빌드 경로에 정상적으로 생성되었는지 확인
- `widget_id`가 정확한지 확인 (예: `"CameraWidget.widget.CameraWidget"`)

### Pluggable 위젯과 Classic 위젯을 구분하는 기준

mendraw는 `.mpk` 파일 내부의 구조로 자동 판별한다:

- `.mjs` 파일이 포함되어 있으면 → **Pluggable** 위젯
- `.mjs` 없이 `.js`만 포함되어 있으면 → **Classic** 위젯

사용자가 별도로 지정할 필요 없다.
