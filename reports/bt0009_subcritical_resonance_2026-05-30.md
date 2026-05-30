# BT-0009 Subcritical Resonance Report - 2026-05-30

## Did BT-0009 Produce A Structural Theorem Or No-Go?

BT-0009 produced a structural theorem. It is not a no-go.

The theorem does not hardcode the twelve known maximizers. Instead, it explains
them as the patterns that stay locked to the `6`-lattice and occupy exactly two
residue classes modulo `5`.

## Exact Theorem Proved

Lean path:

```text
lean/NumBridge/SubcriticalResonance.lean
```

Main theorem:

```text
NumBridge.bt0009_subcritical_235_k3_D59_structural_breakthrough
```

For any normalized distinct three-point pattern `H` with offsets `<= 59`:

```text
FiniteResonanceNumerator [2,3,5] H <= 6
```

and:

```text
FiniteResonanceNumerator [2,3,5] H = 6
iff
AllOffsetsDivisibleBy6 H
and
LocalResidueShadowCount 5 H = 2.
```

## Did It Avoid Hardcoded Enumeration?

Yes. The Lean theorem contains no list of twelve maximizers.

The proof uses a structural obstruction:

```text
three distinct offsets <= 59 cannot all be multiples of 30
```

So a three-point pattern cannot keep the full `[2,3,5]` lattice lock. The best
available subcritical structure keeps the `2`- and `3`-gate locks and gives up
exactly one residue class modulo `5`.

## Why Is This Stronger Than BT-0007 And BT-0008?

BT-0007 proved that a generated classifier correctly returns finite maximizers.
BT-0009 proves a human-readable structural condition for a subcritical maximum.

BT-0008 classified absolute upper-bound maximizers. BT-0009 goes below that
absolute threshold and explains the next-best layer when the full lattice
pattern cannot fit.

## Claims PROVED_IN_LEAN

- The subcritical normalized pattern predicate.
- The upper bound `score <= 6`.
- If a pattern is not locked to the `6`-lattice, its score is at most `4`.
- If a subcritical pattern is locked to the `6`-lattice, it cannot also be
  fully locked to the `30`-lattice.
- Equality `score = 6` iff all offsets are divisible by `6` and exactly two
  residues modulo `5` are occupied.

## Claims COMPUTED_BY_PYTHON

Python path:

```text
src/bridge/subcritical_resonance.py
```

The verifier checks all `1711` normalized distinct patterns for `k=3`, `D=59`
and `gates=[2,3,5]`.

It confirms that the structural condition selects exactly:

```text
[0,6,30], [0,6,36],
[0,12,30], [0,12,42],
[0,18,30], [0,18,48],
[0,24,30], [0,24,54],
[0,30,36], [0,30,42],
[0,30,48], [0,30,54]
```

## What Remains OPEN?

The general one-gate-sacrifice theorem remains open. BT-0009 is the first
concrete subcritical case, not the full family theorem.

## Exact BT-0010 Target

BT-0010 should generalize the mechanism:

```text
gates = [2,3,q]
q coprime to 6, q > 3
W = 6q
k = 3
D = 2W - 1
```

Target theorem:

```text
FiniteResonanceNumerator [2,3,q] H <= 2 * (q - 2)
```

with equality iff:

```text
all offsets are divisible by 6
and
LocalResidueShadowCount q H = 2.
```

This would turn the BT-0009 fixed gate case into a reusable one-gate-sacrifice
schema.

## Boundary

This is finite-sieve / finite-combinatorics only. It is not an actual
prime-distribution theorem and does not prove Hardy-Littlewood, twin primes, or
prime tuples.
