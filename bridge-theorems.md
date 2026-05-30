# Bridge Theorems

A Bridge Theorem is a reusable theorem schema showing that a class of
numerology-like symbolic phrases corresponds to a precise mathematical
structure.

Bridge Theorems sit above individual leads and calibration proofs. A calibration
can be shallow-real and still useful when it exposes the exact mathematical
structure behind a symbolic phrase.

| ID | Title | Symbolic language | Mathematical structure | Lean status | Label |
|---|---|---|---|---|---|
| BT-0001 | Digit collapse is modular arithmetic | root, completion, collapse to one digit | digit sum and digital root correspond to residues modulo `b - 1` | lightweight decimal residue theorem proved | useful |
| BT-0002 | Mirror symmetry creates divisibility gates | mirror, reflection, 11 gate | even-length base-`b` palindromes are divisible by `b + 1` | four- and six-digit base-10 cases proved | strong target |
| BT-0003 | Prime completion-root exclusions are residue obstructions | completion roots vanish from primes | if a prime divisor blocks a residue class, prime roots avoid it | decimal `q = 3`, `b = 10` case proved | shallow-real |
| BT-0004 | Sieve gates and prime-pattern admissibility | prime patterns survive only when they avoid total residue collapse | offset sets that cover all residues modulo a prime obstruct prime constellations | `n,n+2,n+4` obstruction and finite-cover lemma proved | useful / prime-structural |
| BT-0005 | Residue shadow resonance | gate, shadow, resonance, survival | residue shadows and local survival factors rank prime-pattern candidates | engine plus concrete Lean facts proved | prime-structural / search-enabling |
| BT-0006 | Wheel-shadow distribution theorem | resonance through prime gates | exact finite-wheel survivor counts factor into local survival counts | full arbitrary positive pairwise-coprime gate-list theorem proved | foundational / finite-sieve / proved-in-Lean |
| BT-0007 | Finite resonance optimization theorem | strongest resonance, surviving patterns, best prime shapes | exact finite argmax classification over bounded `k,D,P` search spaces | broad all-`k,D,P` finite classifier proved | finite combinatorics / proved-in-Lean |
| BT-0008 | Resonance lattice maximizer theorem | strongest resonance, gate-product alignment, lattice lock | absolute finite-resonance maximizers lie on the gate-product lattice | upper bound and equality characterization proved; reverse threshold open | finite-sieve structural maximizer |
| BT-0009 | Subcritical resonance theorem | subcritical resonance, one gate sacrifice, partial lattice lock | below the full lattice threshold, best patterns keep the 6-lattice and sacrifice the 5-gate minimally | first subcritical `[2,3,5]`, `k=3`, `D=59` theorem proved | finite-sieve subcritical structural theorem |
| BT-0010 | First subcritical sacrifice theorem | first subcritical zone, one gate sacrifice | for `[2,3,q]`, best first-subcritical patterns keep the 6-lattice and occupy exactly two q-residues | parametric upper bound and equality iff proved | finite-sieve parametric structural theorem |
| BT-0011 | General first-subcritical sacrifice theorem | base-spine resonance, one gate sacrifice | for arbitrary two-gate base spines `[a,b]`, best first-subcritical patterns lock `a*b` and occupy exactly two q-residues | two-gate fallback theorem proved; arbitrary finite base spine open | finite-sieve two-gate structural theorem |
| BT-0012 | Prime wheel upper bound | actual prime tuples must survive finite gates | prime tuple translates above gates land in wheel-survivor residues and satisfy a wheel-block count bound | elementary actual-prime wheel theorem proved | actual-prime bridge elementary |
| BT-0013 | Finite Gallagher resonance conservation | resonance averages to neutral across the finite wheel | finite singular-series numerators conserve total mass when averaged over residue tuples | single-gate and two-gate arbitrary-`k` theorems proved; arbitrary gate-list theorem open | internal NumBridge breakthrough |

## Current Lean Surface

Lean path: `lean/NumBridge/BridgeTheorems.lean`

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
NumBridge.triplet_offsets_cover_hits_multiple
NumBridge.resonance_triplet_obstructed_mod_three
NumBridge.resonance_zero_two_six_survives_mod_three
NumBridge.resonance_zero_two_survives_mod_two_and_three
NumBridge.resonance_cover_forces_sieve_hit
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
NumBridge.two_point_finite_resonance_score_le_max
NumBridge.two_point_gateProduct_attains_resonance_max
NumBridge.bt0007_two_point_bounded_finite_resonance_optimization
NumBridge.finite_resonance_maximizers_classify
NumBridge.bt0007_all_k_D_P_finite_resonance_classification
NumBridge.finite_resonance_numerator_le_upper_bound
NumBridge.equality_upper_bound_implies_single_shadow_each_gate
NumBridge.same_residue_as_zero_all_gates_iff_dvd_gateProduct
NumBridge.resonance_upper_bound_eq_iff_offsets_dvd_gateProduct
NumBridge.bt0008_resonance_lattice_maximizer_theorem
NumBridge.canonical_lattice_pattern_valid_if_D_ge
NumBridge.canonical_lattice_pattern_attains_upper_bound
NumBridge.bt0008_attainability_threshold_sufficient
NumBridge.bt0008_maximizer_family_characterization
NumBridge.bt0009_subcritical_235_k3_D59_upper_bound
NumBridge.bt0009_subcritical_235_k3_D59_equality_characterization
NumBridge.bt0009_subcritical_235_k3_D59_structural_breakthrough
NumBridge.first_subcritical_upper_bound_two_three_q
NumBridge.first_subcritical_equality_forces_six_lock_and_q_sacrifice
NumBridge.first_subcritical_six_lock_and_q_sacrifice_attains
NumBridge.bt0010_first_subcritical_sacrifice_theorem
NumBridge.two_gate_first_subcritical_upper_bound
NumBridge.two_gate_first_subcritical_equality_forces_lock_and_q_sacrifice
NumBridge.two_gate_first_subcritical_lock_and_q_sacrifice_attains
NumBridge.bt0011_two_gate_first_subcritical_sacrifice_theorem
NumBridge.prime_translate_avoids_each_gate_residue
NumBridge.prime_tuple_translate_implies_wheel_survivor
NumBridge.predicate_count_le_wheel_survivor_blocks
NumBridge.bt0012_prime_tuple_wheel_upper_bound
NumBridge.tuples_length_count
NumBridge.tuples_all_count
NumBridge.single_gate_avoided_residue_sum
NumBridge.single_gate_local_survivor_sum
NumBridge.two_gate_finite_gallagher_conservation
NumBridge.two_gate_finite_gallagher_conservation_local
NumBridge.bt0013_two_gate_finite_gallagher_resonance_conservation
```

## Honest Status

BT-0001 is proved only for the lightweight decimal `digital_root_10` function.
The full digit-sum iteration theorem for arbitrary base `b` remains engineering
work.

BT-0002 has concrete four- and six-digit base-10 mirror proofs. The full
digit-list/base-`b` theorem remains a strong target.

BT-0003 is closed for the decimal prime/digital-root case and is shallow-real:
the phenomenon reduces to divisibility by 3 and does not survive as a deeper
prime-specific pattern against the fair null model.

BT-0004 is useful / prime-structural. It proves the concrete obstruction for
`n,n+2,n+4` and a general finite-cover sieve schema. Full admissibility for
arbitrary finite prime constellations remains the next theorem layer.

BT-0005 is prime-structural / search-enabling. It adds a Python engine for
residue shadows, gate deficits, local survival factors, truncated singular
series, pattern search, and empirical prime-translate counts. The Lean layer
records concrete obstruction/survival facts, while the Hardy-Littlewood
heuristic remains explicitly outside the proof boundary.

BT-0006 is finite-sieve / CRT / proved-in-Lean. Python verifies the
exact finite-wheel product formula for arbitrary tested pairwise-coprime gate
lists. Lean now proves the local identity `survivors_p(H) = p - nu_p(H)` for
every offset list, a reusable two-modulus CRT/cardinality theorem, and exact
6-wheel and 30-wheel product formulas derived from that theorem. The full
arbitrary positive pairwise-coprime gate-list product theorem is now closed in
Lean as `NumBridge.bt0006_squarefree_wheel_shadow_distribution`. This remains a
finite-sieve distribution theorem, not an actual prime-distribution theorem.
Mathematical depth: foundational for NumBridge. Prime-distribution status:
pre-analytic finite model. Numerology status: formally true under the
finite-sieve interpretation.

BT-0007 is now closed as an exact exhaustive finite classifier for all
parameters `k`, `D`, and `P`: Lean defines the bounded candidate universe,
the finite resonance numerator, the finite argmax classifier, and proves that
classifier membership is equivalent to being a bounded candidate whose score is
globally maximal inside the finite search space. This is broad finite
classification, not a closed-form structural description of all maximizing
families and not an analytic prime-distribution claim.

BT-0008 closes the first structural maximizer theorem after BT-0007. Lean proves
that for zero-started patterns and pairwise-coprime gates greater than one, the
finite resonance numerator is bounded by `prod (p - 1)`, and equality occurs
if and only if every offset is divisible by `gateProduct gates`. Lean also
proves that the canonical lattice pattern `[0,W,2W,...,(k-1)W]` is a valid
normalized distinct upper-bound attainer whenever `(k - 1)W <= D`. The reverse
threshold/floor-family theorem remains open Lean work and is currently only
bounded-checked by Python.

BT-0009 closes the first subcritical structural theorem. For normalized
distinct three-point patterns bounded by `59` and gates `[2,3,5]`, Lean proves
the score is at most `6`, with equality if and only if all offsets are
divisible by `6` and the pattern occupies exactly two residue classes modulo
`5`. This explains the twelve Python-discovered maximizers without hardcoding
their list.

BT-0010 generalizes BT-0009 parametrically. For every `q >= 5` coprime to `6`,
Lean proves the first-subcritical `[2,3,q]` upper bound
`2 * (q - 2)` and the equality iff condition: 6-lattice lock plus exactly two
q-shadows. The direct Lean residue-count proof that `[0,6,6q]` has exactly two
q-shadows is still isolated as a small open lemma; Python verifies the
canonical attainer and finds no counterexample in the requested q range.

BT-0011 closes the requested fallback theorem for arbitrary two-gate base
spines. For `2 <= a,b,q`, `Nat.Coprime a b`, `Nat.Coprime q (a*b)`, and
`(a - 1)*(b - 1) + 1 <= q`, Lean proves the first-subcritical upper bound
`(a - 1)*(b - 1)*(q - 2)` and equality iff `AllOffsetsDivisibleBy (a*b) H`
and `LocalResidueShadowCount q H = 2`. The full arbitrary finite base-spine
theorem remains open Lean work; Python performs bounded arbitrary-base checks
and an equality-edge counterexample search.

BT-0012 pivots out of local finite-sieve optimization. The arbitrary finite
base-spine theorem remains open, but Lean now proves an elementary
actual-prime bridge: prime tuple translates above all gates must occupy
wheel-survivor residues, and any Boolean enumerator sound for those actual
prime translates is bounded by the number of wheel survivor residues times the
number of wheel blocks up to `N`. This is an actual-prime-count upper bound,
not an analytic sieve theorem.
