// Synthetic Mendix data objects — fake ListValue/ObjectItem/ListAttributeValue
// for feeding external API data into Mendix chart/grid widgets
import { toList } from "../gleam.mjs";

// id -> index mapping for O(1) lookup
function buildIdIndex(items) {
  const map = new Map();
  items.forEach((item, i) => map.set(item.id, i));
  return map;
}

// noop for mutation methods
const noop = () => {};

// === ObjectItem ===

export function make_object_item(id) {
  return { id };
}

export function make_object_items(count) {
  const items = [];
  for (let i = 0; i < count; i++) {
    items.push({ id: `synth_${i}` });
  }
  return toList(items);
}

// === ListValue ===
// items stored as JS Array (chart widgets iterate with for-of and access .length)

export function make_list_value(gleamItems) {
  const items = gleamItems.toArray();
  return {
    status: "available",
    items,
    offset: 0,
    limit: items.length,
    hasMoreItems: false,
    totalCount: items.length,
    sortOrder: [],
    filter: undefined,
    setOffset: noop,
    setLimit: noop,
    setFilter: noop,
    setSortOrder: noop,
    reload: noop,
    requestTotalCount: noop,
  };
}

// === ListAttributeValue ===
// .get(item) returns EditableValue-shaped object

export function make_list_attribute(gleamItems, gleamValues, displayFn, attrType) {
  const items = gleamItems.toArray();
  const values = gleamValues.toArray();
  const idIndex = buildIdIndex(items);

  const formatFn = (v) =>
    v !== undefined && v !== null ? displayFn(v) : "";

  return {
    get: (item) => {
      const idx = idIndex.get(item.id);
      const val = idx !== undefined ? values[idx] : undefined;
      return {
        status: "available",
        value: val,
        displayValue: formatFn(val),
        readOnly: true,
        validation: undefined,
        setValue: noop,
        setValidator: noop,
        setTextValue: noop,
        formatter: {
          format: formatFn,
          parse: () => ({ valid: false }),
        },
        universe: undefined,
      };
    },
    id: `synth_attr_${attrType}`,
    sortable: false,
    filterable: false,
    type: attrType,
    formatter: {
      format: formatFn,
      parse: () => ({ valid: false }),
    },
  };
}

// === TextTemplate (static, no datasource binding) ===

export function make_text_template(value) {
  return { value };
}

// === ListExpressionValue / ListTextTemplate ===
// .get(item) returns { status, value }

export function make_list_text_template(gleamItems, gleamValues) {
  const items = gleamItems.toArray();
  const values = gleamValues.toArray();
  const idIndex = buildIdIndex(items);

  return {
    get: (item) => {
      const idx = idIndex.get(item.id);
      return {
        status: "available",
        value: idx !== undefined ? values[idx] : "",
      };
    },
  };
}

export function make_list_expression(gleamItems, gleamValues) {
  const items = gleamItems.toArray();
  const values = gleamValues.toArray();
  const idIndex = buildIdIndex(items);

  return {
    get: (item) => {
      const idx = idIndex.get(item.id);
      return {
        status: "available",
        value: idx !== undefined ? values[idx] : undefined,
      };
    },
  };
}

// === Association (for DynamicDataGrid cell→row/cell→column references) ===

export function make_association(gleamItems, gleamTargets) {
  const items = gleamItems.toArray();
  const targets = gleamTargets.toArray();
  const idIndex = buildIdIndex(items);

  return {
    get: (item) => {
      const idx = idIndex.get(item.id);
      return {
        status: "available",
        value: idx !== undefined ? targets[idx] : undefined,
        readOnly: true,
        validation: undefined,
        setValue: noop,
      };
    },
  };
}

// === Chart series config builders ===

export function make_chart_series_static(
  dataSource,
  xAttr,
  yAttr,
  name,
  aggregation,
  interpolation,
  lineStyle,
  lineColor,
  barColor,
) {
  const series = {
    dataSet: "static",
    staticDataSource: dataSource,
    staticXAttribute: xAttr,
    staticYAttribute: yAttr,
    staticName: name,
    aggregationType: aggregation || "none",
    customSeriesOptions: "",
  };
  if (interpolation) series.interpolation = interpolation;
  if (lineStyle) series.lineStyle = lineStyle;
  if (lineColor) series.staticLineColor = { status: "available", value: lineColor };
  if (barColor) series.staticBarColor = { status: "available", value: barColor };
  return series;
}

// === Utility ===

export function to_js_array(gleamList) {
  return gleamList.toArray();
}
