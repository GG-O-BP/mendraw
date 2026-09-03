[English](README.md) | **Korean** | [Japanese](README.ja.md)

# mendraw

`mendraw`는 Gleam에서 Mendix 클라이언트 값과 **이미 설치된** `.mpk` 위젯
자산을 사용하기 위한 JavaScript 타깃 패키지다.

담당 영역은 다음으로 제한한다.

- Mendix Pluggable Widget 클라이언트 API의 타입 래퍼
- Pluggable/Classic 위젯을 위한 Redraw interop
- `build/widgets/*` 자산에서 결정적으로 바인딩 생성
- Mendix 밖의 웹 앱에서 사용할 synthetic Mendix 호환 값

Marketplace 검색·인증·브라우저 자동화·다운로드·전역 캐시·락파일은 Mendraw의
책임이 아니다. 해당 기능은 독립 패키지
[`mxpak`](https://github.com/glendix-labs/mxpak)이 담당한다.

## 설치

```sh
gleam add mendraw@2
```

## 설치된 MPK 사용

### 1. mxpak으로 자산 설치

```toml
[tools.mxpak]
mode = "extract"

[tools.mxpak.widgets.Charts]
version = "3.0.0"
# id = 12345
# s3_id = "com/..."
```

```sh
mxp install
```

mxpak을 Git/path 의존성으로 사용하면 다음 진입점도 같다.

```sh
gleam run -t erlang -m mxpak/install
```

### 2. Mendraw 바인딩 생성

```sh
gleam run -m mendraw/install
```

Mendraw는 `build/widgets/`를 읽어 `src/widgets/*.gleam`과 JavaScript 컴포넌트
레지스트리를 생성한다. 다시 실행하면 생성 파일도 다시 만들어 오래된 결과를 남기지
않는다.

### 3. 렌더링

```gleam
import gleam/result
import mendraw/interop
import mendraw/mendix
import mendraw/mendix/editable_value
import mendraw/widget
import redraw

pub fn view(
  props props: mendix.JsProps,
) -> Result(redraw.Element, widget.WidgetError) {
  let value = mendix.get_prop_required(props, "textAttr")
  let current_text = editable_value.display_value(value)
  use component <- result.try(widget.component("Switch"))
  Ok(interop.component_el(component, [
    widget.prop("caption", "제목"),
    widget.editable_prop(
      "textAttr",
      current_text,
      editable_value.display_value(value),
      fn(updated_text) {
        editable_value.set_text_value(value, updated_text)
      },
    ),
    widget.action_prop("onClick", fn() {
      editable_value.set_text_value(value, "Updated")
    }),
  ], []))
}
```

## Classic 위젯

```gleam
import mendraw/classic

classic.render("CameraWidget.widget.CameraWidget", [
  #("mfToExecute", classic.to_value(microflow)),
  #("preferRearCamera", classic.to_value(True)),
])
```

바인딩이 없으면 `render`와 `render_with_class`는 상세한 `Result` 오류를 반환한다.

## 주요 모듈

| 모듈 | 책임 |
| --- | --- |
| `mendraw/mendix` | 핵심 handle, 상태, prop 접근, Option 변환 |
| `mendraw/mendix/editable_value` | 편집 값과 validation |
| `mendraw/mendix/list_value` | data source paging/filter/sort/reload |
| `mendraw/mendix/list_attribute` | item별 attribute/action/expression 접근 |
| `mendraw/mendix/filter` | 타입 안전 필터 표현식 |
| `mendraw/mendix/date` | JavaScript Date 경계 |
| `mendraw/mendix/decimal` | Big.js 경계 변환 |
| `mendraw/widget` | 생성된 Pluggable 컴포넌트 조회와 prop adapter |
| `mendraw/classic` | 생성된 Classic 컴포넌트 조회 |
| `mendraw/interop` | JavaScript 컴포넌트를 Redraw element로 변환 |
| `mendraw/synthetic` | 외부 데이터를 위한 Mendix 호환 값 |
데이터소스에 바인딩된 프로퍼티는 런타임 구조를 직접 검사하지 않고 하나의
typed 스냅샷으로 포착할 수 있습니다:

```gleam
import mendraw/datasource

case datasource.capture(props, "dataSource") {
  datasource.Available(_, data) -> render_rows(data.items)
  datasource.Loading(_) -> render_loading()
  datasource.PropertyAbsent(_) | datasource.Unavailable(_) -> render_empty()
}
```


## 저장소 간 관계

```text
mxpak       패키지 자산 설치·캐시
  ↓ build/widgets/*
mendraw     타입 바인딩 생성·Mendix 클라이언트 값 모델링
  ↓ 공개 Gleam API
glendix     Mendix 위젯 빌드·Lustre/React 브리지
```

Mendix 타입이나 synthetic 값만 필요하면 Mendraw만 의존하면 된다. 패키지 설치만
필요하면 mxpak만 사용하면 된다.

## 개발

```sh
gleam deps download
gleam format --check
gleam check
gleam build --warnings-as-errors
gleam docs build
gleam test --runtime bun
```

## 라이선스

[MIT 라이선스](LICENCE)
