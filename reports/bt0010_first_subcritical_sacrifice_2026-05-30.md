# BT-0010 First Subcritical Sacrifice Report - 2026-05-30

## Did BT-0010 Produce A Parametric Theorem?

Yes. BT-0010 proves the first subcritical sacrifice theorem parametrically for
gates `[2,3,q]`, assuming:

```text
5 <= q
Nat.Coprime q 6
```

## Did It Genuinely Generalize BT-0009?

Yes. Setting `q = 5` gives gates `[2,3,5]`, `W = 30`, `D = 59`, and maximum
score `2*(5-2) = 6`, exactly the BT-0009 theorem.

## Lean Theorem Names Closed

Lean path:

```text
lean/NumBridge/FirstSubcriticalSacrifice.lean
```

Closed theorem names:

```text
NumBridge.gateProduct_two_three_q
NumBridge.no_first_subcritical_pattern_all_offsets_divisible_by_six_q
NumBridge.local_shadow_q_ge_two_of_all_divisible_by6_first_subcritical
NumBridge.local_q_le_q_minus_two_of_all_divisible_by6_first_subcritical
NumBridge.first_subcritical_score_le_q_minus_one_of_not_six_lock
NumBridge.first_subcritical_upper_bound_two_three_q
NumBridge.first_subcritical_equality_forces_six_lock_and_q_sacrifice
NumBridge.first_subcritical_six_lock_and_q_sacrifice_attains
NumBridge.bt0010_first_subcritical_sacrifice_theorem
NumBridge.canonical_first_subcritical_attainer_pattern
NumBridge.canonical_first_subcritical_attainer_six_lock
NumBridge.canonical_first_subcritical_attainer_attains_if_q_shadow_two
```

## PROVED_IN_LEAN

For every normalized distinct three-point `H` bounded by `12*q - 1`:

```text
FiniteResonanceNumerator [2,3,q] H <= 2 * (q - 2)
```

and:

```text
FiniteResonanceNumerator [2,3,q] H = 2 * (q - 2)
iff
DivisibleBySixPattern H
and
LocalResidueShadowCount q H = 2.
```

Lean also proves the canonical candidate `[0,6,6q]` is valid and keeps the
`6`-lattice lock, and proves it attains conditionally on the isolated q-shadow
count.

## COMPUTED_BY_PYTHON

Python path:

```text
src/bridge/first_subcritical_sacrifice.py
```

The requested scans passed:

```text
q=5: max=6
q=7: max=10
q=11: max=18
q=13: max=22
q=17: max=30
```

The counterexample search through `q <= 25` found none.

Python verifies that `[0,6,6q]` is a concrete attainer in the scanned q range.

## Was Any Counterexample Found?

No. The requested search:

```bash
python3 bridge.py bt0010-counterexample-search --q-max 25
```

returned `counterexample=None`.

## Open Lean Piece

The only isolated open Lean sublemma is:

```text
LocalResidueShadowCount q [0,6,6*q] = 2
```

under `5 <= q` and `Nat.Coprime q 6`. The main parametric theorem does not
depend on this lemma; it is only needed to make the concrete canonical attainer
fully unconditional in Lean.

## Finite-Sieve Or Prime Distribution?

This is finite-sieve / finite-combinatorics. It optimizes finite wheel
resonance numerators. It does not prove Hardy-Littlewood, prime tuples, or any
actual prime-distribution theorem.

## What Would Be Needed For Actual Prime Distribution?

The project would need analytic input: sieve bounds, distribution estimates for
primes in residue classes, explicit error terms, or a framework comparable to
Bombieri-Vinogradov / Maynard-Tao machinery. BT-0010 is pre-analytic.

## Next Target

BT-0011 should remove the remaining local counting friction by proving a
general two-offset residue-shadow lemma:

```text
If 0 < q and d % q != 0,
then LocalResidueShadowCount q [0,d] = 2.
```

That lemma immediately closes the unconditional canonical attainer for
BT-0010 and should be reusable across future sacrifice theorems.
