---
id: C-0007
type: conjecture
title: Finite resonance optimization
status: proved-in-lean-all-k-D-P-finite-classifier
source_lead: L-0007
bridge: B-0007
lean_status: all-k-D-P-finite-classifier-proved
theorem_kind: finite_resonance_optimization
related_experiments: []
---
# C-0007: Finite Resonance Optimization

## Statement

For fixed natural parameters `k`, `D`, and finite prime bound `P`, classify or
bound the admissible offset patterns `H` with `|H| = k` and
`diameter(H) <= D` that maximize:

```text
Res_P(H) = prod_{p <= P} (1 - nu_p(H) / p) / (1 - 1 / p)^k
```

## Current Status

`PROVED_IN_LEAN`: the first exact theorem is closed for two-point patterns
`[0,d]`. If `D >= gateProduct gates`, then `d = gateProduct gates` attains the
finite resonance numerator upper bound among all `d <= D`.

`PROVED_IN_LEAN`: for every `k`, `D`, and `P`, the generated finite classifier
contains exactly the bounded canonical candidate patterns whose finite
resonance numerator is globally maximal in that finite search space.

`COMPUTED_BY_PYTHON`: existing resonance ranking code can generate candidate
maximizers for bounded `(k, D, P)`.

`OPEN`: closed-form structural descriptions of all maximizing families.

## Boundary

This conjecture is about finite admissible patterns and finite products. It is
not a proof of prime tuples, asymptotic prime density, or Hardy-Littlewood.
