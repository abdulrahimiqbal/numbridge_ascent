# Proof Roadmap

## PR-0000: Bridge theorem layer

Goal: promote isolated calibration theorems into reusable theorem schemas.

Lean path: `lean/NumBridge/BridgeTheorems.lean`

Status: intermediate bridge theorems proved.

Closed theorem names:

```text
NumBridge.digital_root_10_mod_nine
NumBridge.residue_three_six_zero_mod_nine_implies_three_dvd
NumBridge.digital_root_10_eq_three_six_nine_implies_three_dvd
NumBridge.prime_completion_roots_vanish_bridge
NumBridge.six_digit_mirror_factorization
NumBridge.six_digit_mirror_divisible_by_11
NumBridge.mirror_symmetry_creates_divisibility_gates_bridge
NumBridge.triplet_mod_three_sieve_gate
NumBridge.prime_triplet_start_eq_three
NumBridge.only_prime_triplet_three_five_seven
NumBridge.residue_cover_translate_hits_multiple
```

Remaining engineering work: full base-`b` digit-list digital roots and full
base-`b` even-palindrome divisibility, plus a reusable admissibility API for
finite prime constellations.

## PR-0001: Digital root and modular arithmetic

Goal: prove that repeated base-`b` digit sum preserves congruence modulo `b - 1`.

Lean path: `lean/NumBridge/DigitalRoot.lean`

Status: lightweight decimal residue theorem proved in `BridgeTheorems.lean`;
full base-`b` digit-list theorem still open.

## PR-0002: Prime digital-root exclusion

Goal: prove that a prime `p > 3` is not divisible by 3, so its decimal digital root cannot be 3, 6, or 9.

Lean path: `lean/NumBridge/PrimeDigitalRoot.lean`

Status: shallow-real theorem proved.

Closed theorem chain:

```text
NumBridge.PrimeDigitalRoot.prime_gt_three_not_dvd_by_three
NumBridge.PrimeDigitalRoot.prime_gt_three_mod_three_ne_zero
NumBridge.PrimeDigitalRoot.prime_gt_three_mod_nine_allowed
NumBridge.PrimeDigitalRoot.prime_gt_three_digital_root_10_not_three_six_nine
```

Next proof step: replace the lightweight residue-based `digital_root_10` with
a reusable digit-list digital-root function and prove its congruence modulo 9.

## PR-0003: Even palindromes divisible by 11

Goal: prove that even-length base-10 palindromes are divisible by 11.

Lean path: `lean/NumBridge/Palindrome11.lean`

Status: micro-theorem-proved.

Suggested tractable weakening:

```text
For digits a b, the mirror number 1000a + 100b + 10b + a is divisible by 11.
```

This captures the symbolic bridge while being much easier to prove in Lean.

Closed theorem:

```text
NumBridge.Palindrome11.four_digit_mirror_divisible_by_11
```

Next proof step: define a decimal value function on digit lists and prove that
`value (xs ++ reverse xs)` is divisible by 11, or first prove the alternating
digit-sum test modulo 11.

## PR-0004: Prime constellation admissibility

Goal: prove that offset patterns covering every residue class modulo a prime
are obstructed.

Lean path: `lean/NumBridge/PrimeConstellations.lean`

Status: concrete theorem and finite-cover schema proved.

Closed theorem names:

```text
NumBridge.triplet_mod_three_sieve_gate
NumBridge.prime_triplet_start_eq_three
NumBridge.only_prime_triplet_three_five_seven
NumBridge.residue_cover_translate_hits_multiple
NumBridge.triplet_offsets_cover_hits_multiple
```

Next proof step: define `Admissible offsets` as the absence of residue-cover
obstructions for every prime modulus, then prove non-admissibility of
`[0, 2, 4]` modulo 3 through that API.

## PR-0005: Residue-shadow resonance

Goal: connect symbolic resonance language to residue shadows, gate deficits,
admissibility, and local survival factors.

Lean paths:

```text
lean/NumBridge/ResidueShadow.lean
lean/NumBridge/PrimePatternResonance.lean
```

Status: concrete obstruction/survival facts proved; Python search engine built.

Closed theorem names:

```text
NumBridge.translation_zero_cover_hits_multiple
NumBridge.zero_two_six_not_cover_residues_mod_three
NumBridge.zero_two_not_cover_residues_mod_two
NumBridge.zero_two_not_cover_residues_mod_three
NumBridge.resonance_triplet_obstructed_mod_three
NumBridge.resonance_zero_two_six_survives_mod_three
NumBridge.resonance_zero_two_survives_mod_two_and_three
NumBridge.resonance_cover_forces_sieve_hit
```

Roadmap target: prove the finite-check reduction in Lean: a list of `k`
offsets cannot cover all residues modulo `p` when `p > k`.

## PR-0006: Wheel-shadow finite-sieve distribution

Goal: prove the exact finite-wheel product theorem:

```text
|R_W(H)| = prod_{p | W} (p - nu_p(H))
```

Lean paths:

```text
lean/NumBridge/WheelShadow.lean
lean/NumBridge/WheelProduct.lean
lean/NumBridge/WheelProductGeneral.lean
lean/NumBridge/NumerologyBranches.lean
```

Status: product-layer theorem proved for local gates, the squarefree wheels
6 and 30, and arbitrary finite positive pairwise-coprime gate lists.

Closed theorem names:

```text
NumBridge.twin_survives_mod_two_three_iff_mod_six_five
NumBridge.zero_two_four_no_survivor_mod_two_three
NumBridge.zero_two_six_wheel30_product_count_arithmetic
NumBridge.local_gate_survivor_count_eq_modulus_sub_shadow
NumBridge.wheel6_residue_product_formula
NumBridge.wheel6_residue_product_formula_as_shadow_sub
NumBridge.wheel30_residue_product_formula
NumBridge.wheel30_residue_product_formula_as_shadow_sub
NumBridge.crt_count_product_two_moduli
NumBridge.wheel_product_step
NumBridge.wheel6_residue_product_formula_via_crt
NumBridge.wheel30_residue_product_formula_via_crt
NumBridge.bt0006_two_moduli_wheel_shadow_distribution
NumBridge.bt0006_two_moduli_wheel_shadow_distribution_as_shadow_sub
NumBridge.wheel_survivor_count_product_general
NumBridge.product_local_gate_survivor_count_eq_shadow_sub_general
NumBridge.wheel_survivor_count_product_as_shadow_sub_general
NumBridge.bt0006_squarefree_wheel_shadow_distribution
NumBridge.resonance_branch_truth_label
```

Roadmap target: build a cleaner reusable API around this theorem, then separate
finite-wheel candidate distribution from any future analytic theorem about
actual primes.

## PR-0007: Finite resonance optimization

Goal: use BT-0006 to prove finite optimization theorems for the truncated
resonance score:

```text
Res_P(H) = prod_{p <= P} (1 - nu_p(H) / p) / (1 - 1 / p)^k
```

over admissible `k`-offset patterns with constraints such as
`diameter(H) <= D`.

Status: broad all-`k,D,P` exhaustive finite classifier proved in Lean.

Lean path:

```text
lean/NumBridge/ResonanceOptimization.lean
```

Closed theorem names:

```text
NumBridge.two_point_finite_resonance_score_le_max
NumBridge.two_point_gateProduct_attains_resonance_max
NumBridge.bt0007_two_point_bounded_finite_resonance_optimization
NumBridge.finite_resonance_maximizers_classify
NumBridge.bt0007_all_k_D_P_finite_resonance_classification
```

Next proof step: move from exhaustive classifier theorems to closed-form
structural descriptions of the maximizing families for interesting parameter
families.

## PR-0008: Resonance lattice maximizer

Goal: prove a closed-form structural maximizer theorem for the absolute finite
resonance numerator.

Lean path:

```text
lean/NumBridge/ResonanceLatticeMaximizer.lean
```

Status: core structural theorem proved in Lean; full reverse threshold remains
open.

Closed theorem names:

```text
NumBridge.nonempty_shadow_count_ge_one
NumBridge.local_survivor_count_le_p_minus_one
NumBridge.finite_resonance_numerator_le_upper_bound
NumBridge.local_survivor_count_eq_p_minus_one_iff_all_mod_zero
NumBridge.equality_upper_bound_implies_single_shadow_each_gate
NumBridge.same_residue_as_zero_all_gates_iff_dvd_gateProduct
NumBridge.resonance_upper_bound_eq_iff_offsets_dvd_gateProduct
NumBridge.bt0008_resonance_lattice_maximizer_theorem
NumBridge.canonical_lattice_pattern_valid_if_D_ge
NumBridge.canonical_lattice_pattern_attains_upper_bound
NumBridge.bt0008_attainability_threshold_sufficient
NumBridge.bt0008_maximizer_family_characterization
```

Roadmap target: prove the finite order/pigeonhole lemma that `k` distinct
multiples of positive `W`, containing zero and bounded by `D`, force
`D >= (k - 1)W`. That would close the full iff threshold and floor-family
statement for BT-0008.

## PR-0009: Subcritical resonance maximizers

Goal: classify best finite resonance patterns below the lattice threshold
`D < (k - 1)W`.

First target:

```text
gates = [2,3,5], W = 30, k = 3, D = 59
```

Status: first subcritical structural theorem proved in Lean.

Lean path:

```text
lean/NumBridge/SubcriticalResonance.lean
```

Closed theorem names:

```text
NumBridge.bt0009_subcritical_235_k3_D59_upper_bound
NumBridge.bt0009_subcritical_235_k3_D59_equality_characterization
NumBridge.bt0009_subcritical_235_k3_D59_structural_breakthrough
```

Lean proves max score `6`, with equality iff every offset is divisible by `6`
and exactly two residues modulo `5` are occupied.

## PR-0010: One-gate-sacrifice theorem

Goal: generalize BT-0009 from `[2,3,5]` to `[2,3,q]`.

Status: parametric theorem proved in Lean.

Lean path:

```text
lean/NumBridge/FirstSubcriticalSacrifice.lean
```

Closed theorem names:

```text
NumBridge.first_subcritical_upper_bound_two_three_q
NumBridge.first_subcritical_equality_forces_six_lock_and_q_sacrifice
NumBridge.first_subcritical_six_lock_and_q_sacrifice_attains
NumBridge.bt0010_first_subcritical_sacrifice_theorem
```

Theorem:

```text
q coprime to 6, q > 3
W = 6q
k = 3
D = 2W - 1
FiniteResonanceNumerator [2,3,q] H <= 2 * (q - 2)
```

Expected equality condition:

```text
All offsets are divisible by 6
and
LocalResidueShadowCount q H = 2.
```

This turns the first subcritical example into a reusable finite-sieve schema.

Open proof polish: prove directly in Lean that the concrete canonical pattern
`[0,6,6q]` has `LocalResidueShadowCount q = 2`. Python verifies it in the
requested scans, and Lean has a conditional attainer theorem once that local
count is supplied.

## PR-0011: General first-subcritical sacrifice

Goal: generalize BT-0010 beyond the fixed base spine `[2,3]`.

Status: arbitrary two-gate fallback theorem proved in Lean; full arbitrary
finite base-spine theorem remains open.

Lean path:

```text
lean/NumBridge/GeneralFirstSubcriticalSacrifice.lean
```

Closed theorem names:

```text
NumBridge.no_three_distinct_bounded_twoM_minus_one_all_dvd
NumBridge.q_gt_left_of_two_gate_threshold
NumBridge.q_gt_right_of_two_gate_threshold
NumBridge.dropped_left_two_gate_product_lt
NumBridge.dropped_right_two_gate_product_lt
NumBridge.two_gate_first_subcritical_base_lock_forces_q_shadow_ge_two
NumBridge.two_gate_local_q_le_q_minus_two_of_base_lock
NumBridge.two_gate_base_local_factor_eq_of_lock
NumBridge.two_gate_lock_of_base_local_factors_eq
NumBridge.two_gate_not_locked_score_drop
NumBridge.two_gate_first_subcritical_upper_bound
NumBridge.two_gate_first_subcritical_equality_forces_lock_and_q_sacrifice
NumBridge.two_gate_first_subcritical_lock_and_q_sacrifice_attains
NumBridge.bt0011_two_gate_first_subcritical_sacrifice_theorem
```

Lean-proved fallback theorem:

```text
2 <= a, 2 <= b, 2 <= q
Nat.Coprime a b
Nat.Coprime q (a*b)
(a - 1)*(b - 1) + 1 <= q
D = 2*(a*b*q) - 1
FiniteResonanceNumerator [a,b,q] H
  <= (a - 1)*(b - 1)*(q - 2)
```

Equality holds iff:

```text
AllOffsetsDivisibleBy (a*b) H
and
LocalResidueShadowCount q H = 2
```

Next proof step: prove the full arbitrary finite base-spine theorem. The
missing ingredient is a reusable product-factor drop/equality lemma strong
enough to rule out non-locked equality in the edge case `q = B + 1`.

## PR-0012: Two-offset residue-shadow count

Goal: remove the remaining local counting friction.

Target:

```text
If 0 < q and d % q != 0,
then LocalResidueShadowCount q [0,d] = 2.
```

This lemma closes the unconditional canonical attainer for BT-0010 and should
support later sacrifice theorems.
