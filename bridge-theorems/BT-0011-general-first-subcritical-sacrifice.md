---
id: BT-0011
type: bridge-theorem
title: General first-subcritical sacrifice theorem
status: proved-in-lean-fallback
source_bridges:
  - B-0011
related_conjectures:
  - C-0011
lean_path: lean/NumBridge/GeneralFirstSubcriticalSacrifice.lean
label: finite-sieve-two-gate-subcritical-structural-theorem
---
# BT-0011: General First-Subcritical Sacrifice Theorem

## Symbolic Language

`base-spine resonance`, `first subcritical zone`, `one gate sacrifice`,
`partial lattice lock`.

## Mathematical Structure

The target arbitrary-base theorem says:

```text
baseGates pairwise coprime, every gate >= 2
L = gateProduct baseGates
B = prod_{g in baseGates} (g - 1)
q coprime to L
B + 1 <= q
D = 2*L*q - 1
```

For normalized distinct three-point patterns bounded by `D`, the expected
maximum is:

```text
B * (q - 2)
```

with equality exactly when all offsets are divisible by `L` and the q-shadow
has size `2`.

## Lean Result

Lean closes the requested fallback theorem for arbitrary two-gate base spines:

```text
baseGates = [a,b]
2 <= a, 2 <= b, 2 <= q
Nat.Coprime a b
Nat.Coprime q (a*b)
(a - 1)*(b - 1) + 1 <= q
D = 2*(a*b*q) - 1
```

Closed theorem:

```text
NumBridge.bt0011_two_gate_first_subcritical_sacrifice_theorem
```

This proves:

```text
FiniteResonanceNumerator [a,b,q] H <= (a - 1)*(b - 1)*(q - 2)
```

and equality iff:

```text
AllOffsetsDivisibleBy (a*b) H
and
LocalResidueShadowCount q H = 2.
```

## Current Status

`PROVED_IN_LEAN`: arbitrary two-gate base-spine fallback theorem.

`COMPUTED_BY_PYTHON`: arbitrary finite base-spine checks and equality-edge
search in the requested finite window.

`OPEN`: full arbitrary finite base-spine equality proof in Lean.

## Boundary

This is finite-sieve combinatorics. It does not prove actual prime
distribution. The result strictly generalizes BT-0010 because `[2,3,q]` is the
case `a=2`, `b=3`.
