---
id: E-0002
type: experiment
title: Palindrome divisibility
status: ready
runner: palindrome_divisibility
lead: L-0002
conjecture: C-0002
null_models:
  - NM-0005
---
# E-0002: Palindrome divisibility

## Question

Are even-length base-10 palindromes divisible by 11?

## Method

Generate even-length palindromes and check divisibility by 11. Also sample the base-`b` analogue for `b + 1`.

## Lean Follow-up

`NumBridge.Palindrome11.four_digit_mirror_divisible_by_11` now proves the
smallest four-digit mirror case without `sorry`. This validates the bridge
mechanism but does not replace the empirical evidence for the full even-length
palindrome conjecture.
## Latest Result

Result file: `data/experiment-results/E-0002.json`

Verdict: **strong-bridge**

Summary: All generated even-length base-10 palindromes were divisible by 11; sampled base-b even palindromes were divisible by b + 1.

Bridge implication: The symbolic mirror/gate idea maps to palindrome structure and divisibility by base + 1. This is a high-priority Lean target.
