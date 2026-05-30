---
id: BT-0004
type: bridge-theorem
title: Sieve gates and prime-pattern admissibility
status: theorem-proved
source_bridges:
  - B-0004
related_conjectures:
  - C-0004
lean_path: lean/NumBridge/PrimeConstellations.lean
label: useful-prime-structural
---
# BT-0004: Sieve Gates and Prime-Pattern Admissibility

## Symbolic Language

Prime patterns survive only when they avoid total residue collapse.

## Mathematical Structure

A finite prime pattern is obstructed if its offsets cover every residue class
modulo some prime `q`. Then every translate has at least one member divisible by
`q`.

## Lean Result

Closed concrete triplet theorem:

```text
NumBridge.triplet_mod_three_sieve_gate
NumBridge.prime_triplet_start_eq_three
NumBridge.only_prime_triplet_three_five_seven
```

The theorem proves that one of `n`, `n+2`, or `n+4` is divisible by 3 for every
natural number `n`. Therefore, if all three are prime under the local prime
predicate, then `n = 3`, so the only such triplet is `3,5,7`.

Closed general finite-cover schema:

```text
NumBridge.residue_cover_translate_hits_multiple
```

## Classification

Useful / prime-structural. This is not deep sieve theory yet, but it is a real
step from digit-root gates into admissibility of prime constellations.

## Remaining Work

Generalize from the list-level cover lemma to a reusable admissibility API:
finite offset sets, prime moduli, and automated residue-cover checks.
