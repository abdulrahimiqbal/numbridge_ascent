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

## Resonance Lattice Maximizers

BT-0008 proves the first closed-form structural theorem for the absolute
finite resonance numerator. For pairwise-coprime gates greater than one, a
zero-anchored pattern satisfies:

```text
ProductLocalGateSurvivorCount gates H <= prod_{p in gates} (p - 1)
```

and equality holds exactly when every offset is divisible by:

```text
W = gateProduct gates
```

So the strongest possible finite resonance locks onto the gate-product lattice.

Lean also proves that `[0,W,2W,...,(k-1)W]` is normalized, distinct, bounded by
`D`, and upper-bound-attaining whenever `(k - 1)W <= D`. Python checks the full
threshold behavior in bounded windows and searches subcritical cases. The full
reverse threshold/floor-family proof remains open Lean work.

## Subcritical Resonance

BT-0009 proves that the first subcritical window has structure rather than only
a computed list. For:

```text
gates = [2,3,5]
W = 30
k = 3
D = 59
```

Lean proves:

```text
FiniteResonanceNumerator [2,3,5] H <= 6
```

for normalized distinct `H`, with equality iff all offsets are divisible by `6`
and `LocalResidueShadowCount 5 H = 2`.

Interpretation: `[0,30,60]` cannot fit, so the best subcritical patterns keep
the `2`- and `3`-gate locks and sacrifice exactly one residue at the `5`-gate.

## First Subcritical Sacrifice

BT-0010 proves the parametric version. For `q >= 5` with `Nat.Coprime q 6`,
use gates `[2,3,q]` and bound `D = 12q - 1`. Lean proves:

```text
FiniteResonanceNumerator [2,3,q] H <= 2 * (q - 2)
```

for normalized distinct three-point patterns, with equality iff:

```text
All offsets are divisible by 6
and
LocalResidueShadowCount q H = 2.
```

This is the first reusable one-gate-sacrifice theorem: full `[2,3,q]` lattice
lock cannot fit, so maximal subcritical resonance keeps `[2,3]` and sacrifices
the q-gate minimally.

## General First Subcritical Sacrifice

BT-0011 closes the arbitrary two-gate base-spine fallback. For pairwise-coprime
base gates `[a,b]`, a new gate `q` coprime to `a*b`, and
`(a - 1)*(b - 1) + 1 <= q`, Lean proves:

```text
FiniteResonanceNumerator [a,b,q] H
  <= (a - 1)*(b - 1)*(q - 2)
```

for normalized distinct three-point patterns bounded by `2*(a*b*q) - 1`.
Equality holds exactly when the pattern is locked modulo `a*b` and has exactly
two q-residue shadows.

The full arbitrary finite base-spine theorem is still open. Python checks the
finite-list version in bounded windows and searches the only equality edge
where the crude product-drop argument could fail.
