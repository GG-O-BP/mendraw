[English](README.md) | [Korean](README.ko.md) | **Japanese**

# mendraw

`mendraw` は、Gleam から Mendix クライアント値と**インストール済み**の
`.mpk` ウィジェット資産を利用する JavaScript ターゲットのパッケージです。

責務は次に限定されます。

- Mendix Pluggable Widget クライアント API の型付きラッパー
- Pluggable/Classic ウィジェットの Redraw interop
- `build/widgets/*` からの決定的なバインディング生成
- Mendix 外の Web アプリ向け synthetic Mendix 互換値

Marketplace の検索、認証、ブラウザ自動化、ダウンロード、グローバルキャッシュ、
ロックファイルは Mendraw の責務ではありません。独立パッケージ
[`mxpak`](https://github.com/glendix-labs/mxpak) が担当します。

## インストール

```sh
gleam add mendraw@2
```

## インストール済み MPK の利用

### 1. mxpak で資産をインストール

```toml
[tools.mxpak]
mode = "extract"

[tools.mxpak.widgets.Charts]
version = "3.0.0"
# id = 12345
# s3_id = "com/..."
```

```sh
mxp install
```

mxpak を Git/path 依存として使う場合は次のエントリポイントも利用できます。

```sh
gleam run -t erlang -m mxpak/install
```

### 2. Mendraw バインディングを生成

```sh
gleam run -m mendraw/install
```

Mendraw は `build/widgets/` を読み、`src/widgets/*.gleam` と JavaScript
コンポーネントレジストリを生成します。再実行時も生成ソースを更新します。

### 3. レンダリング

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
    widget.prop("caption", "タイトル"),
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

## Classic ウィジェット

```gleam
import mendraw/classic

classic.render("CameraWidget.widget.CameraWidget", [
  #("mfToExecute", classic.to_value(microflow)),
  #("preferRearCamera", classic.to_value(True)),
])
```

バインディングがない場合、`render` と `render_with_class` は詳細な `Result`
エラーを返します。

## 主なモジュール

| モジュール | 責務 |
| --- | --- |
| `mendraw/mendix` | 基本 handle、状態、prop アクセス、Option 変換 |
| `mendraw/mendix/editable_value` | 編集可能値と validation |
| `mendraw/mendix/list_value` | data source の paging/filter/sort/reload |
| `mendraw/datasource` | データソース状態・オブジェクト一覧・項目属性の型付きスナップショット |
| `mendraw/value_adapter` | リスト束縛編集値の型付き読取・パース・比較・書き込みアダプター |
| `mendraw/mendix/list_attribute` | item 別 attribute/action/expression |
| `mendraw/mendix/filter` | 型付きフィルター式 |
| `mendraw/mendix/date` | JavaScript Date 境界 |
| `mendraw/mendix/decimal` | Big.js 境界変換 |
| `mendraw/widget` | 生成済み Pluggable コンポーネントと prop adapter |
| `mendraw/classic` | 生成済み Classic コンポーネント |
| `mendraw/interop` | JavaScript コンポーネントから Redraw element への変換 |
| `mendraw/synthetic` | 外部データ向け Mendix 互換値 |
データソースに束縛されたプロパティは、ランタイムの構造を直接調べずに
型付きスナップショットとして取得できます:

```gleam
import mendraw/datasource

case datasource.capture(props, "dataSource") {
  datasource.Available(_, data) -> render_rows(data.items)
  datasource.Loading(_) -> render_loading()
  datasource.PropertyAbsent(_) | datasource.Unavailable(_) -> render_empty()
}
```

リストに束縛された編集可能値は、ローカルな `instanceof` 検査なしで読み取り、
パースし、比較し、書き戻せます:

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


## リポジトリ間の関係

```text
mxpak       パッケージ資産のインストールとキャッシュ
  ↓ build/widgets/*
mendraw     型付きバインディング生成と Mendix クライアント値
  ↓ 公開 Gleam API
glendix     Mendix ウィジェットビルドと Lustre/React ブリッジ
```

Mendix 型や synthetic 値だけなら Mendraw のみ、パッケージ取得だけなら mxpak
のみを利用できます。

## 開発

```sh
gleam deps download
gleam format --check
gleam check
gleam build --warnings-as-errors
gleam docs build
gleam test --runtime bun
```

## ライセンス

[MIT ライセンス](LICENCE)
