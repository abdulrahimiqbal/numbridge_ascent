# BT-0006 Formalization Push - 2026-05-30

## 2026-05-30 Update

This report is superseded by
`reports/bt0006_general_wheel_product_breakthrough_2026-05-30.md`. The full
arbitrary finite positive pairwise-coprime gate-list induction is now closed in
Lean as `NumBridge.bt0006_squarefree_wheel_shadow_distribution`.

## Goal

Upgrade BT-0006 from Python-checked finite examples toward a general
finite-sieve product theorem:

```text
|R_W(H)| = prod_{p | W} (p - nu_p(H))
```

for finite offset lists `H` and squarefree wheels `W`.

## What Was Proved In Lean

New Lean path:

```text
lean/NumBridge/WheelProduct.lean
```

Closed theorem names:

```text
NumBridge.local_gate_survivor_count_eq_modulus_sub_shadow
NumBridge.wheel6_residue_product_formula
NumBridge.wheel6_residue_product_formula_as_shadow_sub
NumBridge.wheel30_residue_product_formula
NumBridge.wheel30_residue_product_formula_as_shadow_sub
```

The first theorem is fully general over finite offset lists:

```text
LocalGateSurvivorCount p H = p - LocalResidueShadowCount p H
```

The 6-wheel and 30-wheel theorems are fully general over finite offset lists
`H`, but only for the fixed squarefree wheels `2 * 3` and `2 * 3 * 5`.

## What Remains Open

The full arbitrary squarefree-wheel theorem is not closed.

The current Lean proof uses explicit Boolean CRT tables for wheels 6 and 30.
The missing breakthrough theorem is a reusable CRT/cardinality framework that
turns those finite tables into an induction over arbitrary pairwise-coprime
prime gates.

## Classification

Useful formalization progress / finite-sieve theorem layer.

This is not yet a public mathematical breakthrough. It is a real project
upgrade because the Lean layer now proves product formulas for arbitrary
patterns rather than only named examples.

## Next Strongest Target

Prove a general CRT cardinality lemma:

```text
count residues modulo M * p satisfying local predicates modulo M and p
= count residues modulo M satisfying the first predicate
  * count residues modulo p satisfying the second predicate
```

under `Nat.Coprime M p`.

Once that lemma is available, BT-0006 should close by induction over the list
of squarefree prime gates.
