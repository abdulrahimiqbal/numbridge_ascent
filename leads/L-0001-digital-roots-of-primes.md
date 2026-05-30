---
id: L-0001
type: lead
title: Digital roots of primes
status: shallow-real-theorem
domain:
  - primes
  - digital_roots
  - modular_arithmetic
symbolic_terms:
  - completion
  - root
related_experiments:
  - E-0001
related_conjectures:
  - C-0001
related_bridges:
  - B-0001
---
# L-0001: Digital roots of primes

## Symbolic intuition

Primes appear to avoid certain completion roots.

## Candidate formalizations

1. For prime `p > 3`, `digital_root_10(p)` is not in `{3, 6, 9}`.
2. For prime `p > 3`, `p mod 9 ∈ {1, 2, 4, 5, 7, 8}`.
3. Base-general analogue: digit-root behavior corresponds to residue modulo `b - 1`.

## Current result

True but shallow. The exclusion is fully explained by divisibility by 3 and is
now closed in Lean under the local standard-library predicate
`NumBridge.PrimeDigitalRoot.Prime`.

Compiled theorem chain:

```text
NumBridge.PrimeDigitalRoot.prime_gt_three_not_dvd_by_three
NumBridge.PrimeDigitalRoot.prime_gt_three_mod_three_ne_zero
NumBridge.PrimeDigitalRoot.prime_gt_three_mod_nine_allowed
NumBridge.PrimeDigitalRoot.prime_gt_three_digital_root_10_not_three_six_nine
```

This is a PrimeBridge result, not an extension of the mirror/11 calibration
bridge.

## Ascent level

Level 7: shallow-real bridge recorded as `B-0001`.
