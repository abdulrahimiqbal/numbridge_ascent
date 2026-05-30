---
id: C-0013
type: conjecture
title: Finite Gallagher resonance conservation
status: partial-proved-in-lean
source_lead: null
bridge: B-0013
lean_status: single-and-two-gate-proved
theorem_kind: finite_gallagher_resonance_conservation
related_experiments: []
---
# C-0013: Finite Gallagher Resonance Conservation

## Theorem Closed In Lean

Lean proves the arbitrary-`k` single-gate and two-gate conservation laws:

```text
NumBridge.single_gate_local_survivor_sum
NumBridge.bt0013_two_gate_finite_gallagher_resonance_conservation
```

The two-gate theorem says that for positive coprime gates `p` and `q`:

```text
sum_{H in (Z / pqZ)^k}
  LocalGateSurvivorCount p H * LocalGateSurvivorCount q H
=
p*q * (p - 1)^k * (q - 1)^k
```

## Full Target Still Open

For arbitrary positive pairwise-coprime gate lists:

```text
sum_H FiniteResonanceNumerator gates H
  = gateProduct gates * product_{p in gates} (p - 1)^k
```

This remains the next Lean target. It should be attacked by a residue-choice
CRT induction, not by enumerating fixed wheels.

## Current Status

`PROVED_IN_LEAN`: single-gate and two-gate arbitrary-`k` conservation.

`COMPUTED_BY_PYTHON`: arbitrary tested gate-list audits and scans.

`OPEN`: full arbitrary finite gate-list Lean theorem and all analytic
prime-distribution upgrades.
