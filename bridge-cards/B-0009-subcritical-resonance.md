---
id: B-0009
type: bridge
title: Subcritical resonance
status: proved-in-lean
source_leads:
  - L-0009
related_conjectures:
  - C-0009
bridge_strength: finite-sieve-subcritical-structural-theorem
lean_priority: high
---
# B-0009: Subcritical Resonance

## Symbolic Form

When full lattice resonance cannot fit, the best pattern keeps the strongest
gate locks and sacrifices one gate minimally.

## Mathematical Form

In the first subcritical window:

```text
gates = [2,3,5]
k = 3
D = 59
W = 30
```

the absolute lattice attainer `[0,30,60]` is unavailable. Lean proves the
structural replacement:

```text
FiniteResonanceNumerator [2,3,5] H <= 6
```

with equality exactly when:

```text
AllOffsetsDivisibleBy 6 H
and
LocalResidueShadowCount 5 H = 2.
```

## Lean Result

Lean path:

```text
lean/NumBridge/SubcriticalResonance.lean
```

Closed theorem names:

```text
NumBridge.bt0009_subcritical_235_k3_D59_upper_bound
NumBridge.bt0009_subcritical_235_k3_D59_equality_characterization
NumBridge.bt0009_subcritical_235_k3_D59_structural_breakthrough
```

## Python Support

Python path:

```text
src/bridge/subcritical_resonance.py
```

CLI:

```bash
python3 bridge.py subcritical-bt009
python3 bridge.py subcritical-bt009 --explain
python3 bridge.py subcritical-bt009 --verify
```

## Claim Labels

- `PROVED_IN_LEAN` for the structural upper bound and equality characterization.
- `COMPUTED_BY_PYTHON` for the bounded search confirming the twelve examples.
- `NOT_PROVEN` for actual prime-distribution consequences.

## Classification

Finite-sieve / subcritical-resonance / structural theorem.

This is not a hardcoded list theorem and not a classifier-correctness theorem.
