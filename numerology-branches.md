# Numerology Branches

A branch of numerology is formally true when a symbolic operation compiles into
a precise mathematical structure and produces verified reusable theorems.

This does not mean mystical numerology is true. It means a symbolic vocabulary
has a rigorous mathematical interpretation.

## NB-0001: Digital-Root Branch

Symbolic language: `root`, `completion`, `collapse`.

Formal interpretation: modular arithmetic modulo `b - 1`.

Lean evidence:

```text
NumBridge.digital_root_10_mod_nine
NumBridge.prime_gt_three_digital_root_10_not_three_six_nine
```

Truth label: `FORMALLY_TRUE_AS_MODULAR_ARITHMETIC`.

Claim labels: `INTERPRETIVE_FORMALIZATION`, `PROVED_IN_LEAN`.

## NB-0002: Mirror Branch

Symbolic language: `mirror`, `reflection`, `11 gate`.

Formal interpretation: palindromes and divisibility.

Lean evidence:

```text
NumBridge.four_digit_mirror_divisible_by_11
NumBridge.six_digit_mirror_divisible_by_11
```

Truth label: `FORMALLY_TRUE_AS_SYMMETRY_DIVISIBILITY`.

Claim labels: `INTERPRETIVE_FORMALIZATION`, `PROVED_IN_LEAN`.

## NB-0003: Gate Branch

Symbolic language: `gate`, `forbidden number`, `obstruction`.

Formal interpretation: residue class obstruction and local sieve gates.

Lean evidence:

```text
NumBridge.triplet_mod_three_sieve_gate
NumBridge.only_prime_triplet_three_five_seven
NumBridge.residue_cover_translate_hits_multiple
```

Truth label: `FORMALLY_TRUE_AS_LOCAL_SIEVE_THEORY`.

Claim labels: `INTERPRETIVE_FORMALIZATION`, `PROVED_IN_LEAN`.

## NB-0004: Resonance Branch

Symbolic language: `resonance`, `survival`, `harmonic prime pattern`.

Formal interpretation: residue-shadow survival and finite-wheel distribution.

Lean/Python evidence:

```text
NumBridge.resonance_cover_forces_sieve_hit
NumBridge.twin_survives_mod_two_three_iff_mod_six_five
NumBridge.zero_two_four_no_survivor_mod_two_three
NumBridge.crt_count_product_two_moduli
NumBridge.wheel30_residue_product_formula_via_crt
NumBridge.bt0006_squarefree_wheel_shadow_distribution
```

Python evidence:

```text
exact_wheel_distribution_holds
wheel_survivor_count
wheel_survivor_count_general
product_local_survival_count
product_local_survivor_counts
compare_patterns_by_wheel_distribution
```

Truth label: `FORMALLY_TRUE_AS_FINITE_SIEVE_DISTRIBUTION`.

Claim labels: `INTERPRETIVE_FORMALIZATION`, `PROVED_IN_LEAN`,
`COMPUTED_BY_PYTHON`, and `HEURISTIC` for resonance ranking.

## Not Proven

The following are explicitly `NOT_PROVEN`:

- mystical destiny claims
- personality claims
- predictive divination
- arbitrary name-number encodings unless they produce statistical or predictive
  structure
- the Hardy-Littlewood prime k-tuples conjecture
