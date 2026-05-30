---
id: E-0001
type: experiment
title: Prime digital-root distribution
status: ready
runner: prime_digital_roots
lead: L-0001
conjecture: C-0001
null_models:
  - NM-0003
---
# E-0001: Prime digital-root distribution

## Question

Do primes show special digital-root behavior?

## Method

Compare decimal digital roots of primes greater than 3 against odd nonmultiples of 3.

## Expected result

The exclusion of roots 3, 6, and 9 is explained by divisibility by 3.

## Lean Follow-up

`NumBridge.PrimeDigitalRoot.prime_gt_three_digital_root_10_not_three_six_nine`
now proves the lightweight digital-root exclusion for primes greater than 3.
This is a shallow-real theorem: it formalizes the bridge but confirms that the
prime-specific pattern is explained by divisibility by 3.
## Latest Result

Result file: `data/experiment-results/E-0001.json`

Verdict: **shallow-real**

Summary: Primes greater than 3 avoid decimal roots 3, 6, and 9, but the same exclusion holds for the fair null of odd nonmultiples of 3.

Bridge implication: Digital-root language translates cleanly to modular arithmetic modulo 9; the prime-specific mysticism collapses to divisibility by 3.
