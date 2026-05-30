# BT-0006 General Wheel Product Breakthrough - 2026-05-30

## 1. Was the arbitrary squarefree-wheel theorem closed in Lean?

Yes. The full finite-wheel theorem for an arbitrary finite list of positive
pairwise-coprime gates is now closed in Lean.

## 2. Exact Lean theorem names

```text
NumBridge.wheel_survivor_count_product_general
NumBridge.product_local_gate_survivor_count_eq_shadow_sub_general
NumBridge.wheel_survivor_count_product_as_shadow_sub_general
NumBridge.bt0006_squarefree_wheel_shadow_distribution
```

## 3. Reusable CRT/cardinality lemma proved

The central reusable lemma is proved in Lean:

```text
NumBridge.crt_count_product_two_moduli
```

It proves that for positive coprime moduli `M` and `p`, arbitrary Boolean local
predicates factor exactly over residues modulo `M * p`:

```text
count a in range (M*p) with PM(a mod M) and Pp(a mod p)
= count x in range M with PM(x) * count y in range p with Pp(y)
```

The named alias is:

```text
NumBridge.wheel_product_step
```

The induction applies this lemma recursively over the gate list.

## 4. Did this replace the explicit 6/30 Boolean tables?

Yes for the replacement proof layer. The older table theorems remain in
`lean/NumBridge/WheelProduct.lean`, but the new file proves:

```text
NumBridge.wheel6_residue_product_formula_via_crt
NumBridge.wheel30_residue_product_formula_via_crt
```

These derive the wheel 6 and wheel 30 product formulas from the reusable CRT
count theorem rather than from explicit Boolean table enumeration.

## 5. PROVED_IN_LEAN

```text
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

Existing BT-0006 product-layer theorems also remain proved:

```text
NumBridge.local_gate_survivor_count_eq_modulus_sub_shadow
NumBridge.wheel6_residue_product_formula_as_shadow_sub
NumBridge.wheel30_residue_product_formula_as_shadow_sub
```

## 6. COMPUTED_BY_PYTHON

The Python mirror lives at:

```text
src/bridge/wheel_product_general.py
```

It checks arbitrary finite pairwise-coprime gate lists by brute force:

```text
verify_general_wheel_product
wheel_survivor_count_general
product_local_survivor_counts
brute_force_crt_count_product
search_for_counterexample_to_wheel_product
```

The CLI exposes:

```bash
python3 bridge.py wheel-product-general H=0,2,6 gates=2,3,5
python3 bridge.py wheel-product-counterexample-search --max-gate 12 --max-offset 20
```

## 7. OPEN

The arbitrary gate-list induction is no longer open. The closed theorem is:

```text
WheelSurvivorCountGeneral gates H =
ProductLocalGateSurvivorCount gates H
```

under positive pairwise-coprime gates, followed by the closed
shadow-substitution form:

```text
WheelSurvivorCountGeneral gates H =
product over p in gates of (p - LocalResidueShadowCount p H)
```

Still open: a more ergonomic reusable `Finset`/`Fin` API, and any theorem about
actual prime distribution rather than finite wheel candidates.

## 8. Finite-sieve boundary

This is a theorem about residue classes modulo a finite wheel. It counts
candidate residues that survive local divisibility gates. It does not prove
that any translate consists of primes, does not give prime-density asymptotics,
and does not prove the Hardy-Littlewood prime-tuples conjecture.

## 9. Numerological branch interpretation

The symbolic phrase "resonance through prime gates" is now rigorous as finite
local survival through residue gates. A pattern "resonates" in this branch only
when its occupied residue shadows leave surviving classes across the chosen
finite wheel.

Classification: `finite-sieve / CRT / proved-in-Lean`.
