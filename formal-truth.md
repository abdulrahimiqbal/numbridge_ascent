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
