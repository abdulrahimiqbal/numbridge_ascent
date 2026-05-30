---
id: L-0006
type: lead
title: Prime-pattern resonance
status: search-engine-built
domain:
  - primes
  - constellations
  - residue_geometry
  - sieve
symbolic_terms:
  - resonance
  - shadow
  - gate
  - survival
  - collapse
related_experiments: []
related_conjectures:
  - C-0005
related_bridges:
  - B-0005
---
# L-0006: Prime-Pattern Resonance

## Symbolic Intuition

Prime patterns resonate when their residue shadows survive local sieve gates.

## Candidate Formalizations

1. `shadow_p(H) = {h mod p : h in H}`.
2. `deficit_p(H) = p - |shadow_p(H)|`.
3. `H` is locally obstructed when `deficit_p(H) = 0`.
4. Resonance is a truncated product of local survival factors.

## Current Result

The PrimeBridge Resonance Engine is implemented in Python and has Lean-backed
concrete obstruction/survival facts. This is classified as
prime-structural / search-enabling.
