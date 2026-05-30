---
id: L-0008
type: lead
title: Resonance lattice maximizer
status: theorem-proved-partial-threshold-open
domain:
  - finite-sieve
  - resonance
  - optimization
symbolic_terms:
  - strongest resonance
  - lattice lock
  - gate-product alignment
related_experiments: []
related_conjectures:
  - C-0008
related_bridges:
  - B-0008
---
# L-0008: Resonance Lattice Maximizer

## Symbolic Intuition

The strongest finite resonance happens when all offsets fall into the same
residue class through every finite gate. Symbolically: a pattern "locks onto"
the gate-product lattice.

## Candidate Formalization

For positive pairwise-coprime gates with product `W`, the finite resonance
numerator of a zero-anchored pattern is at most:

```text
prod_{p in gates} (p - 1)
```

Equality should occur exactly when every offset is divisible by `W`.

## Current Result

The upper-bound and equality characterization are proved in Lean as BT-0008.
The canonical pattern `[0, W, 2W, ..., (k-1)W]` is also proved valid and
upper-bound-attaining whenever `(k - 1)W <= D`.

The reverse threshold and exact floor-family counting theorem remain open Lean
work.
