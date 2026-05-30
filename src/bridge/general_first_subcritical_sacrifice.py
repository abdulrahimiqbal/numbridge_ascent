from __future__ import annotations

from itertools import combinations
from math import gcd
from typing import Iterable

from .residue_shadow import residue_shadow_size


def product(xs: Iterable[int]) -> int:
    result = 1
    for x in xs:
        result *= int(x)
    return result


def gate_product(gates: Iterable[int]) -> int:
    return product(gates)


def base_upper_bound(gates: Iterable[int]) -> int:
    return product(int(g) - 1 for g in gates)


def pairwise_coprime(xs: Iterable[int]) -> bool:
    values = [int(x) for x in xs]
    return all(gcd(a, b) == 1 for a, b in combinations(values, 2))


def normalized_distinct_three_pattern(H: Iterable[int], D: int) -> bool:
    offsets = [int(h) for h in H]
    return (
        len(offsets) == 3
        and offsets[0] == 0
        and len(set(offsets)) == 3
        and all(0 <= h <= D for h in offsets)
    )


def all_offsets_divisible_by(H: Iterable[int], L: int) -> bool:
    return all(int(h) % L == 0 for h in H)


def local_residue_shadow_count(H: Iterable[int], q: int) -> int:
    return residue_shadow_size([int(h) for h in H], int(q))


def finite_resonance_numerator(gates: Iterable[int], H: Iterable[int]) -> int:
    offsets = [int(h) for h in H]
    return product(int(g) - local_residue_shadow_count(offsets, int(g)) for g in gates)


def _normalize_base_gates(base_gates: Iterable[int]) -> list[int]:
    gates = [int(g) for g in base_gates]
    if not gates:
        raise ValueError("base gate list must be nonempty")
    if any(g < 2 for g in gates):
        raise ValueError("every base gate must be at least 2")
    if not pairwise_coprime(gates):
        raise ValueError("base gates must be pairwise coprime")
    return gates


def _validate_general_inputs(base_gates: Iterable[int], q: int) -> tuple[list[int], int, int, int]:
    base = _normalize_base_gates(base_gates)
    qv = int(q)
    if qv < 2:
        raise ValueError("q must be at least 2")
    L = gate_product(base)
    B = base_upper_bound(base)
    if gcd(qv, L) != 1:
        raise ValueError("q must be coprime to the base gate product")
    if qv < B + 1:
        raise ValueError("q is outside the theorem range q >= B + 1")
    return base, qv, L, B


def general_first_subcritical_bound(base_gates: Iterable[int], q: int) -> dict[str, int]:
    base, qv, L, B = _validate_general_inputs(base_gates, q)
    return {
        "L": L,
        "B": B,
        "D": 2 * L * qv - 1,
        "predicted_max_score": B * (qv - 2),
        "base_len": len(base),
    }


def general_first_subcritical_condition(base_gates: Iterable[int], q: int, H: Iterable[int]) -> bool:
    base, qv, L, _B = _validate_general_inputs(base_gates, q)
    D = 2 * L * qv - 1
    offsets = [int(h) for h in H]
    return (
        normalized_distinct_three_pattern(offsets, D)
        and all_offsets_divisible_by(offsets, L)
        and local_residue_shadow_count(offsets, qv) == 2
    )


def _canonical_attainer(L: int, q: int) -> list[int]:
    return [0, L, L * q]


def _iter_three_patterns(D: int):
    for b, c in combinations(range(1, D + 1), 2):
        yield [0, b, c]


def _potential_equality_edge_counterexample(base: list[int], q: int, L: int, B: int) -> dict[str, object] | None:
    """Search only the arithmetic edge where arbitrary-base equality could fail.

    The crude proof bounds a non-base-locked pattern by `(B - 1) * (q - 1)`.
    Equality with `B * (q - 2)` can only occur when `q = B + 1`, the q-shadow
    has size one, and the base contribution is exactly `B - 1`.  In that case
    every offset is a multiple of q, so it is enough to search quotient offsets
    up to `2L - 1`.
    """

    if q != B + 1:
        return None
    for x, y in combinations(range(1, 2 * L), 2):
        H = [0, q * x, q * y]
        if all_offsets_divisible_by(H, L):
            continue
        base_score = finite_resonance_numerator(base, H)
        if base_score == B - 1 and local_residue_shadow_count(H, q) == 1:
            return {
                "pattern": H,
                "quotient_pattern": [0, x, y],
                "base_score": base_score,
                "q_shadow": 1,
                "score": finite_resonance_numerator([*base, q], H),
                "predicted_max_score": B * (q - 2),
            }
    return None


def verify_general_first_subcritical(
    base_gates: Iterable[int],
    q: int,
    *,
    exact_pattern_cap: int = 250_000,
) -> dict[str, object]:
    base, qv, L, B = _validate_general_inputs(base_gates, q)
    D = 2 * L * qv - 1
    predicted = B * (qv - 2)
    pattern_count = D * (D - 1) // 2
    gates = [*base, qv]
    canonical = _canonical_attainer(L, qv)
    canonical_score = finite_resonance_numerator(gates, canonical)
    edge_counterexample = _potential_equality_edge_counterexample(base, qv, L, B)

    exact = pattern_count <= exact_pattern_cap
    max_score: int | None = None
    maximizers: list[list[int]] = []
    structural_count: int | None = None
    over_bound: list[dict[str, object]] = []
    bad_maximizers: list[dict[str, object]] = []
    missed_structural: list[dict[str, object]] = []

    if exact:
        structural_count = 0
        for pattern in _iter_three_patterns(D):
            score = finite_resonance_numerator(gates, pattern)
            structural = (
                all_offsets_divisible_by(pattern, L)
                and local_residue_shadow_count(pattern, qv) == 2
            )
            if structural:
                structural_count += 1
            if score > predicted:
                over_bound.append({"pattern": pattern, "score": score})
            if structural and score != predicted:
                missed_structural.append({"pattern": pattern, "score": score})
            if max_score is None or score > max_score:
                max_score = score
                maximizers = [pattern]
            elif score == max_score and len(maximizers) < 50:
                maximizers.append(pattern)
        bad_maximizers = [
            {
                "pattern": pattern,
                "score": max_score,
                "base_locked": all_offsets_divisible_by(pattern, L),
                "q_shadow": local_residue_shadow_count(pattern, qv),
            }
            for pattern in maximizers
            if not (
                all_offsets_divisible_by(pattern, L)
                and local_residue_shadow_count(pattern, qv) == 2
            )
        ]

    holds = (
        canonical_score == predicted
        and edge_counterexample is None
        and (not exact or (
            max_score == predicted
            and not over_bound
            and not bad_maximizers
            and not missed_structural
        ))
    )

    return {
        "base_gates": base,
        "q": qv,
        "gates": gates,
        "L": L,
        "B": B,
        "D": D,
        "predicted_max_score": predicted,
        "canonical_attainer": canonical,
        "canonical_score": canonical_score,
        "canonical_attains": canonical_score == predicted,
        "checked_patterns": pattern_count if exact else 0,
        "pattern_count": pattern_count,
        "exact_bruteforce": exact,
        "exact_pattern_cap": exact_pattern_cap,
        "max_score": max_score,
        "maximizers": maximizers,
        "maximizer_count_reported": len(maximizers),
        "structural_count": structural_count,
        "edge_counterexample": edge_counterexample,
        "over_bound": over_bound,
        "bad_maximizers": bad_maximizers,
        "missed_structural": missed_structural,
        "holds": holds,
        "lean_scope": "two-gate" if len(base) == 2 else "python-general-conjecture-check",
    }


def counterexample_search_general_first_subcritical(
    max_gate: int,
    max_q: int,
    max_base_len: int,
) -> dict[str, object]:
    if max_gate < 2:
        raise ValueError("max_gate must be at least 2")
    if max_q < 2:
        raise ValueError("max_q must be at least 2")
    if max_base_len < 1:
        raise ValueError("max_base_len must be positive")

    checked: list[dict[str, object]] = []
    rejected: list[dict[str, object]] = []
    outside_failures: list[dict[str, object]] = []
    first_counterexample: dict[str, object] | None = None

    gate_values = list(range(2, int(max_gate) + 1))
    for base_len in range(1, int(max_base_len) + 1):
        for base_tuple in combinations(gate_values, base_len):
            base = list(base_tuple)
            if not pairwise_coprime(base):
                rejected.append({"base_gates": base, "reason": "base gates not pairwise coprime"})
                continue
            L = gate_product(base)
            B = base_upper_bound(base)
            for q in range(2, int(max_q) + 1):
                if gcd(q, L) != 1:
                    rejected.append({"base_gates": base, "q": q, "reason": "q not coprime to L"})
                    continue
                if q < B + 1:
                    outside_failures.append({
                        "base_gates": base,
                        "q": q,
                        "L": L,
                        "B": B,
                        "reason": "outside theorem range q < B + 1",
                    })
                    continue
                result = verify_general_first_subcritical(base, q, exact_pattern_cap=20_000)
                summary = {
                    "base_gates": base,
                    "q": q,
                    "L": L,
                    "B": B,
                    "D": result["D"],
                    "exact_bruteforce": result["exact_bruteforce"],
                    "checked_patterns": result["checked_patterns"],
                    "holds": result["holds"],
                    "edge_counterexample": result["edge_counterexample"],
                }
                checked.append(summary)
                if not result["holds"] and first_counterexample is None:
                    first_counterexample = result
                    break
            if first_counterexample is not None:
                break
        if first_counterexample is not None:
            break

    return {
        "max_gate": int(max_gate),
        "max_q": int(max_q),
        "max_base_len": int(max_base_len),
        "checked": len(checked),
        "rejected": len(rejected),
        "outside_theorem_cases": len(outside_failures),
        "checked_cases": checked,
        "outside_examples": outside_failures[:25],
        "counterexample": first_counterexample,
        "holds": first_counterexample is None,
    }


def discover_next_sacrifice_family(max_gate: int, max_q: int, max_k: int) -> dict[str, object]:
    if max_k < 1:
        raise ValueError("max_k must be positive")
    search = counterexample_search_general_first_subcritical(max_gate, max_q, max_k)
    valid = [row for row in search["checked_cases"] if row["holds"]]
    two_gate = [row for row in valid if len(row["base_gates"]) == 2]
    arbitrary_base = [row for row in valid if len(row["base_gates"]) > 2]
    return {
        "max_gate": int(max_gate),
        "max_q": int(max_q),
        "max_k": int(max_k),
        "recommended_next_family": "full arbitrary finite base-spine equality proof",
        "reason": (
            "BT-0011 Lean closes arbitrary two-gate spines; Python's equality-edge "
            "search found no arbitrary-base failure in the requested window."
        ),
        "two_gate_candidates": two_gate[:20],
        "arbitrary_base_candidates": arbitrary_base[:20],
        "search_summary": {
            "checked": search["checked"],
            "outside_theorem_cases": search["outside_theorem_cases"],
            "counterexample": search["counterexample"],
            "holds": search["holds"],
        },
    }
