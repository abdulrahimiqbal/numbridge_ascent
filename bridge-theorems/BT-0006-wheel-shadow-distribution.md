---
id: BT-0006
type: bridge-theorem
title: Wheel-shadow distribution theorem
status: finite-sieve-lean-product-layer
source_bridges:
  - B-0006
related_conjectures:
  - C-0006
lean_path: lean/NumBridge/WheelProduct.lean
label: prime-distribution-finite-sieve-bridge-theorem
---
# BT-0006: Wheel-Shadow Distribution Theorem

## Symbolic Language

`resonance`, `survival through prime gates`.

## Mathematical Structure

For an offset pattern `H` and squarefree wheel `W = prod P`, the residues that
survive all wheel gates are:

```text
R_W(H) = {a mod W : for every h in H, gcd(a+h, W)=1}
```

The finite-sieve product theorem predicts:

```text
|R_W(H)| = prod_{p | W} (p - nu_p(H))
```

where `nu_p(H)` is the residue-shadow size modulo `p`.

## Python Result

The product formula is checked by brute force for finite wheels:

```text
exact_wheel_distribution_holds
normalized_wheel_density
wheel_resonance_factor
compare_patterns_by_wheel_distribution
```

## Lean Result

Concrete Lean facts and product-layer theorems:

```text
NumBridge.twin_survives_mod_two_three_iff_mod_six_five
NumBridge.zero_two_four_no_survivor_mod_two_three
NumBridge.zero_two_six_wheel30_product_count_arithmetic
NumBridge.local_gate_survivor_count_eq_modulus_sub_shadow
NumBridge.wheel6_residue_product_formula
NumBridge.wheel6_residue_product_formula_as_shadow_sub
NumBridge.wheel30_residue_product_formula
NumBridge.wheel30_residue_product_formula_as_shadow_sub
```

The 6-wheel and 30-wheel theorems are no longer tied to a named pattern such as
`[0,2]` or `[0,2,6]`: they hold for every finite offset list `H`. This is a
formal CRT-table layer for the first nontrivial squarefree wheels.

## Classification

Prime-distribution / finite-sieve / formalization-progress.

This is about exact finite-sieve candidate distribution, not about actual prime
distribution.

## Remaining Work

Prove the full squarefree product theorem in Lean for arbitrary finite prime
gate lists. The next missing piece is a reusable CRT/cardinality lemma replacing
the explicit 6- and 30-wheel Boolean tables.
