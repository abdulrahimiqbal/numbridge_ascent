---
id: C-0001
type: conjecture
title: Prime digital-root exclusion
status: theorem-proved
source_lead: L-0001
bridge: B-0001
lean_status: digital-root-exclusion-proved
theorem_kind: prime_digital_root_exclusion
related_experiments:
  - E-0001
---
# C-0001: Prime digital-root exclusion

## Statement

For every prime `p > 3`, the base-10 digital root of `p` is in `{1, 2, 4, 5, 7, 8}`.

## Equivalent arithmetic statement

For every prime `p > 3`, `p mod 9` is in `{1, 2, 4, 5, 7, 8}`.

## Symbolic origin

Primes avoid completion roots.

## Proof sketch

If `digital_root_10(p)` is in `{3, 6, 9}`, then `3 ∣ p`. Since `p` is prime and greater than 3, this is impossible.

## Lean plan

First prove a smaller theorem:

```text
Nat.Prime p → 3 < p → ¬ 3 ∣ p
```

Then connect digit roots to divisibility by 3 / residue modulo 9.

## Lean result

Closed under a lightweight local prime predicate:

```text
NumBridge.PrimeDigitalRoot.Prime
NumBridge.PrimeDigitalRoot.prime_gt_three_not_dvd_by_three
NumBridge.PrimeDigitalRoot.prime_gt_three_mod_three_ne_zero
NumBridge.PrimeDigitalRoot.prime_gt_three_mod_nine_allowed
NumBridge.PrimeDigitalRoot.digital_root_10
NumBridge.PrimeDigitalRoot.prime_gt_three_digital_root_10_not_three_six_nine
```

The theorem proves the prime-specific digital-root exclusion without `sorry`.
It is classified as shallow-real: the numerology phrase "completion roots
vanish from primes" reduces to the elementary fact that a prime greater than 3
is not divisible by 3.
