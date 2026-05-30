---
id: B-0012
type: bridge
title: Arbitrary base-spine or prime wheel upper bound
status: actual-prime-bridge-elementary
source_leads: []
related_conjectures:
  - C-0012
bridge_strength: elementary-actual-prime-wheel-upper-bound
lean_priority: high
---
# B-0012: Arbitrary Base-Spine Or Prime Wheel Upper Bound

## Symbolic Form

Prime resonance must survive the finite wheel before it can appear among
actual prime tuples.

## Mathematical Form

Let `H` be an offset pattern and let `gates` be a finite list of gate moduli.
If every `n + h` is prime and is greater than every gate, then `n` must occupy
a wheel-survivor residue modulo:

```text
W = gateProduct gates
```

Therefore any Boolean enumerator that only accepts such actual prime tuple
translates has count up to `N` bounded by:

```text
WheelSurvivorCountGeneral gates H * (N / W + 1)
```

## Lean Result

Lean path:

```text
lean/NumBridge/PrimeWheelUpperBound.lean
```

Closed theorem names:

```text
NumBridge.prime_translate_avoids_each_gate_residue
NumBridge.prime_tuple_translate_implies_wheel_survivor
NumBridge.predicate_count_le_wheel_survivor_blocks
NumBridge.bt0012_prime_tuple_wheel_upper_bound
```

## Python Support

Python path:

```text
src/bridge/bt0012_breakthrough.py
```

CLI:

```bash
python3 bridge.py bt0012-arbitrary-base-spine-check base=2,3,5 q=31
python3 bridge.py bt0012-prime-wheel-bound H=0,2,6 gates=2,3,5 N=100000
python3 bridge.py bt0012-breakthrough-audit
```

## Claim Labels

- `PROVED_IN_LEAN` for the elementary actual-prime wheel upper bound.
- `COMPUTED_BY_PYTHON` for sample prime tuple counts and the open arbitrary
  base-spine check.
- `OPEN` for the full arbitrary finite base-spine sacrifice theorem.
- `HEURISTIC` for any future singular-series ranking or Hardy-Littlewood
  intuition.
- `NOT_PROVEN` for Selberg-sieve or Hardy-Littlewood-type distribution claims.

## Classification

`ACTUAL_PRIME_BRIDGE_ELEMENTARY`
