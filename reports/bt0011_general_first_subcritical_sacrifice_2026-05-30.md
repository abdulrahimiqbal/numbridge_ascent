# BT-0011 General First-Subcritical Sacrifice Report

## Attempted Bridge

Symbolic phrase:

```text
In the first subcritical zone, strongest resonance keeps the base spine locked
and sacrifices exactly one residue at the new gate.
```

Mathematical target A was the full arbitrary finite base-spine theorem for
`baseGates ++ [q]`. That theorem did not close in Lean in this pass.

Mathematical target B, the requested fallback, did close: arbitrary two-gate
base spines `[a,b,q]`.

## Lean Theorem Proved

Lean path:

```text
lean/NumBridge/GeneralFirstSubcriticalSacrifice.lean
```

Main closed theorem:

```text
NumBridge.bt0011_two_gate_first_subcritical_sacrifice_theorem
```

Statement shape:

```text
2 <= a, 2 <= b, 2 <= q
Nat.Coprime a b
Nat.Coprime q (a*b)
(a - 1)*(b - 1) + 1 <= q
TwoGateFirstSubcriticalPattern a b q H

FiniteResonanceNumerator [a,b,q] H
  <= (a - 1)*(b - 1)*(q - 2)

and equality iff:

AllOffsetsDivisibleBy (a*b) H
and
LocalResidueShadowCount q H = 2
```

No `sorry`, `admit`, or `axiom` is used.

## Exact Answers

1. Did BT-0011 land as a general base-spine theorem or only the two-gate fallback?

Only the two-gate fallback landed in Lean. The full arbitrary finite
base-spine theorem remains open.

2. Which exact Lean theorem names closed?

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

3. Does BT-0011 strictly generalize BT-0010?

Yes, the Lean-proved fallback strictly generalizes BT-0010 because BT-0010 is
the case `a = 2`, `b = 3`.

4. Did the theorem avoid classifier-by-definition logic?

Yes. The Lean theorem proves an upper bound and an equality characterization
from local survivor bounds, lattice-lock forcing, and a first-subcritical
pigeonhole lemma. It does not define a classifier and prove that the classifier
classifies itself.

5. Did it avoid fixed examples and hardcoded lists?

Yes for the Lean fallback: `a`, `b`, and `q` are arbitrary natural numbers
under explicit assumptions. No fixed q or fixed `[2,3]` spine is hardcoded.

6. Which claims are `PROVED_IN_LEAN`?

The arbitrary two-gate first-subcritical sacrifice theorem and its helper
lemmas.

7. Which claims are `COMPUTED_BY_PYTHON`?

Python verifies sample cases:

```text
base=[2,3], q=5
base=[2,3], q=7
base=[2,5], q=7
```

It also runs a bounded arbitrary-base counterexample search up to
`max_gate=12`, `max_q=31`, `max_base_len=4`. Large cases use a targeted
equality-edge search rather than exhaustive pattern enumeration, and the
reporting marks whether exact brute force was used.

8. Which claims remain `OPEN`?

The full arbitrary finite base-spine Lean theorem:

```text
baseGates arbitrary finite pairwise-coprime list
L = gateProduct baseGates
B = prod (g - 1)
q coprime to L
B + 1 <= q
```

with the same upper bound and equality iff condition. The missing Lean
ingredient is a reusable product-factor drop/equality lemma for arbitrary
base-spine local factors, especially the edge case `q = B + 1`.

9. Is this externally novel mathematics, a formalization contribution, or known finite-sieve combinatorics?

This should be treated as known finite-sieve combinatorics plus an internal
formalization step. A quick literature check found the surrounding residue
shadow and singular-series framework in standard prime k-tuple material:
Kedlaya's analytic number theory notes define the local correction using the
number of residue classes represented modulo `p`, and Pintz discusses
Gallagher's singular-series work in the Hardy-Littlewood prime k-tuple setting.

Links checked:

- https://kskedlaya.org/ant/chap-k-tuples.html
- https://arxiv.org/abs/1004.1084

10. What exact next theorem would cross closer to actual prime distribution?

Not another first-subcritical finite-wheel theorem. The next theorem should
connect finite-wheel resonance to an analytic sieve estimate, for example a
Selberg-sieve upper-bound statement for translated patterns under explicit
local obstruction data. A realistic intermediate Lean target is still finite:
prove the full arbitrary finite base-spine BT-0011 theorem, then formulate a
clean finite-to-sieve interface theorem with no claim of prime asymptotics.

## Breakthrough Status

`INTERNAL_NUMBRIDGE_BREAKTHROUGH`

Reason: this is structural, parametric, and Lean-proved beyond BT-0010, but it
is the two-gate fallback rather than the full arbitrary finite base-spine
theorem. The mathematics is best classified as known finite-sieve
combinatorics, not externally novel field mathematics.

## Files Changed

```text
lean/NumBridge/GeneralFirstSubcriticalSacrifice.lean
lean/NumBridge.lean
src/bridge/general_first_subcritical_sacrifice.py
src/numbridge/cli.py
src/numbridge/reports.py
tests/test_general_first_subcritical_sacrifice.py
bridge-theorems.md
bridge-theorems/BT-0011-general-first-subcritical-sacrifice.md
bridge-cards/B-0011-general-first-subcritical-sacrifice.md
conjectures/C-0011-general-first-subcritical-sacrifice.md
bridges.md
proof-roadmap.md
evolution.md
resonance.md
primebridge.md
formal-truth.md
open-questions.md
README.md
reports/bt0011_general_first_subcritical_sacrifice_2026-05-30.md
```

## Next Target

Prove the full arbitrary finite base-spine theorem in Lean, or isolate it into:

```text
product_factor_drop_equality_edge:
if each local factor is bounded by its base maximum and the product misses
the full product by exactly one, characterize the only possible factor
configurations and rule them out using the coprimality/threshold assumptions.
```

That is the real blocker for target A.
