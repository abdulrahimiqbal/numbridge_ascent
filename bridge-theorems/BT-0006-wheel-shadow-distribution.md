---
id: BT-0006
type: bridge-theorem
title: Wheel-shadow distribution theorem
status: proved-in-lean-finite-sieve-crt
source_bridges:
  - B-0006
related_conjectures:
  - C-0006
lean_path: lean/NumBridge/WheelProductGeneral.lean
label: finite-sieve-crt-bridge-theorem
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

The product formula is checked by brute force for finite wheels and arbitrary
tested pairwise-coprime gate lists:

```text
exact_wheel_distribution_holds
verify_general_wheel_product
wheel_survivor_count_general
product_local_survivor_counts
search_for_counterexample_to_wheel_product
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
NumBridge.crt_count_product_two_moduli
NumBridge.wheel_product_step
NumBridge.wheel6_residue_product_formula_via_crt
NumBridge.wheel30_residue_product_formula_via_crt
NumBridge.bt0006_two_moduli_wheel_shadow_distribution
NumBridge.bt0006_two_moduli_wheel_shadow_distribution_as_shadow_sub
NumBridge.wheel_survivor_count_product_general
NumBridge.product_local_gate_survivor_count_eq_shadow_sub_general
NumBridge.wheel_survivor_count_product_as_shadow_sub_general
NumBridge.bt0006_squarefree_wheel_shadow_distribution
```

The 6-wheel and 30-wheel theorems are no longer tied to a named pattern such as
`[0,2]` or `[0,2,6]`: they hold for every finite offset list `H`. This is a
formal product layer for the first nontrivial squarefree wheels.

The newest Lean layer proves the reusable two-modulus CRT/cardinality theorem:

```text
count a in range (M*p) with PM(a mod M) and Pp(a mod p)
= count x in range M with PM(x) * count y in range p with Pp(y)
```

under positive coprime moduli. The wheel 6 and wheel 30 product formulas now
have replacement proofs via this theorem.

The full induction is now closed for arbitrary finite positive pairwise-coprime
gate lists:

```text
WheelSurvivorCountGeneral gates H =
ProductLocalGateSurvivorCount gates H
```

and in shadow-complement form:

```text
WheelSurvivorCountGeneral gates H =
prod_{p in gates} (p - nu_p(H))
```

## Classification

Finite-sieve / CRT / proved-in-Lean.

This is about exact finite-sieve candidate distribution, not about actual prime
distribution.

## Remaining Work

The next work is not this finite-wheel theorem; it is either a cleaner
`Finset`/`Fin` API for reuse or a separate theorem connecting these finite
wheel counts to analytic prime-distribution hypotheses. No actual-prime
distribution theorem is claimed here.
