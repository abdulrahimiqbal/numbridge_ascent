---
id: C-0003
type: conjecture
title: Base-b even palindromes divisible by b plus one
status: proposed
source_lead: L-0002
bridge: B-0002
lean_status: not-started
theorem_kind: base_b_even_palindrome
related_experiments:
  - E-0002
---
# C-0003: Base-b even palindromes divisible by b + 1

## Statement

For base `b > 1`, every even-length base-`b` palindrome is divisible by `b + 1`.

## Proof idea

Since `b ≡ -1 mod (b + 1)`, evaluating a mirrored digit string creates alternating cancellation.

## Status

Proposed. This is more elegant than `C-0002` but harder to formalize.
