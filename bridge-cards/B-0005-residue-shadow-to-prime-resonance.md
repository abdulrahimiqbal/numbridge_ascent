---
id: B-0005
type: bridge
title: Residue shadow to prime resonance
status: search-engine-built
source_leads:
  - L-0006
related_conjectures:
  - C-0005
bridge_strength: prime-structural-search-enabling
lean_priority: high
---
# B-0005: Residue Shadow to Prime Resonance

## Symbolic Form

Prime patterns have resonance when their shadows survive local gates.

## Mathematical Form

Residue shadows, gate deficits, admissibility, and local survival factors:

```text
shadow_p(H) = {h mod p : h in H}
deficit_p(H) = p - |shadow_p(H)|
local_factor_p(H) = (1 - nu_p(H)/p) / (1 - 1/p)^|H|
```

## Closed Engine Surface

```text
normalize_offsets
residue_shadow
gate_deficit
is_obstructed_mod
admissibility_witnesses
is_admissible
local_survival_factor
truncated_singular_series
search_admissible_patterns
rank_patterns_by_resonance
count_prime_translates
compare_observed_to_resonance
```

## Lean Surface

```text
NumBridge.resonance_triplet_obstructed_mod_three
NumBridge.resonance_zero_two_six_survives_mod_three
NumBridge.resonance_zero_two_survives_mod_two_and_three
NumBridge.resonance_cover_forces_sieve_hit
```

## Classification

Prime-structural / search-enabling. This moves NumBridge from hand-fed examples
to autonomous prime-pattern bridge discovery.
