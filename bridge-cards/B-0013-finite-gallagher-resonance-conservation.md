---
id: B-0013
type: bridge
title: Finite Gallagher resonance conservation
status: partial-proved-in-lean
source_leads: []
related_conjectures:
  - C-0013
bridge_strength: finite-gallagher-partial
lean_priority: high
---
# B-0013: Finite Gallagher Resonance Conservation

## Symbolic Form

Resonance is not created from nothing; across the full finite wheel it is
conserved on average.

## Mathematical Form

The finite resonance numerator is a local avoided-residue count. For one gate
`p`, summing over all length-`k` residue tuples modulo `p` gives:

```text
p * (p - 1)^k
```

For two positive coprime gates `p` and `q`, summing over all length-`k` residue
tuples modulo `p*q` gives:

```text
p*q * (p - 1)^k * (q - 1)^k
```

## Lean Result

Lean path:

```text
lean/NumBridge/FiniteGallagher.lean
```

Closed theorem names:

```text
NumBridge.single_gate_local_survivor_sum
NumBridge.two_gate_finite_gallagher_conservation_local
NumBridge.bt0013_two_gate_finite_gallagher_resonance_conservation
```

## Python Support

Python path:

```text
src/bridge/finite_gallagher.py
```

CLI:

```bash
python3 bridge.py finite-gallagher gates=2,3,5 k=3
python3 bridge.py finite-gallagher gates=2,5,7 k=4
python3 bridge.py finite-gallagher-scan --max-gate 11 --max-k 5 --max-gate-len 4
python3 bridge.py finite-gallagher-counterexample-search --max-gate 12 --max-k 5
```

## Claim Labels

- `PROVED_IN_LEAN` for the arbitrary-`k` single-gate and two-gate theorem.
- `COMPUTED_BY_PYTHON` for arbitrary finite pairwise-coprime gate-list audits.
- `OPEN` for the full arbitrary gate-list Lean theorem.
- `HEURISTIC` for normalized singular-series language beyond the finite
  integer identity.
- `NOT_PROVEN` for Hardy-Littlewood, Gallagher's asymptotic theorem, twin
  primes, or any actual prime-distribution result.

## Classification

`INTERNAL_NUMBRIDGE_BREAKTHROUGH`
