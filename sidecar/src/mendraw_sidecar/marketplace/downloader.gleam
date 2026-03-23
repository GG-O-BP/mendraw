// 위젯 다운로드 + ZIP 추출 + TOML 관리

import gleam/bit_array
import gleam/http/request
import gleam/httpc
import gleam/int
import gleam/io
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/result
import gleam/string
import simplifile

// ── 타입 ──

pub type DownloadResult {
  DownloadResult(
    name: String,
    version: String,
    content_id: Option(Int),
    s3_id: String,
  )
}

// ── ZIP FFI ──

/// ZIP 바이너리를 메모리에 추출 → [(파일명, 내용)] 반환
@external(erlang, "mendraw_sidecar_zip_ffi", "unzip_to_memory")
fn unzip_to_memory(
  zip_binary: BitArray,
) -> Result(List(#(String, BitArray)), String)

// ── 다운로드 + 추출 ──

/// URL에서 .mpk를 다운로드하고 build/widgets/{name}/에 추출
pub fn download_and_extract(
  url: String,
  name: String,
  version: String,
  content_id: Option(Int),
  project_root: String,
) -> Result(DownloadResult, String) {
  let cache_dir = project_root <> "/build/widgets/" <> name
  let _ = simplifile.create_directory_all(cache_dir)

  // HTTP 다운로드
  use zip_data <- result.try(download_binary(url))

  // ZIP 메모리 추출
  use entries <- result.try(
    unzip_to_memory(zip_data)
    |> result.map_error(fn(e) { name <> " — 추출 실패: " <> e }),
  )

  // 파일 분류 및 저장
  let has_mjs = list.any(entries, fn(e) { string.ends_with(e.0, ".mjs") })

  // package.xml 저장
  list.each(entries, fn(entry) {
    let #(path, content) = entry
    let filename = basename(path)

    case filename {
      "package.xml" -> {
        let _ = simplifile.write_bits(cache_dir <> "/package.xml", content)
        Nil
      }
      _ -> Nil
    }
  })

  // 위젯 XML 경로 추출 (package.xml에서 widgetFile 속성)
  let widget_xml_paths = case
    list.find(entries, fn(e) { basename(e.0) == "package.xml" })
  {
    Ok(#(_, pkg_content)) ->
      case bit_array.to_string(pkg_content) {
        Ok(xml_str) -> extract_widget_file_paths(xml_str)
        Error(_) -> []
      }
    Error(_) -> []
  }

  // 위젯 XML 저장
  list.each(entries, fn(entry) {
    let #(path, content) = entry
    case list.contains(widget_xml_paths, path) {
      True -> {
        let _ =
          simplifile.write_bits(cache_dir <> "/" <> basename(path), content)
        Nil
      }
      False -> Nil
    }
  })

  // .mjs 파일 추출
  list.each(entries, fn(entry) {
    let #(path, content) = entry
    case string.ends_with(path, ".mjs") {
      True -> {
        let _ =
          simplifile.write_bits(cache_dir <> "/" <> basename(path), content)
        Nil
      }
      False -> Nil
    }
  })

  // .css 파일 추출 (editorPreview 제외)
  list.each(entries, fn(entry) {
    let #(path, content) = entry
    case
      string.ends_with(path, ".css") && !string.contains(path, "editorPreview")
    {
      True -> {
        let _ =
          simplifile.write_bits(cache_dir <> "/" <> basename(path), content)
        Nil
      }
      False -> Nil
    }
  })

  // Classic 위젯 (.mjs 없으면): .js, .html 파일을 경로 구조 유지
  case has_mjs {
    True -> Nil
    False ->
      list.each(entries, fn(entry) {
        let #(path, content) = entry
        case
          !string.ends_with(path, "/")
          && {
            string.ends_with(path, ".js") || string.ends_with(path, ".html")
          }
        {
          True -> {
            let out_path = cache_dir <> "/" <> path
            let dir = dirname(out_path)
            let _ = simplifile.create_directory_all(dir)
            let _ = simplifile.write_bits(out_path, content)
            Nil
          }
          False -> Nil
        }
      })
  }

  // meta.toml 기록
  let meta =
    "version = \""
    <> version
    <> "\"\n"
    <> case content_id {
      Some(id) -> "id = " <> int.to_string(id) <> "\n"
      None -> ""
    }
    <> case has_mjs {
      True -> ""
      False -> "classic = true\n"
    }
  let _ = simplifile.write(cache_dir <> "/meta.toml", meta)

  io.println(name <> " v" <> version <> " — 캐시 완료")
  Ok(DownloadResult(name, version, content_id, url))
}

// ── TOML 관리 ──

/// gleam.toml에 위젯 정보 기록
pub fn write_widget_toml(
  name: String,
  version: String,
  content_id: Option(Int),
  s3_id: Option(String),
  project_root: String,
) -> Result(Nil, String) {
  let toml_path = project_root <> "/gleam.toml"
  use content <- result.try(
    simplifile.read(toml_path)
    |> result.map_error(fn(_) { "gleam.toml 읽기 실패" }),
  )

  let section_header = "[tools.mendraw.widgets." <> quote_toml_key(name) <> "]"
  let entries =
    [#("version", "\"" <> version <> "\"")]
    |> append_if(content_id, fn(id) { #("id", int.to_string(id)) })
    |> append_if(s3_id, fn(s) { #("s3_id", "\"" <> s <> "\"") })

  let new_content = case string.contains(content, section_header) {
    True ->
      // 기존 섹션 업데이트
      list.fold(entries, content, fn(acc, entry) {
        update_toml_key(acc, section_header, entry.0, entry.1)
      })
    False -> {
      // 새 섹션 추가
      let section_content =
        list.map(entries, fn(e) { e.0 <> " = " <> e.1 })
        |> string.join("\n")
      content <> "\n\n" <> section_header <> "\n" <> section_content <> "\n"
    }
  }

  simplifile.write(toml_path, new_content)
  |> result.map_error(fn(_) { "gleam.toml 쓰기 실패" })
}

/// .env 파일에서 값 읽기
pub fn read_env_value(key: String, project_root: String) -> Option(String) {
  case simplifile.read(project_root <> "/.env") {
    Error(_) -> None
    Ok(content) -> {
      string.split(content, "\n")
      |> list.find_map(fn(line) {
        let trimmed = string.trim(line)
        case trimmed == "" || string.starts_with(trimmed, "#") {
          True -> Error(Nil)
          False ->
            case string.split_once(trimmed, "=") {
              Ok(#(k, v)) -> {
                case string.trim(k) == key {
                  True ->
                    Ok(
                      string.trim(v)
                      |> string.replace("\"", "")
                      |> string.replace("'", ""),
                    )
                  False -> Error(Nil)
                }
              }
              _ -> Error(Nil)
            }
        }
      })
      |> option.from_result
    }
  }
}

// ── 내부 헬퍼 ──

fn download_binary(url: String) -> Result(BitArray, String) {
  use req <- result.try(
    request.to(url)
    |> result.map_error(fn(_) { "잘못된 URL: " <> url }),
  )
  let config =
    httpc.configure()
    |> httpc.follow_redirects(True)
    |> httpc.timeout(60_000)

  let req = request.map(req, bit_array.from_string)
  httpc.dispatch_bits(config, req)
  |> result.map(fn(resp) { resp.body })
  |> result.map_error(fn(_) { "다운로드 실패" })
}

fn basename(path: String) -> String {
  case string.split(path, "/") |> list.last {
    Ok(name) -> name
    Error(_) -> path
  }
}

fn dirname(path: String) -> String {
  let parts = string.split(path, "/")
  case list.length(parts) > 1 {
    True ->
      list.take(parts, list.length(parts) - 1)
      |> string.join("/")
    False -> "."
  }
}

/// package.xml에서 widgetFile 경로 추출
fn extract_widget_file_paths(xml: String) -> List(String) {
  // 간단한 정규식 대체: widgetFile="..." 패턴 매칭
  do_extract_widget_paths(xml, [])
}

fn do_extract_widget_paths(remaining: String, acc: List(String)) -> List(String) {
  case string.split_once(remaining, "widgetFile=\"") {
    Ok(#(_, rest)) ->
      case string.split_once(rest, "\"") {
        Ok(#(path, after)) -> do_extract_widget_paths(after, [path, ..acc])
        Error(_) -> list.reverse(acc)
      }
    Error(_) -> list.reverse(acc)
  }
}

fn quote_toml_key(name: String) -> String {
  case
    string.contains(name, " ")
    || string.contains(name, "-")
    || string.contains(name, ".")
  {
    True -> "\"" <> name <> "\""
    False -> name
  }
}

fn update_toml_key(
  content: String,
  section_header: String,
  key: String,
  value: String,
) -> String {
  let lines = string.split(content, "\n")
  let #(result, _) =
    list.fold(lines, #([], False), fn(state, line) {
      let #(acc, in_section) = state
      let trimmed = string.trim(line)
      case in_section {
        False ->
          case trimmed == section_header {
            True -> #([line, ..acc], True)
            False -> #([line, ..acc], False)
          }
        True ->
          case string.starts_with(trimmed, "[") {
            True -> #([line, ..acc], False)
            False ->
              case
                string.starts_with(trimmed, key <> " ")
                || string.starts_with(trimmed, key <> "=")
              {
                True -> #([key <> " = " <> value, ..acc], True)
                False -> #([line, ..acc], True)
              }
          }
      }
    })
  list.reverse(result) |> string.join("\n")
}

fn append_if(
  entries: List(#(String, String)),
  opt: Option(a),
  to_entry: fn(a) -> #(String, String),
) -> List(#(String, String)) {
  case opt {
    Some(v) -> list.append(entries, [to_entry(v)])
    None -> entries
  }
}
