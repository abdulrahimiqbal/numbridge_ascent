# Bridge Scoring

Each bridge candidate is scored using the following dimensions.

| Dimension | Question |
|---|---|
| Formal clarity | Is the statement precise? |
| Empirical support | Does it hold over tested ranges? |
| Null survival | Does it survive fair controls? |
| Base behavior | Is it base-specific, base-general, or base-invariant? |
| Generality | Does it cover more than one cherry-picked case? |
| Simplicity | Is the bridge compact? |
| Proof tractability | Can it plausibly be proved in Lean? |
| Reusability | Does it define a reusable translation? |
| Novelty | Does it teach something beyond a tautology? |

## Labels

- `mirage`: disappears under basic controls.
- `shallow-real`: true but explained by elementary arithmetic.
- `useful-bridge`: clean reusable translation.
- `prime-structural`: connects symbolic language to prime-pattern structure such as admissibility or sieve gates.
- `search-enabling`: provides infrastructure for generating and ranking new bridge candidates.
- `finite-sieve`: exact theorem or computation about finite wheel candidates, not actual prime distribution.
- `formally-true-branch`: symbolic branch proved true under an explicit mathematical interpretation.
- `strong-bridge`: theorem-level or robust conjecture.
- `deep-bridge`: opens a nontrivial mathematical path.
