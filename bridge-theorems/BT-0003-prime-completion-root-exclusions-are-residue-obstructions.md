---
id: BT-0003
type: bridge-theorem
title: Prime completion-root exclusions are residue obstructions
status: shallow-real-theorem-proved
source_bridges:
  - B-0001
related_conjectures:
  - C-0001
lean_path: lean/NumBridge/BridgeTheorems.lean
label: shallow-real
---
# BT-0003: Prime Completion-Root Exclusions Are Residue Obstructions

## Symbolic Language

`completion roots vanish from primes`.

## Mathematical Structure

If `q` is a prime divisor of `b - 1` and `p > q` is prime, then the base-`b`
digital root of `p` cannot be divisible by `q`.

## Lean Result

Closed decimal instance:

```text
NumBridge.residue_three_six_zero_mod_nine_implies_three_dvd
NumBridge.digital_root_10_eq_three_six_nine_implies_three_dvd
NumBridge.prime_completion_roots_vanish_bridge
```

Together with the PrimeBridge theorem in `lean/NumBridge/PrimeDigitalRoot.lean`,
this proves that primes greater than 3 cannot have lightweight decimal digital
root 3, 6, or 9.

## Classification

Shallow-real. The translation is correct and Lean-checked, but the phenomenon is
fully explained by divisibility by 3.

## Remaining Work

The full Bridge Theorem should parameterize the base `b` and prime divisor `q`
of `b - 1`, then connect a base-`b` digital-root function to divisibility by
`q`.
