---
id: B-0008
type: bridge
title: Resonance lattice maximizer
status: proved-in-lean-core
source_leads:
  - L-0008
related_conjectures:
  - C-0008
bridge_strength: finite-sieve-structural-maximizer
lean_priority: high
---
# B-0008: Resonance Lattice Maximizer

## Symbolic Form

Strongest resonance locks onto the gate-product lattice.

## Mathematical Form

For finite pairwise-coprime gates greater than one, let `W` be their product.
A zero-anchored pattern `H` has finite resonance numerator:

```text
ProductLocalGateSurvivorCount gates H
```

The absolute upper bound is:

```text
prod_{p in gates} (p - 1)
```

because the zero offset occupies one forbidden residue class at every gate.
Lean proves that equality occurs exactly when every offset of `H` is divisible
by `W`.

## Lean Result

Lean path:

```text
lean/NumBridge/ResonanceLatticeMaximizer.lean
```

Closed theorem names:

```text
NumBridge.finite_resonance_numerator_le_upper_bound
NumBridge.equality_upper_bound_implies_single_shadow_each_gate
NumBridge.same_residue_as_zero_all_gates_iff_dvd_gateProduct
NumBridge.resonance_upper_bound_eq_iff_offsets_dvd_gateProduct
NumBridge.bt0008_resonance_lattice_maximizer_theorem
NumBridge.canonical_lattice_pattern_valid_if_D_ge
NumBridge.canonical_lattice_pattern_attains_upper_bound
NumBridge.bt0008_attainability_threshold_sufficient
NumBridge.bt0008_maximizer_family_characterization
```

## Python Support

Python path:

```text
src/bridge/resonance_lattice_maximizer.py
```

CLI examples:

```bash
python3 bridge.py resonance-lattice-max k=3 D=60 gates=2,3,5
python3 bridge.py resonance-lattice-max k=3 D=59 gates=2,3,5
python3 bridge.py verify-bt0008 --max-k 4 --max-D 80 --gates 2,3,5
python3 bridge.py subcritical-resonance-search k=3 D=59 gates=2,3,5
```

## Claim Labels

- `PROVED_IN_LEAN` for the upper bound and equality iff lattice condition.
- `PROVED_IN_LEAN` for canonical lattice attainability when `(k - 1)W <= D`.
- `COMPUTED_BY_PYTHON` for bounded threshold and subcritical searches.
- `OPEN` for the reverse Lean threshold/floor-family pigeonhole theorem.
- `NOT_PROVEN` for actual prime-distribution consequences.

## Classification

Finite combinatorics / finite-sieve / structural resonance maximizer theorem.
This improves BT-0007 by proving a closed-form structure for an absolute
maximum rather than merely proving an argmax classifier correct by definition.
