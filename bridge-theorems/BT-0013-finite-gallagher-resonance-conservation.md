---
id: BT-0013
type: bridge-theorem
title: Finite Gallagher resonance conservation
status: partial-proved-in-lean
source_bridges:
  - B-0013
related_conjectures:
  - C-0013
lean_path: lean/NumBridge/FiniteGallagher.lean
label: internal-numbridge-breakthrough
---
# BT-0013: Finite Gallagher Resonance Conservation

## Symbolic Language

Resonance averages to neutral across the whole finite wheel.

## Mathematical Structure

For a gate `p`, the sum over all length-`k` residue tuples modulo `p` of the
number of avoided residues is exactly:

```text
p * (p - 1)^k
```

For two positive coprime gates `p` and `q`, the sum over all length-`k` residue
tuples modulo `p*q` of the product of local avoided counts is exactly:

```text
p*q * (p - 1)^k * (q - 1)^k
```

This is the first finite-wheel analogue of Gallagher-style singular-series
averaging proved in Lean for arbitrary `k`.

## Lean Status

`PROVED_IN_LEAN`:

```text
NumBridge.tuples_length_count
NumBridge.tuples_all_count
NumBridge.single_gate_avoided_residue_sum
NumBridge.single_gate_local_survivor_sum
NumBridge.two_gate_finite_gallagher_conservation
NumBridge.two_gate_finite_gallagher_conservation_local
NumBridge.bt0013_two_gate_finite_gallagher_resonance_conservation
```

## Open Generalization

The full arbitrary pairwise-coprime finite gate-list theorem remains open in
Lean. The missing proof step is the residue-choice CRT/product induction that
turns the two-gate conservation proof into:

```text
sum_H FiniteResonanceNumerator gates H
  = gateProduct gates * product_{p in gates} (p - 1)^k
```

## Classification

`INTERNAL_NUMBRIDGE_BREAKTHROUGH`

This is not Hardy-Littlewood, not Gallagher's infinite/asymptotic theorem, and
not a prime-distribution theorem.
