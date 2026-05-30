---
id: E-0003
type: experiment
title: Base-invariance calibration
status: ready
runner: base_invariance
lead: L-0001
conjecture: C-0001
null_models:
  - NM-0005
---
# E-0003: Base-invariance calibration

## Question

Which digit-root claims are base-specific versus base-general?

## Method

Verify the relation between digit sums and residues modulo `b - 1` across multiple bases.
## Latest Result

Result file: `data/experiment-results/E-0003.json`

Verdict: **confirmed-translation**

Summary: Across tested bases, digital root preserves congruence modulo base - 1.

Bridge implication: Digit-root numerology has a robust arithmetic translation: modular arithmetic modulo b - 1.
