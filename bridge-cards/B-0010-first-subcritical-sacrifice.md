---
id: B-0010
type: bridge
title: First subcritical sacrifice
status: proved-in-lean
source_leads:
  - L-0009
related_conjectures:
  - C-0010
bridge_strength: finite-sieve-parametric-subcritical-structural-theorem
lean_priority: high
---
# B-0010: First Subcritical Sacrifice

## Symbolic Form

In the first subcritical zone, strongest resonance keeps the smallest gate
locks and sacrifices only the next gate.

## Mathematical Form

For `q >= 5` with `Nat.Coprime q 6`, use gates:

```text
[2,3,q]
```

The full lattice product is `W = 6q`, but for `k=3` and
`D = 12q - 1`, the perfect lattice pattern `[0,6q,12q]` cannot fit.

Lean proves:

```text
FiniteResonanceNumerator [2,3,q] H <= 2 * (q - 2)
```

for every normalized distinct three-point pattern `H` bounded by `D`, with
equality exactly when:

```text
AllOffsetsDivisibleBy 6 H
and
LocalResidueShadowCount q H = 2.
```

## Lean Result

Lean path:

```text
lean/NumBridge/FirstSubcriticalSacrifice.lean
```

Closed theorem names:

```text
NumBridge.gateProduct_two_three_q
NumBridge.first_subcritical_upper_bound_two_three_q
NumBridge.first_subcritical_equality_forces_six_lock_and_q_sacrifice
NumBridge.first_subcritical_six_lock_and_q_sacrifice_attains
NumBridge.bt0010_first_subcritical_sacrifice_theorem
```

Lean also proves the canonical candidate `[0,6,6q]` is a valid pattern and is
6-locked. The remaining direct Lean count
`LocalResidueShadowCount q [0,6,6q] = 2` is isolated as a small residue-count
lemma; Python verifies the canonical attainer for the scanned q-values.

## Python Support

Python path:

```text
src/bridge/first_subcritical_sacrifice.py
```

CLI:

```bash
python3 bridge.py bt0010-first-subcritical q=5
python3 bridge.py bt0010-first-subcritical q=7
python3 bridge.py bt0010-scan --q-max 17
python3 bridge.py bt0010-counterexample-search --q-max 25
```

## Claim Labels

- `PROVED_IN_LEAN` for the parametric upper bound and equality characterization.
- `COMPUTED_BY_PYTHON` for bounded canonical-attainer and counterexample scans.
- `OPEN` for the tiny direct Lean residue-count lemma for `[0,6,6q]`.
- `NOT_PROVEN` for actual prime-distribution consequences.

## Classification

Finite-sieve / parametric subcritical-resonance / structural theorem.
