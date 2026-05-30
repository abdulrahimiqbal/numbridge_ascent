from __future__ import annotations

from math import gcd
from typing import Iterable

from numbridge.features import is_prime

from .general_first_subcritical_sacrifice import verify_general_first_subcritical
from .prime_patterns import normalize_offsets
from .wheel_product_general import pairwise_coprime, product


def _validate_gates(gates: Iterable[int]) -> list[int]:
    values = [int(g) for g in gates]
    if not values:
        raise ValueError("gate list must be nonempty")
    if any(g <= 1 for g in values):
        raise ValueError("all gates must be > 1")
    if not pairwise_coprime(values):
        raise ValueError("gates must be pairwise coprime")
    return values


def _validate_offsets(H: Iterable[int]) -> list[int]:
    raw = [int(h) for h in H]
    if len(raw) != len(set(raw)):
        raise ValueError("offset pattern must be duplicate-free")
    return normalize_offsets(raw)


def wheel_residue_survivors(gates: Iterable[int], H: Iterable[int]) -> list[int]:
    gs = _validate_gates(gates)
    offsets = _validate_offsets(H)
    W = product(gs)
    return [
        a
        for a in range(W)
        if all((a + h) % g != 0 for g in gs for h in offsets)
    ]


def prime_tuple_translate_above_gates(gates: Iterable[int], H: Iterable[int], n: int) -> bool:
    gs = _validate_gates(gates)
    offsets = _validate_offsets(H)
    nv = int(n)
    return all(is_prime(nv + h) and all(g < nv + h for g in gs) for h in offsets)


def prime_tuple_count(gates: Iterable[int], H: Iterable[int], N: int) -> int:
    gs = _validate_gates(gates)
    offsets = _validate_offsets(H)
    Nv = int(N)
    if Nv < 0:
        return 0
    return sum(1 for n in range(Nv + 1) if prime_tuple_translate_above_gates(gs, offsets, n))


def verify_prime_wheel_upper_bound(gates: Iterable[int], H: Iterable[int], N: int) -> dict[str, object]:
    gs = _validate_gates(gates)
    offsets = _validate_offsets(H)
    Nv = int(N)
    if Nv < 0:
        raise ValueError("N must be nonnegative")
    W = product(gs)
    survivors = wheel_residue_survivors(gs, offsets)
    count = prime_tuple_count(gs, offsets, Nv)
    bound = len(survivors) * (Nv // W + 1)
    bad_translates = [
        n
        for n in range(Nv + 1)
        if prime_tuple_translate_above_gates(gs, offsets, n) and (n % W) not in survivors
    ]
    return {
        "gates": gs,
        "pattern": offsets,
        "N": Nv,
        "W": W,
        "wheel_survivor_count": len(survivors),
        "wheel_survivors": survivors,
        "prime_tuple_count": count,
        "block_bound": bound,
        "bad_translates": bad_translates[:25],
        "bad_translate_count": len(bad_translates),
        "holds": count <= bound and not bad_translates,
        "classification": "ACTUAL_PRIME_BRIDGE_ELEMENTARY",
    }


def verify_arbitrary_base_spine_check(base_gates: Iterable[int], q: int) -> dict[str, object]:
    return verify_general_first_subcritical(base_gates, q, exact_pattern_cap=20_000)


def bt0012_breakthrough_audit() -> dict[str, object]:
    sample_arbitrary = verify_arbitrary_base_spine_check([2, 3, 5], 31)
    sample_prime = verify_prime_wheel_upper_bound([2, 3, 5], [0, 2, 6], 100_000)
    return {
        "path_landed": "B actual-prime wheel upper bound",
        "part_a_status": "OPEN",
        "part_a_sample_holds": sample_arbitrary["holds"],
        "part_a_sample_exact_bruteforce": sample_arbitrary["exact_bruteforce"],
        "part_b_status": "PROVED_IN_LEAN",
        "part_b_sample_holds": sample_prime["holds"],
        "classification": "ACTUAL_PRIME_BRIDGE_ELEMENTARY",
        "lean_theorems": [
            "NumBridge.prime_translate_avoids_each_gate_residue",
            "NumBridge.prime_tuple_translate_implies_wheel_survivor",
            "NumBridge.predicate_count_le_wheel_survivor_blocks",
            "NumBridge.bt0012_prime_tuple_wheel_upper_bound",
        ],
        "open_next": "Selberg-sieve upper bound for prime tuple translates using local obstruction data.",
    }
