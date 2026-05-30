# Wheel-Shadow Distribution Breakthrough Report - 2026-05-29

## Targeted Prime-Distribution Theorem

Target: BT-0006, the Wheel-Shadow Distribution Theorem.

For a finite offset pattern `H` and squarefree wheel `W = prod P`, define:

```text
R_W(H) = {a mod W : for every h in H, gcd(a+h, W)=1}
```

The exact finite-sieve theorem is:

```text
|R_W(H)| = prod_{p | W} (p - nu_p(H))
|R_W(H)| / W = prod_{p | W} (1 - nu_p(H)/p)
```

Claim label: `INTERPRETIVE_FORMALIZATION`.

## Actual Primes Or Finite Sieve Candidates?

This is about finite sieve candidates, not actual primes.

Claim label: `NOT_PROVEN` for any statement that this predicts actual prime
tuples as a theorem.

## Exact Theorem Proved Or Checked

`COMPUTED_BY_PYTHON`: the product formula is checked by brute force through:

```text
exact_wheel_distribution_holds
wheel_survivor_count
product_local_survival_count
normalized_wheel_density
```

Examples:

```text
H=[0,2,4], W=6 -> 0 survivors
H=[0,2], W=6 -> 1 survivor
H=[0,2,6], W=30 -> 2 survivors = (2-1)*(3-2)*(5-3)
H=[0,4,6], W=30 -> product formula holds
```

`PROVED_IN_LEAN`: concrete wheel facts are proved in:

```text
lean/NumBridge/WheelShadow.lean
lean/NumBridge/NumerologyBranches.lean
```

Closed theorem names:

```text
NumBridge.twin_survives_mod_two_three_iff_mod_six_five
NumBridge.zero_two_four_no_survivor_mod_two_three
NumBridge.zero_two_six_wheel30_product_count_arithmetic
NumBridge.resonance_branch_truth_label
```

`OPEN`: the full squarefree product theorem in Lean.

## Relation To Singular Series And Local Factors

The normalized wheel density:

```text
prod_{p | W} (1 - nu_p(H)/p)
```

is the finite-sieve survival part underneath the local factors used in
prime-tuple heuristics. The resonance factor divides by the naive independent
prime density:

```text
prod_p (1 - nu_p(H)/p) / (1 - 1/p)^|H|
```

Claim label: `HEURISTIC` when used to rank actual prime patterns.

## Numerology Branch That Became Formally True

NB-0004: Resonance branch.

Truth label:

```text
FORMALLY_TRUE_AS_FINITE_SIEVE_DISTRIBUTION
```

This means resonance/survival language has a rigorous interpretation as
finite-wheel residue survival. It does not mean mystical resonance claims are
true.

## What Remains Heuristic

- using resonance scores to predict actual prime tuples
- interpreting high local factors as long-range prime abundance
- any Hardy-Littlewood-style asymptotic claim

Claim label: `HEURISTIC`.

## What Remains Open

- full Lean proof of the squarefree product theorem
- CRT/cardinality framework for arbitrary finite offset lists
- Lean proof of finite-check reduction `p > |H|` cannot be fully covered

Claim label: `OPEN`.

## Overreach Audit

No claim here proves the Hardy-Littlewood prime k-tuples conjecture.

No claim here proves all numerology true.

The breakthrough is narrower and stronger: some numerology branches compile
into rigorous mathematics, and resonance compiles into exact finite-sieve
distribution plus a search engine for prime-pattern candidates.
