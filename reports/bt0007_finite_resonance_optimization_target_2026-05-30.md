# BT-0007 Finite Resonance Optimization Closure - 2026-05-30

## Why BT-0007 Is Next

BT-0006 closed the exact finite-wheel product theorem in Lean. The next
meaningful leap is not another CRT theorem. It is to use the finite product
formula to prove finite optimization statements about prime-pattern resonance.

## Target

For fixed `k`, diameter bound `D`, and finite prime bound `P`, study admissible
offset patterns `H` that maximize:

```text
Res_P(H) = prod_{p <= P} (1 - nu_p(H) / p) / (1 - 1 / p)^k
```

## Honest Status

`BT-0006`: `PROVED_IN_LEAN`, foundational finite-sieve / CRT /
wheel-shadow distribution theorem.

`BT-0007`: broad all-`k,D,P` exhaustive finite classifier proved in Lean.

Closed theorem:

```text
NumBridge.bt0007_two_point_bounded_finite_resonance_optimization
NumBridge.bt0007_all_k_D_P_finite_resonance_classification
```

For two-point patterns `[0,d]`, Lean proves that the finite resonance numerator
is bounded by the product of best local factors, and that `d = gateProduct gates`
attains the bound whenever the diameter bound `D` satisfies
`gateProduct gates <= D`.

For every `k`, `D`, and `P`, Lean also proves that membership in the generated
classifier is equivalent to being a bounded canonical candidate pattern whose
finite resonance numerator is globally maximal in that finite search space.

## Why This Could Matter

This is finite combinatorics, not analytic prime distribution. But exact
maximizer classifications, inequalities, or structural restrictions for
finite-wheel resonance may be new and independently checkable.

## First Concrete Work Item

Use the classifier to generate maximizer families, then try to prove
closed-form structural descriptions for interesting parameter ranges.
