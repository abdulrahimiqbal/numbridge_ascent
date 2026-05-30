---
id: C-0009
type: conjecture
title: Subcritical resonance
status: proved-in-lean
source_lead: L-0009
bridge: B-0009
lean_status: subcritical-235-structural-theorem-proved
theorem_kind: finite_subcritical_resonance
related_experiments: []
---
# C-0009: Subcritical Resonance

## Statement

For normalized distinct three-point patterns `H` with all offsets bounded by
`59`, define:

```text
score(H) = FiniteResonanceNumerator [2,3,5] H
```

Then:

```text
score(H) <= 6
```

and equality holds if and only if:

```text
every h in H is divisible by 6
and
LocalResidueShadowCount 5 H = 2.
```

## Current Status

`PROVED_IN_LEAN`: the upper bound and equality characterization compile in
`lean/NumBridge/SubcriticalResonance.lean`.

`COMPUTED_BY_PYTHON`: bounded search over all normalized distinct patterns in
the window confirms that the structural condition picks out exactly the twelve
maximizers previously found by computation.

## Boundary

This is finite-sieve / finite-combinatorics only. It is not a theorem about
actual prime distribution.
