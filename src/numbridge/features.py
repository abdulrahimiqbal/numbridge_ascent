from __future__ import annotations

from collections import Counter
from math import isqrt
from typing import Iterable


def sieve_primes(limit: int) -> list[int]:
    if limit < 2:
        return []
    sieve = bytearray(b"\x01") * (limit + 1)
    sieve[0:2] = b"\x00\x00"
    for p in range(2, isqrt(limit) + 1):
        if sieve[p]:
            start = p * p
            sieve[start: limit + 1: p] = b"\x00" * (((limit - start) // p) + 1)
    return [i for i in range(limit + 1) if sieve[i]]


def is_prime(n: int) -> bool:
    if n < 2:
        return False
    if n in (2, 3):
        return True
    if n % 2 == 0 or n % 3 == 0:
        return False
    k = 5
    while k * k <= n:
        if n % k == 0 or n % (k + 2) == 0:
            return False
        k += 6
    return True


def digits(n: int, base: int = 10) -> list[int]:
    if base <= 1:
        raise ValueError("base must be > 1")
    if n < 0:
        raise ValueError("digits expects n >= 0")
    if n == 0:
        return [0]
    out: list[int] = []
    while n:
        out.append(n % base)
        n //= base
    return list(reversed(out))


def from_digits(ds: Iterable[int], base: int = 10) -> int:
    n = 0
    for d in ds:
        if d < 0 or d >= base:
            raise ValueError(f"digit {d} invalid for base {base}")
        n = n * base + d
    return n


def digit_sum(n: int, base: int = 10) -> int:
    return sum(digits(n, base))


def digital_root(n: int, base: int = 10) -> int:
    if base <= 1:
        raise ValueError("base must be > 1")
    if n == 0:
        return 0
    return 1 + ((n - 1) % (base - 1))


def is_palindrome_digits(n: int, base: int = 10) -> bool:
    ds = digits(n, base)
    return ds == list(reversed(ds))


def mirror_number(prefix: int, base: int = 10) -> int:
    ds = digits(prefix, base)
    return from_digits(ds + list(reversed(ds)), base)


def even_palindromes_by_prefix(max_prefix: int, base: int = 10) -> list[int]:
    return [mirror_number(prefix, base) for prefix in range(1, max_prefix + 1)]


def prime_factorization(n: int) -> dict[int, int]:
    if n < 1:
        raise ValueError("n must be >= 1")
    factors: dict[int, int] = {}
    d = 2
    while d * d <= n:
        while n % d == 0:
            factors[d] = factors.get(d, 0) + 1
            n //= d
        d = 3 if d == 2 else d + 2
    if n > 1:
        factors[n] = factors.get(n, 0) + 1
    return factors


def omega(n: int) -> int:
    """Number of prime factors counted with multiplicity."""
    return sum(prime_factorization(n).values())


def distinct_omega(n: int) -> int:
    return len(prime_factorization(n))


def num_divisors(n: int) -> int:
    total = 1
    for exponent in prime_factorization(n).values():
        total *= exponent + 1
    return total


def valuation(n: int, p: int) -> int:
    count = 0
    while n and n % p == 0:
        count += 1
        n //= p
    return count


def multiplicative_persistence(n: int, base: int = 10, max_steps: int = 100) -> tuple[int, int]:
    steps = 0
    while n >= base and steps < max_steps:
        prod = 1
        for d in digits(n, base):
            prod *= d
        n = prod
        steps += 1
    return n, steps


def additive_persistence(n: int, base: int = 10, max_steps: int = 100) -> tuple[int, int]:
    steps = 0
    while n >= base and steps < max_steps:
        n = digit_sum(n, base)
        steps += 1
    return n, steps


def distribution(values: Iterable[int]) -> dict[int, float]:
    vals = list(values)
    total = len(vals)
    if total == 0:
        return {}
    counts = Counter(vals)
    return {k: counts[k] / total for k in sorted(counts)}


def mean(values: Iterable[float]) -> float:
    vals = list(values)
    return sum(vals) / len(vals) if vals else 0.0
