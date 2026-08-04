import Big from "big.js";
export function decimal_from_string(s) {
  return new Big(s);
}
export function decimal_from_int(n) {
  return new Big(n);
}
export function decimal_from_float(f) {
  return new Big(f);
}
export function decimal_to_string(d) {
  return d.toString();
}
export function decimal_to_float(d) {
  return d.toNumber();
}
export function decimal_to_int(d) {
  return Math.trunc(d.toNumber());
}
export function decimal_to_fixed(d, dp) {
  return d.toFixed(dp);
}
