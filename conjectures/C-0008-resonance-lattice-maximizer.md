---
id: C-0008
type: conjecture
title: Resonance lattice maximizer
status: proved-in-lean-core-python-checked-threshold
source_lead: L-0008
bridge: B-0008
lean_status: upper-bound-and-lattice-equality-proved
theorem_kind: finite_resonance_lattice_maximizer
related_experiments: []
---
# C-0008: Resonance Lattice Maximizer

## Statement

Let `gates` be a finite list of pairwise-coprime moduli greater than one, and
let:

```text
W = gateProduct gates
Upper(gates) = prod_{p in gates} (p - 1)
Numerator(gates,H) = ProductLocalGateSurvivorCount gates H
```

For any zero-anchored pattern `H`, the expected structural theorem is:

```text
Numerator(gates,H) <= Upper(gates)

Numerator(gates,H) = Upper(gates)
iff
every h in H is divisible by W.
```

For distinct normalized `k`-point patterns with offsets `<= D`, the canonical
lattice pattern:

```text
[0, W, 2W, ..., (k-1)W]
```

is valid and upper-bound-attaining whenever `(k - 1)W <= D`.

## Current Status

`PROVED_IN_LEAN`: the numerator upper bound, the equality iff lattice
condition, the canonical valid pattern above the threshold, and the normalized
upper-bound family characterization.

`COMPUTED_BY_PYTHON`: bounded brute-force checks confirm that for
`gates=[2,3,5]`, `k=3`, `D=60` attains the upper bound at `[0,30,60]`, while
`D=59` does not attain the upper bound.

`OPEN`: the full Lean reverse threshold theorem:

```text
if a normalized distinct k-point pattern <= D attains Upper(gates),
then (k - 1)W <= D.
```

Equivalently, Lean still needs the finite order/pigeonhole lemma that any
`k` distinct multiples of positive `W`, containing zero and bounded by `D`,
force `D >= (k - 1)W`.

## Boundary

This is finite-sieve combinatorics. It is not a theorem about the distribution
of actual prime constellations.
