---
id: BT-0012
type: bridge-theorem
title: Arbitrary base-spine or prime wheel upper bound
status: actual-prime-bridge-elementary
source_bridges:
  - B-0012
related_conjectures:
  - C-0012
lean_path: lean/NumBridge/PrimeWheelUpperBound.lean
label: actual-prime-bridge-elementary
---
# BT-0012: Arbitrary Base-Spine Or Prime Wheel Upper Bound

## Fork

BT-0012 was the first forced fork after BT-0011:

1. Close the full arbitrary finite base-spine sacrifice theorem in Lean.
2. If that does not close cleanly, pivot to an actual-prime-count bridge using
   wheel-survivor machinery.

Path 2 landed.

## Part A Status

`OPEN`: the arbitrary finite base-spine theorem remains unproved in Lean. The
blocker is still the product-factor equality edge: ruling out non-base-locked
equality when the base local product is exactly one below the base upper bound.

Python still checks examples and the equality edge, but this is not a proof.

## Part B Lean Result

Lean path:

```text
lean/NumBridge/PrimeWheelUpperBound.lean
```

Closed theorem names:

```text
NumBridge.prime_translate_avoids_each_gate_residue
NumBridge.prime_tuple_translate_implies_wheel_survivor
NumBridge.prime_tuple_translate_implies_wheel_survivor_bool
NumBridge.predicate_count_le_wheel_survivor_blocks
NumBridge.bt0012_prime_tuple_wheel_upper_bound
```

Main theorem shape:

```text
If P is a Boolean enumerator whose true values are actual prime tuple
translates above all gates, then:

count_{n <= N} P(n)
  <= WheelSurvivorCountGeneral gates H * (N / gateProduct gates + 1)
```

This crosses from finite candidate residues to actual prime tuples, but only
as an elementary wheel obstruction upper bound.

## Classification

`ACTUAL_PRIME_BRIDGE_ELEMENTARY`

This is not a Selberg sieve theorem, Hardy-Littlewood theorem, or asymptotic
prime-distribution result.
