from __future__ import annotations

from typing import Iterable

from .prime_patterns import (
    candidate_patterns,
    count_prime_translates,
    normalize_offsets,
    primes_up_to,
    rough_prime_tuple_scale,
)
from .residue_shadow import (
    admissibility_witnesses,
    is_admissible,
    is_obstructed_mod,
    residue_shadow_size,
    shadow_profile,
)


def local_survival_factor(H: Iterable[int], p: int) -> float:
    offsets = normalize_offsets(H)
    nu = residue_shadow_size(offsets, p)
    if nu >= p:
        return 0.0
    base = 1.0 - (1.0 / p)
    return (1.0 - (nu / p)) / (base ** len(offsets))


def truncated_singular_series(H: Iterable[int], prime_bound: int) -> float:
    offsets = normalize_offsets(H)
    total = 1.0
    for p in primes_up_to(prime_bound):
        factor = local_survival_factor(offsets, p)
        if factor == 0.0:
            return 0.0
        total *= factor
    return total


def classify_pattern(H: Iterable[int], prime_bound: int = 31, N: int | None = None) -> list[str]:
    offsets = normalize_offsets(H)
    labels: list[str] = []
    if is_admissible(offsets):
        labels.append("admissible")
    else:
        labels.append("obstructed")

    resonance = truncated_singular_series(offsets, prime_bound)
    if resonance == 0:
        labels.append("low-resonance")
    elif resonance >= 1.0:
        labels.append("high-resonance")
    else:
        labels.append("low-resonance")

    if N is not None and N > 0:
        comparison = compare_observed_to_resonance(offsets, N, prime_bound)
        if comparison["observed"] >= max(1.0, 0.5 * float(comparison["expected_rough"])):
            labels.append("empirically promising")
        else:
            labels.append("empirically weak")

    return labels


def search_admissible_patterns(k: int, diameter: int) -> list[list[int]]:
    return [pattern for pattern in candidate_patterns(k, diameter) if is_admissible(pattern)]


def rank_patterns_by_resonance(k: int, diameter: int, prime_bound: int) -> list[dict[str, object]]:
    rows: list[dict[str, object]] = []
    for pattern in candidate_patterns(k, diameter):
        witnesses = admissibility_witnesses(pattern)
        resonance = 0.0 if witnesses else truncated_singular_series(pattern, prime_bound)
        rows.append({
            "pattern": pattern,
            "admissible": not witnesses,
            "obstruction_witnesses": witnesses,
            "resonance": resonance,
            "labels": classify_pattern(pattern, prime_bound),
        })
    rows.sort(key=lambda row: (bool(row["admissible"]), float(row["resonance"])), reverse=True)
    return rows


def compare_observed_to_resonance(H: Iterable[int], N: int, prime_bound: int) -> dict[str, object]:
    offsets = normalize_offsets(H)
    resonance = truncated_singular_series(offsets, prime_bound)
    observed = count_prime_translates(offsets, N)
    expected = resonance * rough_prime_tuple_scale(offsets, N)
    ratio = observed / expected if expected > 0 else None
    return {
        "pattern": offsets,
        "N": N,
        "prime_bound": prime_bound,
        "observed": observed,
        "resonance": resonance,
        "expected_rough": expected,
        "observed_to_expected": ratio,
        "labels": classify_pattern(offsets, prime_bound),
        "shadow_profile": shadow_profile(offsets, prime_bound),
        "obstruction_witnesses": admissibility_witnesses(offsets),
    }
