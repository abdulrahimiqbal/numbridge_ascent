# PrimeBridge

PrimeBridge is the NumBridge mode for translating symbolic prime language into
residue geometry, local sieve structure, admissibility, and empirical
prime-pattern search.

## Current Thesis

Numerological "resonance" for prime patterns should be formalized as the local
residue-survival profile of a finite offset pattern `H`.

For an offset pattern `H = {h_1, ..., h_k}`:

```text
shadow_p(H) = {h mod p : h in H}
deficit_p(H) = p - |shadow_p(H)|
H obstructed modulo p iff deficit_p(H) = 0
H admissible iff no prime p causes obstruction
```

Because `|H| = k`, primes `p > k` cannot be fully covered by `H`, so
admissibility only needs checking primes `p <= k`.

## Engine

Python path:

```text
src/bridge/prime_patterns.py
src/bridge/residue_shadow.py
src/bridge/resonance.py
src/bridge/search_prime_patterns.py
src/bridge/wheel_product_general.py
src/bridge/resonance_lattice_maximizer.py
src/bridge/subcritical_resonance.py
src/bridge/first_subcritical_sacrifice.py
```

CLI examples:

```bash
python3 bridge.py prime-pattern H=0,2,4
python3 bridge.py prime-pattern H=0,2,6
python3 bridge.py search-admissible --k 3 --diameter 20
python3 bridge.py rank-resonance --k 4 --diameter 50 --prime-bound 31
python3 bridge.py primebridge-report --k 3 --diameter 30 --N 100000
python3 bridge.py wheel-product-general H=0,2,6 gates=2,3,5
python3 bridge.py wheel-product-counterexample-search --max-gate 12 --max-offset 20
python3 bridge.py resonance-lattice-max k=3 D=60 gates=2,3,5
python3 bridge.py verify-bt0008 --max-k 4 --max-D 80 --gates 2,3,5
python3 bridge.py subcritical-bt009 --verify
python3 bridge.py bt0010-scan --q-max 17
```

## Honest Boundary

This is not a proof of the Hardy-Littlewood prime tuple conjecture. It is a
search-enabling bridge from symbolic resonance language into local factors used
by sieve heuristics.

## Wheel-Shadow Distribution

BT-0006 adds the exact finite-sieve layer:

```text
R_W(H) = {a mod W : every a+h is coprime to W}
|R_W(H)| = prod_{p | W} (p - nu_p(H))
```

The repo checks this product formula by brute force for finite wheels and uses
it as the rigorous distribution layer underneath resonance ranking. Lean proves
the central two-modulus CRT/count theorem and uses it to replace the wheel 6
and wheel 30 table proofs; Lean now also proves the arbitrary positive
pairwise-coprime gate-list finite-wheel theorem.

## Next Phase: Finite Resonance Optimization

BT-0007 should study finite optimization of truncated resonance scores over
admissible offset patterns:

```text
Res_P(H) = prod_{p <= P} (1 - nu_p(H) / p) / (1 - 1 / p)^k
```

Candidate questions:

- Among admissible `k`-patterns with `diameter(H) <= D`, which patterns
  maximize `Res_P(H)`?
- Are there reusable upper bounds in terms of residue-shadow sizes?
- Do maximizing families match known prime-constellation patterns, or produce
  new finite classifications worth checking against the literature?

First Lean closure:

```text
NumBridge.bt0007_two_point_bounded_finite_resonance_optimization
NumBridge.bt0007_all_k_D_P_finite_resonance_classification
```

This proves both the two-point bounded optimization case and the broad
all-`k,D,P` exhaustive finite classifier. It is finite combinatorics, not prime
distribution.

## Structural Maximizer Layer

BT-0008 upgrades the classifier layer into a structural theorem for the
absolute finite resonance upper bound. Lean proves:

```text
ProductLocalGateSurvivorCount gates H = prod_{p in gates} (p - 1)
iff
every h in H is divisible by gateProduct gates.
```

This formalizes the symbolic phrase "strongest resonance locks onto the
gate-product lattice." It remains finite-sieve combinatorics. The next target
is subcritical resonance: classify the best patterns when the diameter bound is
too small to fit `[0,W,2W,...,(k-1)W]`.

## Subcritical Structural Layer

BT-0009 closes the first subcritical case:

```text
gates = [2,3,5], W = 30, k = 3, D = 59
```

Lean proves that every normalized distinct pattern has finite resonance
numerator at most `6`, and equality holds exactly when all offsets are
divisible by `6` and exactly two residues modulo `5` are occupied.

This is the first "one gate sacrifice" theorem: the full `[2,3,5]` lattice
cannot fit, so the maximizers keep the `[2,3]` lattice and lose one controlled
unit at the `5` gate.

## Parametric First-Subcritical Layer

BT-0010 generalizes BT-0009 to `[2,3,q]` for `q >= 5` and coprime to `6`.
Lean proves that the first-subcritical maximum is `2 * (q - 2)`, with equality
exactly when the pattern is divisible by `6` and has two q-residue shadows.

This keeps the branch finite and structural: it is still about local
finite-wheel resonance, not actual prime distribution.

## General Base-Spine Layer

BT-0011 pushes the one-gate-sacrifice schema beyond `[2,3]`. Lean proves the
arbitrary two-gate fallback theorem for `[a,b,q]`: under the expected
coprimality and threshold assumptions, the first-subcritical maximum is
`(a - 1)*(b - 1)*(q - 2)`, attained exactly by `a*b`-locked patterns with two
q-shadows.

The arbitrary finite base-spine theorem remains the next Lean target. Python
now checks the finite-list version and searches for equality-edge failures in
bounded windows.

## Actual-Prime Wheel Bound

BT-0012 adds the first actual-prime count bridge. Lean proves that actual prime
tuple translates above the finite gates must land in wheel-survivor residues,
and that any sound Boolean enumerator of such translates is bounded by:

```text
WheelSurvivorCountGeneral gates H * (N / gateProduct gates + 1)
```

This is elementary but important: it connects the finite wheel layer to actual
prime tuples. It is not yet Selberg sieve, Bombieri-Vinogradov, Maynard-Tao,
or Hardy-Littlewood.
