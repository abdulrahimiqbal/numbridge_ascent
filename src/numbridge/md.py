from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path
from typing import Any


@dataclass
class MarkdownDoc:
    path: Path
    meta: dict[str, Any]
    body: str


def _parse_scalar(value: str) -> Any:
    value = value.strip()
    if value == "":
        return None
    if value.lower() == "true":
        return True
    if value.lower() == "false":
        return False
    if value.startswith("[") and value.endswith("]"):
        inner = value[1:-1].strip()
        if not inner:
            return []
        return [item.strip().strip('"\'') for item in inner.split(",")]
    try:
        return int(value)
    except ValueError:
        return value.strip('"')


def parse_frontmatter(text: str) -> tuple[dict[str, Any], str]:
    if not text.startswith("---\n"):
        return {}, text
    parts = text.split("\n---\n", 1)
    if len(parts) != 2:
        return {}, text
    raw = parts[0].split("\n", 1)[1]
    body = parts[1]
    meta: dict[str, Any] = {}
    current_key: str | None = None
    for line in raw.splitlines():
        if not line.strip() or line.strip().startswith("#"):
            continue
        if line.startswith("  - ") and current_key:
            meta.setdefault(current_key, [])
            if not isinstance(meta[current_key], list):
                meta[current_key] = [meta[current_key]]
            meta[current_key].append(_parse_scalar(line[4:]))
            continue
        if ":" in line and not line.startswith(" "):
            key, value = line.split(":", 1)
            key = key.strip()
            current_key = key
            if value.strip() == "":
                meta[key] = []
            else:
                meta[key] = _parse_scalar(value)
    return meta, body


def read_doc(path: Path) -> MarkdownDoc:
    text = path.read_text(encoding="utf-8")
    meta, body = parse_frontmatter(text)
    return MarkdownDoc(path=path, meta=meta, body=body)


def dump_frontmatter(meta: dict[str, Any]) -> str:
    lines = ["---"]
    for key, value in meta.items():
        if isinstance(value, list):
            lines.append(f"{key}:")
            for item in value:
                lines.append(f"  - {item}")
        elif value is None:
            lines.append(f"{key}:")
        else:
            lines.append(f"{key}: {value}")
    lines.append("---")
    return "\n".join(lines) + "\n"


def write_doc(path: Path, meta: dict[str, Any], body: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(dump_frontmatter(meta) + body.lstrip(), encoding="utf-8")


def append_section(path: Path, heading: str, content: str) -> None:
    text = path.read_text(encoding="utf-8") if path.exists() else ""
    marker = f"\n## {heading}\n"
    if marker in text:
        before, _sep, _after = text.partition(marker)
        text = before.rstrip() + marker + "\n" + content.strip() + "\n"
    else:
        text = text.rstrip() + f"\n\n## {heading}\n\n" + content.strip() + "\n"
    path.write_text(text, encoding="utf-8")
