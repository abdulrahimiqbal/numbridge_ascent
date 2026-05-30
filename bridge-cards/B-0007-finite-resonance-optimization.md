---
id: B-0007
type: bridge
title: Finite resonance optimization
status: proved-in-lean-all-k-D-P-finite-classifier
source_leads:
  - L-0007
related_conjectures:
  - C-0007
bridge_strength: finite-combinatorics-exhaustive-classifier
lean_priority: high
---
# B-0007: Finite Resonance Optimization

## Symbolic Form

Strongest resonance patterns survive the prime gates best.

## Mathematical Form

For admissible `k`-offset patterns with bounded diameter, optimize finite-wheel
resonance scores such as:

```text
Res_P(H) = prod_{p <= P} (1 - nu_p(H) / p) / (1 - 1 / p)^k
```

BT-0006 proves the exact finite-wheel product theorem that makes this score a
precise finite-sieve object. BT-0007 now closes an exact exhaustive finite
argmax classifier for every `k`, `D`, and `P`.

## Evidence

The existing PrimeBridge engine computes residue shadows, admissibility
witnesses, local survival factors, and resonance rankings.

Lean proves:

```text
NumBridge.two_point_finite_resonance_score_le_max
NumBridge.two_point_gateProduct_attains_resonance_max
NumBridge.bt0007_two_point_bounded_finite_resonance_optimization
NumBridge.finite_resonance_maximizers_classify
NumBridge.bt0007_all_k_D_P_finite_resonance_classification
```

The theorem says that for two-point patterns `[0,d]`, the finite resonance
numerator is bounded by the product of best local factors, and if
`gateProduct gates <= D`, the canonical gap `d = gateProduct gates` attains
that bound under the diameter constraint `d <= D`.

The broad classifier theorem says that for every `k`, `D`, and `P`, membership
in `BT0007FiniteResonanceClassifiers k D P` is equivalent to being a bounded
canonical candidate pattern whose finite resonance numerator is globally
maximal over the finite candidate universe.

## Claim Labels

- `INTERPRETIVE_FORMALIZATION`
- `COMPUTED_BY_PYTHON` for bounded searches
- `PROVED_IN_LEAN` for the two-point bounded optimization theorem
- `PROVED_IN_LEAN` for the broad all-`k,D,P` exhaustive finite classifier
- `OPEN` for closed-form structural descriptions of all maximizer families
- `NOT_PROVEN` for actual prime-distribution consequences

## Classification

Finite combinatorics / resonance optimization / exhaustive classifier proved in
Lean.
