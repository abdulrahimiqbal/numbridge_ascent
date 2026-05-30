/-
BT-0009 subcritical finite-resonance theorem.

This file treats the first subcritical case after BT-0008:

  gates = [2, 3, 5], W = 30, k = 3, D = 59 = 2W - 1.

The result is structural, not an enumeration of the twelve maximizing lists.
The best subcritical patterns stay locked through the 2- and 3-gates and
occupy exactly two residues modulo 5.
-/

import Lean.Elab.Tactic.Omega
import NumBridge.ResonanceLatticeMaximizer

namespace NumBridge

/-- Normalized distinct three-point patterns with offsets bounded by 59. -/
def Pattern235Subcritical (H : List Nat) : Prop :=
  NormalizedDistinctPattern 3 59 H

/-- The pattern is locked to the 2- and 3-gates. -/
def AllOffsetsDivisibleBy6 (H : List Nat) : Prop :=
  AllOffsetsDivisibleBy 6 H

/-- The pattern occupies exactly two residue classes modulo 5. -/
def OccupiesExactlyTwoResiduesMod5 (H : List Nat) : Prop :=
  LocalResidueShadowCount 5 H = 2

/-- The BT-0009 finite resonance score. -/
def Subcritical235Score (H : List Nat) : Nat :=
  FiniteResonanceNumerator [2, 3, 5] H

/-- A subcritical normalized pattern contains the zero offset. -/
theorem subcritical235_mem_zero {H : List Nat} (hpat : Pattern235Subcritical H) :
    0 ∈ H :=
  startsAtZero_mem_zero hpat.left

/-- Divisibility by 6 from simultaneous zero residues modulo 2 and 3. -/
theorem dvd_six_of_mod_two_three_zero {h : Nat}
    (h2 : h % 2 = 0) (h3 : h % 3 = 0) :
    6 ∣ h := by
  have hdvd2 : 2 ∣ h := Nat.dvd_of_mod_eq_zero h2
  have hdvd3 : 3 ∣ h := Nat.dvd_of_mod_eq_zero h3
  have hcop : Nat.Coprime 2 3 := by decide
  have hprod : 2 * 3 ∣ h := hcop.mul_dvd_of_dvd_of_dvd hdvd2 hdvd3
  simpa using hprod

/-- Local maxima at gates 2 and 3 force every offset onto the 6-lattice. -/
theorem all_offsets_divisible_by6_of_local_two_three_max {H : List Nat}
    (hzero : 0 ∈ H)
    (h2 : LocalGateSurvivorCount 2 H = 1)
    (h3 : LocalGateSurvivorCount 3 H = 2) :
    AllOffsetsDivisibleBy6 H := by
  have hall2 : ∀ h : Nat, h ∈ H → h % 2 = 0 :=
    (local_survivor_count_eq_p_minus_one_iff_all_mod_zero 2 H (by decide) hzero).mp
      (by simpa using h2)
  have hall3 : ∀ h : Nat, h ∈ H → h % 3 = 0 :=
    (local_survivor_count_eq_p_minus_one_iff_all_mod_zero 3 H (by decide) hzero).mp
      (by simpa using h3)
  intro h hh
  exact dvd_six_of_mod_two_three_zero (hall2 h hh) (hall3 h hh)

/-- Divisibility by 6 gives zero residues modulo 2 and 3. -/
theorem mod_two_three_zero_of_dvd_six {h : Nat} (hh : 6 ∣ h) :
    h % 2 = 0 ∧ h % 3 = 0 := by
  constructor
  · exact Nat.mod_eq_zero_of_dvd (Nat.dvd_trans (by decide : 2 ∣ 6) hh)
  · exact Nat.mod_eq_zero_of_dvd (Nat.dvd_trans (by decide : 3 ∣ 6) hh)

/-- The 2-gate has its best local value for any 6-lattice pattern. -/
theorem local_two_eq_one_of_all_offsets_divisible_by6 {H : List Nat}
    (hzero : 0 ∈ H) (hdiv6 : AllOffsetsDivisibleBy6 H) :
    LocalGateSurvivorCount 2 H = 1 := by
  apply local_survivor_count_eq_p_minus_one_of_all_mod_zero 2 H (by decide) hzero
  intro h hh
  exact (mod_two_three_zero_of_dvd_six (hdiv6 h hh)).left

/-- The 3-gate has its best local value for any 6-lattice pattern. -/
theorem local_three_eq_two_of_all_offsets_divisible_by6 {H : List Nat}
    (hzero : 0 ∈ H) (hdiv6 : AllOffsetsDivisibleBy6 H) :
    LocalGateSurvivorCount 3 H = 2 := by
  apply local_survivor_count_eq_p_minus_one_of_all_mod_zero 3 H (by decide) hzero
  intro h hh
  exact (mod_two_three_zero_of_dvd_six (hdiv6 h hh)).right

/--
Three distinct normalized offsets bounded by 59 cannot all be multiples of 30.

This is the subcritical obstruction: `[0, 30, 60]` would be the first
three-point full-lattice pattern, but `60` lies outside the diameter.
-/
theorem no_subcritical_pattern_all_offsets_divisible_by30 {H : List Nat}
    (hpat : Pattern235Subcritical H) :
    ¬ AllOffsetsDivisibleBy 30 H := by
  intro hall30
  rcases hpat with ⟨hstart, hlen, hnodup, hbound⟩
  cases H with
  | nil =>
      cases hstart
  | cons a t =>
      cases t with
      | nil =>
          simp at hlen
      | cons b t2 =>
          cases t2 with
          | nil =>
              simp at hlen
          | cons c t3 =>
              cases t3 with
              | nil =>
                  simp [StartsAtZeroProp] at hstart
                  subst a
                  have hb_le : b ≤ 59 := hbound b (by simp)
                  have hc_le : c ≤ 59 := hbound c (by simp)
                  have hb_dvd : 30 ∣ b := hall30 b (by simp)
                  have hc_dvd : 30 ∣ c := hall30 c (by simp)
                  have hb_cases : b = 0 ∨ b = 30 := by
                    rcases hb_dvd with ⟨m, hm⟩
                    omega
                  have hc_cases : c = 0 ∨ c = 30 := by
                    rcases hc_dvd with ⟨m, hm⟩
                    omega
                  simp at hnodup
                  rcases hb_cases with hb0 | hb30
                  · exact hnodup.left.left hb0.symm
                  · rcases hc_cases with hc0 | hc30
                    · exact hnodup.left.right hc0.symm
                    · subst b
                      subst c
                      exact hnodup.right rfl
              | cons d t4 =>
                  simp at hlen

/-- In the subcritical window, a 6-lattice pattern must occupy at least two mod-5 residues. -/
theorem local_shadow5_ge_two_of_all_divisible_by6_subcritical {H : List Nat}
    (hpat : Pattern235Subcritical H) (hdiv6 : AllOffsetsDivisibleBy6 H) :
    2 ≤ LocalResidueShadowCount 5 H := by
  have hzero : 0 ∈ H := subcritical235_mem_zero hpat
  have hge1 : 1 ≤ LocalResidueShadowCount 5 H :=
    nonempty_shadow_count_ge_one 5 H (by decide) hzero
  by_cases hshadow1 : LocalResidueShadowCount 5 H = 1
  · have hle5 : LocalResidueShadowCount 5 H ≤ 5 := local_shadow_count_le_p 5 H
    have hsurv5 : LocalGateSurvivorCount 5 H = 4 := by
      rw [local_gate_survivor_count_eq_modulus_sub_shadow]
      omega
    have hall5 : ∀ h : Nat, h ∈ H → h % 5 = 0 :=
      (local_survivor_count_eq_p_minus_one_iff_all_mod_zero 5 H (by decide) hzero).mp
        (by simpa using hsurv5)
    have hall30 : AllOffsetsDivisibleBy 30 H := by
      intro h hh
      have h6 : 6 ∣ h := hdiv6 h hh
      have h5 : 5 ∣ h := Nat.dvd_of_mod_eq_zero (hall5 h hh)
      have hcop : Nat.Coprime 6 5 := by decide
      have h30 : 6 * 5 ∣ h := hcop.mul_dvd_of_dvd_of_dvd h6 h5
      simpa using h30
    exact False.elim (no_subcritical_pattern_all_offsets_divisible_by30 hpat hall30)
  · omega

/-- A subcritical 6-lattice pattern has at most three local survivors modulo 5. -/
theorem local_five_le_three_of_all_divisible_by6_subcritical {H : List Nat}
    (hpat : Pattern235Subcritical H) (hdiv6 : AllOffsetsDivisibleBy6 H) :
    LocalGateSurvivorCount 5 H ≤ 3 := by
  rw [local_gate_survivor_count_eq_modulus_sub_shadow]
  have hge2 := local_shadow5_ge_two_of_all_divisible_by6_subcritical hpat hdiv6
  have hle5 := local_shadow_count_le_p 5 H
  omega

/-- If the pattern is not locked to the 6-lattice, its score is at most 4. -/
theorem subcritical235_score_le_four_of_not_all_divisible_by6 {H : List Nat}
    (hpat : Pattern235Subcritical H) (hnot : ¬ AllOffsetsDivisibleBy6 H) :
    Subcritical235Score H ≤ 4 := by
  have hzero : 0 ∈ H := subcritical235_mem_zero hpat
  have h2le : LocalGateSurvivorCount 2 H ≤ 1 :=
    local_survivor_count_le_p_minus_one 2 H (by decide) hzero
  have h3le : LocalGateSurvivorCount 3 H ≤ 2 :=
    local_survivor_count_le_p_minus_one 3 H (by decide) hzero
  have h5le : LocalGateSurvivorCount 5 H ≤ 4 :=
    local_survivor_count_le_p_minus_one 5 H (by decide) hzero
  unfold Subcritical235Score FiniteResonanceNumerator ProductLocalGateSurvivorCount
  by_cases h2max : LocalGateSurvivorCount 2 H = 1
  · by_cases h3max : LocalGateSurvivorCount 3 H = 2
    · have hdiv6 : AllOffsetsDivisibleBy6 H :=
        all_offsets_divisible_by6_of_local_two_three_max hzero h2max h3max
      exact False.elim (hnot hdiv6)
    · have h3le1 : LocalGateSurvivorCount 3 H ≤ 1 := by omega
      have h23 : LocalGateSurvivorCount 2 H * LocalGateSurvivorCount 3 H ≤ 1 * 1 :=
        Nat.mul_le_mul h2le h3le1
      have hprod : (LocalGateSurvivorCount 2 H * LocalGateSurvivorCount 3 H) *
          LocalGateSurvivorCount 5 H ≤ (1 * 1) * 4 :=
        Nat.mul_le_mul h23 h5le
      simpa [Nat.mul_assoc] using hprod
  · have h2zero : LocalGateSurvivorCount 2 H = 0 := by omega
    simp [h2zero]

/-- BT-0009 upper bound: no subcritical normalized pattern scores above 6. -/
theorem bt0009_subcritical_235_k3_D59_upper_bound {H : List Nat}
    (hpat : Pattern235Subcritical H) :
    FiniteResonanceNumerator [2, 3, 5] H ≤ 6 := by
  by_cases hdiv6 : AllOffsetsDivisibleBy6 H
  · have hzero : 0 ∈ H := subcritical235_mem_zero hpat
    have h2le : LocalGateSurvivorCount 2 H ≤ 1 :=
      local_survivor_count_le_p_minus_one 2 H (by decide) hzero
    have h3le : LocalGateSurvivorCount 3 H ≤ 2 :=
      local_survivor_count_le_p_minus_one 3 H (by decide) hzero
    have h5le : LocalGateSurvivorCount 5 H ≤ 3 :=
      local_five_le_three_of_all_divisible_by6_subcritical hpat hdiv6
    unfold FiniteResonanceNumerator ProductLocalGateSurvivorCount
    have h23 : LocalGateSurvivorCount 2 H * LocalGateSurvivorCount 3 H ≤ 1 * 2 :=
      Nat.mul_le_mul h2le h3le
    have hprod : (LocalGateSurvivorCount 2 H * LocalGateSurvivorCount 3 H) *
        LocalGateSurvivorCount 5 H ≤ (1 * 2) * 3 :=
      Nat.mul_le_mul h23 h5le
    simpa [Nat.mul_assoc] using hprod
  · have hle4 := subcritical235_score_le_four_of_not_all_divisible_by6 hpat hdiv6
    unfold Subcritical235Score at hle4
    omega

/-- Any structurally described subcritical maximizer attains score 6. -/
theorem subcritical235_score_eq_six_of_structure {H : List Nat}
    (hpat : Pattern235Subcritical H)
    (hdiv6 : AllOffsetsDivisibleBy6 H)
    (hshadow5 : OccupiesExactlyTwoResiduesMod5 H) :
    FiniteResonanceNumerator [2, 3, 5] H = 6 := by
  have hzero : 0 ∈ H := subcritical235_mem_zero hpat
  have h2 : LocalGateSurvivorCount 2 H = 1 :=
    local_two_eq_one_of_all_offsets_divisible_by6 hzero hdiv6
  have h3 : LocalGateSurvivorCount 3 H = 2 :=
    local_three_eq_two_of_all_offsets_divisible_by6 hzero hdiv6
  have h5 : LocalGateSurvivorCount 5 H = 3 := by
    rw [local_gate_survivor_count_eq_modulus_sub_shadow]
    unfold OccupiesExactlyTwoResiduesMod5 at hshadow5
    rw [hshadow5]
  simp [FiniteResonanceNumerator, ProductLocalGateSurvivorCount, h2, h3, h5]

/-- Score 6 forces the structural 6-lattice and exactly two mod-5 shadows. -/
theorem structure_of_subcritical235_score_eq_six {H : List Nat}
    (hpat : Pattern235Subcritical H)
    (hscore : FiniteResonanceNumerator [2, 3, 5] H = 6) :
    AllOffsetsDivisibleBy6 H ∧ OccupiesExactlyTwoResiduesMod5 H := by
  have hzero : 0 ∈ H := subcritical235_mem_zero hpat
  have hdiv6 : AllOffsetsDivisibleBy6 H := by
    by_cases hcase : AllOffsetsDivisibleBy6 H
    · exact hcase
    · have hle4 := subcritical235_score_le_four_of_not_all_divisible_by6 hpat hcase
      unfold Subcritical235Score at hle4
      omega
  have h2 : LocalGateSurvivorCount 2 H = 1 :=
    local_two_eq_one_of_all_offsets_divisible_by6 hzero hdiv6
  have h3 : LocalGateSurvivorCount 3 H = 2 :=
    local_three_eq_two_of_all_offsets_divisible_by6 hzero hdiv6
  have h5 : LocalGateSurvivorCount 5 H = 3 := by
    unfold FiniteResonanceNumerator ProductLocalGateSurvivorCount at hscore
    simp [h2, h3] at hscore
    omega
  have hshadow5 : LocalResidueShadowCount 5 H = 2 := by
    rw [local_gate_survivor_count_eq_modulus_sub_shadow] at h5
    have hle5 := local_shadow_count_le_p 5 H
    omega
  exact ⟨hdiv6, hshadow5⟩

/-- BT-0009 equality characterization. -/
theorem bt0009_subcritical_235_k3_D59_equality_characterization {H : List Nat}
    (hpat : Pattern235Subcritical H) :
    FiniteResonanceNumerator [2, 3, 5] H = 6 ↔
      AllOffsetsDivisibleBy6 H ∧ OccupiesExactlyTwoResiduesMod5 H := by
  constructor
  · exact structure_of_subcritical235_score_eq_six hpat
  · intro h
    exact subcritical235_score_eq_six_of_structure hpat h.left h.right

/-- BT-0009 structural theorem for the first subcritical resonance window. -/
theorem bt0009_subcritical_235_k3_D59_structural_breakthrough {H : List Nat}
    (hpat : Pattern235Subcritical H) :
    FiniteResonanceNumerator [2, 3, 5] H ≤ 6 ∧
      (FiniteResonanceNumerator [2, 3, 5] H = 6 ↔
        AllOffsetsDivisibleBy6 H ∧ OccupiesExactlyTwoResiduesMod5 H) := by
  exact ⟨bt0009_subcritical_235_k3_D59_upper_bound hpat,
    bt0009_subcritical_235_k3_D59_equality_characterization hpat⟩

end NumBridge
