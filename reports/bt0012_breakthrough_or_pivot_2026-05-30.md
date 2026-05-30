# BT-0012 Breakthrough Or Pivot Report

## 1. Path Landed

Path B landed: `ACTUAL_PRIME_BRIDGE_ELEMENTARY`.

Path A, the full arbitrary finite base-spine first-subcritical theorem, remains
open. The proof blocker is still the arbitrary product-factor equality edge:
one must rule out non-base-locked equality when the base local product is
exactly one below the base upper bound.

## 2. Exact Lean Theorem Names

Lean path:

```text
lean/NumBridge/PrimeWheelUpperBound.lean
```

Closed theorem names:

```text
NumBridge.prime_above_gate_not_dvd
NumBridge.add_mod_gate_of_dvd_wheel
NumBridge.prime_translate_avoids_each_gate_residue
NumBridge.prime_tuple_translate_implies_wheel_survivor
NumBridge.wheel_residue_survivor_bool_of_prop
NumBridge.prime_tuple_translate_implies_wheel_survivor_bool
NumBridge.countP_le_countP_of_imp_bool
NumBridge.one_block_count_le_wheel_survivor_count
NumBridge.count_complete_wheel_blocks_le
NumBridge.predicate_count_le_wheel_survivor_blocks
NumBridge.bt0012_prime_tuple_wheel_upper_bound
```

## 3. PROVED_IN_LEAN

Lean proves that an actual prime tuple translate above all gates lands in a
wheel-survivor residue:

```text
NumBridge.prime_tuple_translate_implies_wheel_survivor
```

Lean also proves the elementary count bound:

```text
If P n = true only when n is a prime tuple translate above all gates, then

(List.range (N + 1)).countP P
  <= WheelSurvivorCountGeneral gates H * (N / gateProduct gates + 1)
```

No `sorry`, `admit`, or `axiom` is used.

## 4. COMPUTED_BY_PYTHON

Python verifies:

```text
python3 bridge.py bt0012-arbitrary-base-spine-check base=2,3,5 q=31
python3 bridge.py bt0012-prime-wheel-bound H=0,2,6 gates=2,3,5 N=100000
python3 bridge.py bt0012-breakthrough-audit
```

For the sample prime-wheel command, Python found:

```text
W = 30
wheel_survivor_count = 2
prime_tuple_count = 258
block_bound = 6668
bad_translate_count = 0
```

## 5. HEURISTIC

Any singular-series ranking, resonance score comparison, or Hardy-Littlewood
intuition remains heuristic unless separately proved. BT-0012 only proves an
elementary wheel obstruction/count bound.

## 6. OPEN

- Full arbitrary finite base-spine first-subcritical theorem in Lean.
- Selberg-sieve upper bound for prime tuple translates.
- Bombieri-Vinogradov, Maynard-Tao, or Hardy-Littlewood-type distribution
  input.
- Any asymptotic formula for actual prime tuples.

## 7. Breakthrough Classification

`ACTUAL_PRIME_BRIDGE_ELEMENTARY`

Reason: BT-0012 crosses from finite candidate residues to an actual-prime
count statement, but the count statement is elementary and only uses finite
wheel obstruction. It is not a deep analytic theorem.

## 8. External Novelty Audit

This should not be called externally novel mathematics. The local obstruction
and residue-count framework is standard in prime k-tuple and singular-series
contexts. A quick literature check found the same surrounding framework in:

- Kedlaya's analytic number theory notes, Chapter 19, which define the
  Hardy-Littlewood local correction using the number of residue classes
  represented modulo `p`: https://kskedlaya.org/ant/chap-k-tuples.html
- Pintz's note on Gallagher's singular-series theorem in the prime k-tuple
  conjecture setting: https://arxiv.org/abs/1004.1084

The contribution here is internal formalization and project direction: the
finite-wheel layer now has a Lean bridge into actual prime tuple counts.

## 9. Next Theorem Toward Actual Prime Distribution

The next theorem should be an explicit sieve upper bound. A precise target:

```text
Selberg-sieve upper bound:
count_{n <= N} (forall h in H, n+h prime)
  <= C(H, gates) * N / (log N)^|H|
```

with `C(H, gates)` expressed using local obstruction data or finite-wheel
survivor density. That would be a genuine move toward analytic prime
distribution. BT-0012 does not prove it.

## Files Changed

```text
lean/NumBridge/PrimeWheelUpperBound.lean
lean/NumBridge.lean
src/bridge/bt0012_breakthrough.py
src/numbridge/cli.py
tests/test_bt0012_breakthrough.py
bridge-theorems/BT-0012-arbitrary-base-spine-or-prime-wheel-upper-bound.md
bridge-cards/B-0012-arbitrary-base-spine-or-prime-wheel-upper-bound.md
conjectures/C-0012-arbitrary-base-spine-or-prime-wheel-upper-bound.md
bridge-theorems.md
bridges.md
proof-roadmap.md
evolution.md
resonance.md
primebridge.md
formal-truth.md
open-questions.md
README.md
reports/bt0012_breakthrough_or_pivot_2026-05-30.md
```
