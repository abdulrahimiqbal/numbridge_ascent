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
| BT-0006 | Wheel-shadow distribution theorem | resonance and survival through prime gates | exact finite-wheel survivor counts factor into local survival counts | full arbitrary positive pairwise-coprime gate-list theorem proved | finite-sieve / CRT / proved-in-Lean |

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
