// Mendix Decimal 타입 — Big.js 경계 변환 전용 Gleam opaque 래퍼
// EditableValue<BigJs.Big>에서 반환되는 Big.js 객체의 타입 안전한 변환
// 산술/비교는 위젯 프로젝트에서 dee 등을 사용

// === 타입 ===

pub type Decimal

// === 생성 ===

/// 문자열로 Decimal 생성
@external(javascript, "./decimal_ffi.mjs", "decimal_from_string")
pub fn from_string(s: String) -> Decimal

/// 정수로 Decimal 생성
@external(javascript, "./decimal_ffi.mjs", "decimal_from_int")
pub fn from_int(n: Int) -> Decimal

/// 부동소수점으로 Decimal 생성 (정밀도 손실 주의)
@external(javascript, "./decimal_ffi.mjs", "decimal_from_float")
pub fn from_float(f: Float) -> Decimal

// === 변환 ===

/// 문자열로 변환
@external(javascript, "./decimal_ffi.mjs", "decimal_to_string")
pub fn to_string(d: Decimal) -> String

/// Float로 변환 (정밀도 손실 가능)
@external(javascript, "./decimal_ffi.mjs", "decimal_to_float")
pub fn to_float(d: Decimal) -> Float

/// Int로 변환 (소수점 이하 버림)
@external(javascript, "./decimal_ffi.mjs", "decimal_to_int")
pub fn to_int(d: Decimal) -> Int

/// 고정 소수점 문자열 (소수점 이하 dp자리)
@external(javascript, "./decimal_ffi.mjs", "decimal_to_fixed")
pub fn to_fixed(d: Decimal, dp: Int) -> String
