# BT-0008 Resonance Lattice Maximizer Report - 2026-05-30

## What Was Structurally Classified?

BT-0008 classifies the absolute upper-bound cases for finite resonance
numerators. For pairwise-coprime gates greater than one, a zero-anchored offset
pattern reaches:

```text
prod_{p in gates} (p - 1)
```

if and only if every offset is divisible by the full gate product `W`.

In symbolic language, "strongest resonance locks onto the gate-product
lattice" now has a precise finite-sieve theorem.

## Which Lean Theorems Closed?

Lean path:

```text
lean/NumBridge/ResonanceLatticeMaximizer.lean
```

Closed theorem names:

```text
NumBridge.finite_resonance_numerator_le_upper_bound
NumBridge.local_survivor_count_eq_p_minus_one_iff_all_mod_zero
NumBridge.equality_upper_bound_implies_single_shadow_each_gate
NumBridge.same_residue_as_zero_all_gates_iff_dvd_gateProduct
NumBridge.resonance_upper_bound_eq_iff_offsets_dvd_gateProduct
NumBridge.bt0008_resonance_lattice_maximizer_theorem
NumBridge.canonical_lattice_pattern_valid_if_D_ge
NumBridge.canonical_lattice_pattern_attains_upper_bound
NumBridge.bt0008_attainability_threshold_sufficient
NumBridge.bt0008_maximizer_family_characterization
```

No `sorry`, `admit`, or `axiom` is used.

## Did The Proof Avoid Duplicate-Pattern Degeneracy?

Yes for the normalized pattern layer. Lean defines:

```text
NormalizedDistinctPattern k D H
```

with a zero start, exact length, `Nodup`, and bounded offsets. The core
upper-bound theorem itself is intentionally valid for arbitrary zero-started
lists, because duplicate offsets do not change residue shadows. The maximizer
family and canonical threshold statements use the distinct normalized pattern
predicate.

Python explicitly rejects `[0,0,0]` and other duplicate patterns in
`normalized_distinct_pattern`.

## How Does BT-0008 Improve On BT-0007?

BT-0007 proved an exhaustive classifier correct: a generated argmax list
contains exactly the candidates that are maximal in a finite search space.

BT-0008 proves a human-readable structural theorem: absolute maximizers are
exactly gate-product lattice patterns. This is a real step beyond "the
classifier returns the maximizers."

## Which Parts Are PROVED_IN_LEAN?

- The numerator upper bound.
- Equality iff every offset is divisible by `gateProduct gates`.
- The local equality characterization at each gate.
- The product-divisibility equivalence for pairwise-coprime gate lists.
- The canonical lattice pattern is normalized, distinct, bounded, and
  upper-bound-attaining whenever `(k - 1)W <= D`.
- Among normalized distinct patterns, upper-bound maximizers are exactly the
  lattice patterns.

## Which Parts Are COMPUTED_BY_PYTHON?

Python path:

```text
src/bridge/resonance_lattice_maximizer.py
```

The bounded verifier checks examples such as:

```bash
python3 bridge.py resonance-lattice-max k=3 D=60 gates=2,3,5
python3 bridge.py resonance-lattice-max k=3 D=59 gates=2,3,5
python3 bridge.py verify-bt0008 --max-k 4 --max-D 80 --gates 2,3,5
```

For `gates=[2,3,5]`, `W=30`. The verifier confirms that `[0,30,60]` attains
the upper bound at `k=3, D=60`, while no upper-bound attainer exists at
`k=3, D=59`.

## Which Parts Remain OPEN?

The full Lean reverse threshold is still open:

```text
If H is normalized, distinct, has length k, all offsets <= D, and every h in H
is divisible by W, then D >= (k - 1)W.
```

This is a finite order/pigeonhole theorem about distinct bounded multiples of a
positive number. Once proved, it gives the full iff threshold and exact
floor-family statement.

## Why This Is Not Actual Prime Distribution

BT-0008 is finite-sieve combinatorics. It optimizes the numerator of a finite
wheel-resonance score. It does not show that any maximizing pattern has
infinitely many prime translates, does not prove Hardy-Littlewood, and does not
provide analytic error terms.

## Classification

`PROVED_IN_LEAN` for the structural finite-sieve upper-bound and lattice
maximizer theorem.

Classification: finite-combinatorics / finite-sieve / structural maximizer.

It is stronger than BT-0007's generated classifier, but the full threshold
family theorem is not fully closed in Lean yet.

## Next Subcritical Theorem: BT-0009

BT-0009 should classify the best subcritical patterns when `D < (k - 1)W`.
The first target should be the concrete finite-sieve case:

```text
gates = [2,3,5], W = 30, k = 3, D = 59
```

Python finds max score `6` and twelve maximizers:

```text
[0,6,30], [0,6,36], [0,12,30], [0,12,42],
[0,18,30], [0,18,48], [0,24,30], [0,24,54],
[0,30,36], [0,30,42], [0,30,48], [0,30,54]
```

The next structural question is to explain these subcritical maximizers without
exhaustive enumeration.
