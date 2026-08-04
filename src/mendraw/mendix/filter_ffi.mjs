import * as filters from "mendix/filters/builders";
export function filter_and(conditions) {
  return filters.and(...conditions.toArray());
}
export function filter_or(conditions) {
  return filters.or(...conditions.toArray());
}
export function filter_not(condition) {
  return filters.not(condition);
}
export function filter_equals(a, b) {
  return filters.equals(a, b);
}
export function filter_not_equal(a, b) {
  return filters.notEqual(a, b);
}
export function filter_greater_than(a, b) {
  return filters.greaterThan(a, b);
}
export function filter_greater_than_or_equal(a, b) {
  return filters.greaterThanOrEqual(a, b);
}
export function filter_less_than(a, b) {
  return filters.lessThan(a, b);
}
export function filter_less_than_or_equal(a, b) {
  return filters.lessThanOrEqual(a, b);
}
export function filter_contains(a, b) {
  return filters.contains(a, b);
}
export function filter_starts_with(a, b) {
  return filters.startsWith(a, b);
}
export function filter_ends_with(a, b) {
  return filters.endsWith(a, b);
}
export function filter_day_equals(a, b) {
  return filters.dayEquals(a, b);
}
export function filter_day_not_equal(a, b) {
  return filters.dayNotEqual(a, b);
}
export function filter_day_greater_than(a, b) {
  return filters.dayGreaterThan(a, b);
}
export function filter_day_greater_than_or_equal(a, b) {
  return filters.dayGreaterThanOrEqual(a, b);
}
export function filter_day_less_than(a, b) {
  return filters.dayLessThan(a, b);
}
export function filter_day_less_than_or_equal(a, b) {
  return filters.dayLessThanOrEqual(a, b);
}
export function filter_attribute(id) {
  return filters.attribute(id);
}
export function filter_association(id) {
  return filters.association(id);
}
export function filter_literal(value) {
  return filters.literal(value);
}
export function filter_empty() {
  return filters.empty();
}
