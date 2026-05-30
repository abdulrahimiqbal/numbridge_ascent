from __future__ import annotations

from itertools import combinations, product as cartesian_product
from typing import Iterable

from .wheel_product_general import pairwise_coprime, product


BRUTE_FORCE_TUPLE_CAP = 250_000


def _validate_gates(gates: Iterable[int], *, require_coprime: bool = True) -> list[int]:
    values = [int(g) for g in gates]
    if not values:
        raise ValueError("gate list must be nonempty")
    if any(g <= 1 for g in values):
        raise ValueError("all gates must be > 1")
    if require_coprime and not pairwise_coprime(values):
        raise ValueError("gates must be pairwise coprime")
    return values


def tuples_of_length(k: int, m: int):
    kv = int(k)
    mv = int(m)
    if kv < 0:
        raise ValueError("k must be nonnegative")
    if mv < 0:
        raise ValueError("m must be nonnegative")
    for tup in cartesian_product(range(mv), repeat=kv):
        yield list(tup)


def avoided_residue_count(p: int, H: Iterable[int]) -> int:
    pv = int(p)
    if pv <= 0:
        raise ValueError("p must be positive")
    offsets = [int(h) for h in H]
    return sum(1 for r in range(pv) if all((r + h) % pv != 0 for h in offsets))


def finite_resonance_numerator(gates: Iterable[int], H: Iterable[int]) -> int:
    gs = _validate_gates(gates)
    offsets = [int(h) for h in H]
    return product(avoided_residue_count(g, offsets) for g in gs)


def product_local_max_powers(gates: Iterable[int], k: int) -> int:
    gs = _validate_gates(gates)
    kv = int(k)
    if kv < 0:
        raise ValueError("k must be nonnegative")
    return product((g - 1) ** kv for g in gs)


def finite_gallagher_rhs(gates: Iterable[int], k: int) -> int:
    gs = _validate_gates(gates)
    return product(gs) * product_local_max_powers(gs, k)


def _factorized_lhs(gates: list[int], k: int) -> int:
    # Exact finite double-counting value: choose one avoided residue per gate,
    # then choose k tuple entries from the surviving CRT residue set.
    one_entry_survivors = product(g - 1 for g in gates)
    return product(gates) * (one_entry_survivors ** k)


def sum_finite_resonance(
    gates: Iterable[int],
    k: int,
    *,
    brute_force_cap: int = BRUTE_FORCE_TUPLE_CAP,
) -> dict[str, object]:
    gs = _validate_gates(gates)
    kv = int(k)
    if kv < 0:
        raise ValueError("k must be nonnegative")
    W = product(gs)
    tuple_count = W ** kv
    factorized = _factorized_lhs(gs, kv)
    if tuple_count <= brute_force_cap:
        brute = sum(finite_resonance_numerator(gs, H) for H in tuples_of_length(kv, W))
        return {
            "lhs": brute,
            "factorized_lhs": factorized,
            "exact_bruteforce": True,
            "tuple_count": tuple_count,
        }
    return {
        "lhs": factorized,
        "factorized_lhs": factorized,
        "exact_bruteforce": False,
        "tuple_count": tuple_count,
    }


def verify_finite_gallagher(gates: Iterable[int], k: int) -> dict[str, object]:
    gs = _validate_gates(gates)
    kv = int(k)
    lhs_info = sum_finite_resonance(gs, kv)
    rhs = finite_gallagher_rhs(gs, kv)
    return {
        "gates": gs,
        "k": kv,
        "W": product(gs),
        "tuple_count": lhs_info["tuple_count"],
        "lhs": lhs_info["lhs"],
        "factorized_lhs": lhs_info["factorized_lhs"],
        "rhs": rhs,
        "exact_bruteforce": lhs_info["exact_bruteforce"],
        "holds": lhs_info["lhs"] == rhs,
        "classification": "INTERNAL_NUMBRIDGE_BREAKTHROUGH",
        "lean_status": "PROVED_FOR_SINGLE_AND_TWO_GATES_ARBITRARY_K",
    }


def scan_finite_gallagher(max_gate: int, max_k: int, max_gate_len: int) -> dict[str, object]:
    if max_gate < 2:
        raise ValueError("max_gate must be at least 2")
    if max_k < 0:
        raise ValueError("max_k must be nonnegative")
    if max_gate_len < 1:
        raise ValueError("max_gate_len must be positive")
    checked = 0
    brute_force_checked = 0
    first_failure = None
    gate_values = list(range(2, max_gate + 1))
    for gate_len in range(1, max_gate_len + 1):
        for gates_tuple in combinations(gate_values, gate_len):
            gates = list(gates_tuple)
            if not pairwise_coprime(gates):
                continue
            for k in range(max_k + 1):
                row = verify_finite_gallagher(gates, k)
                checked += 1
                brute_force_checked += int(bool(row["exact_bruteforce"]))
                if not row["holds"] and first_failure is None:
                    first_failure = row
    return {
        "max_gate": int(max_gate),
        "max_k": int(max_k),
        "max_gate_len": int(max_gate_len),
        "checked": checked,
        "brute_force_checked": brute_force_checked,
        "first_failure": first_failure,
        "holds": first_failure is None,
    }


def _brute_force_non_coprime_row(gates: list[int], k: int) -> dict[str, object] | None:
    W = product(gates)
    tuple_count = W ** k
    if tuple_count > 25_000:
        return None
    lhs = sum(
        product(avoided_residue_count(g, H) for g in gates)
        for H in tuples_of_length(k, W)
    )
    rhs = W * product((g - 1) ** k for g in gates)
    return {
        "gates": gates,
        "k": k,
        "pairwise_coprime": False,
        "tuple_count": tuple_count,
        "lhs": lhs,
        "rhs": rhs,
        "holds": lhs == rhs,
    }


def search_counterexample_finite_gallagher(
    max_gate: int,
    max_k: int,
    max_gate_len: int = 3,
) -> dict[str, object]:
    scan = scan_finite_gallagher(max_gate, max_k, max_gate_len)
    first_outside_failure = None
    gate_values = list(range(2, max_gate + 1))
    for gate_len in range(2, max_gate_len + 1):
        for gates_tuple in combinations(gate_values, gate_len):
            gates = list(gates_tuple)
            if pairwise_coprime(gates):
                continue
            for k in range(max_k + 1):
                row = _brute_force_non_coprime_row(gates, k)
                if row is not None and not row["holds"]:
                    first_outside_failure = row
                    break
            if first_outside_failure:
                break
        if first_outside_failure:
            break
    return {
        **scan,
        "coprime_counterexample": scan["first_failure"],
        "outside_assumptions_counterexample": first_outside_failure,
    }
