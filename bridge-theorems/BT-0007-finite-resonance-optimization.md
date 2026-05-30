---
id: BT-0007
type: bridge-theorem
title: Finite resonance optimization theorem
status: proved-in-lean-all-k-D-P-finite-classifier
source_bridges:
  - B-0007
related_conjectures:
  - C-0007
lean_path: lean/NumBridge/ResonanceOptimization.lean
label: finite-combinatorics-new-math-candidate
---
# BT-0007: Finite Resonance Optimization Theorem

## Symbolic Language

`strongest resonance`, `best surviving pattern`, `harmonic prime shape`.

## Mathematical Structure

BT-0007 uses the BT-0006 finite-wheel layer to optimize finite resonance
scores. It now has two closed Lean layers:

1. a two-point bounded optimization theorem for patterns `[0,d]`;
2. a broad exhaustive classifier theorem for every finite `k`, `D`, and `P`.

The local integer numerator is:

```text
if d ≡ 0 mod p then p - 1 else p - 2
```

and the finite score is the product of these local numerators over a gate list.
This is the numerator part of the truncated two-point resonance product:

```text
Res_P(H) = prod_{p <= P} (1 - nu_p(H) / p) / (1 - 1 / p)^k
```

where the denominator is fixed for fixed gates and `k = 2`.

## Lean Result

Lean path:

```text
lean/NumBridge/ResonanceOptimization.lean
```

Closed theorem names:

```text
NumBridge.two_point_finite_resonance_score_le_max
NumBridge.two_point_finite_resonance_score_eq_max_of_all_dvd
NumBridge.two_point_gateProduct_attains_resonance_max
NumBridge.bt0007_two_point_bounded_finite_resonance_optimization
NumBridge.finite_resonance_maximizers_classify
NumBridge.bt0007_all_k_D_P_finite_resonance_classification
```

## Theorem Statement

```text
If D >= gateProduct gates, then among all two-point gaps d <= D,
d = gateProduct gates attains the absolute finite-resonance upper bound:

TwoPointFiniteResonanceScore gates d <= TwoPointFiniteResonanceMax gates.
```

Broad all-`k,D,P` finite classifier:

```text
H ∈ BT0007FiniteResonanceClassifiers k D P
iff
H ∈ BoundedCandidatePatterns k D
and every bounded candidate G has
  FiniteResonanceNumerator (GateModuliUpTo P) G
  <= FiniteResonanceNumerator (GateModuliUpTo P) H.
```

## Current Status

`PROVED_IN_LEAN` for the two-point bounded finite optimization theorem and for
the broad all-`k,D,P` exhaustive finite classifier.

Closed-form structural descriptions of all maximizing families remain open
finite-combinatorics work.

## Boundary

This is a finite optimization theorem target. It does not assert that the
maximizing finite pattern has infinitely many prime translates.
