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
and wheel 30 table proofs; the arbitrary squarefree gate-list theorem is still
open.
