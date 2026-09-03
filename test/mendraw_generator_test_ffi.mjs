import {
  existsSync,
  mkdirSync,
  mkdtempSync,
  readFileSync,
  rmSync,
  writeFileSync,
} from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { Ok } from "./gleam.mjs";
import { generate_widget_bindings } from "./mendraw/cmd_ffi.mjs";

function inTemporaryProject(run) {
  const previousDirectory = process.cwd();
  const project = mkdtempSync(join(tmpdir(), "mendraw-generator-"));
  try {
    process.chdir(project);
    return run(project);
  } catch (error) {
    console.error("[mendraw test] generator fixture failed", error);
    return false;
  } finally {
    process.chdir(previousDirectory);
    rmSync(project, { recursive: true, force: true });
  }
}

export function empty_assets_remove_stale_bindings() {
  return inTemporaryProject(() => {
    mkdirSync("src/widgets", { recursive: true });
    writeFileSync("src/widgets/stale.gleam", "pub fn stale() { Nil }\n");
    const result = generate_widget_bindings();
    const runtimePath =
      "build/dev/javascript/mendraw/mendraw/widget_ffi.mjs";
    return result instanceof Ok
      && !existsSync("src/widgets/stale.gleam")
      && existsSync(runtimePath)
      && readFileSync(runtimePath, "utf-8").includes(
        "Install packages with mxpak",
      );
  });
}

export function pluggable_assets_generate_bindings() {
  return inTemporaryProject(() => {
    mkdirSync("build/widgets/Fixture", { recursive: true });
    writeFileSync(
      "build/widgets/Fixture/meta.toml",
      'version = "1.0.0"\n',
    );
    writeFileSync(
      "build/widgets/Fixture/Fixture.xml",
      '<widget id="Fixture.widget.Fixture"><name>Fixture</name>'
        + '<properties><property key="title" required="true" /></properties>'
        + "</widget>",
    );
    writeFileSync(
      "build/widgets/Fixture/Fixture.mjs",
      "export default function Fixture() { return null; }\n",
    );
    const result = generate_widget_bindings();
    const sourcePath = "src/widgets/fixture.gleam";
    const runtimePath =
      "build/dev/javascript/mendraw/mendraw/widget_ffi.mjs";
    return result instanceof Ok
      && existsSync(sourcePath)
      && readFileSync(sourcePath, "utf-8").includes(
        'widget.component("Fixture")',
      )
      && readFileSync(runtimePath, "utf-8").includes(
        '"Fixture": Fixture',
      );
  });
}

export function hostile_widget_names_generate_valid_bindings() {
  return inTemporaryProject(() => {
    function installWidget(dir, name, fileName) {
      mkdirSync(`build/widgets/${dir}`, { recursive: true });
      writeFileSync(
        `build/widgets/${dir}/meta.toml`,
        'version = "1.0.0"\n',
      );
      writeFileSync(
        `build/widgets/${dir}/${fileName}.xml`,
        `<widget id="Fixture.widget.${fileName}"><name>${name}</name>`
          + '<properties><property key="1st" required="true" /></properties>'
          + "</widget>",
      );
      writeFileSync(
        `build/widgets/${dir}/${fileName}.mjs`,
        `export default function ${fileName}() { return null; }\n`,
      );
    }
    installWidget("Digit", "123 Chart", "Digit");
    installWidget("Emoji", "😀", "Emoji");
    installWidget("Dash", "A-B", "Dash");
    installWidget("Space", "A B", "Space");
    const result = generate_widget_bindings();
    const runtime = readFileSync(
      "build/dev/javascript/mendraw/mendraw/widget_ffi.mjs",
      "utf-8",
    );
    return result instanceof Ok
      && existsSync("src/widgets/widget_123_chart.gleam")
      && existsSync("src/widgets/widget.gleam")
      && existsSync("src/widgets/ab.gleam")
      && existsSync("src/widgets/a_b.gleam")
      && runtime.includes("import widget_123Chart from")
      && runtime.includes("import widget from")
      && runtime.includes("import AB from")
      && runtime.includes("import AB_2 from")
      && runtime.includes('"123 Chart": widget_123Chart')
      && runtime.includes('"😀": widget')
      && runtime.includes('"A-B": AB')
      && runtime.includes('"A B": AB_2');
  });
}

export function classic_meta_with_comments_generate_bindings() {
  return inTemporaryProject(() => {
    mkdirSync("build/widgets/CommentGrid", { recursive: true });
    writeFileSync(
      "build/widgets/CommentGrid/meta.toml",
      'version = "1.0.0" # pinned by the installer\n'
        + "classic = true # legacy widget package\n"
        + 'label = "Keep # inside strings"\n',
    );
    writeFileSync(
      "build/widgets/CommentGrid/CommentGrid.xml",
      '<widget id="Classic.widget.CommentGrid">'
        + "<name>Comment Grid</name>"
        + '<properties><property key="title" required="true" /></properties>'
        + "</widget>",
    );
    writeFileSync(
      "build/widgets/CommentGrid/CommentGrid.js",
      "define([\"dojo/_base/declare\"], function(declare) { return declare(null, {}); });\n",
    );
    const result = generate_widget_bindings();
    const source = readFileSync(
      "src/widgets/comment_grid.gleam",
      "utf-8",
    );
    const runtime = readFileSync(
      "build/dev/javascript/mendraw/mendraw/classic_ffi.mjs",
      "utf-8",
    );
    return result instanceof Ok
      && source.includes('classic.render("Classic.widget.CommentGrid"')
      && runtime.includes('"CommentGrid": {')
      && runtime.includes('widgetId: "Classic.widget.CommentGrid"');
  });
}
