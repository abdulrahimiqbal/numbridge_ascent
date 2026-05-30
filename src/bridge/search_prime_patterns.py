from __future__ import annotations

from typing import Iterable

from .prime_patterns import count_prime_translates, normalize_offsets
from .residue_shadow import admissibility_witnesses, shadow_profile
from .resonance import (
    compare_observed_to_resonance,
    rank_patterns_by_resonance,
    search_admissible_patterns,
    truncated_singular_series,
)


def pattern_summary(H: Iterable[int], prime_bound: int = 31, N: int | None = None) -> dict[str, object]:
    offsets = normalize_offsets(H)
    witnesses = admissibility_witnesses(offsets)
    summary: dict[str, object] = {
        "pattern": offsets,
        "admissible": not witnesses,
        "classification": "admissible" if not witnesses else "obstructed",
        "obstruction_witnesses": witnesses,
        "shadow_profile": shadow_profile(offsets, prime_bound),
        "truncated_singular_series": 0.0 if witnesses else truncated_singular_series(offsets, prime_bound),
    }
    if N is not None:
        comparison = compare_observed_to_resonance(offsets, N, prime_bound)
        summary["observed_prime_translates"] = count_prime_translates(offsets, N)
        summary["empirical_comparison"] = comparison
    return summary


__all__ = [
    "admissibility_witnesses",
    "compare_observed_to_resonance",
    "count_prime_translates",
    "normalize_offsets",
    "pattern_summary",
    "rank_patterns_by_resonance",
    "search_admissible_patterns",
    "shadow_profile",
    "truncated_singular_series",
]
