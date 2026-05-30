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

Status: product-layer theorem proved for local gates and the squarefree wheels
6 and 30; reusable two-modulus CRT/cardinality theorem proved; full arbitrary
squarefree gate-list product theorem open.

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
NumBridge.resonance_branch_truth_label
```

Roadmap target: turn `crt_count_product_two_moduli` into an induction over
positive pairwise-coprime gate lists, producing
`wheel_survivor_count_product_general` and the corresponding `p - nu_p(H)`
theorem for arbitrary squarefree wheels.
