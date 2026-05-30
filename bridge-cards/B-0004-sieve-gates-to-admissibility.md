---
id: B-0004
type: bridge
title: Sieve gates to admissibility
status: theorem-proved
source_leads:
  - L-0005
related_conjectures:
  - C-0004
bridge_strength: useful-prime-structural
lean_priority: high
---
# B-0004: Sieve Gates to Admissibility

## Symbolic Form

Prime patterns survive only when they avoid total residue collapse.

## Mathematical Form

A finite offset pattern is obstructed if the offsets cover every residue class
modulo some prime `q`. Every translate then hits a multiple of `q`.

## Closed Lean Theorems

```text
NumBridge.triplet_mod_three_sieve_gate
NumBridge.prime_triplet_start_eq_three
NumBridge.only_prime_triplet_three_five_seven
NumBridge.residue_cover_translate_hits_multiple
NumBridge.triplet_offsets_cover_hits_multiple
```

## Bridge Theorem Layer

Promoted into:

```text
BT-0004: Sieve gates and prime-pattern admissibility
```

## Classification

Useful / prime-structural. This is more important than the digital-root bridge
because it connects symbolic gate language to local obstructions in prime
constellations rather than only to digit residues.

## Next Target

Build a reusable admissibility API for finite offset sets and prime moduli.
