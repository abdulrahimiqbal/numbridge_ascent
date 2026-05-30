from __future__ import annotations

from itertools import combinations
from math import log
from typing import Iterable

from numbridge.features import is_prime, sieve_primes


def normalize_offsets(H: Iterable[int]) -> list[int]:
    """Return sorted unique offsets translated so the first offset is 0."""
    offsets = sorted(set(int(h) for h in H))
    if not offsets:
        raise ValueError("offset pattern must be nonempty")
    minimum = offsets[0]
    return [h - minimum for h in offsets]


def primes_up_to(n: int) -> list[int]:
    return sieve_primes(max(0, int(n)))


def candidate_patterns(k: int, diameter: int) -> list[list[int]]:
    if k <= 0:
        raise ValueError("k must be positive")
    if diameter < 0:
        raise ValueError("diameter must be nonnegative")
    if k == 1:
        return [[0]]
    return [[0, *combo] for combo in combinations(range(1, diameter + 1), k - 1)]


def count_prime_translates(H: Iterable[int], N: int) -> int:
    offsets = normalize_offsets(H)
    if N < 0:
        return 0
    count = 0
    for n in range(N + 1):
        if all(is_prime(n + h) for h in offsets):
            count += 1
    return count


def rough_prime_tuple_scale(H: Iterable[int], N: int) -> float:
    offsets = normalize_offsets(H)
    if N < 3:
        return 0.0
    return N / (log(N) ** len(offsets))
