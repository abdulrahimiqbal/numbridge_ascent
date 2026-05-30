---
id: L-0009
type: lead
title: Subcritical resonance
status: theorem-proved
domain:
  - finite-sieve
  - resonance
  - optimization
symbolic_terms:
  - subcritical resonance
  - one gate sacrifice
  - partial lattice lock
related_experiments: []
related_conjectures:
  - C-0009
related_bridges:
  - B-0009
---
# L-0009: Subcritical Resonance

## Symbolic Intuition

When the full gate-product lattice cannot fit inside the diameter bound, the
best finite resonance should preserve as many gate locks as possible and
sacrifice the weakest remaining gate in a controlled way.

## Candidate Formalization

For the first subcritical case:

```text
gates = [2,3,5]
W = 30
k = 3
D = 59
```

the full lattice pattern `[0,30,60]` is unavailable. The structural candidate
is that maximizers stay locked modulo `6` and occupy exactly two residue
classes modulo `5`.

## Current Result

`PROVED_IN_LEAN`: BT-0009 proves score `<= 6`, with equality iff every offset
is divisible by `6` and the pattern has exactly two residue shadows modulo `5`.
