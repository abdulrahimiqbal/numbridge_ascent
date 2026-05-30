/-
General CRT/cardinality layer for BT-0006.

This file proves the reusable two-modulus counting theorem that the earlier
6- and 30-wheel Boolean tables were standing in for. It is still
standard-library-only: no Mathlib and no unsafe proof placeholders.
-/

import Init.Data.List.Perm
import Init.Data.List.Erase
import Init.Data.List.Nat.Range
import Init.Data.List.Count
import Init.Data.Nat.Lemmas
import Lean.Elab.Tactic.Omega
import NumBridge.WheelProduct

namespace NumBridge

open List

/-- Product of a finite list of natural-number gates. -/
def gateProduct (gates : List Nat) : Nat :=
  gates.foldr (fun a b => a * b) 1

/-- A lightweight positivity predicate for gate lists. -/
def PositiveGates (gates : List Nat) : Prop :=
  ∀ p : Nat, p ∈ gates → 0 < p

/-- A lightweight pairwise-coprime predicate for gate lists. -/
def PairwiseCoprime (gates : List Nat) : Prop :=
  gates.Pairwise Nat.Coprime

/-- General wheel-survivor count over the product of all gates. -/
def WheelSurvivorCountGeneral (gates offsets : List Nat) : Nat :=
  (List.range (gateProduct gates)).countP
    (fun a => gates.all (fun p => GateGoodResidue p offsets (a % p)))

/-- If two nodup lists have equal length and one is contained in the other, they are permutations. -/
theorem nodup_subset_length_perm {α : Type} [BEq α] [LawfulBEq α]
    {l u : List α} (hndl : l.Nodup) (hndu : u.Nodup)
    (hsub : l ⊆ u) (hlen : l.length = u.length) : l ~ u := by
  induction l generalizing u with
  | nil =>
      have hu0 : u.length = 0 := by simpa using hlen.symm
      have hu : u = [] := List.eq_nil_of_length_eq_zero hu0
      subst u
      exact List.Perm.nil
  | cons a t ih =>
      have hparts := List.nodup_cons.mp hndl
      have hnot : a ∉ t := hparts.left
      have hndt : t.Nodup := hparts.right
      have hau : a ∈ u := hsub (by simp)
      have hndErase : (u.erase a).Nodup := hndu.erase a
      have hsubt : t ⊆ u.erase a := by
        intro x hx
        have xinu : x ∈ u := hsub (by simp [hx])
        have xnea : x ≠ a := by
          intro hxa
          subst x
          exact hnot hx
        exact (List.Nodup.mem_erase_iff hndu).mpr ⟨xnea, xinu⟩
      have hlent : t.length = (u.erase a).length := by
        rw [List.length_erase_of_mem hau]
        simp at hlen
        omega
      have hp : t ~ u.erase a := ih hndt hndErase hsubt hlent
      exact (hp.cons a).trans (List.perm_cons_erase hau).symm

/-- Remainders inside a quotient block reduce to the block offset. -/
theorem add_mul_mod_left_eq {M x k : Nat} (hx : x < M) :
    (x + M * k) % M = x := by
  rw [Nat.add_mod]
  have hmul : (M * k) % M = 0 := by
    exact Nat.mod_eq_zero_of_dvd (Nat.dvd_mul_right M k)
  rw [hmul]
  simpa using Nat.mod_eq_of_lt hx

/-- Uniqueness of the quotient/remainder representation `x + M*k` with `x < M`. -/
theorem pair_representation_inj
    {M x1 x2 k1 k2 : Nat} (hM : 0 < M)
    (hx1 : x1 < M) (hx2 : x2 < M)
    (heq : x1 + M * k1 = x2 + M * k2) : x1 = x2 ∧ k1 = k2 := by
  have hx : x1 = x2 := by
    have hmod : (x1 + M * k1) % M = (x2 + M * k2) % M := by rw [heq]
    rw [add_mul_mod_left_eq hx1, add_mul_mod_left_eq hx2] at hmod
    exact hmod
  subst x2
  have hk : M * k1 = M * k2 := by
    exact Nat.add_left_cancel heq
  have hk' : k1 = k2 := Nat.mul_left_cancel hM hk
  exact ⟨rfl, hk'⟩

/-- Quotient/remainder enumeration of residues modulo `M*p`, grouped by remainder modulo `M`. -/
def PairResidues (M p : Nat) : List Nat :=
  (List.range M).flatMap (fun x => (List.range p).map (fun k => x + M * k))

/-- The quotient/remainder enumeration has no duplicates. -/
theorem pair_residues_nodup {M p : Nat} (hM : 0 < M) :
    (PairResidues M p).Nodup := by
  unfold PairResidues
  rw [List.nodup_iff_pairwise_ne]
  rw [List.pairwise_flatMap]
  constructor
  · intro x hx
    have hxlt : x < M := List.mem_range.mp hx
    have hPairRange : (List.range p).Pairwise (fun a b => a ≠ b) :=
      List.nodup_iff_pairwise_ne.mp List.nodup_range
    have hPairOrig : (List.range p).Pairwise (fun k1 k2 => x + M * k1 ≠ x + M * k2) := by
      exact hPairRange.imp_of_mem (fun _ _ hne heq => by
        have hpair := pair_representation_inj hM hxlt hxlt heq
        exact hne hpair.right)
    exact List.Pairwise.map (fun k => x + M * k) (fun _ _ h => h) hPairOrig
  · have hPairRange : (List.range M).Pairwise (fun a b => a ≠ b) :=
      List.nodup_iff_pairwise_ne.mp List.nodup_range
    exact hPairRange.imp_of_mem (fun hx1 hx2 hne y hy z hz heq => by
      rcases List.mem_map.mp hy with ⟨k1, _, rfl⟩
      rcases List.mem_map.mp hz with ⟨k2, _, rfl⟩
      have hx1lt : _ := List.mem_range.mp hx1
      have hx2lt : _ := List.mem_range.mp hx2
      have hpair := pair_representation_inj hM hx1lt hx2lt heq
      exact hne hpair.left)

/-- Sum of a constant over `range n`. -/
theorem sum_const_range (n c : Nat) :
    ((List.range n).map (fun _ => c)).sum = n * c := by
  induction n with
  | zero => simp
  | succ n ih =>
      rw [List.range_succ, List.map_append, List.sum_append]
      simp [ih, Nat.succ_mul, Nat.add_comm]

/-- The quotient/remainder enumeration has the expected length. -/
theorem pair_residues_length (M p : Nat) :
    (PairResidues M p).length = M * p := by
  unfold PairResidues
  rw [List.length_flatMap]
  have hmap :
      (List.map (fun a => (List.map (fun k => a + M * k) (List.range p)).length)
        (List.range M)) =
      (List.range M).map (fun _ => p) := by
    apply List.map_inj_left.mpr
    intro a ha
    simp
  rw [hmap, sum_const_range]

/-- Every quotient/remainder entry lies in `range (M*p)`. -/
theorem pair_residues_subset_range {M p : Nat} :
    PairResidues M p ⊆ List.range (M * p) := by
  unfold PairResidues
  intro y hy
  rcases List.mem_flatMap.mp hy with ⟨x, hx, hyx⟩
  rcases List.mem_map.mp hyx with ⟨k, hk, rfl⟩
  have hxlt : x < M := List.mem_range.mp hx
  have hklt : k < p := List.mem_range.mp hk
  apply List.mem_range.mpr
  have hk1 : k + 1 ≤ p := by omega
  calc
    x + M * k < M + M * k := Nat.add_lt_add_right hxlt (M * k)
    _ = M * (k + 1) := by rw [Nat.mul_succ, Nat.add_comm]
    _ ≤ M * p := Nat.mul_le_mul_left M hk1

/-- Quotient/remainder enumeration is a permutation of the ordinary residue range. -/
theorem pair_residues_perm_range {M p : Nat} (hM : 0 < M) :
    PairResidues M p ~ List.range (M * p) :=
  nodup_subset_length_perm (pair_residues_nodup (M := M) (p := p) hM)
    List.nodup_range pair_residues_subset_range (by rw [pair_residues_length, List.length_range])

/-- Multiplication by a coprime modulus permutes residues modulo `p`, even after translation. -/
theorem residue_affine_inj
    {M p x k1 k2 : Nat} (hp : 0 < p) (hcop : Nat.Coprime M p)
    (hk1 : k1 < p) (hk2 : k2 < p)
    (heq : (x + M * k1) % p = (x + M * k2) % p) :
    k1 = k2 := by
  rcases (Nat.mod_eq_mod_iff.mp heq) with ⟨a, b, h⟩
  have hcancel : M * k1 + a * p = M * k2 + b * p := by
    rw [Nat.add_assoc, Nat.add_assoc] at h
    exact Nat.add_left_cancel h
  by_cases hle : k1 ≤ k2
  · have hbale : b ≤ a := by
      have hmk : M * k1 ≤ M * k2 := Nat.mul_le_mul_left M hle
      have hbpap : b * p ≤ a * p := by omega
      exact Nat.le_of_mul_le_mul_right hbpap hp
    have hEq : M * (k2 - k1) = (a - b) * p := by
      have hmk : M * k1 ≤ M * k2 := Nat.mul_le_mul_left M hle
      have hbp : b * p ≤ a * p := Nat.mul_le_mul_right p hbale
      rw [Nat.mul_sub_left_distrib, Nat.mul_sub_right_distrib]
      omega
    have hdivmul : p ∣ M * (k2 - k1) := by
      rw [hEq]
      exact Nat.dvd_mul_left p (a - b)
    have hdiv : p ∣ k2 - k1 :=
      (hcop.symm).dvd_of_dvd_mul_left hdivmul
    have hlt : k2 - k1 < p := by omega
    have hzero : k2 - k1 = 0 := Nat.eq_zero_of_dvd_of_lt hdiv hlt
    omega
  · have hle' : k2 ≤ k1 := by omega
    have hable : a ≤ b := by
      have hmk : M * k2 ≤ M * k1 := Nat.mul_le_mul_left M hle'
      have hapbp : a * p ≤ b * p := by omega
      exact Nat.le_of_mul_le_mul_right hapbp hp
    have hEq : M * (k1 - k2) = (b - a) * p := by
      have hmk : M * k2 ≤ M * k1 := Nat.mul_le_mul_left M hle'
      have hap : a * p ≤ b * p := Nat.mul_le_mul_right p hable
      rw [Nat.mul_sub_left_distrib, Nat.mul_sub_right_distrib]
      omega
    have hdivmul : p ∣ M * (k1 - k2) := by
      rw [hEq]
      exact Nat.dvd_mul_left p (b - a)
    have hdiv : p ∣ k1 - k2 :=
      (hcop.symm).dvd_of_dvd_mul_left hdivmul
    have hlt : k1 - k2 < p := by omega
    have hzero : k1 - k2 = 0 := Nat.eq_zero_of_dvd_of_lt hdiv hlt
    omega

/-- Affine coprime residue maps are permutations of `range p`. -/
theorem affine_residue_perm_range
    {M p x : Nat} (hp : 0 < p) (hcop : Nat.Coprime M p) :
    (List.range p).map (fun k => (x + M * k) % p) ~ List.range p := by
  let f := fun k => (x + M * k) % p
  have hPairRange : (List.range p).Pairwise (fun a b => a ≠ b) :=
    List.nodup_iff_pairwise_ne.mp List.nodup_range
  have hPairOrig : (List.range p).Pairwise (fun a b => f a ≠ f b) := by
    exact hPairRange.imp_of_mem (fun ha hb hne heq => by
      have ha_lt : _ := List.mem_range.mp ha
      have hb_lt : _ := List.mem_range.mp hb
      exact hne (residue_affine_inj hp hcop ha_lt hb_lt heq))
  have hPairMap : ((List.range p).map f).Pairwise (fun a b => a ≠ b) :=
    List.Pairwise.map f (fun _ _ h => h) hPairOrig
  have hndMap : ((List.range p).map f).Nodup :=
    List.nodup_iff_pairwise_ne.mpr hPairMap
  have hsub : ((List.range p).map f) ⊆ List.range p := by
    intro y hy
    rcases List.mem_map.mp hy with ⟨k, _, rfl⟩
    exact List.mem_range.mpr (Nat.mod_lt _ hp)
  have hlen : ((List.range p).map f).length = (List.range p).length := by simp
  exact nodup_subset_length_perm hndMap List.nodup_range hsub hlen

/-- Counting is invariant under affine coprime residue permutations. -/
theorem affine_residue_count_eq
    {M p x : Nat} (hp : 0 < p) (hcop : Nat.Coprime M p) (P : Nat → Bool) :
    (List.range p).countP (fun k => P ((x + M * k) % p)) =
      (List.range p).countP P := by
  let f := fun k => (x + M * k) % p
  have hpperm := affine_residue_perm_range (M := M) (p := p) (x := x) hp hcop
  have hmap : (List.range p).countP (fun k => P (f k)) = ((List.range p).map f).countP P := by
    rw [List.countP_map]
    simp [Function.comp_def]
  rw [hmap]
  exact hpperm.countP_eq P

/-- Count over a flat map as a sum of block counts. -/
theorem countP_flatMap_eq_sum {α β : Type} (l : List α) (f : α → List β) (P : β → Bool) :
    (l.flatMap f).countP P = (l.map (fun a => (f a).countP P)).sum := by
  induction l with
  | nil => rfl
  | cons a t ih =>
      simp [List.flatMap, List.countP_append, Function.comp_def]

/-- Count one quotient/remainder block after applying local predicates. -/
theorem block_count_eq
    {M p x : Nat} (hp : 0 < p) (hcop : Nat.Coprime M p) (hx : x < M)
    (PM Pp : Nat → Bool) :
    ((List.range p).map (fun k => x + M * k)).countP
        (fun a => PM (a % M) && Pp (a % p)) =
      if PM x then (List.range p).countP Pp else 0 := by
  rw [List.countP_map]
  simp [Function.comp_def, add_mul_mod_left_eq hx]
  by_cases hpm : PM x
  · simp [hpm, affine_residue_count_eq hp hcop Pp]
  · simp [hpm]

/-- Sum an indicator times a constant. -/
theorem sum_if_eq_countP_mul {α : Type} (l : List α) (P : α → Bool) (C : Nat) :
    (l.map (fun x => if P x then C else 0)).sum = l.countP P * C := by
  induction l with
  | nil => simp
  | cons a t ih =>
      by_cases h : P a
      · simp [h, ih, Nat.add_mul, Nat.add_comm]
      · simp [h, ih]

/--
Central two-modulus CRT/cardinality theorem.

For coprime positive moduli `M` and `p`, arbitrary Boolean local predicates
factor exactly across the wheel `M*p`.
-/
theorem crt_count_product_two_moduli
    {M p : Nat} (hM : 0 < M) (hp : 0 < p) (hcop : Nat.Coprime M p)
    (PM Pp : Nat → Bool) :
    (List.range (M * p)).countP (fun a => PM (a % M) && Pp (a % p)) =
      (List.range M).countP PM * (List.range p).countP Pp := by
  have hperm := pair_residues_perm_range (M := M) (p := p) hM
  let Q := fun a => PM (a % M) && Pp (a % p)
  have hcountPerm : (List.range (M * p)).countP Q = (PairResidues M p).countP Q := by
    exact (hperm.countP_eq Q).symm
  rw [hcountPerm]
  unfold PairResidues
  rw [countP_flatMap_eq_sum]
  have hblocks :
      (List.map (fun a => List.countP Q (List.map (fun k => a + M * k) (List.range p))) (List.range M)) =
      (List.range M).map (fun x => if PM x then (List.range p).countP Pp else 0) := by
    apply List.map_inj_left.mpr
    intro x hx
    have hxlt : x < M := List.mem_range.mp hx
    exact block_count_eq hp hcop hxlt PM Pp
  rw [hblocks]
  exact sum_if_eq_countP_mul (List.range M) PM ((List.range p).countP Pp)

/-- Named wheel-product step: the reusable CRT count factorization. -/
theorem wheel_product_step
    {M p : Nat} (hM : 0 < M) (hp : 0 < p) (hcop : Nat.Coprime M p)
    (PM Pp : Nat → Bool) :
    (List.range (M * p)).countP (fun a => PM (a % M) && Pp (a % p)) =
      (List.range M).countP PM * (List.range p).countP Pp :=
  crt_count_product_two_moduli hM hp hcop PM Pp

/-- The 6-wheel product formula, now proved by the general two-modulus CRT theorem. -/
theorem wheel6_residue_product_formula_via_crt (offsets : List Nat) :
    Wheel6ResidueSurvivorCount offsets =
      LocalGateSurvivorCount 2 offsets * LocalGateSurvivorCount 3 offsets := by
  unfold Wheel6ResidueSurvivorCount LocalGateSurvivorCount
  simpa using crt_count_product_two_moduli (M := 2) (p := 3)
    (by decide) (by decide) (by decide : Nat.Coprime 2 3)
    (GateGoodResidue 2 offsets) (GateGoodResidue 3 offsets)

/-- The 30-wheel product formula, now composed from two applications of the CRT step. -/
theorem wheel30_residue_product_formula_via_crt (offsets : List Nat) :
    Wheel30ResidueSurvivorCount offsets =
      LocalGateSurvivorCount 2 offsets * LocalGateSurvivorCount 3 offsets *
        LocalGateSurvivorCount 5 offsets := by
  unfold Wheel30ResidueSurvivorCount
  let PM := fun r => GateGoodResidue 2 offsets (r % 2) && GateGoodResidue 3 offsets (r % 3)
  have hstep := crt_count_product_two_moduli (M := 6) (p := 5)
    (by decide) (by decide) (by decide : Nat.Coprime 6 5)
    PM (GateGoodResidue 5 offsets)
  have h6 : (List.range 6).countP PM =
      LocalGateSurvivorCount 2 offsets * LocalGateSurvivorCount 3 offsets := by
    unfold PM LocalGateSurvivorCount
    simpa using crt_count_product_two_moduli (M := 2) (p := 3)
      (by decide) (by decide) (by decide : Nat.Coprime 2 3)
      (GateGoodResidue 2 offsets) (GateGoodResidue 3 offsets)
  unfold LocalGateSurvivorCount
  simpa [PM, Nat.mod_mod_of_dvd, h6, Nat.mul_assoc] using hstep

/-- BT-0006 closed for two coprime gates, the reusable step toward the full induction. -/
theorem bt0006_two_moduli_wheel_shadow_distribution
    {M p : Nat} (hM : 0 < M) (hp : 0 < p) (hcop : Nat.Coprime M p)
    (offsets : List Nat) :
    (List.range (M * p)).countP
        (fun a => GateGoodResidue M offsets (a % M) && GateGoodResidue p offsets (a % p)) =
      LocalGateSurvivorCount M offsets * LocalGateSurvivorCount p offsets := by
  unfold LocalGateSurvivorCount
  exact crt_count_product_two_moduli hM hp hcop
    (GateGoodResidue M offsets) (GateGoodResidue p offsets)

/-- The two-gate BT-0006 theorem in `p - nu_p(H)` form. -/
theorem bt0006_two_moduli_wheel_shadow_distribution_as_shadow_sub
    {M p : Nat} (hM : 0 < M) (hp : 0 < p) (hcop : Nat.Coprime M p)
    (offsets : List Nat) :
    (List.range (M * p)).countP
        (fun a => GateGoodResidue M offsets (a % M) && GateGoodResidue p offsets (a % p)) =
      (M - LocalResidueShadowCount M offsets) *
        (p - LocalResidueShadowCount p offsets) := by
  rw [bt0006_two_moduli_wheel_shadow_distribution hM hp hcop offsets,
    local_gate_survivor_count_eq_modulus_sub_shadow,
    local_gate_survivor_count_eq_modulus_sub_shadow]

end NumBridge
