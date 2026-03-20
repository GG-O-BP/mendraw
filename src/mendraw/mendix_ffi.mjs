// Mendix Pluggable Widget API FFI 어댑터
// Mendix 런타임 타입의 속성 접근과 메서드 호출을 Gleam에 노출
import { Some, None } from "../../gleam_stdlib/gleam/option.mjs";
import { Ok, Error as GleamError, toList } from "../gleam.mjs";

// === JS undefined ↔ Gleam Option 변환 ===

export function to_option(value) {
  return value !== undefined && value !== null ? new Some(value) : new None();
}

export function from_option(option) {
  return option instanceof Some ? option[0] : undefined;
}

// === JsProps 접근 ===

export function get_mendix_prop(props, key) {
  return to_option(props[key]);
}

export function get_mendix_prop_required(props, key) {
  return props[key];
}

export function get_string_prop(props, key) {
  const value = props[key];
  return value !== undefined && value !== null ? String(value) : "";
}

export function has_prop(props, key) {
  return key in props && props[key] !== undefined && props[key] !== null;
}

// === ValueStatus / ObjectItem ===

export function get_status(obj) {
  return obj.status;
}

export function get_object_id(item) {
  return item.id;
}

// === EditableValue ===

export function get_editable_value(obj) {
  return to_option(obj.value);
}

export function get_editable_read_only(obj) {
  return obj.readOnly;
}

export function get_editable_validation(obj) {
  return to_option(obj.validation);
}

export function get_editable_display_value(obj) {
  return obj.displayValue;
}

export function get_editable_formatter(obj) {
  return obj.formatter;
}

export function get_editable_universe(obj) {
  return to_option(obj.universe ? toList(obj.universe) : undefined);
}

export function editable_set_value(obj, option) {
  obj.setValue(from_option(option));
}

export function editable_set_text_value(obj, text) {
  obj.setTextValue(text);
}

export function editable_set_validator(obj, option_fn) {
  if (option_fn instanceof Some) {
    const gleam_fn = option_fn[0];
    obj.setValidator((value) => {
      const result = gleam_fn(to_option(value));
      return from_option(result);
    });
  } else {
    obj.setValidator(undefined);
  }
}

// === ActionValue ===

export function get_action_can_execute(a) {
  return a.canExecute;
}

export function get_action_is_executing(a) {
  return a.isExecuting;
}

export function action_execute(a) {
  a.execute();
}

// === DynamicValue ===

export function get_dynamic_value(obj) {
  return to_option(obj.value);
}

// === ListValue ===

export function get_list_items(lv) {
  return to_option(lv.items ? toList(lv.items) : undefined);
}

export function get_list_offset(lv) {
  return lv.offset;
}

export function get_list_limit(lv) {
  return lv.limit;
}

export function get_list_has_more_items(lv) {
  return to_option(lv.hasMoreItems);
}

export function get_list_total_count(lv) {
  return to_option(lv.totalCount);
}

export function get_list_sort_order(lv) {
  return toList(lv.sortOrder || []);
}

export function get_list_filter(lv) {
  return to_option(lv.filter);
}

export function list_set_offset(lv, offset) {
  lv.setOffset(offset);
}

export function list_set_limit(lv, limit) {
  lv.setLimit(limit);
}

export function list_set_filter(lv, option) {
  lv.setFilter(from_option(option));
}

export function list_set_sort_order(lv, gleam_list) {
  lv.setSortOrder(gleam_list.toArray());
}

export function list_reload(lv) {
  lv.reload();
}

export function list_request_total_count(lv, need) {
  lv.requestTotalCount(need);
}

// === List-linked 타입 (공용) ===

export function list_type_get(list_type, item) {
  return list_type.get(item);
}

// === ListAttributeValue 메타데이터 ===

export function get_list_attr_id(attr) {
  return attr.id;
}

export function get_list_attr_sortable(attr) {
  return attr.sortable;
}

export function get_list_attr_filterable(attr) {
  return attr.filterable;
}

export function get_list_attr_type(attr) {
  return attr.type;
}

export function get_list_attr_formatter(attr) {
  return attr.formatter;
}

// === Selection ===

export function get_selection_single(sel) {
  return to_option(sel.selection);
}

export function get_selection_multi(sel) {
  return toList(sel.selection || []);
}

export function set_selection_single(sel, option) {
  sel.setSelection(from_option(option));
}

export function set_selection_multi(sel, gleam_list) {
  sel.setSelection(gleam_list.toArray());
}

// === ModifiableValue / Reference ===

export function get_modifiable_value(obj) {
  return to_option(obj.value);
}

export function modifiable_set_value(obj, option) {
  obj.setValue(from_option(option));
}

// === ReferenceSetValue (Array↔List 변환) ===

export function get_reference_set_value(obj) {
  return to_option(obj.value ? toList(obj.value) : undefined);
}

export function set_reference_set_value(obj, option) {
  if (option instanceof Some) {
    obj.setValue(option[0].toArray());
  } else {
    obj.setValue(undefined);
  }
}

export function get_modifiable_read_only(obj) {
  return obj.readOnly;
}

export function get_modifiable_validation(obj) {
  return to_option(obj.validation);
}

// === FileValue / WebImage ===

export function get_file_uri(f) {
  return f.uri;
}

export function get_file_name(f) {
  return to_option(f.name);
}

export function get_image_alt_text(img) {
  return to_option(img.altText);
}

// === WebIcon ===

export function get_icon_type(icon) {
  return icon.type;
}

export function get_icon_class(icon) {
  return icon.iconClass || "";
}

export function get_icon_url(icon) {
  return icon.iconUrl || "";
}

// === Formatter ===

export function formatter_format(fmt, option_value) {
  return fmt.format(from_option(option_value));
}

export function formatter_parse(fmt, text) {
  const result = fmt.parse(text);
  if (result.valid) {
    return new Ok(to_option(result.value));
  } else {
    return new GleamError(undefined);
  }
}

// === SortInstruction ===

export function make_sort_instruction(id, asc) {
  return { id, asc };
}

export function get_sort_id(instr) {
  return instr.id;
}

export function get_sort_asc(instr) {
  return instr.asc;
}

// === JS Date ===

export function date_now() {
  return new Date();
}

export function date_from_iso(iso_string) {
  return new Date(iso_string);
}

export function date_from_timestamp(ms) {
  return new Date(ms);
}

// month: Gleam 1-based → JS 0-based 변환
export function date_create(year, month, day, hours, minutes, seconds, ms) {
  return new Date(year, month - 1, day, hours, minutes, seconds, ms);
}

export function date_to_iso(d) {
  return d.toISOString();
}

export function date_get_time(d) {
  return d.getTime();
}

export function date_to_string(d) {
  return d.toString();
}

export function date_get_full_year(d) {
  return d.getFullYear();
}

// JS 0-based → Gleam 1-based 변환
export function date_get_month(d) {
  return d.getMonth() + 1;
}

export function date_get_date(d) {
  return d.getDate();
}

export function date_get_hours(d) {
  return d.getHours();
}

export function date_get_minutes(d) {
  return d.getMinutes();
}

export function date_get_seconds(d) {
  return d.getSeconds();
}

export function date_get_milliseconds(d) {
  return d.getMilliseconds();
}

export function date_get_day(d) {
  return d.getDay();
}

// === Date 변환 (JS Date ↔ HTML input[type="date"]) ===

export function date_to_input_value(jsDate) {
  const year = jsDate.getFullYear();
  const month = String(jsDate.getMonth() + 1).padStart(2, "0");
  const day = String(jsDate.getDate()).padStart(2, "0");
  return `${year}-${month}-${day}`;
}

export function input_value_to_date(dateString) {
  if (!dateString) return new None();
  const [year, month, day] = dateString.split("-").map(Number);
  return new Some(new Date(year, month - 1, day));
}
