---
id: BT-0008
type: bridge-theorem
title: Resonance lattice maximizer theorem
status: proved-in-lean-core-threshold-reverse-open
source_bridges:
  - B-0008
related_conjectures:
  - C-0008
lean_path: lean/NumBridge/ResonanceLatticeMaximizer.lean
label: finite-sieve-structural-maximizer
---
# BT-0008: Resonance Lattice Maximizer Theorem

## Symbolic Language

`strongest resonance`, `gate-product alignment`, `lattice lock`.

## Mathematical Structure

For finite pairwise-coprime gates greater than one, the finite resonance
numerator:

```text
ProductLocalGateSurvivorCount gates H
```

is bounded above by:

```text
ResonanceUpperBound gates = prod_{p in gates} (p - 1)
```

for every zero-anchored pattern `H`. Equality is not mysterious: it happens
exactly when all offsets in `H` are congruent to zero modulo every gate, or
equivalently when every offset is divisible by `gateProduct gates`.

## Lean Result

Lean path:

```text
lean/NumBridge/ResonanceLatticeMaximizer.lean
```

Closed theorem names:

```text
NumBridge.nonempty_shadow_count_ge_one
NumBridge.local_survivor_count_le_p_minus_one
NumBridge.finite_resonance_numerator_le_upper_bound
NumBridge.local_survivor_count_eq_p_minus_one_iff_all_mod_zero
NumBridge.equality_upper_bound_implies_single_shadow_each_gate
NumBridge.same_residue_as_zero_all_gates_iff_dvd_gateProduct
NumBridge.resonance_upper_bound_eq_iff_offsets_dvd_gateProduct
NumBridge.bt0008_resonance_lattice_maximizer_theorem
NumBridge.canonical_lattice_pattern_valid_if_D_ge
NumBridge.canonical_lattice_pattern_attains_upper_bound
NumBridge.bt0008_attainability_threshold_sufficient
NumBridge.bt0008_maximizer_family_characterization
```

## Theorem Statement

Core theorem:

```text
If gates are pairwise-coprime and every gate is > 1, and H starts at 0, then:

FiniteResonanceNumerator gates H <= ResonanceUpperBound gates

and

FiniteResonanceNumerator gates H = ResonanceUpperBound gates
iff
every h in H is divisible by gateProduct gates.
```

Canonical attainability:

```text
If k > 0 and (k - 1) * gateProduct gates <= D, then
[0, W, 2W, ..., (k-1)W]
is a normalized distinct k-point pattern with offsets <= D and attains the
upper bound.
```

## Current Status

`PROVED_IN_LEAN`: A, B, the sufficient half of C, and the upper-bound family
characterization among normalized distinct patterns.

`COMPUTED_BY_PYTHON`: bounded verification of the full threshold behavior and
subcritical searches.

`OPEN`: full Lean proof of the reverse threshold and exact floor-family
classification:

```text
upper-bound attainer among k distinct offsets <= D
implies
D >= (k - 1)W.
```

## Boundary

This is a finite-combinatorics / finite-sieve theorem. It does not prove
Hardy-Littlewood, prime tuples, or any actual prime-distribution statement.
