// Fixtures for typed datasource snapshot tests.
export function available_datasource_props() {
  const items = [
    { id: "row-1" },
    { id: "row-2" },
    { id: "row-3" },
  ];
  return {
    dataSource: {
      status: "available",
      items,
      offset: 6,
      limit: 3,
      hasMoreItems: true,
      totalCount: 42,
    },
    columns: [
      { caption: "Name", valueAttribute: "fullName" },
      { caption: "Size", valueAttribute: "size" },
    ],
  };
}

export function empty_datasource_props() {
  return {
    dataSource: {
      status: "available",
      items: [],
      offset: 0,
      limit: 0,
      hasMoreItems: false,
      totalCount: 0,
    },
  };
}

export function loading_datasource_props() {
  return { dataSource: { status: "loading", items: [] } };
}

export function unavailable_datasource_props() {
  return { dataSource: { status: "confused", items: [] } };
}

export function missing_datasource_props() {
  return {};
}

export function columns_not_a_list_props() {
  return { columns: { caption: "Name" } };
}

export function synthetic_items(count) {
  const items = [];
  for (let i = 0; i < count; i++) {
    items.push({ id: `synth_${i}` });
  }
  return items;
}
