---
id: L-0007
type: lead
title: Finite resonance optimization
status: theorem-proved
domain:
  - prime-patterns
  - finite-sieve
  - optimization
symbolic_terms:
  - resonance
  - strongest pattern
  - survival through gates
related_experiments: []
related_conjectures:
  - C-0007
related_bridges:
  - B-0007
---
# L-0007: Finite Resonance Optimization

## Symbolic Intuition

The strongest prime-pattern resonances should be the admissible offset patterns
that survive finite prime gates with maximal normalized density.

## Mathematical Interpretation

For a finite offset pattern `H` of size `k`, define the truncated resonance
score:

```text
Res_P(H) = prod_{p <= P} (1 - nu_p(H) / p) / (1 - 1 / p)^k
```

where `nu_p(H)` is the number of occupied residue classes modulo `p`.

## Current Status

Theorem proved. BT-0006 gives the exact finite-wheel product theorem underneath
this score, and BT-0007 now proves both a two-point bounded optimization theorem
and a broad all-`k,D,P` exhaustive finite classifier in Lean:

```text
NumBridge.bt0007_two_point_bounded_finite_resonance_optimization
NumBridge.bt0007_all_k_D_P_finite_resonance_classification
```

The next step is to find closed-form structural descriptions of the maximizing
families produced by the classifier.

## Boundary

This is finite combinatorics, not the Hardy-Littlewood prime-tuples conjecture
and not an actual prime-distribution theorem.
