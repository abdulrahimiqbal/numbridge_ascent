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

## B-0009: Subcritical resonance

Symbolic form: when the full lattice cannot fit, the strongest subcritical
patterns keep the strongest gate locks and sacrifice one gate minimally.

Mathematical form: for normalized distinct three-point patterns bounded by
`59` and gates `[2,3,5]`,

```text
FiniteResonanceNumerator [2,3,5] H <= 6
```

with equality exactly when every offset is divisible by `6` and
`LocalResidueShadowCount 5 H = 2`.

Status: PROVED_IN_LEAN / finite-sieve subcritical structural theorem. Python
confirms the structural condition picks out the twelve bounded maximizers, but
the Lean theorem does not hardcode the list.

Bridge Theorem:

- `BT-0009`: subcritical resonance theorem.

## B-0010: First subcritical sacrifice

Symbolic form: in the first subcritical zone, strongest resonance keeps the
smallest gate locks and sacrifices only the next gate.

Mathematical form: for `q >= 5`, `Nat.Coprime q 6`, normalized distinct
three-point patterns bounded by `12q - 1`, and gates `[2,3,q]`,

```text
FiniteResonanceNumerator [2,3,q] H <= 2 * (q - 2)
```

with equality exactly when every offset is divisible by `6` and
`LocalResidueShadowCount q H = 2`.

Status: PROVED_IN_LEAN for the parametric upper bound and equality
characterization. The canonical `[0,6,6q]` attainer is verified by Python in
the requested q scans, while the direct Lean q-shadow count for that concrete
pattern remains a small isolated lemma.

Bridge Theorem:

- `BT-0010`: first subcritical sacrifice theorem.

## B-0011: General first-subcritical sacrifice

Symbolic form: in the first subcritical zone, strongest resonance keeps the
base spine locked and sacrifices exactly one residue at the new gate.

Mathematical form: for arbitrary two-gate base spines `[a,b]`, with
`q` coprime to `a*b` and `(a - 1)*(b - 1) + 1 <= q`,

```text
FiniteResonanceNumerator [a,b,q] H
  <= (a - 1)*(b - 1)*(q - 2)
```

for every normalized distinct three-point pattern bounded by
`2*(a*b*q) - 1`, with equality exactly when every offset is divisible by
`a*b` and `LocalResidueShadowCount q H = 2`.

Status: PROVED_IN_LEAN for the arbitrary two-gate fallback theorem. The full
arbitrary finite base-spine theorem is still open, with bounded Python checks
and equality-edge search recorded for the requested window.

Bridge Theorem:

- `BT-0011`: general first-subcritical sacrifice theorem.

## B-0012: Prime wheel upper bound

Symbolic form: actual prime resonance must first pass through the finite
wheel gates.

Mathematical form: if `n + h` is prime for every offset `h` and every such
prime is above every gate, then `n % gateProduct gates` is a wheel-survivor
residue. Consequently, any Boolean enumerator sound for those prime tuple
translates has count at most:

```text
WheelSurvivorCountGeneral gates H * (N / gateProduct gates + 1)
```

Status: PROVED_IN_LEAN as an elementary actual-prime wheel upper bound. This
is not a Selberg sieve theorem and does not prove any prime tuple asymptotic.

Bridge Theorem:

- `BT-0012`: prime wheel upper bound.

## B-0013: Finite Gallagher resonance conservation

Symbolic form: resonance averages to neutral across the finite wheel.

Mathematical form: for one gate `p`, the total avoided-residue mass over all
length-`k` residue tuples modulo `p` is:

```text
p * (p - 1)^k
```

For two positive coprime gates `p,q`, the total product of local avoided counts
over all length-`k` residue tuples modulo `p*q` is:

```text
p*q * (p - 1)^k * (q - 1)^k
```

Status: PROVED_IN_LEAN for arbitrary `k` in the single-gate and two-gate
cases. Python verifies the corresponding finite identity for arbitrary tested
pairwise-coprime gate lists. The full arbitrary gate-list Lean theorem remains
open and should be attacked by residue-choice CRT induction.

Bridge Theorem:

- `BT-0013`: finite Gallagher resonance conservation.
