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

// Wrap a JS number in a Big.js-like object.
// Mendix chart widgets call .toNumber() on Decimal/Integer/Long values.
function wrapNumber(n) {
  const num = typeof n === "number" ? n : Number(n);
  return {
    toNumber: () => num,
    toFixed: (dp) => num.toFixed(dp !== undefined ? dp : 0),
    toString: () => String(num),
    valueOf: () => num,
    // Big.js comparison methods used by some widgets
    eq: (other) => num === (typeof other === "number" ? other : other?.toNumber?.() ?? Number(other)),
    gt: (other) => num > (typeof other === "number" ? other : other?.toNumber?.() ?? Number(other)),
    lt: (other) => num < (typeof other === "number" ? other : other?.toNumber?.() ?? Number(other)),
    gte: (other) => num >= (typeof other === "number" ? other : other?.toNumber?.() ?? Number(other)),
    lte: (other) => num <= (typeof other === "number" ? other : other?.toNumber?.() ?? Number(other)),
    plus: (other) => wrapNumber(num + (typeof other === "number" ? other : other?.toNumber?.() ?? Number(other))),
    minus: (other) => wrapNumber(num - (typeof other === "number" ? other : other?.toNumber?.() ?? Number(other))),
    times: (other) => wrapNumber(num * (typeof other === "number" ? other : other?.toNumber?.() ?? Number(other))),
    div: (other) => wrapNumber(num / (typeof other === "number" ? other : other?.toNumber?.() ?? Number(other))),
    abs: () => wrapNumber(Math.abs(num)),
    round: (dp, rm) => wrapNumber(Number(num.toFixed(dp || 0))),
    cmp: (other) => {
      const o = typeof other === "number" ? other : other?.toNumber?.() ?? Number(other);
      return num > o ? 1 : num < o ? -1 : 0;
    },
  };
}

// Wrap value based on Mendix attribute type
function wrapValue(rawVal, attrType) {
  if (rawVal === undefined || rawVal === null) return rawVal;
  if (attrType === "Decimal" || attrType === "Integer" || attrType === "Long" || attrType === "AutoNumber") {
    return wrapNumber(rawVal);
  }
  if (attrType === "DateTime") {
    // Chart widgets expect Date objects for DateTime attributes
    return new Date(typeof rawVal === "number" ? rawVal : Number(rawVal));
  }
  return rawVal;
}

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

  const formatFn = (v) => {
    if (v === undefined || v === null) return "";
    // Unwrap Big.js-like objects for display
    const raw = v?.toNumber ? v.toNumber() : v;
    return displayFn(raw);
  };

  return {
    get: (item) => {
      const idx = idIndex.get(item.id);
      const rawVal = idx !== undefined ? values[idx] : undefined;
      const val = wrapValue(rawVal, attrType);
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

// === TextTemplate ===
// Supports both direct .value access and .get(item) for list-bound contexts.
// Chart widgets call .get(item) on textTemplates bound to a datasource.

export function make_text_template(value) {
  return {
    value,
    get: () => ({ status: "available", value }),
  };
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

// Helper: create a constant ListExpressionValue (returns same value for any item)
// Used for chart color/tooltip properties that are expression-typed
function makeConstantExpression(value) {
  return {
    get: () => ({ status: "available", value }),
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
  // Color properties are ListExpressionValue — chart widgets call .get(item) on them
  if (lineColor) series.staticLineColor = makeConstantExpression(lineColor);
  if (barColor) series.staticBarColor = makeConstantExpression(barColor);
  return series;
}

// === Utility ===

export function to_js_array(gleamList) {
  return gleamList.toArray();
}
