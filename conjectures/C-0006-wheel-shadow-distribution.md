---
id: C-0006
type: conjecture
title: Wheel-shadow distribution
status: proved-in-lean-finite-sieve-crt
source_lead: L-0006
bridge: B-0006
lean_status: arbitrary-positive-pairwise-coprime-gate-list-theorem-proved
theorem_kind: wheel_shadow_distribution
related_experiments: []
---
# C-0006: Wheel-Shadow Distribution

## Statement

For a finite offset pattern `H` and squarefree wheel `W = prod P`, the number of
residues `a mod W` such that every `a+h` is coprime to `W` equals:

```text
prod_{p in P} (p - nu_p(H))
```

## Current Status

`COMPUTED_BY_PYTHON`: the product formula is checked by brute force for finite
patterns, prime sets, and arbitrary tested pairwise-coprime gate lists.

`PROVED_IN_LEAN`: concrete wheel-shadow facts for `[0,2]`, `[0,2,4]`, and
product-side arithmetic for `[0,2,6]`.

`PROVED_IN_LEAN`: for arbitrary finite offset lists, local gate survivors are
`p - nu_p(H)`; a reusable two-modulus CRT/cardinality theorem factors local
Boolean predicates over coprime moduli; and the full arbitrary positive
pairwise-coprime gate-list product theorem holds in Lean.

## Boundary

This is an exact finite-sieve distribution theorem, not a proof of the
Hardy-Littlewood prime k-tuples conjecture.
