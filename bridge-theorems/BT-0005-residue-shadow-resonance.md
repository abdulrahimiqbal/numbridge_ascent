---
id: BT-0005
type: bridge-theorem
title: Residue shadow resonance
status: search-engine-built
source_bridges:
  - B-0005
related_conjectures:
  - C-0005
lean_path: lean/NumBridge/PrimePatternResonance.lean
label: prime-structural-search-enabling
---
# BT-0005: Residue Shadow Resonance

## Symbolic Language

`gate`, `shadow`, `resonance`, `collapse`, `survival`.

## Mathematical Structure

For a finite offset pattern `H`, symbolic resonance is the local residue
survival profile:

```text
shadow_p(H) = {h mod p : h in H}
deficit_p(H) = p - |shadow_p(H)|
local_factor_p(H) = (1 - nu_p(H)/p) / (1 - 1/p)^|H|
```

## Engine Result

The repo can now search finite offset patterns, detect local obstructions, rank
admissible patterns by truncated local factors, and compare top patterns against
observed prime translates.

Python path:

```text
src/bridge/prime_patterns.py
src/bridge/residue_shadow.py
src/bridge/resonance.py
src/bridge/search_prime_patterns.py
```

## Lean Result

Closed Lean facts:

```text
NumBridge.resonance_triplet_obstructed_mod_three
NumBridge.resonance_zero_two_six_survives_mod_three
NumBridge.resonance_zero_two_survives_mod_two_and_three
NumBridge.resonance_cover_forces_sieve_hit
```

## Classification

Prime-structural / search-enabling.

This is not a proof of prime k-tuples. It is a bridge object connecting symbolic
resonance language to local sieve factors used in prime-pattern heuristics.
