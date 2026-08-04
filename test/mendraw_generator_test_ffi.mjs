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
