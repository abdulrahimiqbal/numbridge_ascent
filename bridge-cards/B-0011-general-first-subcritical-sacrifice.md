---
id: B-0011
type: bridge
title: General first-subcritical sacrifice
status: proved-in-lean-fallback
source_leads: []
related_conjectures:
  - C-0011
bridge_strength: finite-sieve-two-gate-subcritical-structural-theorem
lean_priority: high
---
# B-0011: General First-Subcritical Sacrifice

## Symbolic Form

In the first subcritical zone, strongest resonance keeps the base spine locked
and sacrifices exactly one residue at the new gate.

## Mathematical Form

For arbitrary two-gate base spines `[a,b]`, Lean proves the fallback BT-0011
theorem. Under:

```text
2 <= a, 2 <= b, 2 <= q
Nat.Coprime a b
Nat.Coprime q (a*b)
(a - 1)*(b - 1) + 1 <= q
```

every normalized distinct three-point pattern `H` bounded by:

```text
D = 2*(a*b*q) - 1
```

satisfies:

```text
FiniteResonanceNumerator [a,b,q] H
  <= (a - 1)*(b - 1)*(q - 2)
```

with equality exactly when:

```text
AllOffsetsDivisibleBy (a*b) H
and
LocalResidueShadowCount q H = 2.
```

## Lean Result

Lean path:

```text
lean/NumBridge/GeneralFirstSubcriticalSacrifice.lean
```

Closed theorem names:

```text
NumBridge.no_three_distinct_bounded_twoM_minus_one_all_dvd
NumBridge.q_gt_left_of_two_gate_threshold
NumBridge.q_gt_right_of_two_gate_threshold
NumBridge.dropped_left_two_gate_product_lt
NumBridge.dropped_right_two_gate_product_lt
NumBridge.two_gate_first_subcritical_base_lock_forces_q_shadow_ge_two
NumBridge.two_gate_local_q_le_q_minus_two_of_base_lock
NumBridge.two_gate_base_local_factor_eq_of_lock
NumBridge.two_gate_lock_of_base_local_factors_eq
NumBridge.two_gate_not_locked_score_drop
NumBridge.two_gate_first_subcritical_upper_bound
NumBridge.two_gate_first_subcritical_lock_and_q_sacrifice_attains
NumBridge.two_gate_first_subcritical_equality_forces_lock_and_q_sacrifice
NumBridge.bt0011_two_gate_first_subcritical_sacrifice_theorem
```

## Python Support

Python path:

```text
src/bridge/general_first_subcritical_sacrifice.py
```

CLI:

```bash
python3 bridge.py bt0011-general-sacrifice base=2,3 q=5
python3 bridge.py bt0011-general-sacrifice base=2,3 q=7
python3 bridge.py bt0011-general-sacrifice base=2,5 q=7
python3 bridge.py bt0011-counterexample-search --max-gate 12 --max-q 31 --max-base-len 4
python3 bridge.py bt0011-discover-next --max-gate 12 --max-q 31 --max-k 5
```

The Python checker rejects `base=2,3,5 q=7` as outside the theorem range
because `B + 1 = 9 > 7`.

## Claim Labels

- `PROVED_IN_LEAN` for the arbitrary two-gate fallback theorem.
- `COMPUTED_BY_PYTHON` for arbitrary-base finite checks and equality-edge
  counterexample search.
- `OPEN` for the full arbitrary finite base-spine Lean theorem.
- `NOT_PROVEN` for actual prime-distribution consequences.

## Classification

Finite-sieve / two-gate subcritical structural theorem. This is an internal
NumBridge breakthrough, not a field-level breakthrough claim.
