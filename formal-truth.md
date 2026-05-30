# Formal Truth Taxonomy

Every NumBridge report should distinguish proof, computation, heuristic, and
interpretation.

## Labels

- `PROVED_IN_LEAN`: a precise theorem compiles in Lean without `sorry`,
  `admit`, or `axiom`.
- `COMPUTED_BY_PYTHON`: a finite computation or brute-force check was performed
  by repo code.
- `HEURISTIC`: a useful model or score, not a proof.
- `INTERPRETIVE_FORMALIZATION`: symbolic language has been mapped to a precise
  mathematical structure.
- `NOT_PROVEN`: no proof or finite exhaustive computation establishes the
  claim.
- `REFUTED`: a counterexample or failed null comparison kills the claim.
- `OPEN`: a precise claim remains unresolved.

## Rule

Do not promote an interpretive bridge into a mystical claim. A branch is
formally true only under its explicit mathematical interpretation.

For layered theorem work, apply labels to the exact layer that was verified.
BT-0006 now has `PROVED_IN_LEAN` for the finite-sieve wheel distribution
theorem over arbitrary finite positive pairwise-coprime gate lists. That label
does not apply to actual prime-distribution claims.

For BT-0006, the correct status is:

```text
PROVED_IN_LEAN
finite-sieve / CRT / wheel-shadow distribution
pre-analytic finite model
formally true under finite-sieve interpretation
```

For BT-0008, the correct status is:

```text
PROVED_IN_LEAN
finite-sieve / finite-combinatorics / structural resonance maximizer
absolute upper-bound equality iff gate-product lattice alignment
reverse threshold/floor-family theorem still OPEN in Lean
actual prime-distribution consequences NOT_PROVEN
```

For BT-0009, the correct status is:

```text
PROVED_IN_LEAN
finite-sieve / subcritical-resonance / structural theorem
first one-gate-sacrifice case: [2,3,5], k=3, D=59
score 6 iff 6-lattice lock and exactly two mod-5 shadows
actual prime-distribution consequences NOT_PROVEN
```

For BT-0010, the correct status is:

```text
PROVED_IN_LEAN
finite-sieve / parametric first-subcritical sacrifice theorem
[2,3,q] with q >= 5 and coprime to 6
score 2*(q-2) iff 6-lattice lock and exactly two q-shadows
canonical [0,6,6q] attainer COMPUTED_BY_PYTHON in requested scans
actual prime-distribution consequences NOT_PROVEN
```

For BT-0011, the correct status is:

```text
PROVED_IN_LEAN for the arbitrary two-gate fallback theorem
COMPUTED_BY_PYTHON for bounded arbitrary-base checks and equality-edge search
OPEN for the full arbitrary finite base-spine theorem
finite-sieve / first-subcritical sacrifice
actual prime-distribution consequences NOT_PROVEN
```
