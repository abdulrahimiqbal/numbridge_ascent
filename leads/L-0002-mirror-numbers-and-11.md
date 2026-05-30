---
id: L-0002
type: lead
title: Mirror numbers and 11
status: micro-theorem-proved
domain:
  - palindromes
  - divisibility
  - base10
symbolic_terms:
  - mirror
  - gate
  - symmetry
related_experiments:
  - E-0002
related_conjectures:
  - C-0002
related_bridges:
  - B-0002
---
# L-0002: Mirror numbers and 11

## Symbolic intuition

Mirror numbers pass through an 11-gate.

## Candidate formalizations

1. Even-length base-10 palindromes are divisible by 11.
2. More generally, even-length base-`b` palindromes are divisible by `b + 1`.
3. The digit reversal map is an involution whose fixed points create cancellation under `b ≡ -1 mod (b + 1)`.

## Current result

Strong bridge with a closed shallow-real calibration theorem. The Lean theorem
`NumBridge.Palindrome11.four_digit_mirror_divisible_by_11` proves that every
number of the form `1000*a + 100*b + 10*b + a` is divisible by 11.

This does not yet prove the full even-length palindrome theorem. It closes the
minimal mirror/gate bridge and leaves the digit-list generalization as the next
formal target.

## Next actions

- [x] Formalize a minimal mirror-number theorem in Lean.
- [x] Update `bridge-cards/B-0002-mirror-symmetry-to-divisibility.md` when the proof compiles.
- [ ] Generalize from four-digit mirror numbers to constructed even-length palindromes.
