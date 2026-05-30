---
id: BT-0009
type: bridge-theorem
title: Subcritical resonance theorem
status: proved-in-lean
source_bridges:
  - B-0009
related_conjectures:
  - C-0009
lean_path: lean/NumBridge/SubcriticalResonance.lean
label: finite-sieve-subcritical-structural-theorem
---
# BT-0009: Subcritical Resonance Theorem

## Symbolic Language

`subcritical resonance`, `one gate sacrifice`, `partial lattice lock`.

## Mathematical Structure

BT-0008 says absolute finite resonance occurs on the full gate-product lattice.
BT-0009 studies the first case where the full three-point lattice pattern does
not fit the diameter bound:

```text
gates = [2,3,5]
W = 30
k = 3
D = 59 = 2W - 1
```

The full lattice pattern `[0,30,60]` is unavailable. The best score preserves
the `2`- and `3`-gate locks, then sacrifices exactly one residue at the
`5`-gate:

```text
score(H) = 6
iff
all offsets are divisible by 6
and
LocalResidueShadowCount 5 H = 2.
```

## Lean Result

Lean path:

```text
lean/NumBridge/SubcriticalResonance.lean
```

Closed theorem names:

```text
NumBridge.Pattern235Subcritical
NumBridge.AllOffsetsDivisibleBy6
NumBridge.OccupiesExactlyTwoResiduesMod5
NumBridge.Subcritical235Score
NumBridge.no_subcritical_pattern_all_offsets_divisible_by30
NumBridge.subcritical235_score_le_four_of_not_all_divisible_by6
NumBridge.bt0009_subcritical_235_k3_D59_upper_bound
NumBridge.subcritical235_score_eq_six_of_structure
NumBridge.structure_of_subcritical235_score_eq_six
NumBridge.bt0009_subcritical_235_k3_D59_equality_characterization
NumBridge.bt0009_subcritical_235_k3_D59_structural_breakthrough
```

## Theorem Statement

```text
For any H satisfying Pattern235Subcritical H:

FiniteResonanceNumerator [2,3,5] H <= 6

and

FiniteResonanceNumerator [2,3,5] H = 6
iff
AllOffsetsDivisibleBy6 H
and
LocalResidueShadowCount 5 H = 2.
```

## Current Status

`PROVED_IN_LEAN`: full structural theorem for the first subcritical window.

`COMPUTED_BY_PYTHON`: the verifier checks all `1711` normalized distinct
patterns in the window and confirms that the structural condition identifies
exactly the twelve maximizers.

## Boundary

This is finite-sieve combinatorics. It does not claim anything about actual
prime tuples, Hardy-Littlewood, or prime distribution.
