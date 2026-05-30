---
id: C-0004
type: conjecture
title: Prime triplet obstruction
status: theorem-proved
source_lead: L-0005
bridge: B-0004
lean_status: prime-constellation-obstruction-proved
theorem_kind: prime_triplet_obstruction
related_experiments: []
---
# C-0004: Prime Triplet Obstruction

## Statement

For every natural number `n`, one of `n`, `n+2`, or `n+4` is divisible by 3.
Consequently, if `n`, `n+2`, and `n+4` are all prime, then `n = 3`, so the only
prime triplet of this form is `3,5,7`.

## Symbolic Origin

Prime patterns survive only when they avoid total residue collapse.

## Formal Translation

- prime pattern -> finite offset set
- survival -> admissibility against local residue obstructions
- total residue collapse -> offsets cover all residue classes modulo a prime
- sieve gate -> forced divisibility by that prime

## Lean Result

Closed theorem chain:

```text
NumBridge.triplet_mod_three_sieve_gate
NumBridge.prime_triplet_start_eq_three
NumBridge.only_prime_triplet_three_five_seven
NumBridge.residue_cover_translate_hits_multiple
NumBridge.triplet_offsets_cover_hits_multiple
```

The general finite-cover lemma is proved, but the full reusable admissibility
framework for arbitrary finite offset sets remains engineering work.
