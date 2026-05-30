# Bridges Index

## B-0001: Digital root to modular arithmetic

Symbolic form: a number's one-digit essence.

Mathematical form: residue modulo `b - 1`.

Status: shallow-real PrimeBridge theorem. The translation is useful, and the
prime-specific exclusion now compiles in Lean, but the result is explained by
divisibility by 3 rather than a deeper prime phenomenon.

Bridge Theorems:

- `BT-0001`: digit collapse is modular arithmetic.
- `BT-0003`: prime completion-root exclusions are residue obstructions.

## B-0002: Mirror symmetry to divisibility

Symbolic form: mirror numbers pass through a gate.

Mathematical form: palindromic digit strings imply divisibility constraints.

Status: partial theorem. The shallow-real four-digit calibration theorem
`NumBridge.Palindrome11.four_digit_mirror_divisible_by_11` compiles without
`sorry`; the full even-length palindrome theorem remains the next target.

Bridge Theorem:

- `BT-0002`: mirror symmetry creates divisibility gates.

## B-0003: Collapse to iterative maps

Symbolic form: a number collapses into a root/state.

Mathematical form: iterated maps such as digit sum, multiplicative persistence, aliquot maps, or factorization trees.

Status: exploratory.

## B-0004: Sieve gates to admissibility

Symbolic form: prime patterns survive only when they avoid total residue
collapse.

Mathematical form: an offset pattern is obstructed if it covers all residue
classes modulo some prime `q`; every translate then contains a multiple of `q`.

Status: useful / prime-structural theorem. The concrete `n,n+2,n+4`
obstruction modulo 3 and a general finite-cover lemma compile in Lean.

Bridge Theorem:

- `BT-0004`: sieve gates and prime-pattern admissibility.

## B-0005: Residue shadow to prime resonance

Symbolic form: prime patterns have resonance when their shadows survive local
gates.

Mathematical form: residue shadows, gate deficits, admissibility, and local
survival factors rank prime-pattern candidates.

Status: prime-structural / search-enabling engine. The repo can now search,
rank, and empirically compare finite offset patterns.

Bridge Theorem:

- `BT-0005`: residue shadow resonance.

## B-0006: Wheel-shadow distribution

Symbolic form: resonance and survival through prime gates.

Mathematical form: exact finite-wheel survivor counts factor as a product of
local survival counts.

Status: PROVED_IN_LEAN / foundational finite-sieve CRT theorem. Python verifies the
product formula for finite wheels and arbitrary tested pairwise-coprime gate
lists; Lean proves concrete wheel-shadow facts, the local `p - nu_p(H)` count
for arbitrary offset lists, a reusable two-modulus CRT/cardinality theorem, and
arbitrary-pattern product formulas for the 6-wheel and 30-wheel via that
theorem. Lean now also proves the full arbitrary positive pairwise-coprime
gate-list theorem.

Prime-distribution status: pre-analytic finite model. Numerology status:
formally true under finite-sieve interpretation.

Bridge Theorem:

- `BT-0006`: wheel-shadow distribution theorem.

## B-0007: Finite resonance optimization

Symbolic form: strongest resonance patterns survive the finite gates best.

Mathematical form: optimize the truncated finite-wheel resonance score

```text
prod_{p <= P} (1 - nu_p(H) / p) / (1 - 1 / p)^k
```

over admissible `k`-offset patterns subject to constraints such as
`diameter(H) <= D`.

Status: broad exhaustive finite classifier proved in Lean. The closed theorem
classifies maximizers for every `k`, `D`, and `P` by generated argmax:
membership in the classifier is equivalent to being a bounded candidate whose
finite resonance numerator is globally maximal in that finite search space.
Closed-form structural descriptions of all maximizing families remain open
finite combinatorics.

Bridge Theorem:

- `BT-0007`: finite resonance optimization theorem.

## B-0008: Resonance lattice maximizer

Symbolic form: strongest resonance locks onto the gate-product lattice.

Mathematical form: for pairwise-coprime gates greater than one, the finite
resonance numerator of a zero-anchored pattern is bounded by:

```text
prod_{p in gates} (p - 1)
```

and equality occurs exactly when every offset is divisible by the full gate
product `W`.

Status: structural finite-sieve maximizer theorem proved in Lean for the
upper-bound and equality lattice characterization. Lean also proves the
canonical pattern `[0,W,2W,...,(k-1)W]` is valid and upper-bound-attaining when
`(k - 1)W <= D`. The reverse threshold and exact floor-family characterization
remain open Lean work, with bounded Python verification.

Bridge Theorem:

- `BT-0008`: resonance lattice maximizer theorem.
