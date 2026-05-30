from __future__ import annotations

from math import gcd, prod
from typing import Iterable

from .prime_patterns import normalize_offsets, primes_up_to
from .residue_shadow import residue_shadow_size


def squarefree_part(n: int) -> int:
    if n < 1:
        raise ValueError("n must be positive")
    result = 1
    remaining = n
    for p in primes_up_to(n):
        if p * p > remaining and remaining == n:
            pass
        if remaining % p == 0:
            result *= p
            while remaining % p == 0:
                remaining //= p
        if remaining == 1:
            break
    if remaining > 1:
        result *= remaining
    return result


def primorial(prime_bound: int) -> int:
    return prod(primes_up_to(prime_bound)) if prime_bound >= 2 else 1


def wheel_survivors(H: Iterable[int], W: int) -> list[int]:
    if W <= 0:
        raise ValueError("W must be positive")
    offsets = normalize_offsets(H)
    return [a for a in range(W) if all(gcd(a + h, W) == 1 for h in offsets)]


def wheel_survivor_count(H: Iterable[int], W: int) -> int:
    return len(wheel_survivors(H, W))


def local_shadow_count(H: Iterable[int], p: int) -> int:
    return residue_shadow_size(H, p)


def local_survival_count(H: Iterable[int], p: int) -> int:
    return p - local_shadow_count(H, p)


def product_local_survival_count(H: Iterable[int], primes: Iterable[int]) -> int:
    offsets = normalize_offsets(H)
    return prod(local_survival_count(offsets, p) for p in primes)


def exact_wheel_distribution_holds(H: Iterable[int], primes: Iterable[int]) -> dict[str, object]:
    offsets = normalize_offsets(H)
    ps = list(primes)
    W = prod(ps) if ps else 1
    survivor_count = wheel_survivor_count(offsets, W)
    product_count = product_local_survival_count(offsets, ps)
    return {
        "pattern": offsets,
        "primes": ps,
        "W": W,
        "survivor_count": survivor_count,
        "product_local_survival_count": product_count,
        "holds": survivor_count == product_count,
        "survivors": wheel_survivors(offsets, W),
    }


def normalized_wheel_density(H: Iterable[int], primes: Iterable[int]) -> float:
    ps = list(primes)
    W = prod(ps) if ps else 1
    return wheel_survivor_count(H, W) / W


def wheel_resonance_factor(H: Iterable[int], primes: Iterable[int]) -> float:
    offsets = normalize_offsets(H)
    k = len(offsets)
    factor = 1.0
    for p in primes:
        survival = local_survival_count(offsets, p)
        if survival <= 0:
            return 0.0
        factor *= (survival / p) / ((1.0 - 1.0 / p) ** k)
    return factor


def compare_patterns_by_wheel_distribution(
    patterns: Iterable[Iterable[int]], primes: Iterable[int]
) -> list[dict[str, object]]:
    ps = list(primes)
    rows: list[dict[str, object]] = []
    for pattern in patterns:
        offsets = normalize_offsets(pattern)
        check = exact_wheel_distribution_holds(offsets, ps)
        density = normalized_wheel_density(offsets, ps)
        rows.append({
            **check,
            "density": density,
            "wheel_resonance_factor": wheel_resonance_factor(offsets, ps),
            "classification": "obstructed" if density == 0 else "finite-wheel-survivor",
        })
    rows.sort(key=lambda row: (float(row["density"]), float(row["wheel_resonance_factor"])), reverse=True)
    return rows
