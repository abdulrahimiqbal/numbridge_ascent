# PrimeBridge Resonance Engine Report - 2026-05-29

## 1. What Changed

NumBridge moved from hand-fed bridge theorems into a search engine for
prime-pattern bridges.

New engine modules:

```text
src/bridge/prime_patterns.py
src/bridge/residue_shadow.py
src/bridge/resonance.py
src/bridge/search_prime_patterns.py
```

New CLI commands:

```text
python3 bridge.py prime-pattern H=0,2,4
python3 bridge.py prime-pattern H=0,2,6
python3 bridge.py search-admissible --k 3 --diameter 20
python3 bridge.py rank-resonance --k 4 --diameter 50 --prime-bound 31
python3 bridge.py primebridge-report --k 3 --diameter 30 --N 100000
```

## 2. The New Bridge

Symbolic resonance now translates as:

```text
symbolic resonance
  -> residue shadows
  -> gate deficits
  -> local survival factors
  -> prime-pattern admissibility
```

For a finite offset pattern `H`:

```text
shadow_p(H) = {h mod p : h in H}
deficit_p(H) = p - |shadow_p(H)|
local_factor_p(H) = (1 - nu_p(H)/p) / (1 - 1/p)^|H|
```

## 3. Concrete Examples

`H = [0,2,4]` is obstructed modulo 3:

```text
shadow_3(H) = {0,1,2}
deficit_3(H) = 0
```

`H = [0,2,6]` is admissible under the finite check:

```text
shadow_2(H) = {0}
shadow_3(H) = {0,2}
```

`H = [0,2]` is the twin-prime offset pattern and is admissible under the finite
check.

Lean records these concrete facts in:

```text
lean/NumBridge/ResidueShadow.lean
lean/NumBridge/PrimePatternResonance.lean
```

## 4. Best High-Resonance Patterns Found

Parameters: `prime_bound = 31`, empirical counts use `N = 100000`.

### k = 2, diameter <= 20

| Pattern | Resonance | Count |
|---|---:|---:|
| `[0,6]` | 2.657597 | 2447 |
| `[0,12]` | 2.657597 | 2421 |
| `[0,18]` | 2.657597 | 2477 |
| `[0,10]` | 1.771732 | 1624 |
| `[0,20]` | 1.771732 | 1645 |

### k = 3, diameter <= 30

| Pattern | Resonance | Count |
|---|---:|---:|
| `[0,6,30]` | 8.742801 | 821 |
| `[0,12,30]` | 8.742801 | 780 |
| `[0,18,30]` | 8.742801 | 782 |
| `[0,24,30]` | 8.742801 | 782 |
| `[0,6,12]` | 5.828534 | 530 |

### k = 4, diameter <= 50

| Pattern | Resonance | Count |
|---|---:|---:|
| `[0,12,30,42]` | 34.539192 | 306 |
| `[0,6,30,36]` | 25.904394 | 261 |
| `[0,18,30,48]` | 25.904394 | 232 |
| `[0,14,30,44]` | 24.670851 | 241 |
| `[0,6,12,42]` | 23.026128 | 216 |

## 5. Honest Classification

BT-0005 is prime-structural / search-enabling.

This is not a proof of the Hardy-Littlewood prime tuple conjecture. It is a
real bridge from numerological resonance language into the local structure used
by sieve theory and prime-pattern heuristics.

## 6. Next Target

Prove the finite-check reduction in Lean:

```text
A list of k offsets cannot cover all residues modulo p when p > k.
```

Then add a reusable admissibility API that connects Python-generated residue
certificates to Lean-checkable obstruction or survival facts.
