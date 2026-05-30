# Resonance

In PrimeBridge mode, "resonance" means local residue survival.

A pattern resonates when it avoids local residue collapse across small prime
moduli and receives large local survival factors.

## Definitions

For finite offsets `H` and prime `p`:

```text
nu_p(H) = |{h mod p : h in H}|
deficit_p(H) = p - nu_p(H)
local_factor_p(H) = (1 - nu_p(H)/p) / (1 - 1/p)^|H|
```

If `deficit_p(H) = 0`, then the pattern is locally obstructed modulo `p` and
its truncated singular series is zero.

The resonance score currently used by the engine is:

```text
prod_{p <= prime_bound} local_factor_p(H)
```

## Interpretation

- `obstructed`: some small prime modulus is fully covered.
- `admissible`: no prime `p <= |H|` fully covers the pattern.
- `high-resonance`: admissible with truncated local product at least 1.
- `low-resonance`: obstructed or low local product.
- `empirically promising`: observed prime translates are not far below the
  rough local-factor heuristic.
- `empirically weak`: observed counts trail the rough heuristic.

This is a search heuristic, not a distribution theorem.

## Finite-Wheel Distribution

The exact finite-sieve theorem underneath the heuristic is:

```text
|R_W(H)| = prod_{p | W} (p - nu_p(H))
```

This counts finite wheel survivors, not actual prime tuples. The normalized
wheel density is:

```text
|R_W(H)| / W = prod_{p | W} (1 - nu_p(H)/p)
```

Lean now proves the reusable two-modulus CRT/cardinality step underlying this
factorization and derives the wheel 6 and wheel 30 product formulas from it.
Python mirrors the broader arbitrary pairwise-coprime gate-list formula and
runs finite counterexample searches. Lean now also proves the full arbitrary
positive pairwise-coprime gate-list finite-wheel theorem.

## Finite Resonance Optimization

The next branch target is to optimize the truncated resonance score:

```text
Res_P(H) = prod_{p <= P} (1 - nu_p(H) / p) / (1 - 1 / p)^k
```

among admissible `k`-patterns with bounded diameter. This is a finite
combinatorics problem about wheel survivors and local residue shadows. It is
the intended BT-0007 layer and should be kept separate from any claim about
actual prime distributions.

The first BT-0007 theorem is now proved in Lean for two-point patterns. It
shows that the finite resonance numerator is maximized, under a sufficient
diameter bound, by the canonical gap divisible by every finite gate.

The broad BT-0007 classifier is also proved in Lean: for every `k`, `D`, and
`P`, the generated maximizer list is exactly the set of bounded canonical
patterns with globally maximal finite resonance numerator in that finite search
space.
