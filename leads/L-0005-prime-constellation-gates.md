---
id: L-0005
type: lead
title: Prime constellation gates
status: theorem-proved
domain:
  - primes
  - constellations
  - admissibility
  - sieve
symbolic_terms:
  - gate
  - collapse
  - survival
related_experiments: []
related_conjectures:
  - C-0004
related_bridges:
  - B-0004
---
# L-0005: Prime Constellation Gates

## Symbolic Intuition

Prime patterns survive only when they avoid total residue collapse.

## Candidate Formalizations

1. A pattern with offsets covering every residue class modulo a prime `q` is
   obstructed.
2. The triplet pattern `n, n+2, n+4` is obstructed modulo 3.
3. Admissible prime constellations are exactly those avoiding such local
   residue obstructions for every prime modulus.

## Current Result

The concrete `n, n+2, n+4` obstruction is proved in Lean. A general finite-cover
lemma is also proved:

```text
NumBridge.residue_cover_translate_hits_multiple
```

This is a useful / prime-structural bridge, not a digit-root calibration.
