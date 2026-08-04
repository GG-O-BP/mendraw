import { spawnSync } from "node:child_process";
import {
  existsSync,
  mkdirSync,
  readdirSync,
  readFileSync,
  statSync,
  unlinkSync,
  writeFileSync,
} from "node:fs";
import { Ok, Error as GleamError } from "../gleam.mjs";

function errorMessage(error) {
  return error instanceof globalThis.Error ? error.message : String(error);
}

export function command_error_message(error) {
  return errorMessage(error);
}

export function file_exists(path) {
  return existsSync(path);
}

function parseTomlValue(raw) {
  if (raw.startsWith('"') && raw.endsWith('"')) return raw.slice(1, -1);
  const number = Number.parseInt(raw, 10);
  if (!Number.isNaN(number) && String(number) === raw) return number;
  if (raw === "true") return true;
  if (raw === "false") return false;
  return raw;
}

function parseMetaToml(path) {
  const content = readFileSync(path, "utf-8");
  const result = {};
  for (const line of content.split(/\r?\n/)) {
    const match = line.match(/^(\w+)\s*=\s*(.+)$/);
    if (match) result[match[1]] = parseTomlValue(match[2].trim());
  }
  return result;
}

function resetGeneratedGleamBindings() {
  const directory = "src/widgets";
  if (!existsSync(directory)) return;
  for (const name of readdirSync(directory)) {
    if (name.endsWith(".gleam")) {
      unlinkSync(`${directory}/${name}`);
    }
  }
}

function resetGeneratedRuntimeBindings() {
  const basePaths = [
    "build/packages/mendraw/src/mendraw",
    "build/dev/javascript/mendraw/mendraw",
  ];
  for (const base of basePaths) {
    if (!existsSync(base)) mkdirSync(base, { recursive: true });
    writeFileSync(
      `${base}/widget_ffi.mjs`,
      `import { Error as GleamError } from "../gleam.mjs";\n\n` +
      `export function get_widget(name) {\n` +
      `  return new GleamError("Widget binding is not registered: " + name + ". Install packages with mxpak, then run mendraw/install.");\n` +
      `}\n\n` +
      `export function widget_error_message(error) {\n` +
      `  return error instanceof globalThis.Error ? error.message : String(error);\n` +
      `}\n`,
    );
    writeFileSync(
      `${base}/classic_ffi.mjs`,
      `import { Error as GleamError } from "../gleam.mjs";\n\n` +
      `export function classic_widget_element(widget_id, _properties) {\n` +
      `  return new GleamError("Classic widget binding is not registered: " + widget_id);\n` +
      `}\n\n` +
      `export function classic_widget_element_with_class(widget_id, _properties, _class_name) {\n` +
      `  return new GleamError("Classic widget binding is not registered: " + widget_id);\n` +
      `}\n\n` +
      `export function to_dynamic(value) { return value; }\n\n` +
      `export function classic_error_message(error) {\n` +
      `  return error instanceof globalThis.Error ? error.message : String(error);\n` +
      `}\n`,
    );
  }
}

function parseWidgetName(xmlString) {
  const match = xmlString.match(/<name>([^<]+)<\/name>/);
  return match ? match[1] : null;
}
function toSafeIdentifier(name) {
  return name.replace(/[^a-zA-Z0-9_$]/g, "");
}
function parseProperties(widgetXml) {
  const properties = [];
  const regex = /<property\s+([^>]*)(?:\/>|>[\s\S]*?<\/property>)/g;
  let match;
  while ((match = regex.exec(widgetXml)) !== null) {
    const attrs = match[1];
    const keyMatch = attrs.match(/key="([^"]+)"/);
    const requiredMatch = attrs.match(/required="([^"]+)"/);
    if (keyMatch) {
      properties.push({
        key: keyMatch[1],
        required: requiredMatch ? requiredMatch[1] === "true" : false,
      });
    }
  }
  return properties;
}
function hasDefaultExport(src) {
  return /\bexport\s+default\b/.test(src) ||
    /\bexport\s*\{[^}]*\bas\s+default\b/.test(src);
}
function findNamedExport(src) {
  const blockMatch = src.match(/\bexport\s*\{([^}]+)\}/);
  if (blockMatch) {
    for (const entry of blockMatch[1].split(",")) {
      const parts = entry.trim().split(/\s+as\s+/);
      const name = parts.length === 2 ? parts[1].trim() : parts[0].trim();
      if (name && name !== "default") return name;
    }
  }
  // export const/let/var/function/class Name
  const declMatch = src.match(/\bexport\s+(?:const|let|var|function|class)\s+(\w+)/);
  if (declMatch) return declMatch[1];
  return null;
}
function toSnakeCase(str) {
  return str
    .replace(/([a-z0-9])([A-Z])/g, "$1_$2")
    .replace(/([A-Z])([A-Z][a-z])/g, "$1_$2")
    .toLowerCase();
}
function toModuleFileName(name) {
  return name
    .replace(/\s+/g, "_")
    .replace(/([a-z0-9])([A-Z])/g, "$1_$2")
    .replace(/([A-Z])([A-Z][a-z])/g, "$1_$2")
    .toLowerCase();
}
const GLEAM_KEYWORDS = new Set([
  "as", "assert", "auto", "case", "const", "delegate", "derive", "echo",
  "else", "fn", "if", "implement", "import", "let", "macro", "opaque",
  "panic", "pub", "return", "test", "todo", "type", "use",
]);
function toGleamVar(key) {
  const snake = toSnakeCase(key);
  return GLEAM_KEYWORDS.has(snake) ? snake + "_" : snake;
}
function formatGeneratedGleamFile(filePath) {
  const result = spawnSync("gleam", ["format", filePath], {
    encoding: "utf-8",
  });
  if (result.error) {
    throw new Error(`Generated Gleam file could not be formatted: ${filePath}`, {
      cause: result.error,
    });
  }
  if (result.status !== 0) {
    throw new Error(
      `Generated Gleam file could not be formatted: ${filePath}: ${result.stderr.trim()}`,
    );
  }
}
function generateWidgetGleamFile(widgetName, widgetXml) {
  const props = parseProperties(widgetXml);
  if (props.length === 0) return;
  const requiredProps = props.filter((p) => p.required);
  const optionalProps = props.filter((p) => !p.required);
  const hasOptional = optionalProps.length > 0;
  const moduleFileName = toModuleFileName(widgetName);
  const filePath = `src/widgets/${moduleFileName}.gleam`;
  if (!existsSync("src/widgets")) {
    mkdirSync("src/widgets", { recursive: true });
  }
  let imports = "import gleam/result\n";
  if (hasOptional) imports += "import gleam/option\n";
  imports += "import mendraw/interop\n";
  imports += "import mendraw/mendix\n";
  imports += "import mendraw/widget\n";
  imports += "import redraw\n";
  imports += "import redraw/dom/attribute\n";
  let body = "";
  for (const prop of requiredProps) {
    body += `  let ${toGleamVar(prop.key)} = mendix.get_prop_required(props, "${prop.key}")\n`;
  }
  body += `\n  use component <- result.try(widget.component("${widgetName}"))\n`;
  body += "  interop.component_el(\n    comp,\n    [\n";
  for (const prop of requiredProps) {
    body += `      attribute.attribute("${prop.key}", ${toGleamVar(prop.key)}),\n`;
  }
  for (const prop of optionalProps) {
    body += `      optional_attr(props, "${prop.key}"),\n`;
  }
  body = body.replace("    comp,", "    component,");
  body += "    ],\n    [],\n  )\n  |> Ok\n";
  let content =
    `//// Generated Mendix widget binding for ${widgetName}.\n` +
    `////\n` +
    `//// Do not edit this file manually.\n` +
    `//// Generator: mendraw/src/mendraw/cmd_ffi.mjs\n` +
    `//// Regenerate with:\n` +
    `////\n` +
    `////     gleam run -m mendraw/install\n\n`;
  content += imports;
  content += "\n";
  content += `/// Renders ${widgetName} from Mendix properties.\n`;
  content +=
    "pub fn render(\n" +
    "  props props: mendix.JsProps,\n" +
    ") -> Result(redraw.Element, widget.WidgetError) {\n";
  content += body;
  content += "}\n";
  if (hasOptional) {
    content += "\n";
    content +=
      "fn optional_attribute(\n" +
      "  props: mendix.JsProps,\n" +
      "  key: String,\n" +
      ") -> attribute.Attribute {\n";
    content += "  case mendix.get_prop(props, key) {\n";
    content += "    option.Some(value) -> attribute.attribute(key, value)\n";
    content += "    option.None -> attribute.none()\n";
    content += "  }\n";
    content += "}\n";
  }
  content = content.replaceAll("optional_attr(", "optional_attribute(");
  writeFileSync(filePath, content);
  formatGeneratedGleamFile(filePath);
  console.log(`Generated widget binding module: ${filePath}`);
}
function classifyClassicFiles(fileEntries) {
  const jsFiles = {}, templateFiles = {}, libFiles = {};
  let css = "";
  for (const [path, content] of fileEntries) {
    if (path.endsWith(".js")) {
      if (path.includes("/lib/")) libFiles[path] = content;
      else jsFiles[path] = content;
    } else if (path.endsWith(".html")) {
      templateFiles[path] = content;
    } else if (path.endsWith(".css")) {
      css += content + "\n";
    }
  }
  return { jsFiles, templateFiles, css: css.trim(), libFiles };
}
function readClassicFromCache(cacheDir) {
  const fileEntries = [];
  function walk(dir) {
    for (const name of readdirSync(dir)) {
      const full = `${dir}/${name}`;
      if (statSync(full).isDirectory()) { walk(full); continue; }
      if (name.endsWith(".js") || name.endsWith(".html") || name.endsWith(".css")) {
        const rel = full.substring(cacheDir.length + 1).replace(/\\/g, "/");
        fileEntries.push([rel, readFileSync(full, "utf-8")]);
      }
    }
  }
  walk(cacheDir);
  return classifyClassicFiles(fileEntries);
}
function generateClassicGleamFile(widgetName, widgetId, properties) {
  const moduleFileName = toModuleFileName(widgetName);
  const filePath = `src/widgets/${moduleFileName}.gleam`;
  if (!existsSync("src/widgets")) {
    mkdirSync("src/widgets", { recursive: true });
  }
  const requiredProps = properties.filter((p) => p.required);
  const optionalProps = properties.filter((p) => !p.required);
  const hasOptional = optionalProps.length > 0;
  let imports = "";
  if (hasOptional) imports += "import gleam/option\n";
  imports += "import mendraw/classic\n";
  imports += "import mendraw/mendix\n";
  imports += "import redraw\n";
  let body = "";
  for (const prop of requiredProps) {
    body += `  let ${toGleamVar(prop.key)} = mendix.get_prop_required(props, "${prop.key}")\n`;
  }
  body += `\n  classic.render("${widgetId}", [\n`;
  for (const prop of requiredProps) {
    body += `    #("${prop.key}", classic.to_value(${toGleamVar(prop.key)})),\n`;
  }
  for (const prop of optionalProps) {
    body += `    optional_prop(props, "${prop.key}"),\n`;
  }
  body += "  ])\n";
  let content =
    `//// Generated classic Mendix widget binding for ${widgetName}.\n` +
    `////\n` +
    `//// Do not edit this file manually.\n` +
    `//// Generator: mendraw/src/mendraw/cmd_ffi.mjs\n` +
    `//// Regenerate with:\n` +
    `////\n` +
    `////     gleam run -m mendraw/install\n\n`;
  content += imports;
  content += "\n";
  content += `/// Renders the classic ${widgetName} widget from Mendix properties.\n`;
  content +=
    "pub fn render(\n" +
    "  props props: mendix.JsProps,\n" +
    ") -> Result(redraw.Element, classic.ClassicError) {\n";
  content += body;
  content += "}\n";
  if (hasOptional) {
    content += "\n";
    content +=
      "fn optional_property(\n" +
      "  props: mendix.JsProps,\n" +
      "  key: String,\n" +
      ") -> #(String, classic.ClassicValue) {\n";
    content += "  case mendix.get_prop(props, key) {\n";
    content += "    option.Some(value) -> #(key, classic.to_value(value))\n";
    content += "    option.None -> #(key, classic.to_value(Nil))\n";
    content += "  }\n";
    content += "}\n";
  }
  content = content.replaceAll("optional_prop(", "optional_property(");
  writeFileSync(filePath, content);
  formatGeneratedGleamFile(filePath);
  console.log(`Generated classic widget binding module: ${filePath}`);
}
function escapeForTemplate(str) {
  return str.replace(/\\/g, "\\\\").replace(/`/g, "\\`").replace(/\$/g, "\\$");
}
function generateClassicFfi(classicWidgets) {
  if (classicWidgets.length === 0) return;
  const widgetEntries = [];
  for (const w of classicWidgets) {
    const jsEntries = Object.entries(w.jsFiles)
      .map(([path, code]) => `      "${path}": \`${escapeForTemplate(code)}\``)
      .join(",\n");
    const templateEntries = Object.entries(w.templateFiles)
      .map(([path, html]) => `      "${path}": \`${escapeForTemplate(html)}\``)
      .join(",\n");
    const libEntries = Object.entries(w.libFiles)
      .map(([path, code]) => `      "${path}": \`${escapeForTemplate(code)}\``)
      .join(",\n");
    widgetEntries.push(
      `  "${w.safeId}": {\n` +
      `    widgetId: "${w.widgetId}",\n` +
      `    js: {\n${jsEntries}\n    },\n` +
      `    templates: {\n${templateEntries}\n    },\n` +
      `    css: \`${escapeForTemplate(w.css)}\`,\n` +
      `    libs: {\n${libEntries}\n    },\n` +
      `  }`,
    );
  }
  const content =
    `// Generated by mendraw/install. Do not edit manually.\n` +
    `import * as React from "react";\n` +
    `import { Ok, Error as GleamError } from "../gleam.mjs";\n\n` +
    `const _classicWidgets = {\n${widgetEntries.join(",\n")}\n};\n\n` +
    `const _injectedCss = new Set();\n` +
    `function injectCss(name, css) {\n` +
    `  if (!css || _injectedCss.has(name)) return;\n` +
    `  _injectedCss.add(name);\n` +
    `  const style = document.createElement("style");\n` +
    `  style.setAttribute("data-classic-widget", name);\n` +
    `  style.textContent = css;\n` +
    `  document.head.appendChild(style);\n` +
    `}\n\n` +
    `const _registeredModules = new Set();\n` +
    `function registerAmdModules(widget) {\n` +
    `  // Register library files before widget modules.\n` +
    `  for (const [path, code] of Object.entries(widget.libs)) {\n` +
    `    const moduleId = path.replace(/\\.js$/, "");\n` +
    `    if (_registeredModules.has(moduleId)) continue;\n` +
    `    _registeredModules.add(moduleId);\n` +
    `    const script = document.createElement("script");\n` +
    `    script.textContent = code;\n` +
    `    document.head.appendChild(script);\n` +
    `  }\n` +
    `  // Register widget JavaScript modules.\n` +
    `  for (const [path, code] of Object.entries(widget.js)) {\n` +
    `    const moduleId = path.replace(/\\.js$/, "");\n` +
    `    if (_registeredModules.has(moduleId)) continue;\n` +
    `    _registeredModules.add(moduleId);\n` +
    `    const script = document.createElement("script");\n` +
    `    script.textContent = code;\n` +
    `    document.head.appendChild(script);\n` +
    `  }\n` +
    `}\n\n` +
    `function registerTemplates(widget) {\n` +
    `  if (typeof window.require === "undefined" || !window.require.cache) return;\n` +
    `  for (const [path, html] of Object.entries(widget.templates)) {\n` +
    `    const cacheKey = "url:dojo/text!" + path;\n` +
    `    if (!window.require.cache[cacheKey]) {\n` +
    `      window.require.cache[cacheKey] = html;\n` +
    `    }\n` +
    `  }\n` +
    `}\n\n` +
    `function mountClassicWidget(widgetId, container, properties) {\n` +
    `  // Derive the asset key from the widget identifier.\n` +
    `  const assetKey = widgetId.split(".")[0];\n` +
    `  const widget = _classicWidgets[assetKey];\n` +
    `  if (!widget) {\n` +
    `    console.error("Classic 위젯을 찾을 수 없습니다: " + assetKey);\n` +
    `    return Promise.resolve(null);\n` +
    `  }\n\n` +
    `  // Register the widget assets.\n` +
    `  injectCss(assetKey, widget.css);\n` +
    `  registerTemplates(widget);\n` +
    `  registerAmdModules(widget);\n\n` +
    `  // Load the widget module through AMD require.\n` +
    `  return new Promise((resolve) => {\n` +
    `    if (typeof window.require !== "function") {\n` +
    `      console.error("AMD 로더(window.require)가 없습니다. Mendix 런타임 내에서 실행하세요.");\n` +
    `      resolve(null);\n` +
    `      return;\n` +
    `    }\n` +
    `    window.require([widgetId], (WidgetClass) => {\n` +
    `      try {\n` +
    `        const props = {};\n` +
    `        for (const [key, value] of properties) {\n` +
    `          props[key] = value;\n` +
    `        }\n` +
    `        const instance = new WidgetClass(props, container);\n` +
    `        if (typeof instance.startup === "function") instance.startup();\n` +
    `        resolve(instance);\n` +
    `      } catch (e) {\n` +
    `        console.error("Classic 위젯 마운트 실패: " + e.message);\n` +
    `        resolve(null);\n` +
    `      }\n` +
    `    }, (err) => {\n` +
    `      console.error("Classic 위젯 AMD 로드 실패: " + err);\n` +
    `      resolve(null);\n` +
    `    });\n` +
    `  });\n` +
    `}\n\n` +
    `function ClassicWidgetWrapper({ widgetId, properties, className }) {\n` +
    `  const containerRef = React.useRef(null);\n` +
    `  const instanceRef = React.useRef(null);\n\n` +
    `  React.useEffect(() => {\n` +
    `    if (!containerRef.current) return;\n` +
    `    let cancelled = false;\n\n` +
    `    mountClassicWidget(widgetId, containerRef.current, properties).then((inst) => {\n` +
    `      if (cancelled) {\n` +
    `        if (inst) destroyWidget(inst);\n` +
    `        return;\n` +
    `      }\n` +
    `      instanceRef.current = inst;\n` +
    `    });\n\n` +
    `    return () => {\n` +
    `      cancelled = true;\n` +
    `      if (instanceRef.current) {\n` +
    `        destroyWidget(instanceRef.current);\n` +
    `        instanceRef.current = null;\n` +
    `      }\n` +
    `    };\n` +
    `  }, [widgetId]);\n\n` +
    `  return React.createElement("div", { ref: containerRef, className: className || undefined });\n` +
    `}\n\n` +
    `function destroyWidget(instance) {\n` +
    `  try {\n` +
    `    if (typeof instance.uninitialize === "function") instance.uninitialize();\n` +
    `    if (typeof instance.destroyRecursive === "function") instance.destroyRecursive();\n` +
    `    else if (typeof instance.destroy === "function") instance.destroy();\n` +
    `  } catch (error) { console.warn("[mendraw] classic widget cleanup failed", error); }\n` +
    `}\n\n` +
    `const MemoizedWrapper = React.memo(ClassicWidgetWrapper);\n\n` +
    `export function classic_widget_element(widget_id, properties) {\n` +
    `  try {\n` +
    `    const asset_key = widget_id.split(".")[0];\n` +
    `    if (!_classicWidgets[asset_key]) {\n` +
    `      return new GleamError("Classic widget binding is not registered: " + widget_id);\n` +
    `    }\n` +
    `    const props = properties.toArray();\n` +
    `    return new Ok(React.createElement(MemoizedWrapper, {\n` +
    `      widgetId: widget_id,\n` +
    `      properties: props,\n` +
    `    }));\n` +
    `  } catch (error) {\n` +
    `    return new GleamError(error);\n` +
    `  }\n` +
    `}\n\n` +
    `export function classic_widget_element_with_class(widget_id, properties, class_name) {\n` +
    `  try {\n` +
    `    const asset_key = widget_id.split(".")[0];\n` +
    `    if (!_classicWidgets[asset_key]) {\n` +
    `      return new GleamError("Classic widget binding is not registered: " + widget_id);\n` +
    `    }\n` +
    `    const props = properties.toArray();\n` +
    `    return new Ok(React.createElement(MemoizedWrapper, {\n` +
    `      widgetId: widget_id,\n` +
    `      properties: props,\n` +
    `      className: class_name,\n` +
    `    }));\n` +
    `  } catch (error) {\n` +
    `    return new GleamError(error);\n` +
    `  }\n` +
    `}\n\n` +
    `export function to_dynamic(value) {\n` +
    `  return value;\n` +
    `}\n\n` +
    `export function classic_error_message(error) {\n` +
    `  return error instanceof globalThis.Error ? error.message : String(error);\n` +
    `}\n`;
  const basePaths = [
    "build/packages/mendraw/src/mendraw",
    "build/dev/javascript/mendraw/mendraw",
  ];
  let written = 0;
  for (const base of basePaths) {
    mkdirSync(base, { recursive: true });
    writeFileSync(`${base}/classic_ffi.mjs`, content);
    written++;
  }
  if (written > 0) {
    const names = classicWidgets.map((w) => w.name).join(", ");
    console.log(`Classic 위젯 바인딩 생성 완료: ${names}`);
  }
}
// Rewrite relative imports in widget .mjs that reference shared deps
// e.g. from"../../../shared/charts/esm/shared-charts.mjs" → from"./shared-charts.mjs"
function rewriteSharedImports(mjsContent, sharedFiles) {
  if (!sharedFiles || sharedFiles.length === 0) return mjsContent;
  let src = typeof mjsContent === "string" ? mjsContent : mjsContent.toString("utf8");
  const sharedNames = new Set(sharedFiles.map(f => f.name));
  // Match import paths like from"../../../anything/shared-charts.mjs"
  // and rewrite to from"./shared-charts.mjs" if the basename is a known shared file
  src = src.replace(/(from\s*["'])([^"']+)(["'])/g, (match, pre, importPath, post) => {
    // Skip npm packages (no ./ or ../)
    if (!importPath.startsWith(".")) return match;
    const basename = importPath.split("/").pop();
    if (sharedNames.has(basename)) {
      return `${pre}./${basename}${post}`;
    }
    return match;
  });
  return Buffer.from(src, "utf8");
}
function generateWidgetBindingsOrThrow() {
  resetGeneratedGleamBindings();
  resetGeneratedRuntimeBindings();
  const hasCacheDir = existsSync("build/widgets");
  if (!hasCacheDir) return;
  const widgets = []; // pluggable: { name, safeId, mjsContent, cssContent }
  const classicWidgets = []; // classic: { name, safeId, widgetId, jsFiles, templateFiles, css, libFiles }
  const processedNames = new Set();
  const cacheDirs = readdirSync("build/widgets");
  for (const dirName of cacheDirs) {
      const cacheDir = `build/widgets/${dirName}`;
      if (!statSync(cacheDir).isDirectory()) continue;
      const metaPath = `${cacheDir}/meta.toml`;
      if (!existsSync(metaPath)) continue;
      const files = readdirSync(cacheDir);
      const xmlFiles = files.filter(f => f.endsWith(".xml") && f !== "package.xml");
      const mjsFiles = files.filter(f => f.endsWith(".mjs"));
      if (mjsFiles.length === 0) {
        const meta = parseMetaToml(metaPath);
        if (!meta.classic) continue;
        const { jsFiles, templateFiles, css, libFiles } = readClassicFromCache(cacheDir);
        for (const xmlFile of xmlFiles) {
          const widgetXml = readFileSync(`${cacheDir}/${xmlFile}`, "utf-8");
          const widgetName = parseWidgetName(widgetXml);
          if (!widgetName || processedNames.has(widgetName)) continue;
          const idMatch = widgetXml.match(/widget\s+[^>]*id="([^"]+)"/);
          if (!idMatch) continue;
          const properties = parseProperties(widgetXml);
          generateClassicGleamFile(widgetName, idMatch[1], properties);
          classicWidgets.push({
            name: widgetName,
            safeId: toSafeIdentifier(widgetName),
            widgetId: idMatch[1],
            jsFiles, templateFiles, css, libFiles,
          });
          processedNames.add(widgetName);
        }
        continue;
      }
      // Collect widget mjs filenames to distinguish from shared deps
      const widgetMjsNames = new Set();
      for (const xmlFile of xmlFiles) {
        const xmlBase = xmlFile.replace(/\.xml$/, "");
        const mjsFile = mjsFiles.find(f => f.replace(/\.mjs$/, "") === xmlBase)
          || (xmlFiles.length === 1 ? mjsFiles[0] : null);
        if (mjsFile) widgetMjsNames.add(mjsFile);
      }
      // Collect shared dependency files (non-widget .mjs/.css in cache dir)
      const sharedFiles = [];
      for (const f of files) {
        if (f === "meta.toml" || f === "package.xml" || f.endsWith(".xml")) continue;
        if (widgetMjsNames.has(f)) continue;
        if (f.endsWith(".mjs") || f.endsWith(".css")) {
          sharedFiles.push({ name: f, content: readFileSync(`${cacheDir}/${f}`) });
        }
      }
      for (const xmlFile of xmlFiles) {
        const widgetXml = readFileSync(`${cacheDir}/${xmlFile}`, "utf-8");
        const widgetName = parseWidgetName(widgetXml);
        if (!widgetName || processedNames.has(widgetName)) continue;
        const xmlBase = xmlFile.replace(/\.xml$/, "");
        const mjsFile = mjsFiles.find(f => f.replace(/\.mjs$/, "") === xmlBase)
          || (xmlFiles.length === 1 ? mjsFiles[0] : null);
        if (!mjsFile) continue;
        let mjsContent = readFileSync(`${cacheDir}/${mjsFile}`);
        // Rewrite relative imports that reference shared deps
        // e.g. from"../../../shared/charts/esm/shared-charts.mjs" → from"./shared-charts.mjs"
        mjsContent = rewriteSharedImports(mjsContent, sharedFiles);
        const cssBase = xmlBase;
        const cssFile = files.find(f => f.replace(/\.css$/, "") === cssBase && !f.includes("editorPreview"))
          || files.find(f => f.endsWith(".css") && !f.includes("editorPreview"));
        const cssContent = cssFile ? readFileSync(`${cacheDir}/${cssFile}`) : null;
        generateWidgetGleamFile(widgetName, widgetXml);
        const safeId = toSafeIdentifier(widgetName);
        widgets.push({ name: widgetName, safeId, mjsContent, cssContent, sharedFiles });
        processedNames.add(widgetName);
      }
      if (xmlFiles.length === 0 && mjsFiles.length > 0) {
        const mjsFile = mjsFiles[0];
        const mjsContent = readFileSync(`${cacheDir}/${mjsFile}`);
        const cssFile = files.find(f => f.endsWith(".css") && !f.includes("editorPreview"));
        const cssContent = cssFile ? readFileSync(`${cacheDir}/${cssFile}`) : null;
        const safeId = toSafeIdentifier(dirName);
        if (!processedNames.has(dirName)) {
          widgets.push({ name: dirName, safeId, mjsContent, cssContent });
          processedNames.add(dirName);
        }
      }
  }
  if (widgets.length === 0 && classicWidgets.length === 0) return;
  if (widgets.length > 0) {
    const cssImports = widgets
      .filter((w) => w.cssContent)
      .map((w) => `import "./widgets/${w.safeId}.css";`)
      .join("\n");
    const mjsImports = widgets
      .map((w) => {
        const src = w.mjsContent ? w.mjsContent.toString("utf8") : "";
        const path = `./widgets/${w.safeId}.mjs`;
        if (hasDefaultExport(src)) {
          return `import ${w.safeId} from "${path}";`;
        }
        const exportName = findNamedExport(src);
        if (exportName && exportName !== w.safeId) {
          return `import { ${exportName} as ${w.safeId} } from "${path}";`;
        }
        if (exportName) {
          return `import { ${w.safeId} } from "${path}";`;
        }
        return `import ${w.safeId} from "${path}";`;
      })
      .join("\n");
    const widgetEntries = widgets
      .map((w) => `  "${w.name}": ${w.safeId}`)
      .join(",\n");
    const content =
      `// Generated by mendraw/install. Do not edit manually.\n` +
      (cssImports ? cssImports + "\n" : "") +
      mjsImports +
      "\n" +
      `import { Ok, Error as GleamError } from "../gleam.mjs";\n\n` +
      `const _widgets = {\n${widgetEntries}\n};\n\n` +
      `export function get_widget(name) {\n` +
      `  const w = _widgets[name];\n` +
      `  if (!w) {\n` +
      `    return new GleamError("Widget binding is not registered: " + name + ". Install packages with mxpak, then run mendraw/install.");\n` +
      `  }\n` +
      `  return new Ok(w);\n` +
      `}\n\n` +
      `export function widget_error_message(error) {\n` +
      `  return error instanceof globalThis.Error ? error.message : String(error);\n` +
      `}\n`;
    const basePaths = [
      "build/packages/mendraw/src/mendraw",
      "build/dev/javascript/mendraw/mendraw",
    ];
    let written = 0;
    for (const base of basePaths) {
        const dir = base;
        mkdirSync(dir, { recursive: true });
        writeFileSync(`${base}/widget_ffi.mjs`, content);
        const widgetsDir = `${base}/widgets`;
        if (!existsSync(widgetsDir)) {
          mkdirSync(widgetsDir, { recursive: true });
        }
        const copiedShared = new Set();
        for (const w of widgets) {
          writeFileSync(`${widgetsDir}/${w.safeId}.mjs`, w.mjsContent);
          if (w.cssContent) {
            writeFileSync(`${widgetsDir}/${w.safeId}.css`, w.cssContent);
          }
          // Copy shared dependency files alongside widget files
          if (w.sharedFiles) {
            for (const sf of w.sharedFiles) {
              if (!copiedShared.has(sf.name)) {
                writeFileSync(`${widgetsDir}/${sf.name}`, sf.content);
                copiedShared.add(sf.name);
              }
            }
          }
        }
        written++;
    }
    if (written > 0) {
      const names = widgets.map((w) => w.name).join(", ");
      console.log(`위젯 바인딩 생성 완료: ${names}`);
    }
  }
  generateClassicFfi(classicWidgets);
}

export function generate_widget_bindings() {
  try {
    generateWidgetBindingsOrThrow();
    return new Ok(undefined);
  } catch (error) {
    return new GleamError(error);
  }
}
