---
id: E-0005
type: experiment
title: Seven resists factor collapse
status: ready
runner: seven_factor_collapse
lead: L-0004
null_models:
  - NM-0003
  - NM-0004
---
# E-0005: Seven resists factor collapse

## Question

Do numbers with decimal digital root 7 have unusual factor complexity?

## Method

Compare prime-factor counts by digital root and inspect whether root 7 is exceptional.
## Latest Result

Result file: `data/experiment-results/E-0005.json`

Verdict: **weak**

Summary: Root 7 was not exceptional in this simple factor-count pass.

Bridge implication: Collapse language is better treated as iterative-map language than as a direct claim about decimal root 7.
