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
without closing the largest possible statement. The honest status is now:
central CRT step proved in Lean, arbitrary squarefree gate-list induction still
open, finite-sieve distribution only.
