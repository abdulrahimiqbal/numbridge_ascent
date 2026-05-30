from __future__ import annotations

from itertools import combinations
from math import gcd
from typing import Callable, Iterable

from .prime_patterns import candidate_patterns, normalize_offsets
from .residue_shadow import residue_shadow_size


def product(xs: Iterable[int]) -> int:
    result = 1
    for x in xs:
        result *= int(x)
    return result


def pairwise_coprime(xs: Iterable[int]) -> bool:
    values = [int(x) for x in xs]
    return all(gcd(a, b) == 1 for a, b in combinations(values, 2))


def _normalize_gates(gates: Iterable[int]) -> list[int]:
    values = [int(g) for g in gates]
    if not values:
        raise ValueError("gate list must be nonempty")
    if any(g <= 1 for g in values):
        raise ValueError("all gates must be > 1")
    return values


def _gate_good(offsets: list[int], gate: int, residue: int) -> bool:
    return all((residue + h) % gate != 0 for h in offsets)


def wheel_survivor_count_general(gates: Iterable[int], H: Iterable[int]) -> int:
    gs = _normalize_gates(gates)
    if not pairwise_coprime(gs):
        raise ValueError("gates must be pairwise coprime")
    offsets = normalize_offsets(H)
    W = product(gs)
    return sum(
        1
        for a in range(W)
        if all(_gate_good(offsets, gate, a % gate) for gate in gs)
    )


def product_local_survivor_counts(gates: Iterable[int], H: Iterable[int]) -> int:
    gs = _normalize_gates(gates)
    if not pairwise_coprime(gs):
        raise ValueError("gates must be pairwise coprime")
    offsets = normalize_offsets(H)
    return product(gate - residue_shadow_size(offsets, gate) for gate in gs)


def verify_general_wheel_product(gates: Iterable[int], H: Iterable[int]) -> dict[str, object]:
    gs = _normalize_gates(gates)
    offsets = normalize_offsets(H)
    if not pairwise_coprime(gs):
        raise ValueError("gates must be pairwise coprime")
    survivor_count = wheel_survivor_count_general(gs, offsets)
    product_count = product_local_survivor_counts(gs, offsets)
    return {
        "gates": gs,
        "pattern": offsets,
        "W": product(gs),
        "pairwise_coprime": True,
        "survivor_count": survivor_count,
        "product_local_survivor_counts": product_count,
        "holds": survivor_count == product_count,
    }


def brute_force_crt_count_product(
    M: int,
    p: int,
    PM: Callable[[int], bool],
    Pp: Callable[[int], bool],
) -> dict[str, object]:
    if M <= 0 or p <= 0:
        raise ValueError("M and p must be positive")
    lhs = sum(1 for a in range(M * p) if PM(a % M) and Pp(a % p))
    rhs_left = sum(1 for x in range(M) if PM(x))
    rhs_right = sum(1 for y in range(p) if Pp(y))
    return {
        "M": M,
        "p": p,
        "pairwise_coprime": gcd(M, p) == 1,
        "lhs": lhs,
        "rhs_left": rhs_left,
        "rhs_right": rhs_right,
        "rhs": rhs_left * rhs_right,
        "holds": lhs == rhs_left * rhs_right,
    }


def _wheel_count_allow_non_coprime(gates: list[int], offsets: list[int]) -> int:
    W = product(gates)
    return sum(
        1
        for a in range(W)
        if all(_gate_good(offsets, gate, a % gate) for gate in gates)
    )


def _product_count_allow_non_coprime(gates: list[int], offsets: list[int]) -> int:
    return product(gate - residue_shadow_size(offsets, gate) for gate in gates)


def search_for_counterexample_to_wheel_product(
    max_gate: int,
    max_offset: int,
    max_len: int = 3,
) -> dict[str, object]:
    if max_gate < 2:
        raise ValueError("max_gate must be at least 2")
    if max_offset < 0:
        raise ValueError("max_offset must be nonnegative")
    if max_len < 1:
        raise ValueError("max_len must be positive")

    checked_coprime = 0
    checked_non_coprime = 0
    first_non_coprime_counterexample: dict[str, object] | None = None

    patterns: list[list[int]] = []
    for k in range(1, max_len + 1):
        patterns.extend(candidate_patterns(k, max_offset))

    gate_values = list(range(2, max_gate + 1))
    for gate_len in range(1, max_len + 1):
        for gates_tuple in combinations(gate_values, gate_len):
            gates = list(gates_tuple)
            coprime = pairwise_coprime(gates)
            for offsets in patterns:
                survivor_count = _wheel_count_allow_non_coprime(gates, offsets)
                product_count = _product_count_allow_non_coprime(gates, offsets)
                row = {
                    "gates": gates,
                    "pattern": offsets,
                    "W": product(gates),
                    "pairwise_coprime": coprime,
                    "survivor_count": survivor_count,
                    "product_local_survivor_counts": product_count,
                    "holds": survivor_count == product_count,
                }
                if coprime:
                    checked_coprime += 1
                    if not row["holds"]:
                        return {
                            "checked_coprime": checked_coprime,
                            "checked_non_coprime": checked_non_coprime,
                            "coprime_counterexample": row,
                            "non_coprime_counterexample": first_non_coprime_counterexample,
                        }
                else:
                    checked_non_coprime += 1
                    if not row["holds"] and first_non_coprime_counterexample is None:
                        first_non_coprime_counterexample = row

    return {
        "checked_coprime": checked_coprime,
        "checked_non_coprime": checked_non_coprime,
        "coprime_counterexample": None,
        "non_coprime_counterexample": first_non_coprime_counterexample,
    }
