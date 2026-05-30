---
id: C-0011
type: conjecture
title: General first-subcritical sacrifice
status: partially-proved-in-lean
source_lead: null
bridge: B-0011
lean_status: two-gate-fallback-proved
theorem_kind: finite_first_subcritical_sacrifice
related_experiments: []
---
# C-0011: General First-Subcritical Sacrifice

## Full Target

Let `baseGates` be a finite list of gates with every gate at least `2` and
pairwise coprime. Let:

```text
L = gateProduct baseGates
B = prod_{g in baseGates} (g - 1)
```

If `q` is coprime to `L` and `B + 1 <= q`, then for normalized distinct
three-point patterns `H` bounded by `2*L*q - 1`,

```text
FiniteResonanceNumerator (baseGates ++ [q]) H <= B * (q - 2)
```

with equality exactly when:

```text
AllOffsetsDivisibleBy L H
and
LocalResidueShadowCount q H = 2.
```

## Lean-Proved Fallback

Lean proves the statement for arbitrary two-gate base spines `[a,b]`:

```text
NumBridge.bt0011_two_gate_first_subcritical_sacrifice_theorem
```

This strictly generalizes BT-0010 because the prior `[2,3,q]` theorem is the
case `a=2`, `b=3`.

## Current Status

`PROVED_IN_LEAN`: two-gate fallback theorem.

`COMPUTED_BY_PYTHON`: arbitrary finite base-spine finite checks and targeted
equality-edge search in the requested window.

`OPEN`: the full finite-list Lean induction. The missing ingredient is a clean
product-factor drop/equality lemma for arbitrary base-spine local factors,
strong enough to rule out the edge case `q = B + 1` without hardcoded
enumeration.

## Boundary

This remains finite-sieve combinatorics only. It does not imply a
Hardy-Littlewood theorem or any actual-prime distribution statement.
