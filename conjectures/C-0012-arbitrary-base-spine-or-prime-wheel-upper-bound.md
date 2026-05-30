---
id: C-0012
type: conjecture
title: Arbitrary base-spine or prime wheel upper bound
status: actual-prime-bridge-elementary-proved
source_lead: null
bridge: B-0012
lean_status: prime-wheel-upper-bound-proved
theorem_kind: elementary_actual_prime_wheel_bound
related_experiments: []
---
# C-0012: Arbitrary Base-Spine Or Prime Wheel Upper Bound

## Original Target

Close the full arbitrary finite base-spine first-subcritical theorem left open
by BT-0011.

## Pivot Result

The arbitrary base-spine theorem remains open. The landed theorem is the
elementary actual-prime wheel upper bound:

```text
NumBridge.bt0012_prime_tuple_wheel_upper_bound
```

If a Boolean predicate only accepts actual prime tuple translates above all
gates, its count up to `N` is at most:

```text
WheelSurvivorCountGeneral gates H * (N / gateProduct gates + 1)
```

## Current Status

`PROVED_IN_LEAN`: elementary actual-prime wheel upper bound.

`COMPUTED_BY_PYTHON`: sample verification for `H=0,2,6`, `gates=2,3,5`,
`N=100000`.

`OPEN`: Selberg-sieve upper bounds and any asymptotic prime-distribution
theorem.
