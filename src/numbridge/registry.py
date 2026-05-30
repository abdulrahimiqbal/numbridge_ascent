from __future__ import annotations

from pathlib import Path
from typing import Iterable

from .md import MarkdownDoc, read_doc
from .paths import RepoPaths


CARD_DIRS = ("leads", "conjectures", "experiments", "bridge-cards", "bridge-theorems")


def iter_markdown(paths: RepoPaths) -> Iterable[Path]:
    for dirname in CARD_DIRS:
        directory = paths.root / dirname
        if directory.exists():
            yield from sorted(directory.glob("*.md"))


def load_cards(paths: RepoPaths) -> list[MarkdownDoc]:
    return [read_doc(path) for path in iter_markdown(paths)]


def find_card(paths: RepoPaths, identifier: str) -> MarkdownDoc | None:
    for doc in load_cards(paths):
        if doc.meta.get("id") == identifier:
            return doc
    return None


def next_id(paths: RepoPaths, prefix: str, directory: Path) -> str:
    max_num = 0
    for path in directory.glob(f"{prefix}-*.md"):
        stem = path.stem
        parts = stem.split("-", 2)
        if len(parts) >= 2 and parts[0] == prefix:
            try:
                max_num = max(max_num, int(parts[1]))
            except ValueError:
                pass
    return f"{prefix}-{max_num + 1:04d}"


def slugify(text: str) -> str:
    out: list[str] = []
    last_dash = False
    for ch in text.lower():
        if ch.isalnum():
            out.append(ch)
            last_dash = False
        elif not last_dash:
            out.append("-")
            last_dash = True
    return "".join(out).strip("-")[:80] or "untitled"
