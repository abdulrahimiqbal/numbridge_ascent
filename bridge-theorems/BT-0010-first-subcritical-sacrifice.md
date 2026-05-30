---
id: BT-0010
type: bridge-theorem
title: First subcritical sacrifice theorem
status: proved-in-lean
source_bridges:
  - B-0010
related_conjectures:
  - C-0010
lean_path: lean/NumBridge/FirstSubcriticalSacrifice.lean
label: finite-sieve-parametric-subcritical-structural-theorem
---
# BT-0010: First Subcritical Sacrifice Theorem

## Symbolic Language

`first subcritical zone`, `one gate sacrifice`, `partial lattice lock`.

## Mathematical Structure

BT-0010 generalizes BT-0009 from `[2,3,5]` to `[2,3,q]`.

Assume:

```text
5 <= q
Nat.Coprime q 6
```

For normalized distinct three-point patterns with offsets at most
`12*q - 1`, Lean proves:

```text
FiniteResonanceNumerator [2,3,q] H <= 2 * (q - 2)
```

and equality holds exactly when:

```text
All offsets are divisible by 6
and
LocalResidueShadowCount q H = 2.
```

## Lean Result

Lean path:

```text
lean/NumBridge/FirstSubcriticalSacrifice.lean
```

Closed theorem names:

```text
NumBridge.gateProduct_two_three_q
NumBridge.no_first_subcritical_pattern_all_offsets_divisible_by_six_q
NumBridge.local_shadow_q_ge_two_of_all_divisible_by6_first_subcritical
NumBridge.local_q_le_q_minus_two_of_all_divisible_by6_first_subcritical
NumBridge.first_subcritical_score_le_q_minus_one_of_not_six_lock
NumBridge.first_subcritical_upper_bound_two_three_q
NumBridge.first_subcritical_equality_forces_six_lock_and_q_sacrifice
NumBridge.first_subcritical_six_lock_and_q_sacrifice_attains
NumBridge.bt0010_first_subcritical_sacrifice_theorem
NumBridge.canonical_first_subcritical_attainer_pattern
NumBridge.canonical_first_subcritical_attainer_six_lock
NumBridge.canonical_first_subcritical_attainer_attains_if_q_shadow_two
```

## Current Status

`PROVED_IN_LEAN`: the parametric upper bound and equality iff theorem.

`COMPUTED_BY_PYTHON`: q-scans confirm the canonical pattern `[0,6,6q]`
attains the predicted maximum and no counterexample appears for the requested
range.

`OPEN`: a direct Lean proof of
`LocalResidueShadowCount q [0,6,6*q] = 2`. Lean has isolated this as exactly
the missing sublemma for the unconditional canonical-attainer theorem.

## Boundary

This is finite-sieve combinatorics. It does not prove any actual prime
distribution theorem.
