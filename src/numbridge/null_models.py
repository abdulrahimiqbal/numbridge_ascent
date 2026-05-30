from __future__ import annotations

from math import prod


def uniform_integers(start: int, stop: int) -> list[int]:
    return list(range(start, stop + 1))


def odd_integers(start: int, stop: int) -> list[int]:
    return [n for n in range(start, stop + 1) if n % 2 == 1]


def odd_nonmultiples_of_3(start: int, stop: int) -> list[int]:
    return [n for n in range(start, stop + 1) if n % 2 == 1 and n % 3 != 0]


def wheel_sieved(start: int, stop: int, primes: tuple[int, ...] = (2, 3, 5)) -> list[int]:
    modulus = prod(primes)
    allowed = {r for r in range(modulus) if all(r % p != 0 for p in primes)}
    return [n for n in range(start, stop + 1) if n % modulus in allowed]
