# Evolution Log

## 2026-05-28: Initial operating memory

Created a Markdown-led research loop:

```text
lead → interpretation → experiment → null model → conjecture → Lean target → bridge
```

## 2026-05-28: Added base-dependence rule

Digit-based claims must be tested in multiple bases unless explicitly base-specific.

## 2026-05-28: Added Lean-solvable bridge mode

The system now includes `seek-lean-bridge`, which ranks candidates by proof tractability, explanatory value, and available experiments.

## 2026-05-29: Close micro-bridges before broad digit libraries

The mirror/11 bridge now has a compiling shallow-real calibration theorem:
four-digit mirror numbers factor through 11. This confirms the symbolic
translation "mirror -> palindrome symmetry" and "gate -> divisibility" without
waiting for a full digit-list library.

Methodological update: when a bridge has a broad theorem and a narrow algebraic
instance, first close the narrow theorem in Lean, label it honestly, and then
use it as the proof seed for the general theorem. Keep local Lean calibration
proofs lightweight when dependency/cache constraints would otherwise block
verification.

## 2026-05-29: PrimeBridge shallow-real closure

The phrase "completion roots vanish from primes" now closes as a PrimeBridge
theorem: under a lightweight local prime predicate, primes greater than 3 are
not divisible by 3, have nonzero residue modulo 3, lie in residue classes
`1, 2, 4, 5, 7, 8` modulo 9, and cannot have lightweight decimal digital root
`3`, `6`, or `9`.

Methodological update: a bridge can be successful even when it kills the
mystique. This one is labeled shallow-real because the observed prime
digital-root exclusion is completely explained by divisibility by 3 and also
appears in the fair null model of odd nonmultiples of 3.

## 2026-05-29: Bridge Theorem layer

Added `bridge-theorems.md` and the first three Bridge Theorem cards. A Bridge
Theorem is now defined as a reusable theorem schema showing that a class of
numerology-like symbolic phrases corresponds to a precise mathematical
structure.

The Lean layer `NumBridge.BridgeTheorems` proves intermediate schemas for
decimal digital-root residues, prime completion-root exclusions, and six-digit
mirror divisibility. The broad base-`b` digit-list theorems remain engineering
work, but the repo now has a level above isolated calibration facts.

## 2026-05-29: First prime-structural breakthrough

Added BT-0004, "sieve gates and prime-pattern admissibility." The symbolic
phrase "prime patterns survive only when they avoid total residue collapse" now
maps to a finite-cover sieve theorem: if offsets cover all residues modulo `q`,
every translate hits a multiple of `q`.

The concrete pattern `n,n+2,n+4` is proved obstructed modulo 3, and Lean proves
that any locally prime triplet of this form must be `3,5,7`. This is classified
as useful / prime-structural: not deep, but a real move from digit-root bridges
into sieve theory.

## 2026-05-29: PrimeBridge Resonance Engine

Added a search engine for prime-pattern bridges. The system now computes residue
shadows, gate deficits, admissibility witnesses, local survival factors,
truncated singular-series scores, and empirical prime-translate counts.

Methodological update: symbolic "resonance" is now interpreted as local residue
survival. The repo can generate and rank bridge candidates instead of waiting
for hand-fed examples. This is classified as prime-structural /
search-enabling, not as a proof of prime k-tuples.

## 2026-05-29: Wheel-shadow finite-sieve distribution

Added BT-0006 and the formal branch-truth layer. Resonance now has an exact
finite-sieve interpretation: wheel survivors are counted by local residue
survival counts. Python verifies the product formula for finite wheels, while
Lean proves concrete wheel facts.

Methodological update: some numerology branches can be called formally true
only under explicit interpretations and labels such as `PROVED_IN_LEAN`,
`COMPUTED_BY_PYTHON`, `HEURISTIC`, and `NOT_PROVEN`.

## 2026-05-30: BT-0006 formalization push

The wheel-shadow theorem moved from named-pattern Lean facts to an
arbitrary-pattern product layer. Lean now proves that each local gate has
`p - nu_p(H)` survivors for every finite offset list `H`, and it proves exact
product formulas for every `H` through the squarefree wheels `6 = 2 * 3` and
`30 = 2 * 3 * 5`.

Methodological update: the next real formalization breakthrough is now sharply
isolated. Explicit finite CRT tables work for small wheels; the missing
mathematical infrastructure is a reusable CRT/cardinality theorem for arbitrary
squarefree wheels. Do not call the full BT-0006 theorem closed until that table
is replaced by a general proof.

## 2026-05-30: BT-0006 central CRT step

The explicit 6- and 30-wheel tables now have replacement proofs from a reusable
two-modulus CRT/cardinality theorem:

```text
NumBridge.crt_count_product_two_moduli
NumBridge.wheel6_residue_product_formula_via_crt
NumBridge.wheel30_residue_product_formula_via_crt
```

Methodological update: a bridge theorem can make a real project breakthrough
without closing the largest possible statement. At this point, the honest
status was: central CRT step proved in Lean, arbitrary squarefree gate-list
induction still open, finite-sieve distribution only.

## 2026-05-30: BT-0006 arbitrary gate-list induction closed

The finite-sieve product theorem is now closed in Lean for arbitrary finite
positive pairwise-coprime gate lists:

```text
NumBridge.wheel_survivor_count_product_general
NumBridge.wheel_survivor_count_product_as_shadow_sub_general
NumBridge.bt0006_squarefree_wheel_shadow_distribution
```

Methodological update: the resonance-through-gates branch has crossed from
Python-checked finite examples to a reusable Lean theorem schema. The boundary
does not move: this is exact finite-wheel candidate distribution, not an
actual-prime distribution theorem.

## 2026-05-30: BT-0007 becomes the next new-math candidate

BT-0006 is now treated as the first foundational NumBridge theorem
breakthrough: a numerological motif has been compiled into a general Lean
theorem under a precise finite-sieve interpretation.

The next theorem target is BT-0007, finite resonance optimization. The project
should now search for finite combinatorics theorems about which admissible
patterns maximize truncated wheel resonance under constraints, rather than
adding another CRT theorem or claiming Hardy-Littlewood-type results.

## 2026-05-30: BT-0007 first optimization theorem closed

Lean now proves the first exact finite resonance optimization theorem:

```text
NumBridge.bt0007_two_point_bounded_finite_resonance_optimization
```

For two-point patterns `[0,d]`, the finite resonance numerator is bounded by
the product of best local gate factors; if the diameter bound allows
`d = gateProduct gates`, that canonical gap attains the bound.

Methodological update: the post-BT-0006 path is now alive. The project has
moved from exact finite-wheel distribution to a proved finite optimization
statement, while still making no actual-prime distribution claim.

## 2026-05-30: BT-0007 broad finite classifier closed

Lean now proves the broad all-`k,D,P` exhaustive finite classification theorem:

```text
NumBridge.bt0007_all_k_D_P_finite_resonance_classification
```

For every finite cardinality parameter `k`, diameter parameter `D`, and gate
bound `P`, the generated classifier contains exactly the bounded canonical
patterns whose finite resonance numerator is globally maximal in that finite
search space.

Methodological update: this is a genuine broad finite classification, but it is
algorithmic/exhaustive rather than a closed-form structural theorem. The next
mathematical leap is to identify and prove human-readable structure in those
maximizer families.

## 2026-05-30: BT-0008 structural resonance maximizer closed

Lean now proves the first closed-form structural theorem after the BT-0007
classifier:

```text
NumBridge.bt0008_resonance_lattice_maximizer_theorem
NumBridge.resonance_upper_bound_eq_iff_offsets_dvd_gateProduct
NumBridge.bt0008_maximizer_family_characterization
```

For pairwise-coprime gates greater than one, a zero-started pattern reaches the
absolute finite resonance numerator upper bound `prod (p - 1)` if and only if
every offset is divisible by the full gate product. The canonical lattice
pattern `[0,W,2W,...,(k-1)W]` is proved valid and upper-bound-attaining when
`(k - 1)W <= D`.

Methodological update: BT-0008 is not another generated classifier. It is a
human-readable structural maximizer theorem for the absolute finite-sieve
upper bound. The exact reverse threshold/floor-family statement remains a
finite order/pigeonhole Lean target, and subcritical maximizers become the next
new theorem-hunting zone.

## 2026-05-30: BT-0009 subcritical resonance theorem closed

The first subcritical resonance case did not collapse into a hardcoded list.
Lean now proves:

```text
NumBridge.bt0009_subcritical_235_k3_D59_structural_breakthrough
```

For normalized distinct three-point patterns bounded by `59`, with gates
`[2,3,5]`, the finite resonance numerator is at most `6`. Equality holds
exactly when all offsets are divisible by `6` and the pattern occupies exactly
two residue classes modulo `5`.

Methodological update: subcritical resonance has real theorem content. The
right next step is not more enumeration, but a one-gate-sacrifice schema such
as `[2,3,q]` with `D = 2*(6q)-1`.

## 2026-05-30: BT-0010 first subcritical sacrifice theorem closed

BT-0009 now generalizes from `[2,3,5]` to `[2,3,q]`. Lean proves:

```text
NumBridge.bt0010_first_subcritical_sacrifice_theorem
```

For every `q >= 5` coprime to `6`, every normalized distinct three-point
pattern bounded by `12q - 1` has score at most `2 * (q - 2)`, with equality
exactly when the pattern is locked to the `6`-lattice and occupies exactly two
residue classes modulo `q`.

Methodological update: the subcritical direction remains alive. The next proof
polish is a reusable two-offset residue-shadow count, not another bounded
search.

## 2026-05-30: BT-0011 two-gate base-spine fallback closed

The full arbitrary finite base-spine theorem did not close in this pass, but
the requested fallback did. Lean now proves:

```text
NumBridge.bt0011_two_gate_first_subcritical_sacrifice_theorem
```

For arbitrary pairwise-coprime base gates `[a,b]`, with `q` coprime to `a*b`
and `(a - 1)*(b - 1) + 1 <= q`, every normalized distinct three-point pattern
bounded by `2*(a*b*q) - 1` has score at most
`(a - 1)*(b - 1)*(q - 2)`. Equality holds exactly when the pattern is locked
to the `a*b` lattice and occupies exactly two residue classes modulo `q`.

Methodological update: this is a real structural generalization of BT-0010,
but not the full arbitrary-base theorem. Do not label BT-0011 as fully closed
for finite base lists until the product-factor equality edge is proved by a
general induction.

## 2026-05-30: BT-0012 actual-prime wheel bridge landed

The full arbitrary finite base-spine sacrifice theorem remained blocked by the
product-factor equality edge, so the project pivoted as instructed. Lean now
proves:

```text
NumBridge.bt0012_prime_tuple_wheel_upper_bound
```

If a Boolean enumerator only accepts actual prime tuple translates above all
finite gates, its count up to `N` is bounded by the finite wheel survivor count
times `N / W + 1`, where `W = gateProduct gates`.

Methodological update: the project has crossed from finite candidate residues
to an elementary actual-prime count bound. This is still not analytic sieve
theory; the next serious theorem must be a Selberg-sieve-style upper bound or
another explicit prime-distribution estimate.
