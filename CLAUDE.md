# mendraw

Mendix widget `.mpk` 파일에서 Gleam/redraw 바인딩을 자동 생성하는 라이브러리.

## 빌드 & 테스트

```bash
gleam build          # 컴파일
gleam test           # 테스트 실행
gleam format src test  # 포맷 체크 (CI에서도 --check로 검증)
gleam run -m mendraw/install  # TOML 위젯 다운로드 + build/widgets/ 캐시 → src/widgets/*.gleam 바인딩 생성
gleam run -m mendraw/marketplace  # Mendix Marketplace 위젯 검색·다운로드 TUI
cd sidecar && gleam run -m gleescript -- --out ../priv  # 사이드카 escript 빌드 → priv/mendraw_sidecar
```

## 프로젝트 구조

- `src/mendraw/install.gleam` — 진입점 (`gleam run -m mendraw/install`)
- `src/mendraw/cmd.gleam` + `cmd_ffi.mjs` — ZIP/XML 파싱, .gleam/.mjs 코드 생성, TOML 위젯 관리, 캐시 다운로드 (빌드타임 전용)
- `src/mendraw/mendix.gleam` + `mendix_ffi.mjs` — JsProps, ValueStatus, Option 변환
- `src/mendraw/interop.gleam` + `interop_ffi.mjs` — JsComponent → redraw Element 브릿지
- `src/mendraw/widget.gleam` + `widget_ffi.mjs` + `widget_prop_ffi.mjs` — Pluggable 위젯 컴포넌트 + prop 래핑
- `src/mendraw/classic.gleam` + `classic_ffi.mjs` — Classic(Dojo) 위젯 React 래퍼
- `src/mendraw/synthetic.gleam` + `synthetic_ffi.mjs` — 외부 API 데이터를 Mendix 위젯 호환 객체(ListValue, ObjectItem, ListAttributeValue 등)로 변환
- `src/mendraw/marketplace.gleam` + `marketplace_ffi.mjs` — Mendix Marketplace 위젯 검색·다운로드 TUI
- `src/mendraw/marketplace/ui.gleam` — Marketplace TUI 스타일링 출력 함수
- `widget_ffi.mjs`, `classic_ffi.mjs`는 **스텁** — install 실행 시 빌드 경로에 실제 파일 생성

### 사이드카 (브라우저 자동화)

- `sidecar/` — Erlang 타겟 HTTP 서버 (chrobot_extra 기반, 별도 Gleam 프로젝트)
  - `src/mendraw_sidecar.gleam` — 진입점: CLI 포트 파싱, mist 서버 시작
  - `src/mendraw_sidecar/router.gleam` — HTTP 라우팅 (path_segments 매칭)
  - `src/mendraw_sidecar/http_utils.gleam` — JSON 응답, 요청 본문 유틸리티
  - `src/mendraw_sidecar/session_handler.gleam` — /session/ensure: Mendix 로그인 세션 관리
  - `src/mendraw_sidecar/version_handler.gleam` — /versions/all, /versions/single: 버전 정보 수집
  - `src/mendraw_sidecar/xas_parser.gleam` — XAS JSON → AppStore.Version 파싱
- mendraw(JS 타겟)는 사이드카를 HTTP로 호출 — `marketplace_ffi.mjs`의 `startSidecar`/`callSidecar`/`stopSidecar`
- 개발 시: `sidecar/` 디렉토리 직접 사용. 배포 시: escript 빌드하여 `priv/mendraw_sidecar`에 포함

## 코드 컨벤션

- **Gleam 문법 참고**: `./docs/gleam_language_tour.md` 파일에 전체 언어 투어가 있음. 문법이 불확실할 때 반드시 참조할 것
- **타겟**: JavaScript only (`gleam.toml`의 `target = "javascript"`)
- **FFI 패턴**: Gleam 함수는 `@external(javascript, "./모듈_ffi.mjs", "함수명")`으로 JS 연결. FFI 파일명은 항상 `_ffi.mjs`
- **Opaque 타입**: `JsProps`, `JsComponent`, `ObjectItem` 등 JS 객체는 opaque type으로 선언하여 FFI 경계 보호
- **Synthetic 타입**: `synthetic.gleam`의 반환 타입은 기존 mendraw 타입(`ListValue`, `ObjectItem`, `ListAttributeValue`)을 재사용. JS 측에서 동일 인터페이스를 모사하는 객체를 생성하므로 Gleam 타입이 호환됨
- **Option 변환**: JS ↔ Gleam 경계에서 `to_option`/`from_option` 사용. JS undefined/null → Gleam None
- **코멘트, 문자열**: 한국어 사용
- **gleam format**: 코드 스타일은 `gleam format`이 처리. 수동 포맷 불필요

## Synthetic Data 모듈

`synthetic.gleam` + `synthetic_ffi.mjs`는 Mendix 런타임 없이 외부 API 데이터를 Mendix 위젯에 전달하기 위한 모듈이다.

- **ListValue**: `items`는 JS Array로 저장 (차트 위젯이 `for-of`/`.length` 직접 접근)
- **ListAttributeValue.get(item)**: id→index Map 기반 O(1) 룩업 클로저
- **EditableValue**: `{ status: "available", value, displayValue, readOnly: true, ... }` 형태
- **Decimal/Integer/Long 값**: Big.js 호환 객체로 래핑 (`.toNumber()`, `.toFixed()`, 비교/산술 메서드)
- **DateTime 값**: `new Date(timestamp)` 자동 변환
- **TextTemplate**: `.value` 직접 접근 + `.get(item)` 양쪽 모두 지원 (차트 위젯이 list-bound textTemplate로 접근)
- **Association**: DynamicDataGrid의 cell→row/cell→column 참조용. `.get(item)` → `{ value: targetItem }`
- **Chart series builder**: `chart_series_static()` — 차트 위젯의 `lines`/`series` prop용 JS 객체 생성
- **공유 의존성 처리**: `cmd_ffi.mjs`의 `rewriteSharedImports()` — 위젯 .mjs의 상대 경로 import를 재작성하고 공유 파일(shared-charts.mjs 등)을 함께 복사

## 코드 생성 규칙

`cmd_ffi.mjs`가 생성하는 파일들:

- 생성된 Gleam 파일의 import는 반드시 `mendraw/` 접두사 사용 (`mendraw/mendix`, `mendraw/interop`, `mendraw/widget`, `mendraw/classic`)
- 빌드 출력 경로: `build/packages/mendraw/src/mendraw/`, `build/dev/javascript/mendraw/mendraw/`
- 위젯 캐시 경로: `build/widgets/{name}/` (TOML 기반 + marketplace 다운로드)
- TOML 설정: `[tools.mendraw.widgets.위젯이름]` 섹션에 version, id, s3_id 관리
- 생성 주석: `// @generated mendraw/install — 직접 수정 금지`
- 이미 존재하는 `src/widgets/*.gleam` 파일은 덮어쓰지 않음 (사용자 수정 보호)

## 테스트

- 프레임워크: gleeunit
- CI: GitHub Actions — Ubuntu, OTP 28, Gleam 1.15.1 (`gleam test` + `gleam format --check`)

## 사이드카 빌드 & 테스트

```bash
cd sidecar && gleam build          # 사이드카 컴파일
cd sidecar && gleam run -m mendraw_sidecar -- 9999  # 포트 9999로 서버 시작
cd sidecar && gleam run -m gleescript -- --out ../priv  # escript 빌드
escript priv/mendraw_sidecar 9999  # escript로 직접 실행
curl http://127.0.0.1:9999/health  # {"status":"ok"} 확인
```

## 관련 프로젝트

- **glendix** (`../glendix/`): 이 라이브러리의 원본. mendraw는 glendix의 MPK 바인딩 기능을 분리한 것
- glendix는 향후 mendraw를 의존성으로 추가하여 MPK 처리를 위임할 예정
- **chrobot_extra** (`../chrobot/`): 사이드카의 브라우저 자동화 엔진 (Chrome DevTools Protocol)
