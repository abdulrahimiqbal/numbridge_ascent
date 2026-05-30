---
id: BT-0002
type: bridge-theorem
title: Mirror symmetry creates divisibility gates
status: intermediate-theorems-proved
source_bridges:
  - B-0002
related_conjectures:
  - C-0002
  - C-0003
lean_path: lean/NumBridge/BridgeTheorems.lean
label: strong-target
---
# BT-0002: Mirror Symmetry Creates Divisibility Gates

## Symbolic Language

`mirror`, `reflection`, `11 gate`.

## Mathematical Structure

Even-length base-`b` palindromes are divisible by `b + 1`.

## Lean Result

Closed base-10 intermediate theorems:

```text
NumBridge.four_digit_mirror_divisible_by_11
NumBridge.six_digit_mirror_factorization
NumBridge.six_digit_mirror_divisible_by_11
NumBridge.mirror_symmetry_creates_divisibility_gates_bridge
```

The six-digit theorem proves that numbers of the form
`100000*a + 10000*b + 1000*c + 100*c + 10*b + a` are divisible by 11.

## Remaining Work

The full Bridge Theorem should define a base-`b` digit-list value function and
prove that `value (xs ++ reverse xs)` is divisible by `b + 1`.
