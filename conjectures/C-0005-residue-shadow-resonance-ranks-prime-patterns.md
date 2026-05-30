---
id: C-0005
type: conjecture
title: Residue-shadow resonance ranks prime patterns
status: engine-built
source_lead: L-0006
bridge: B-0005
lean_status: concrete-lean-facts-proved
theorem_kind: residue_shadow_resonance
related_experiments: []
---
# C-0005: Residue-Shadow Resonance Ranks Prime Patterns

## Statement

For a finite offset pattern `H`, local residue shadows and survival factors give
a search-enabling bridge from symbolic resonance language to prime-pattern
admissibility and empirical candidate ranking.

## Formal Translation

- shadow -> residues occupied modulo a prime
- gate -> local obstruction or deficit
- resonance -> product of local survival factors
- survival -> admissibility against small-prime residue collapse

## Lean Result

Concrete Lean facts are proved:

```text
NumBridge.resonance_triplet_obstructed_mod_three
NumBridge.resonance_zero_two_six_survives_mod_three
NumBridge.resonance_zero_two_survives_mod_two_and_three
NumBridge.resonance_cover_forces_sieve_hit
```

## Boundary

This is not a proof of the Hardy-Littlewood prime tuple conjecture. The local
factor product is used as a bridge/search score, not as a theorem about prime
distribution.
