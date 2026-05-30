from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path


@dataclass(frozen=True)
class RepoPaths:
    root: Path

    @property
    def leads(self) -> Path:
        return self.root / "leads"

    @property
    def conjectures(self) -> Path:
        return self.root / "conjectures"

    @property
    def experiments(self) -> Path:
        return self.root / "experiments"

    @property
    def bridge_cards(self) -> Path:
        return self.root / "bridge-cards"

    @property
    def reports(self) -> Path:
        return self.root / "reports"

    @property
    def data_results(self) -> Path:
        return self.root / "data" / "experiment-results"

    @property
    def lean(self) -> Path:
        return self.root / "lean" / "NumBridge"


def find_repo_root(start: Path | None = None) -> Path:
    """Find the repository root by walking upward until README.md and src/ exist."""
    current = (start or Path.cwd()).resolve()
    for candidate in [current, *current.parents]:
        if (candidate / "README.md").exists() and (candidate / "src" / "numbridge").exists():
            return candidate
    return current
