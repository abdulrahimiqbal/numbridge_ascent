---
id: E-0004
type: experiment
title: Prime-gap root rhythm
status: ready
runner: prime_gap_root_rhythm
lead: L-0003
null_models:
  - NM-0006
---
# E-0004: Prime-gap root rhythm

## Question

Do decimal roots of prime gaps show robust rhythm beyond modular artifacts?

## Method

Compute `digital_root_10(p_{n+1} - p_n)` and compare against shuffled gaps.
## Latest Result

Result file: `data/experiment-results/E-0004.json`

Verdict: **weak**

Summary: The gap-root distribution exists, but this first-pass test does not show a strong rhythm beyond marginal gap structure.

Bridge implication: Do not promote without stronger null models preserving prime-gap constraints.
