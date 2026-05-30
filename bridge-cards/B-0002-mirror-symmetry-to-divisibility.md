---
id: B-0002
type: bridge
title: Mirror symmetry to divisibility
status: partial-theorem
source_leads:
  - L-0002
related_conjectures:
  - C-0002
  - C-0003
bridge_strength: strong-bridge
lean_priority: high
---
# B-0002: Mirror symmetry to divisibility

## Symbolic form

Mirror numbers pass through a hidden gate.

## Mathematical form

Palindromic digit strings imply divisibility constraints.

## Core theorem target

Every even-length base-10 palindrome is divisible by 11.

## Closed Lean calibration

The four-digit mirror case now compiles without `sorry`:

```text
NumBridge.Palindrome11.four_digit_mirror_factorization
NumBridge.Palindrome11.four_digit_mirror_divisible_by_11
```

This is a shallow-real calibration theorem, not the full bridge. It proves that
mirror symmetry creates an 11-divisibility gate for numbers of the form
`1000*a + 100*b + 10*b + a` by the factorization
`1000*a + 100*b + 10*b + a = 11 * (91*a + 10*b)`.

## Bridge Theorem Layer

Promoted into:

```text
BT-0002: Mirror symmetry creates divisibility gates
```

The bridge theorem layer adds the six-digit mirror theorem as the next compiled
intermediate step.

## Generalization

Every even-length base-`b` palindrome is divisible by `b + 1`.

## Why this is a high-priority bridge

It is a clean example where a symbolic phrase maps to a real theorem:

```text
mirror → palindrome
hidden gate → divisibility
11 → base + 1 for base 10
```

## Lean potential

High if scoped carefully. The 4-digit case is closed; next generalize to
constructed even-length digit lists and then to base-`b` palindromes.
