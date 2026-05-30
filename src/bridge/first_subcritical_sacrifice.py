from __future__ import annotations

from math import gcd
from typing import Iterable

from .prime_patterns import candidate_patterns
from .residue_shadow import residue_shadow_size
from .wheel_product_general import product_local_survivor_counts


def _validate_q(q: int) -> int:
    value = int(q)
    if value < 5:
        raise ValueError("q must be at least 5")
    if gcd(value, 6) != 1:
        raise ValueError("q must be coprime to 6")
    return value


def _as_offsets(H: Iterable[int]) -> list[int]:
    return [int(h) for h in H]


def first_subcritical_bound(q: int) -> int:
    qv = _validate_q(q)
    return 12 * qv - 1


def first_subcritical_max_score(q: int) -> int:
    qv = _validate_q(q)
    return 2 * (qv - 2)


def first_subcritical_score(q: int, H: Iterable[int]) -> int:
    qv = _validate_q(q)
    offsets = _as_offsets(H)
    if not first_subcritical_pattern(qv, offsets):
        raise ValueError("pattern must be normalized, distinct, length 3, and inside D=12*q-1")
    return product_local_survivor_counts([2, 3, qv], offsets)


def first_subcritical_pattern(q: int, H: Iterable[int]) -> bool:
    qv = _validate_q(q)
    offsets = _as_offsets(H)
    D = first_subcritical_bound(qv)
    return (
        len(offsets) == 3
        and bool(offsets)
        and offsets[0] == 0
        and len(set(offsets)) == len(offsets)
        and all(0 <= h <= D for h in offsets)
    )


def first_subcritical_structural_condition(q: int, H: Iterable[int]) -> bool:
    qv = _validate_q(q)
    offsets = _as_offsets(H)
    return (
        first_subcritical_pattern(qv, offsets)
        and all(h % 6 == 0 for h in offsets)
        and residue_shadow_size(offsets, qv) == 2
    )


def canonical_first_subcritical_attainer(q: int) -> list[int]:
    qv = _validate_q(q)
    return [0, 6, 6 * qv]


def _rows_for_q(q: int) -> list[dict[str, object]]:
    qv = _validate_q(q)
    D = first_subcritical_bound(qv)
    rows: list[dict[str, object]] = []
    for pattern in candidate_patterns(3, D):
        score = product_local_survivor_counts([2, 3, qv], pattern)
        structural = first_subcritical_structural_condition(qv, pattern)
        rows.append({
            "pattern": pattern,
            "score": score,
            "structural_condition": structural,
        })
    return rows


def verify_first_subcritical_sacrifice(q: int) -> dict[str, object]:
    qv = _validate_q(q)
    rows = _rows_for_q(qv)
    predicted = first_subcritical_max_score(qv)
    max_score = max(int(row["score"]) for row in rows)
    maximizers = [row for row in rows if row["score"] == max_score]
    structural = [row for row in rows if row["structural_condition"]]
    canonical = canonical_first_subcritical_attainer(qv)
    canonical_score = first_subcritical_score(qv, canonical)

    over_bound = [row for row in rows if int(row["score"]) > predicted]
    bad_maximizers = [row for row in maximizers if not row["structural_condition"]]
    missed_structural = [row for row in structural if int(row["score"]) != predicted]

    return {
        "q": qv,
        "gates": [2, 3, qv],
        "W": 6 * qv,
        "D": first_subcritical_bound(qv),
        "checked_patterns": len(rows),
        "predicted_max_score": predicted,
        "max_score": max_score,
        "canonical_attainer": canonical,
        "canonical_score": canonical_score,
        "canonical_attains": canonical_score == predicted,
        "maximizer_count": len(maximizers),
        "structural_count": len(structural),
        "maximizers": [row["pattern"] for row in maximizers],
        "over_bound": over_bound,
        "bad_maximizers": bad_maximizers,
        "missed_structural": missed_structural,
        "holds": (
            max_score == predicted
            and canonical_score == predicted
            and not over_bound
            and not bad_maximizers
            and not missed_structural
            and [row["pattern"] for row in maximizers]
            == [row["pattern"] for row in structural]
        ),
    }


def scan_first_subcritical_q_values(q_values: Iterable[int]) -> dict[str, object]:
    results: list[dict[str, object]] = []
    rejected: list[dict[str, object]] = []
    for q in q_values:
        try:
            results.append(verify_first_subcritical_sacrifice(int(q)))
        except ValueError as exc:
            rejected.append({"q": int(q), "reason": str(exc)})
    failures = [row for row in results if not row["holds"]]
    return {
        "checked": len(results),
        "rejected": rejected,
        "results": results,
        "failures": failures,
        "holds": not failures,
    }


def find_counterexample_bt0010(q_max: int, D_mode: str = "2W-1") -> dict[str, object]:
    if D_mode != "2W-1":
        raise ValueError("only D_mode='2W-1' is supported")
    if q_max < 5:
        raise ValueError("q_max must be at least 5")
    q_values = [q for q in range(5, int(q_max) + 1) if gcd(q, 6) == 1]
    scan = scan_first_subcritical_q_values(q_values)
    first_failure = scan["failures"][0] if scan["failures"] else None
    return {
        "q_max": int(q_max),
        "D_mode": D_mode,
        "tested_q_values": q_values,
        "counterexample": first_failure,
        "holds": first_failure is None,
    }
