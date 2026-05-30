---
id: C-0002
type: conjecture
title: Even palindromes divisible by 11
status: partially-proved
source_lead: L-0002
bridge: B-0002
lean_status: micro-theorem-proved
theorem_kind: even_palindrome_divisible_by_11
related_experiments:
  - E-0002
---
# C-0002: Even palindromes divisible by 11

## Statement

Every even-length base-10 palindrome is divisible by 11.

## Symbolic origin

Mirror numbers pass through the 11-gate.

## Formal translation

- mirror number → palindrome
- gate → divisibility predicate
- 11-gate → divisibility by 11

## Proof sketch

The divisibility test for 11 says a number is divisible by 11 when the alternating sum of its decimal digits is divisible by 11. In an even-length palindrome, mirrored digits occur with opposite signs and cancel.

## Lean plan

Start with a tractable theorem about 4-digit mirror numbers:

```text
11 ∣ 1000*a + 100*b + 10*b + a
```

Then generalize to digit lists.

## Lean result

Closed calibration theorem:

```text
NumBridge.Palindrome11.four_digit_mirror_factorization
NumBridge.Palindrome11.four_digit_mirror_divisible_by_11
```

The proved theorem is shallow-real but useful: it verifies the bridge mechanism
by factoring the mirror number as `11 * (91*a + 10*b)`. The full statement
"every even-length base-10 palindrome is divisible by 11" remains unproved in
Lean and should be attacked next with a digit-list value function or an
alternating-sum theorem.
