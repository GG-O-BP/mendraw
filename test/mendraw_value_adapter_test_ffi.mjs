// Fixtures for typed value adapter tests.
function editableFixture(spec) {
  const record = { written: [] };
  const editable = {
    status: spec.status ?? "available",
    value: spec.value,
    displayValue: "",
    readOnly: spec.readOnly ?? false,
    validation: undefined,
    setValue(next) {
      if (spec.writeError) throw new Error(spec.writeError);
      record.written.push(next);
    },
    setValidator: () => {},
    setTextValue: () => {},
    formatter: {
      format: (value) => String(value ?? ""),
      parse: () => ({ valid: false }),
    },
    universe: undefined,
  };
  return { editable, record };
}
export function integer_editable(value) {
  return editableFixture({ value });
}
export function float_editable(value) {
  return editableFixture({ value });
}
export function string_editable(value) {
  return editableFixture({ value });
}
export function empty_editable() {
  return editableFixture({});
}
export function read_only_integer_editable(value) {
  return editableFixture({ value, readOnly: true });
}
export function loading_editable() {
  return editableFixture({ status: "loading" });
}
export function unavailable_editable() {
  return editableFixture({ status: "confused" });
}
export function unsupported_editable() {
  return editableFixture({ value: {} });
}
export function huge_decimal_editable() {
  return editableFixture({
    value: {
      toNumber: () => Infinity,
      toString: () => "huge",
    },
  });
}
export function decimal_attribute(fixture, type_name) {
  return {
    get: () => fixture.editable,
    id: `fixture_${type_name}`,
    sortable: false,
    filterable: false,
    type: type_name,
    formatter: {
      format: (value) => String(value ?? ""),
      parse: () => ({ valid: false }),
    },
  };
}
export function fixture_editable(fixture) {
  return fixture.editable;
}
export function written_count(fixture) {
  return fixture.record.written.length;
}
export function written_boolean(fixture, index) {
  return fixture.record.written[index];
}
export function written_integer(fixture, index) {
  return fixture.record.written[index];
}
export function written_float(fixture, index) {
  return fixture.record.written[index];
}
export function written_string(fixture, index) {
  return fixture.record.written[index];
}
export function written_is_empty(fixture, index) {
  return fixture.record.written[index] === undefined;
}
export function written_date_milliseconds(fixture, index) {
  return fixture.record.written[index].getTime();
}
export function written_decimal_string(fixture, index) {
  return fixture.record.written[index].toString();
}
export function failing_write_editable() {
  return editableFixture({ value: "x", writeError: "no writes" });
}
