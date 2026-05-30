from __future__ import annotations

from typing import Iterable

from .prime_patterns import candidate_patterns
from .wheel_product_general import pairwise_coprime, product, product_local_survivor_counts


def _normalize_gates(gates: Iterable[int]) -> list[int]:
    values = [int(g) for g in gates]
    if not values:
        raise ValueError("gate list must be nonempty")
    if any(g <= 1 for g in values):
        raise ValueError("all gates must be > 1")
    if not pairwise_coprime(values):
        raise ValueError("gates must be pairwise coprime")
    return values


def resonance_upper_bound(gates: Iterable[int]) -> int:
    gs = _normalize_gates(gates)
    return product(g - 1 for g in gs)


def all_offsets_divisible_by(H: Iterable[int], W: int) -> bool:
    offsets = [int(h) for h in H]
    if W <= 0:
        raise ValueError("W must be positive")
    return all(h % W == 0 for h in offsets)


def normalized_distinct_pattern(H: Iterable[int], k: int, D: int) -> bool:
    offsets = [int(h) for h in H]
    if k <= 0 or D < 0:
        return False
    return (
        len(offsets) == k
        and bool(offsets)
        and offsets[0] == 0
        and len(set(offsets)) == len(offsets)
        and all(0 <= h <= D for h in offsets)
    )


def canonical_lattice_pattern(k: int, W: int) -> list[int]:
    if k <= 0:
        raise ValueError("k must be positive")
    if W <= 0:
        raise ValueError("W must be positive")
    return [i * W for i in range(k)]


def lattice_maximum_attainable(k: int, D: int, W: int) -> bool:
    if k <= 0:
        raise ValueError("k must be positive")
    if D < 0:
        raise ValueError("D must be nonnegative")
    if W <= 0:
        raise ValueError("W must be positive")
    return (k - 1) * W <= D


def structural_maximizer_check(gates: Iterable[int], H: Iterable[int]) -> dict[str, object]:
    gs = _normalize_gates(gates)
    offsets = [int(h) for h in H]
    W = product(gs)
    upper = resonance_upper_bound(gs)
    numerator = product_local_survivor_counts(gs, offsets)
    lattice_condition = all_offsets_divisible_by(offsets, W)
    return {
        "gates": gs,
        "W": W,
        "pattern": offsets,
        "k": len(offsets),
        "D": max(offsets) if offsets else None,
        "normalized_distinct": normalized_distinct_pattern(
            offsets,
            len(offsets),
            max(offsets) if offsets else 0,
        ),
        "numerator": numerator,
        "upper_bound": upper,
        "attains_upper_bound": numerator == upper,
        "lattice_condition": lattice_condition,
        "structural_theorem_agrees": (numerator == upper) == lattice_condition,
    }


def _score_rows(k: int, D: int, gates: list[int]) -> list[dict[str, object]]:
    rows: list[dict[str, object]] = []
    for pattern in candidate_patterns(k, D):
        score = product_local_survivor_counts(gates, pattern)
        rows.append({
            "pattern": pattern,
            "score": score,
            "lattice_condition": all_offsets_divisible_by(pattern, product(gates)),
        })
    return rows


def brute_force_verify_bt0008(k: int, D: int, gates: Iterable[int]) -> dict[str, object]:
    gs = _normalize_gates(gates)
    if k <= 0:
        raise ValueError("k must be positive")
    if D < 0:
        raise ValueError("D must be nonnegative")

    W = product(gs)
    upper = resonance_upper_bound(gs)
    rows = _score_rows(k, D, gs)
    max_score = max((int(row["score"]) for row in rows), default=0)
    maximizers = [row for row in rows if row["score"] == max_score]
    upper_attainers = [row for row in rows if row["score"] == upper]
    threshold = lattice_maximum_attainable(k, D, W)
    canonical = canonical_lattice_pattern(k, W)
    canonical_valid = normalized_distinct_pattern(canonical, k, D)
    canonical_score = product_local_survivor_counts(gs, canonical) if canonical_valid else None

    all_bounded = all(int(row["score"]) <= upper for row in rows)
    upper_attainers_lattice = all(bool(row["lattice_condition"]) for row in upper_attainers)
    threshold_sufficient = (
        (not threshold)
        or (canonical_valid and canonical_score == upper and bool(upper_attainers))
    )
    subthreshold_no_upper_attainer = threshold or not upper_attainers
    maximizers_lattice_when_threshold = (
        (not threshold)
        or all(bool(row["lattice_condition"]) for row in maximizers)
    )

    return {
        "gates": gs,
        "W": W,
        "k": k,
        "D": D,
        "upper_bound": upper,
        "max_score": max_score,
        "threshold_attainable": threshold,
        "canonical_pattern": canonical,
        "canonical_valid": canonical_valid,
        "canonical_score": canonical_score,
        "maximizer_count": len(maximizers),
        "maximizers": [row["pattern"] for row in maximizers],
        "upper_attainer_count": len(upper_attainers),
        "upper_attainers": [row["pattern"] for row in upper_attainers],
        "all_scores_bounded_by_upper": all_bounded,
        "upper_attainers_satisfy_lattice": upper_attainers_lattice,
        "threshold_sufficient": threshold_sufficient,
        "subthreshold_has_no_upper_attainer": subthreshold_no_upper_attainer,
        "maximizers_lattice_when_threshold": maximizers_lattice_when_threshold,
        "holds": (
            all_bounded
            and upper_attainers_lattice
            and threshold_sufficient
            and subthreshold_no_upper_attainer
            and maximizers_lattice_when_threshold
        ),
    }


def verify_bt0008(max_k: int, max_D: int, gates: Iterable[int]) -> dict[str, object]:
    gs = _normalize_gates(gates)
    if max_k <= 0:
        raise ValueError("max_k must be positive")
    if max_D < 0:
        raise ValueError("max_D must be nonnegative")

    checked = 0
    failures: list[dict[str, object]] = []
    for k in range(1, max_k + 1):
        for D in range(max_D + 1):
            result = brute_force_verify_bt0008(k, D, gs)
            checked += 1
            if not result["holds"]:
                failures.append(result)

    return {
        "gates": gs,
        "max_k": max_k,
        "max_D": max_D,
        "checked": checked,
        "failures": failures,
        "holds": not failures,
    }


def search_subcritical_maximizers(k: int, D: int, gates: Iterable[int]) -> dict[str, object]:
    result = brute_force_verify_bt0008(k, D, gates)
    if result["threshold_attainable"]:
        result["note"] = "diameter is not subcritical for the lattice threshold"
    else:
        result["note"] = "subcritical search: upper bound is not attainable"
    return result
