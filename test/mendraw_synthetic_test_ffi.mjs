import {
  make_association,
  make_list_attribute,
  make_list_expression,
  make_list_text_template,
} from "./mendraw/synthetic_ffi.mjs";

// Contract fixtures for synthetic Mendix value constructors.
const asGleamList = (values) => ({ toArray: () => values });

export function aligned_synthetic_constructors_succeed() {
  const items = [{ id: "a" }, { id: "b" }];
  const attribute = make_list_attribute(
    asGleamList(items),
    asGleamList([1, 2]),
    (value) => String(value),
    "Decimal",
  );
  const got = attribute.get(items[0]);
  const template = make_list_text_template(
    asGleamList(items),
    asGleamList(["one", "two"]),
  ).get(items[1]);
  const expression = make_list_expression(
    asGleamList(items),
    asGleamList([10, 20]),
  ).get(items[0]);
  const association = make_association(
    asGleamList(items),
    asGleamList([{ id: "t1" }, { id: "t2" }]),
  ).get(items[1]);
  return got.value.toNumber() === 1
    && got.displayValue === "1"
    && template.value === "two"
    && expression.value === 10
    && association.value.id === "t2";
}

export function mismatched_synthetic_constructors_fail() {
  const twoItems = [{ id: "a" }, { id: "b" }];
  const cases = [
    () => make_list_attribute(asGleamList(twoItems), asGleamList([1]), String, "Decimal"),
    () => make_list_text_template(asGleamList(twoItems), asGleamList(["one"])),
    () => make_list_expression(asGleamList(twoItems), asGleamList([10])),
    () => make_association(asGleamList(twoItems), asGleamList([{ id: "t1" }])),
  ];
  return cases.every((run) => {
    try {
      run();
      return false;
    } catch (error) {
      return error instanceof Error
        && error.message.includes("requires one value per item")
        && error.message.includes("received 2 item(s) and 1 value(s)");
    }
  });
}
