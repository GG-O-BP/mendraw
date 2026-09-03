**English** | [Korean](README.ko.md) | [Japanese](README.ja.md)

# mendraw

`mendraw` is the JavaScript-target package for using Mendix client values and
already-installed `.mpk` widget assets from Gleam.

Its responsibility is intentionally narrow:

- typed wrappers for the Mendix Pluggable Widget client API;
- Redraw interop for pluggable and classic widget components;
- deterministic binding generation from `build/widgets/*` assets;
- synthetic Mendix-compatible values for non-Mendix web applications.

`mendraw` **does not** search the Marketplace, authenticate a user, launch a
browser, download packages, manage a global cache, or write a lockfile. Those
package-manager responsibilities belong to
[`mxpak`](https://github.com/glendix-labs/mxpak).

## Install

```sh
gleam add mendraw@2
```

The package targets JavaScript. Applications rendering Mendix widgets also need
the JavaScript peer packages required by those widgets, normally React and
React DOM.

## Use an installed MPK package

### 1. Install package assets with mxpak

Configure package acquisition under mxpak's namespace:

```toml
[tools.mxpak]
mode = "extract"

[tools.mxpak.widgets.Charts]
version = "3.0.0"
# id = 12345
# s3_id = "com/..." # optional direct-download identifier
```

Run the standalone `mxp` CLI from the project root:

```sh
mxp install
```

For a local Git/path dependency on mxpak, the equivalent Gleam entrypoint is:

```sh
gleam run -t erlang -m mxpak/install
```

Either command owns package resolution and writes extracted assets below
`build/widgets/`.

### 2. Generate Mendraw bindings

```sh
gleam run -m mendraw/install
```

Mendraw reads the installed assets, generates `src/widgets/*.gleam`, and writes
the JavaScript component registry into Mendraw's build output. Running the
command again regenerates the same binding modules, so stale generated source
is not silently retained.

### 3. Render the component

```gleam
import gleam/result
import mendraw/interop
import mendraw/mendix
import mendraw/mendix/editable_value
import mendraw/widget
import redraw

pub fn view(
  props props: mendix.JsProps,
) -> Result(redraw.Element, widget.WidgetError) {
  let value = mendix.get_prop_required(props, "textAttr")
  let current_text = editable_value.display_value(value)
  use component <- result.try(widget.component("Switch"))
  Ok(interop.component_el(component, [
    widget.prop("caption", "Title"),
    widget.editable_prop(
      "textAttr",
      current_text,
      editable_value.display_value(value),
      fn(updated_text) {
        editable_value.set_text_value(value, updated_text)
      },
    ),
    widget.action_prop("onClick", fn() {
      editable_value.set_text_value(value, "Updated")
    }),
  ], []))
}
```

## Classic widgets

Classic/Dojo assets installed by mxpak are wrapped in a React component by the
Mendraw generator:

```gleam
import mendraw/classic

classic.render("CameraWidget.widget.CameraWidget", [
  #("mfToExecute", classic.to_value(microflow)),
  #("preferRearCamera", classic.to_value(True)),
])
```

Both `render` and `render_with_class` return a descriptive `Result` when a
binding is missing.

## Mendix client values

The `mendraw/mendix/*` modules wrap runtime-owned JavaScript handles instead of
recreating Mendix business behavior:

```gleam
import gleam/option
import mendraw/mendix
import mendraw/mendix/action
import mendraw/mendix/editable_value
import mendraw/mendix/list_value

let status = list_value.status(data_source)
let display = editable_value.display_value(attribute)
editable_value.set_text_value(attribute, "Updated")
action.execute_action(on_click)

case mendix.get_prop(props, "optionalValue") {
  option.Some(value) -> value
  option.None -> fallback_value
}
```

Datasource-bound properties can be captured as one typed snapshot instead of
probing runtime shapes:

```gleam
import mendraw/datasource

case datasource.capture(props, "dataSource") {
  datasource.Available(_, data) -> render_rows(data.items)
  datasource.Loading(_) -> render_loading()
  datasource.PropertyAbsent(_) | datasource.Unavailable(_) -> render_empty()
}
```

Editable list-bound values can be read, parsed, compared, and written back
without local `instanceof` probes:

```gleam
import gleam/option
import mendraw/datasource
import mendraw/value_adapter

let editable = datasource.attribute_value(column_attribute, item)

case value_adapter.attribute_snapshot(column_attribute, item) {
  Ok(snapshot) ->
    case value_adapter.parse(snapshot.kind, edited_text) {
      Ok(option.Some(next)) -> value_adapter.write(editable, option.Some(next))
      Ok(option.None) -> value_adapter.write(editable, option.None)
      Error(error) -> show_conversion_error(error)
    }
  Error(error) -> show_adapter_error(error)
}
```


Important modules include:

| Module | Responsibility |
| --- | --- |
| `mendraw/mendix` | Core handles, status values, property access, option conversion |
| `mendraw/mendix/editable_value` | Editable values and validation |
| `mendraw/mendix/list_value` | Data-source paging, filtering, sorting, and reload |
| `mendraw/datasource` | Typed snapshots of datasource states, object lists, and item attributes |
| `mendraw/value_adapter` | Typed read, parse, compare, and write adapters for list-bound editable values |
| `mendraw/mendix/list_attribute` | Per-item attribute/action/expression access |
| `mendraw/mendix/filter` | Typed filter expression construction |
| `mendraw/mendix/date` | JavaScript date boundary |
| `mendraw/mendix/decimal` | Big.js boundary conversion |
| `mendraw/widget` | Generated pluggable component lookup and property adapters |
| `mendraw/classic` | Generated classic component lookup |
| `mendraw/interop` | Typed JavaScript component to Redraw element conversion |
| `mendraw/synthetic` | Mendix-compatible values for external data |

## Synthetic data

`mendraw/synthetic` can construct `ListValue`, `ObjectItem`, and
`ListAttributeValue` compatible objects for rendering an installed Mendix
widget outside the Mendix Runtime. It does not fetch remote data or install the
widget package; applications provide the data and mxpak provides the assets.

## Relationship to the other repositories

```text
mxpak       installs and caches package assets
  ↓ build/widgets/*
mendraw     generates typed bindings and models Mendix client values
  ↓ public Gleam APIs
glendix     builds Mendix widgets and provides the Lustre/React bridge
```

Each package can be used independently. A project that only needs Mendix client
types or synthetic values depends on Mendraw alone. A project that only needs
package acquisition uses mxpak alone.

## Development

```sh
gleam deps download
gleam format --check
gleam check
gleam build --warnings-as-errors
gleam docs build
gleam test --runtime bun
```

## License

[MIT License](LICENCE)
