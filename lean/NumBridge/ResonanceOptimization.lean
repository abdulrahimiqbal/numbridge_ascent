/-
BT-0007 finite resonance optimization.

This file proves the first exact finite optimization theorem after BT-0006.
It is deliberately finite and pre-analytic: no claim is made about actual
prime distribution.
-/

import Lean.Elab.Tactic.Omega
import NumBridge.WheelProductGeneral

namespace NumBridge

/--
The two-point local resonance numerator at a gate `p`.

For a two-point pattern `[0, d]`, the occupied residue shadow modulo `p` has
size `1` when `d ≡ 0 mod p`, and otherwise has size `2`. This numerator is the
corresponding local shadow complement.
-/
def TwoPointLocalResonanceNumerator (p d : Nat) : Nat :=
  if d % p = 0 then p - 1 else p - 2

/-- Product of two-point local resonance numerators over a finite gate list. -/
def TwoPointFiniteResonanceScore (gates : List Nat) (d : Nat) : Nat :=
  gates.foldr (fun p acc => TwoPointLocalResonanceNumerator p d * acc) 1

/-- The absolute product upper bound for two-point finite resonance. -/
def TwoPointFiniteResonanceMax (gates : List Nat) : Nat :=
  gates.foldr (fun p acc => (p - 1) * acc) 1

/-- One local two-point factor is always bounded by its best value. -/
theorem two_point_local_resonance_le_max (p d : Nat) :
    TwoPointLocalResonanceNumerator p d ≤ p - 1 := by
  unfold TwoPointLocalResonanceNumerator
  by_cases h : d % p = 0
  · simp [h]
  · simp [h]
    omega

/-- The finite two-point resonance score is bounded by the product of best local factors. -/
theorem two_point_finite_resonance_score_le_max (gates : List Nat) (d : Nat) :
    TwoPointFiniteResonanceScore gates d ≤ TwoPointFiniteResonanceMax gates := by
  induction gates with
  | nil =>
      simp [TwoPointFiniteResonanceScore, TwoPointFiniteResonanceMax]
  | cons p ps ih =>
      simp [TwoPointFiniteResonanceScore, TwoPointFiniteResonanceMax]
      exact Nat.mul_le_mul (two_point_local_resonance_le_max p d) ih

/--
Any two-point gap divisible by every gate attains the product upper bound.
-/
theorem two_point_finite_resonance_score_eq_max_of_all_dvd
    (gates : List Nat) (d : Nat)
    (hall : ∀ p : Nat, p ∈ gates → d % p = 0) :
    TwoPointFiniteResonanceScore gates d = TwoPointFiniteResonanceMax gates := by
  induction gates with
  | nil =>
      simp [TwoPointFiniteResonanceScore, TwoPointFiniteResonanceMax]
  | cons p ps ih =>
      have hp : d % p = 0 := hall p (by simp)
      have hps : ∀ q : Nat, q ∈ ps → d % q = 0 := by
        intro q hq
        exact hall q (by simp [hq])
      change
        TwoPointLocalResonanceNumerator p d * TwoPointFiniteResonanceScore ps d =
          (p - 1) * TwoPointFiniteResonanceMax ps
      rw [show TwoPointLocalResonanceNumerator p d = p - 1 by
        simp [TwoPointLocalResonanceNumerator, hp], ih hps]

/--
The product of the gates is a canonical two-point gap attaining the finite
resonance upper bound.
-/
theorem two_point_gateProduct_attains_resonance_max (gates : List Nat) :
    TwoPointFiniteResonanceScore gates (gateProduct gates) =
      TwoPointFiniteResonanceMax gates := by
  apply two_point_finite_resonance_score_eq_max_of_all_dvd
  intro p hp
  exact Nat.mod_eq_zero_of_dvd (dvd_gateProduct_of_mem hp)

/--
BT-0007: first finite resonance optimization theorem.

If the diameter bound `D` is at least the gate product, then among all two-point
patterns `[0, d]` with `d ≤ D`, the canonical gap `d = gateProduct gates`
attains the absolute finite-resonance upper bound.
-/
theorem bt0007_two_point_bounded_finite_resonance_optimization
    (gates : List Nat) (D : Nat) (hD : gateProduct gates ≤ D) :
    ∃ d : Nat,
      d ≤ D ∧
      TwoPointFiniteResonanceScore gates d = TwoPointFiniteResonanceMax gates ∧
      ∀ e : Nat, e ≤ D →
        TwoPointFiniteResonanceScore gates e ≤ TwoPointFiniteResonanceMax gates := by
  refine ⟨gateProduct gates, hD, ?_, ?_⟩
  · exact two_point_gateProduct_attains_resonance_max gates
  · intro e _
    exact two_point_finite_resonance_score_le_max gates e

/-- General finite resonance numerator used for finite optimization. -/
def FiniteResonanceNumerator (gates offsets : List Nat) : Nat :=
  ProductLocalGateSurvivorCount gates offsets

/-- All length-`k` offset lists whose entries lie in `0..D`. -/
def BoundedOffsetLists : Nat → Nat → List (List Nat)
  | 0, _ => [[]]
  | Nat.succ k, D =>
      (List.range (D + 1)).flatMap
        (fun h => (BoundedOffsetLists k D).map (fun tail => h :: tail))

/-- A canonical bounded pattern starts at zero. -/
def StartsAtZero : List Nat → Bool
  | [] => true
  | h :: _ => h == 0

/-- Canonical bounded `k`-patterns with diameter parameter `D`. -/
def BoundedCandidatePatterns (k D : Nat) : List (List Nat) :=
  (BoundedOffsetLists k D).filter StartsAtZero

/-- Modulus gates `2, 3, ..., P`; this is a finite gate-bound model. -/
def GateModuliUpTo (P : Nat) : List Nat :=
  (List.range (P + 1)).filter (fun p => 2 ≤ p)

/-- Maximum finite resonance numerator over a candidate list. -/
def FiniteResonanceMaxScore (gates : List Nat) (candidates : List (List Nat)) : Nat :=
  candidates.foldr
    (fun offsets acc => max (FiniteResonanceNumerator gates offsets) acc) 0

/-- Finite argmax classifier for resonance numerators over an explicit candidate universe. -/
def FiniteResonanceMaximizers (gates : List Nat) (candidates : List (List Nat)) :
    List (List Nat) :=
  candidates.filter
    (fun offsets =>
      FiniteResonanceNumerator gates offsets == FiniteResonanceMaxScore gates candidates)

/-- BT-0007 classifier for all finite `k`, `D`, and gate-bound `P`. -/
def BT0007FiniteResonanceClassifiers (k D P : Nat) : List (List Nat) :=
  FiniteResonanceMaximizers (GateModuliUpTo P) (BoundedCandidatePatterns k D)

/-- Any candidate score is bounded by the explicit finite maximum score. -/
theorem finite_resonance_score_le_maxScore_of_mem
    (gates : List Nat) (candidates : List (List Nat)) {offsets : List Nat}
    (hmem : offsets ∈ candidates) :
    FiniteResonanceNumerator gates offsets ≤
      FiniteResonanceMaxScore gates candidates := by
  induction candidates with
  | nil =>
      cases hmem
  | cons head tail ih =>
      unfold FiniteResonanceMaxScore
      simp at hmem
      rcases hmem with hEq | htail
      · subst offsets
        exact Nat.le_max_left _ _
      · exact Nat.le_trans (ih htail) (Nat.le_max_right _ _)

/-- If every candidate score is below `B`, then the explicit maximum is below `B`. -/
theorem finite_resonance_maxScore_le_of_all_le
    (gates : List Nat) (candidates : List (List Nat)) (B : Nat)
    (hall : ∀ offsets : List Nat, offsets ∈ candidates →
      FiniteResonanceNumerator gates offsets ≤ B) :
    FiniteResonanceMaxScore gates candidates ≤ B := by
  induction candidates with
  | nil =>
      simp [FiniteResonanceMaxScore]
  | cons head tail ih =>
      unfold FiniteResonanceMaxScore
      exact Nat.max_le.mpr
        ⟨hall head (by simp), ih (by
          intro offsets hmem
          exact hall offsets (by simp [hmem]))⟩

/--
Exact finite argmax classification theorem.

Membership in the generated classifier is equivalent to being a candidate and
having score at least every candidate score.
-/
theorem finite_resonance_maximizers_classify
    (gates : List Nat) (candidates : List (List Nat)) (offsets : List Nat) :
    offsets ∈ FiniteResonanceMaximizers gates candidates ↔
      offsets ∈ candidates ∧
        ∀ other : List Nat, other ∈ candidates →
          FiniteResonanceNumerator gates other ≤
            FiniteResonanceNumerator gates offsets := by
  unfold FiniteResonanceMaximizers
  constructor
  · intro h
    have hparts := List.mem_filter.mp h
    constructor
    · exact hparts.left
    · intro other hother
      have hEq :
          FiniteResonanceNumerator gates offsets =
            FiniteResonanceMaxScore gates candidates :=
        beq_iff_eq.mp hparts.right
      rw [hEq]
      exact finite_resonance_score_le_maxScore_of_mem gates candidates hother
  · intro h
    have hle_max :=
      finite_resonance_score_le_maxScore_of_mem gates candidates h.left
    have hmax_le :
        FiniteResonanceMaxScore gates candidates ≤
          FiniteResonanceNumerator gates offsets :=
      finite_resonance_maxScore_le_of_all_le gates candidates
        (FiniteResonanceNumerator gates offsets) h.right
    have hEq :
        FiniteResonanceNumerator gates offsets =
          FiniteResonanceMaxScore gates candidates :=
      Nat.le_antisymm hle_max hmax_le
    exact List.mem_filter.mpr ⟨h.left, beq_iff_eq.mpr hEq⟩

/--
BT-0007 broad all-`k,D,P` finite classification theorem.

For every cardinality parameter `k`, diameter bound `D`, and finite gate bound
`P`, the generated classifier contains exactly the bounded canonical patterns
whose finite resonance numerator is globally maximal inside that finite search
space.
-/
theorem bt0007_all_k_D_P_finite_resonance_classification
    (k D P : Nat) (offsets : List Nat) :
    offsets ∈ BT0007FiniteResonanceClassifiers k D P ↔
      offsets ∈ BoundedCandidatePatterns k D ∧
        ∀ other : List Nat, other ∈ BoundedCandidatePatterns k D →
          FiniteResonanceNumerator (GateModuliUpTo P) other ≤
            FiniteResonanceNumerator (GateModuliUpTo P) offsets := by
  unfold BT0007FiniteResonanceClassifiers
  exact finite_resonance_maximizers_classify
    (GateModuliUpTo P) (BoundedCandidatePatterns k D) offsets

end NumBridge
