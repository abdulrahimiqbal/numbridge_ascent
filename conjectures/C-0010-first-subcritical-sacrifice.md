---
id: C-0010
type: conjecture
title: First subcritical sacrifice
status: proved-in-lean
source_lead: L-0009
bridge: B-0010
lean_status: parametric-first-subcritical-sacrifice-proved
theorem_kind: finite_first_subcritical_sacrifice
related_experiments: []
---
# C-0010: First Subcritical Sacrifice

## Statement

Let `q >= 5` and `Nat.Coprime q 6`. For normalized distinct three-point
patterns `H` bounded by:

```text
D = 12*q - 1 = 2*(6q) - 1
```

the finite resonance numerator for gates `[2,3,q]` satisfies:

```text
FiniteResonanceNumerator [2,3,q] H <= 2 * (q - 2)
```

with equality if and only if:

```text
All offsets are divisible by 6
and
LocalResidueShadowCount q H = 2.
```

## Current Status

`PROVED_IN_LEAN`: the parametric upper bound and equality iff theorem compile
in `lean/NumBridge/FirstSubcriticalSacrifice.lean`.

`COMPUTED_BY_PYTHON`: the concrete canonical attainer `[0,6,6q]` is verified
for the requested bounded q scans. Lean proves that this pattern is valid and
that it attains once the isolated q-shadow count is supplied.

## Boundary

This is finite-sieve / finite-combinatorics only, not actual prime distribution.
