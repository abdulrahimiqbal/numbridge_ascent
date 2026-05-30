from __future__ import annotations

from typing import Iterable

from .prime_patterns import normalize_offsets, primes_up_to


def residue_shadow(H: Iterable[int], p: int) -> set[int]:
    if p <= 1:
        raise ValueError("modulus p must be > 1")
    return {h % p for h in normalize_offsets(H)}


def residue_shadow_size(H: Iterable[int], p: int) -> int:
    return len(residue_shadow(H, p))


def gate_deficit(H: Iterable[int], p: int) -> int:
    return p - residue_shadow_size(H, p)


def is_obstructed_mod(H: Iterable[int], p: int) -> bool:
    return gate_deficit(H, p) == 0


def admissibility_witnesses(H: Iterable[int]) -> list[dict[str, object]]:
    offsets = normalize_offsets(H)
    witnesses: list[dict[str, object]] = []
    for p in primes_up_to(len(offsets)):
        shadow = residue_shadow(offsets, p)
        if len(shadow) == p:
            witnesses.append({
                "prime": p,
                "shadow": sorted(shadow),
                "deficit": 0,
            })
    return witnesses


def is_admissible(H: Iterable[int]) -> bool:
    return not admissibility_witnesses(H)


def shadow_profile(H: Iterable[int], prime_bound: int) -> list[dict[str, object]]:
    offsets = normalize_offsets(H)
    profile: list[dict[str, object]] = []
    for p in primes_up_to(prime_bound):
        shadow = residue_shadow(offsets, p)
        deficit = p - len(shadow)
        profile.append({
            "prime": p,
            "shadow": sorted(shadow),
            "shadow_size": len(shadow),
            "gate_deficit": deficit,
            "obstructed": deficit == 0,
        })
    return profile
