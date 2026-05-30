# BT-0013 Finite Gallagher Resonance Conservation Report

## 1. Exact Theorem Landed

BT-0013 landed as a partial Lean theorem:

```text
single-gate arbitrary-k conservation
two-gate arbitrary-k conservation for positive coprime gates
```

The main closed theorem is:

```text
NumBridge.bt0013_two_gate_finite_gallagher_resonance_conservation
```

It proves:

```text
sum_{H in (Z / pqZ)^k}
  LocalGateSurvivorCount p H * LocalGateSurvivorCount q H
=
p*q * (p - 1)^k * (q - 1)^k
```

for `0 < p`, `0 < q`, and `Nat.Coprime p q`.

## 2. Scope

This is a `single-gate` and `two-gate` theorem, not the full arbitrary
gate-list theorem.

The full target remains open:

```text
sum_H FiniteResonanceNumerator gates H
  = gateProduct gates * product_{p in gates} (p - 1)^k
```

for arbitrary positive pairwise-coprime finite gate lists.

## 3. PROVED_IN_LEAN

Lean path:

```text
lean/NumBridge/FiniteGallagher.lean
```

Closed theorem names:

```text
NumBridge.tuples_length_count
NumBridge.tuples_all_count
NumBridge.single_gate_avoided_residue_sum
NumBridge.single_gate_local_survivor_sum
NumBridge.two_gate_finite_gallagher_conservation
NumBridge.two_gate_finite_gallagher_conservation_local
NumBridge.bt0013_two_gate_finite_gallagher_resonance_conservation
```

No `sorry`, `admit`, or `axiom` is used.

## 4. COMPUTED_BY_PYTHON

Python path:

```text
src/bridge/finite_gallagher.py
```

CLI checks:

```bash
python3 bridge.py finite-gallagher gates=2,3,5 k=3
python3 bridge.py finite-gallagher gates=2,5,7 k=4
python3 bridge.py finite-gallagher-scan --max-gate 11 --max-k 5 --max-gate-len 4
python3 bridge.py finite-gallagher-counterexample-search --max-gate 12 --max-k 5
```

Python computes arbitrary tested pairwise-coprime gate-list identities. Large
tuple universes use the exact factorized double-count instead of exhaustive
tuple enumeration.

## 5. HEURISTIC

The normalized singular-series language is interpretive unless the finite
integer identity is explicitly stated. Any extension to infinite products,
interval averages, or actual prime counts remains heuristic here.

## 6. OPEN

- Full arbitrary positive pairwise-coprime gate-list Lean theorem.
- Residue-choice CRT induction for arbitrary gate lists.
- Gallagher's asymptotic average singular-series theorem.
- Hardy-Littlewood prime `k`-tuples.
- Twin primes or any actual prime-distribution theorem.

## 7. Why This Is A Finite Gallagher Analogue

The Hardy-Littlewood prime tuple singular series uses local factors involving
the number of residue classes represented modulo `p`. Gallagher's theorem
concerns average values of these singular-series constants over growing sets.

BT-0013 proves the finite-wheel shadow of that idea: before any limiting
process or actual primes enter, the unnormalized local resonance mass averages
to the neutral value exactly for one and two gates.

Useful context:

- Kedlaya's prime `k`-tuples notes define the local singular-series correction
  using `nu_H(p)`: https://kskedlaya.org/18.785/k-tuples.pdf
- Pintz describes Gallagher's average singular-series theorem in the
  Hardy-Littlewood prime `k`-tuple setting: https://arxiv.org/abs/1004.1084
- A recent singular-series averages paper summarizes Gallagher's role in
  averaging singular-series constants over fixed-size sets:
  https://academic.oup.com/qjmath/article/74/4/1457/7226265

## 8. Why This Does Not Prove Prime Distribution

BT-0013 only sums finite local residue factors over finite residue tuple
spaces. It does not estimate primes in the surviving residue classes, does not
control error terms, and does not take the infinite prime product limit.

It therefore does not prove Hardy-Littlewood, Gallagher's asymptotic theorem,
twin primes, or any prime tuple asymptotic.

## 9. Classification

`INTERNAL_NUMBRIDGE_BREAKTHROUGH`

Reason: the theorem is structural, arbitrary in `k`, and not a fixed example,
but the Lean result is only single/two-gate. The full arbitrary gate-list
formalization is still open, and the mathematics is aligned with standard
singular-series averaging context rather than a checked field-novelty claim.

## 10. Next Theorem Toward Analytic Prime Distribution

First close:

```text
BT-0013-full:
finite_gallagher_resonance_conservation
for arbitrary positive pairwise-coprime gate lists.
```

Then the next analytic bridge should introduce a real sieve estimate, for
example a Selberg/Brun upper bound whose constant is expressed using the same
local obstruction data.

## Files Changed

```text
lean/NumBridge/FiniteGallagher.lean
lean/NumBridge.lean
src/bridge/finite_gallagher.py
src/numbridge/cli.py
src/numbridge/reports.py
src/numbridge/scoring.py
tests/test_finite_gallagher.py
bridge-theorems/BT-0013-finite-gallagher-resonance-conservation.md
bridge-cards/B-0013-finite-gallagher-resonance-conservation.md
conjectures/C-0013-finite-gallagher-resonance-conservation.md
bridge-theorems.md
bridges.md
proof-roadmap.md
evolution.md
resonance.md
primebridge.md
formal-truth.md
numerology-branches.md
open-questions.md
README.md
reports/bt0013_finite_gallagher_resonance_conservation_2026-05-30.md
reports/lean_bridge_candidates.md
```
