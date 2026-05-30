---
id: BT-0001
type: bridge-theorem
title: Digit collapse is modular arithmetic
status: lightweight-theorem-proved
source_bridges:
  - B-0001
related_conjectures:
  - C-0001
lean_path: lean/NumBridge/BridgeTheorems.lean
label: useful
---
# BT-0001: Digit collapse is modular arithmetic

## Symbolic Language

`root`, `completion`, `collapse to one digit`.

## Mathematical Structure

Digit sum and digital root correspond to residues modulo `b - 1`.

## Lean Result

Closed lightweight decimal theorem:

```text
NumBridge.digital_root_10_mod_nine
```

This proves that the lightweight decimal digital root preserves residue modulo
9:

```text
digital_root_10 n % 9 = n % 9
```

## Remaining Work

The full Bridge Theorem should define digit lists, digit sums, and iterated
digit roots in arbitrary base `b`, then prove that digit-sum iteration preserves
residue modulo `b - 1`.
