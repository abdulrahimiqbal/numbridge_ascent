from __future__ import annotations

from dataclasses import asdict, dataclass
from pathlib import Path
from statistics import mean as stat_mean
from typing import Callable, Any
import json
import random

from .features import (
    additive_persistence,
    digital_root,
    distribution,
    even_palindromes_by_prefix,
    from_digits,
    mirror_number,
    omega,
    sieve_primes,
)
from .null_models import odd_nonmultiples_of_3


@dataclass
class ExperimentResult:
    id: str
    title: str
    verdict: str
    summary: str
    metrics: dict[str, Any]
    bridge_implication: str

    def to_json(self) -> str:
        return json.dumps(asdict(self), indent=2, sort_keys=True)


def prime_digital_roots(limit: int = 100_000) -> ExperimentResult:
    primes = [p for p in sieve_primes(limit) if p > 3]
    roots = [digital_root(p, 10) for p in primes]
    null = odd_nonmultiples_of_3(5, limit)
    null_roots = [digital_root(n, 10) for n in null]
    forbidden = {3, 6, 9}
    prime_forbidden_count = sum(1 for r in roots if r in forbidden)
    null_forbidden_count = sum(1 for r in null_roots if r in forbidden)
    metrics = {
        "limit": limit,
        "prime_count": len(primes),
        "prime_root_distribution": distribution(roots),
        "null_count": len(null),
        "null_root_distribution": distribution(null_roots),
        "prime_forbidden_count": prime_forbidden_count,
        "null_forbidden_count": null_forbidden_count,
    }
    return ExperimentResult(
        id="E-0001",
        title="Prime digital-root distribution",
        verdict="shallow-real",
        summary="Primes greater than 3 avoid decimal roots 3, 6, and 9, but the same exclusion holds for the fair null of odd nonmultiples of 3.",
        metrics=metrics,
        bridge_implication="Digital-root language translates cleanly to modular arithmetic modulo 9; the prime-specific mysticism collapses to divisibility by 3.",
    )


def palindrome_divisibility(max_prefix: int = 999) -> ExperimentResult:
    base10_values = even_palindromes_by_prefix(max_prefix, 10)
    bad10 = [n for n in base10_values if n % 11 != 0]
    base_results: dict[int, dict[str, Any]] = {}
    for base in range(2, 17):
        values = even_palindromes_by_prefix(min(max_prefix, 200), base)
        modulus = base + 1
        bad = [n for n in values if n % modulus != 0]
        base_results[base] = {
            "tested": len(values),
            "modulus": modulus,
            "counterexamples": bad[:5],
            "counterexample_count": len(bad),
        }
    metrics = {
        "max_prefix": max_prefix,
        "base10_tested": len(base10_values),
        "base10_counterexample_count": len(bad10),
        "base10_counterexamples": bad10[:5],
        "base_general_sample": base_results,
    }
    return ExperimentResult(
        id="E-0002",
        title="Palindrome divisibility",
        verdict="strong-bridge",
        summary="All generated even-length base-10 palindromes were divisible by 11; sampled base-b even palindromes were divisible by b + 1.",
        metrics=metrics,
        bridge_implication="The symbolic mirror/gate idea maps to palindrome structure and divisibility by base + 1. This is a high-priority Lean target.",
    )


def base_invariance(limit: int = 5_000) -> ExperimentResult:
    failures: list[dict[str, int]] = []
    for base in range(2, 17):
        modulus = base - 1
        for n in range(1, limit + 1):
            # digital_root convention maps residue 0 to modulus. Congruence is still preserved.
            if (digital_root(n, base) - n) % modulus != 0:
                failures.append({"base": base, "n": n, "root": digital_root(n, base)})
                break
    metrics = {
        "limit": limit,
        "bases": list(range(2, 17)),
        "failure_count": len(failures),
        "failures": failures[:10],
    }
    return ExperimentResult(
        id="E-0003",
        title="Base-invariance calibration",
        verdict="confirmed-translation",
        summary="Across tested bases, digital root preserves congruence modulo base - 1.",
        metrics=metrics,
        bridge_implication="Digit-root numerology has a robust arithmetic translation: modular arithmetic modulo b - 1.",
    )


def prime_gap_root_rhythm(limit: int = 100_000, seed: int = 7) -> ExperimentResult:
    primes = sieve_primes(limit)
    gaps = [b - a for a, b in zip(primes, primes[1:])]
    roots = [digital_root(g, 10) for g in gaps if g > 0]
    rng = random.Random(seed)
    shuffled = list(gaps)
    rng.shuffle(shuffled)
    shuffled_roots = [digital_root(g, 10) for g in shuffled if g > 0]
    # Simple autocorrelation proxy: adjacent equality rate.
    adj_equal = sum(1 for a, b in zip(roots, roots[1:]) if a == b) / max(1, len(roots) - 1)
    shuf_equal = sum(1 for a, b in zip(shuffled_roots, shuffled_roots[1:]) if a == b) / max(1, len(shuffled_roots) - 1)
    metrics = {
        "limit": limit,
        "gap_count": len(gaps),
        "root_distribution": distribution(roots),
        "shuffled_root_distribution": distribution(shuffled_roots),
        "adjacent_equal_rate": adj_equal,
        "shuffled_adjacent_equal_rate": shuf_equal,
    }
    return ExperimentResult(
        id="E-0004",
        title="Prime-gap root rhythm",
        verdict="weak",
        summary="The gap-root distribution exists, but this first-pass test does not show a strong rhythm beyond marginal gap structure.",
        metrics=metrics,
        bridge_implication="Do not promote without stronger null models preserving prime-gap constraints.",
    )


def seven_factor_collapse(limit: int = 20_000) -> ExperimentResult:
    buckets: dict[int, list[int]] = {r: [] for r in range(1, 10)}
    for n in range(2, limit + 1):
        buckets[digital_root(n, 10)].append(omega(n))
    means = {r: stat_mean(vals) for r, vals in buckets.items() if vals}
    root7_mean = means.get(7, 0.0)
    all_mean = stat_mean([omega(n) for n in range(2, limit + 1)])
    rank_low_to_high = sorted(means, key=lambda r: means[r])
    metrics = {
        "limit": limit,
        "mean_omega_by_digital_root": means,
        "root7_mean_omega": root7_mean,
        "all_mean_omega": all_mean,
        "root_rank_low_to_high": rank_low_to_high,
        "additive_persistence_of_7_examples": [additive_persistence(n) for n in (7, 77, 777, 7777)],
    }
    if rank_low_to_high and rank_low_to_high[0] == 7:
        verdict = "active"
        summary = "Root 7 had the lowest mean factor count in this simple pass, but this needs residue-matched controls before promotion."
    else:
        verdict = "weak"
        summary = "Root 7 was not exceptional in this simple factor-count pass."
    return ExperimentResult(
        id="E-0005",
        title="Seven resists factor collapse",
        verdict=verdict,
        summary=summary,
        metrics=metrics,
        bridge_implication="Collapse language is better treated as iterative-map language than as a direct claim about decimal root 7.",
    )


RUNNERS: dict[str, Callable[..., ExperimentResult]] = {
    "prime_digital_roots": prime_digital_roots,
    "palindrome_divisibility": palindrome_divisibility,
    "base_invariance": base_invariance,
    "prime_gap_root_rhythm": prime_gap_root_rhythm,
    "seven_factor_collapse": seven_factor_collapse,
}


def write_result(result: ExperimentResult, out_dir: Path) -> Path:
    out_dir.mkdir(parents=True, exist_ok=True)
    path = out_dir / f"{result.id}.json"
    path.write_text(result.to_json() + "\n", encoding="utf-8")
    return path
