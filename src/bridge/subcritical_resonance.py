from __future__ import annotations

from .prime_patterns import candidate_patterns
from .residue_shadow import residue_shadow_size
from .wheel_product_general import product_local_survivor_counts


GATES_235 = [2, 3, 5]
BT0009_K = 3
BT0009_D = 59
BT0009_MAX_SCORE = 6


def _as_offsets(H: list[int] | tuple[int, ...]) -> list[int]:
    return [int(h) for h in H]


def pattern_235_subcritical(H: list[int] | tuple[int, ...]) -> bool:
    offsets = _as_offsets(H)
    return (
        len(offsets) == BT0009_K
        and offsets[0] == 0
        and len(set(offsets)) == len(offsets)
        and all(0 <= h <= BT0009_D for h in offsets)
    )


def subcritical_235_patterns() -> list[list[int]]:
    return candidate_patterns(BT0009_K, BT0009_D)


def subcritical_235_score(H: list[int] | tuple[int, ...]) -> int:
    offsets = _as_offsets(H)
    if not pattern_235_subcritical(offsets):
        raise ValueError("pattern must be normalized, distinct, length 3, and bounded by 59")
    return product_local_survivor_counts(GATES_235, offsets)


def subcritical_235_structural_condition(H: list[int] | tuple[int, ...]) -> bool:
    offsets = _as_offsets(H)
    return (
        pattern_235_subcritical(offsets)
        and all(h % 6 == 0 for h in offsets)
        and residue_shadow_size(offsets, 5) == 2
    )


def explain_bt0009_maximizers() -> dict[str, object]:
    rows = [
        {
            "pattern": pattern,
            "score": subcritical_235_score(pattern),
            "all_offsets_divisible_by_6": all(h % 6 == 0 for h in pattern),
            "mod5_shadow_size": residue_shadow_size(pattern, 5),
            "structural_condition": subcritical_235_structural_condition(pattern),
        }
        for pattern in subcritical_235_patterns()
    ]
    max_score = max(int(row["score"]) for row in rows)
    maximizers = [row for row in rows if row["score"] == max_score]
    structural_patterns = [row for row in rows if row["structural_condition"]]
    return {
        "gates": GATES_235,
        "W": 30,
        "k": BT0009_K,
        "D": BT0009_D,
        "max_score": max_score,
        "maximizers": [row["pattern"] for row in maximizers],
        "structural_patterns": [row["pattern"] for row in structural_patterns],
        "maximizer_count": len(maximizers),
        "structural_count": len(structural_patterns),
        "structural_explanation": (
            "D=59 cannot fit [0,30,60]. The best patterns keep the 2- and "
            "3-gates locked by using multiples of 6, while occupying exactly "
            "two residue classes modulo 5, giving local factors 1*2*3=6."
        ),
    }


def verify_bt0009_subcritical_235() -> dict[str, object]:
    rows = [
        {
            "pattern": pattern,
            "score": subcritical_235_score(pattern),
            "structural_condition": subcritical_235_structural_condition(pattern),
        }
        for pattern in subcritical_235_patterns()
    ]
    max_score = max(int(row["score"]) for row in rows)
    maximizers = [row for row in rows if row["score"] == max_score]
    structural_patterns = [row for row in rows if row["structural_condition"]]
    over_bound = [row for row in rows if int(row["score"]) > BT0009_MAX_SCORE]
    bad_maximizers = [row for row in maximizers if not row["structural_condition"]]
    missed_structural = [row for row in structural_patterns if int(row["score"]) != BT0009_MAX_SCORE]

    return {
        "gates": GATES_235,
        "W": 30,
        "k": BT0009_K,
        "D": BT0009_D,
        "max_score": max_score,
        "expected_max_score": BT0009_MAX_SCORE,
        "checked_patterns": len(rows),
        "maximizers": [row["pattern"] for row in maximizers],
        "structural_patterns": [row["pattern"] for row in structural_patterns],
        "over_bound": over_bound,
        "bad_maximizers": bad_maximizers,
        "missed_structural": missed_structural,
        "holds": (
            max_score == BT0009_MAX_SCORE
            and not over_bound
            and not bad_maximizers
            and not missed_structural
            and [row["pattern"] for row in maximizers]
            == [row["pattern"] for row in structural_patterns]
        ),
    }
