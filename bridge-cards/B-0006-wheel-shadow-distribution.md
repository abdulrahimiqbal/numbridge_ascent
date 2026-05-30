---
id: B-0006
type: bridge
title: Wheel-shadow distribution
status: finite-sieve-lean-product-layer
source_leads:
  - L-0006
related_conjectures:
  - C-0006
bridge_strength: prime-distribution-finite-sieve
lean_priority: high
---
# B-0006: Wheel-Shadow Distribution

## Symbolic Form

Resonance and survival through prime gates.

## Mathematical Form

Exact finite-wheel distribution:

```text
|R_W(H)| = prod_{p | W} (p - nu_p(H))
```

where `R_W(H)` is the set of wheel residues that keep every `a+h` coprime to
`W`.

## Evidence

Python computes and checks the product formula by brute force for finite
patterns and wheels. Lean proves concrete wheel facts for `[0,2]`, `[0,2,4]`,
and the product-side arithmetic for `[0,2,6]` over the 2,3,5 wheel.

The formalization layer now also proves:

```text
NumBridge.local_gate_survivor_count_eq_modulus_sub_shadow
NumBridge.wheel6_residue_product_formula_as_shadow_sub
NumBridge.wheel30_residue_product_formula_as_shadow_sub
```

The 6-wheel and 30-wheel product theorems hold for arbitrary finite offset
lists; the arbitrary squarefree-wheel theorem is still open.

## Claim Labels

- `INTERPRETIVE_FORMALIZATION`
- `COMPUTED_BY_PYTHON`
- `PROVED_IN_LEAN` for concrete facts and arbitrary-pattern 6-/30-wheel formulas
- `OPEN` for the full squarefree Lean theorem

## Classification

Prime-distribution / finite-sieve / bridge theorem. This is not a theorem about
actual primes; it is an exact theorem about finite-sieve candidate residues.
