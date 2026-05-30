---
id: B-0001
type: bridge
title: Digital root to modular arithmetic
status: shallow-real-theorem
source_leads:
  - L-0001
related_conjectures:
  - C-0001
bridge_strength: shallow-real
lean_priority: high
---
# B-0001: Digital root to modular arithmetic

## Symbolic form

A number's one-digit essence.

## Mathematical form

Base-`b` digital root corresponds to residue modulo `b - 1`, with the usual convention that multiples of `b - 1` map to root `b - 1` rather than 0.

## Example

In base 10, digital root corresponds to modulo 9.

## Bridge verdict

Strong as a translation, shallow-real as a prime-specific discovery. It
explains many numerology-style observations without requiring mysticism.

## Closed PrimeBridge theorem

Compiled theorem chain:

```text
NumBridge.PrimeDigitalRoot.prime_gt_three_not_dvd_by_three
NumBridge.PrimeDigitalRoot.prime_gt_three_mod_three_ne_zero
NumBridge.PrimeDigitalRoot.prime_gt_three_mod_nine_allowed
NumBridge.PrimeDigitalRoot.prime_gt_three_digital_root_10_not_three_six_nine
```

This proves that primes greater than 3 cannot have decimal digital root 3, 6,
or 9 under a lightweight local prime predicate. The result is intentionally
classified as shallow-real because the exclusion is exactly the elementary
divisibility-by-3 obstruction.

## Bridge Theorem Layer

Promoted into:

```text
BT-0001: Digit collapse is modular arithmetic
BT-0003: Prime completion-root exclusions are residue obstructions
```

## Lean potential

Closed for the prime-specific exclusion using a lightweight residue-based
`digital_root_10`. A full digit-list digital-root formalization remains a
separate reusable bridge target.
