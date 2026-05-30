/-
BT-0010 first subcritical sacrifice theorem.

This generalizes BT-0009 from gates [2,3,5] to [2,3,q].  In the first
subcritical window D = 2*(6q)-1, the full [2,3,q]-lattice pattern
[0, 6q, 12q] cannot fit.  The best finite-resonance patterns keep the 2- and
3-gates locked and sacrifice exactly one residue at the q-gate.

This is finite-sieve combinatorics only.  It is not a prime-distribution
theorem.
-/

import Lean.Elab.Tactic.Omega
import NumBridge.SubcriticalResonance

namespace NumBridge

/-- Normalized distinct first-subcritical three-point patterns for gates `[2,3,q]`. -/
def FirstSubcriticalPattern (q : Nat) (H : List Nat) : Prop :=
  NormalizedDistinctPattern 3 (12 * q - 1) H

/-- The pattern keeps the 2- and 3-gates locked. -/
def DivisibleBySixPattern (H : List Nat) : Prop :=
  AllOffsetsDivisibleBy 6 H

/-- The pattern sacrifices exactly one residue at the q-gate. -/
def SacrificesQGate (q : Nat) (H : List Nat) : Prop :=
  LocalResidueShadowCount q H = 2

/-- The first-subcritical finite resonance score for gates `[2,3,q]`. -/
def FirstSubcriticalScore (q : Nat) (H : List Nat) : Nat :=
  FiniteResonanceNumerator [2, 3, q] H

/-- Gate product for the `[2,3,q]` family. -/
theorem gateProduct_two_three_q (q : Nat) (_hcop : Nat.Coprime q 6) :
    gateProduct [2, 3, q] = 6 * q := by
  simp [gateProduct]
  omega

/-- A first-subcritical normalized pattern contains zero. -/
theorem first_subcritical_mem_zero {q : Nat} {H : List Nat}
    (hpat : FirstSubcriticalPattern q H) :
    0 ∈ H :=
  startsAtZero_mem_zero hpat.left

/--
Three distinct normalized offsets bounded by `12q - 1` cannot all be multiples
of `6q`.  The missing third multiple would be `12q`.
-/
theorem no_first_subcritical_pattern_all_offsets_divisible_by_six_q
    {q : Nat} {H : List Nat} (hq : 5 ≤ q)
    (hpat : FirstSubcriticalPattern q H) :
    ¬ AllOffsetsDivisibleBy (6 * q) H := by
  intro hall
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
                  have hb_le : b ≤ 12 * q - 1 := hbound b (by simp)
                  have hc_le : c ≤ 12 * q - 1 := hbound c (by simp)
                  have hb_dvd : 6 * q ∣ b := hall b (by simp)
                  have hc_dvd : 6 * q ∣ c := hall c (by simp)
                  have hb_cases : b = 0 ∨ b = 6 * q := by
                    rcases hb_dvd with ⟨m, rfl⟩
                    cases m with
                    | zero =>
                        left
                        simp
                    | succ m =>
                        cases m with
                        | zero =>
                            right
                            simp
                        | succ n =>
                            exfalso
                            have hlarge : 12 * q ≤ (6 * q) * (n + 1 + 1) := by
                              have hbase : (6 * q) * 2 ≤ (6 * q) * (n + 1 + 1) :=
                                Nat.mul_le_mul_left (6 * q) (by omega)
                              have heq : (6 * q) * 2 = 12 * q := by omega
                              omega
                            omega
                  have hc_cases : c = 0 ∨ c = 6 * q := by
                    rcases hc_dvd with ⟨m, rfl⟩
                    cases m with
                    | zero =>
                        left
                        simp
                    | succ m =>
                        cases m with
                        | zero =>
                            right
                            simp
                        | succ n =>
                            exfalso
                            have hlarge : 12 * q ≤ (6 * q) * (n + 1 + 1) := by
                              have hbase : (6 * q) * 2 ≤ (6 * q) * (n + 1 + 1) :=
                                Nat.mul_le_mul_left (6 * q) (by omega)
                              have heq : (6 * q) * 2 = 12 * q := by omega
                              omega
                            omega
                  simp at hnodup
                  rcases hb_cases with hb0 | hbW
                  · exact hnodup.left.left hb0.symm
                  · rcases hc_cases with hc0 | hcW
                    · exact hnodup.left.right hc0.symm
                    · subst b
                      subst c
                      exact hnodup.right rfl
              | cons d t4 =>
                  simp at hlen

/-- In the first subcritical window, a 6-lattice pattern has at least two q-shadows. -/
theorem local_shadow_q_ge_two_of_all_divisible_by6_first_subcritical
    {q : Nat} {H : List Nat} (hq : 5 ≤ q) (hcop : Nat.Coprime q 6)
    (hpat : FirstSubcriticalPattern q H) (hdiv6 : DivisibleBySixPattern H) :
    2 ≤ LocalResidueShadowCount q H := by
  have hzero : 0 ∈ H := first_subcritical_mem_zero hpat
  have hqpos : 0 < q := by omega
  have hge1 : 1 ≤ LocalResidueShadowCount q H :=
    nonempty_shadow_count_ge_one q H hqpos hzero
  by_cases hshadow1 : LocalResidueShadowCount q H = 1
  · have hleq : LocalResidueShadowCount q H ≤ q := local_shadow_count_le_p q H
    have hsurvq : LocalGateSurvivorCount q H = q - 1 := by
      rw [local_gate_survivor_count_eq_modulus_sub_shadow]
      omega
    have hallq : ∀ h : Nat, h ∈ H → h % q = 0 :=
      (local_survivor_count_eq_p_minus_one_iff_all_mod_zero q H hqpos hzero).mp hsurvq
    have hall6q : AllOffsetsDivisibleBy (6 * q) H := by
      intro h hh
      have h6 : 6 ∣ h := hdiv6 h hh
      have hqdvd : q ∣ h := Nat.dvd_of_mod_eq_zero (hallq h hh)
      have hcop6q : Nat.Coprime 6 q := hcop.symm
      exact hcop6q.mul_dvd_of_dvd_of_dvd h6 hqdvd
    exact False.elim (no_first_subcritical_pattern_all_offsets_divisible_by_six_q hq hpat hall6q)
  · omega

/-- A first-subcritical 6-lattice pattern has at most `q - 2` q-local survivors. -/
theorem local_q_le_q_minus_two_of_all_divisible_by6_first_subcritical
    {q : Nat} {H : List Nat} (hq : 5 ≤ q) (hcop : Nat.Coprime q 6)
    (hpat : FirstSubcriticalPattern q H) (hdiv6 : DivisibleBySixPattern H) :
    LocalGateSurvivorCount q H ≤ q - 2 := by
  rw [local_gate_survivor_count_eq_modulus_sub_shadow]
  have hge2 := local_shadow_q_ge_two_of_all_divisible_by6_first_subcritical
    hq hcop hpat hdiv6
  have hleq := local_shadow_count_le_p q H
  omega

/-- If the pattern is not locked to the 6-lattice, its score is at most `q - 1`. -/
theorem first_subcritical_score_le_q_minus_one_of_not_six_lock
    {q : Nat} {H : List Nat} (hq : 5 ≤ q)
    (hpat : FirstSubcriticalPattern q H) (hnot : ¬ DivisibleBySixPattern H) :
    FirstSubcriticalScore q H ≤ q - 1 := by
  have hzero : 0 ∈ H := first_subcritical_mem_zero hpat
  have hqpos : 0 < q := by omega
  have h2le : LocalGateSurvivorCount 2 H ≤ 1 :=
    local_survivor_count_le_p_minus_one 2 H (by decide) hzero
  have h3le : LocalGateSurvivorCount 3 H ≤ 2 :=
    local_survivor_count_le_p_minus_one 3 H (by decide) hzero
  have hqle : LocalGateSurvivorCount q H ≤ q - 1 :=
    local_survivor_count_le_p_minus_one q H hqpos hzero
  unfold FirstSubcriticalScore FiniteResonanceNumerator ProductLocalGateSurvivorCount
  by_cases h2max : LocalGateSurvivorCount 2 H = 1
  · by_cases h3max : LocalGateSurvivorCount 3 H = 2
    · have hdiv6 : DivisibleBySixPattern H :=
        all_offsets_divisible_by6_of_local_two_three_max hzero h2max h3max
      exact False.elim (hnot hdiv6)
    · have h3le1 : LocalGateSurvivorCount 3 H ≤ 1 := by omega
      have h23 : LocalGateSurvivorCount 2 H * LocalGateSurvivorCount 3 H ≤ 1 * 1 :=
        Nat.mul_le_mul h2le h3le1
      have hprod : (LocalGateSurvivorCount 2 H * LocalGateSurvivorCount 3 H) *
          LocalGateSurvivorCount q H ≤ (1 * 1) * (q - 1) :=
        Nat.mul_le_mul h23 hqle
      simpa [Nat.mul_assoc] using hprod
  · have h2zero : LocalGateSurvivorCount 2 H = 0 := by omega
    simp [h2zero]

/-- BT-0010 upper bound for the `[2,3,q]` first-subcritical family. -/
theorem first_subcritical_upper_bound_two_three_q
    {q : Nat} {H : List Nat} (hq : 5 ≤ q) (hcop : Nat.Coprime q 6)
    (hpat : FirstSubcriticalPattern q H) :
    FiniteResonanceNumerator [2, 3, q] H ≤ 2 * (q - 2) := by
  by_cases hdiv6 : DivisibleBySixPattern H
  · have hzero : 0 ∈ H := first_subcritical_mem_zero hpat
    have h2le : LocalGateSurvivorCount 2 H ≤ 1 :=
      local_survivor_count_le_p_minus_one 2 H (by decide) hzero
    have h3le : LocalGateSurvivorCount 3 H ≤ 2 :=
      local_survivor_count_le_p_minus_one 3 H (by decide) hzero
    have hqle : LocalGateSurvivorCount q H ≤ q - 2 :=
      local_q_le_q_minus_two_of_all_divisible_by6_first_subcritical hq hcop hpat hdiv6
    unfold FiniteResonanceNumerator ProductLocalGateSurvivorCount
    have h23 : LocalGateSurvivorCount 2 H * LocalGateSurvivorCount 3 H ≤ 1 * 2 :=
      Nat.mul_le_mul h2le h3le
    have hprod : (LocalGateSurvivorCount 2 H * LocalGateSurvivorCount 3 H) *
        LocalGateSurvivorCount q H ≤ (1 * 2) * (q - 2) :=
      Nat.mul_le_mul h23 hqle
    simpa [Nat.mul_assoc] using hprod
  · have hle := first_subcritical_score_le_q_minus_one_of_not_six_lock hq hpat hdiv6
    unfold FirstSubcriticalScore at hle
    have hqineq : q - 1 ≤ 2 * (q - 2) := by omega
    exact Nat.le_trans hle hqineq

/-- Any 6-lock pattern with exactly two q-shadows attains the BT-0010 bound. -/
theorem first_subcritical_six_lock_and_q_sacrifice_attains
    {q : Nat} {H : List Nat} (_hq : 5 ≤ q) (_hcop : Nat.Coprime q 6)
    (hpat : FirstSubcriticalPattern q H)
    (hdiv6 : DivisibleBySixPattern H)
    (hshadowq : SacrificesQGate q H) :
    FiniteResonanceNumerator [2, 3, q] H = 2 * (q - 2) := by
  have hzero : 0 ∈ H := first_subcritical_mem_zero hpat
  have h2 : LocalGateSurvivorCount 2 H = 1 :=
    local_two_eq_one_of_all_offsets_divisible_by6 hzero hdiv6
  have h3 : LocalGateSurvivorCount 3 H = 2 :=
    local_three_eq_two_of_all_offsets_divisible_by6 hzero hdiv6
  have hqsurv : LocalGateSurvivorCount q H = q - 2 := by
    rw [local_gate_survivor_count_eq_modulus_sub_shadow]
    unfold SacrificesQGate at hshadowq
    rw [hshadowq]
  simp [FiniteResonanceNumerator, ProductLocalGateSurvivorCount, h2, h3, hqsurv]

/-- Equality in the BT-0010 bound forces 6-lock and exactly two q-shadows. -/
theorem first_subcritical_equality_forces_six_lock_and_q_sacrifice
    {q : Nat} {H : List Nat} (hq : 5 ≤ q) (_hcop : Nat.Coprime q 6)
    (hpat : FirstSubcriticalPattern q H)
    (hscore : FiniteResonanceNumerator [2, 3, q] H = 2 * (q - 2)) :
    DivisibleBySixPattern H ∧ SacrificesQGate q H := by
  have hzero : 0 ∈ H := first_subcritical_mem_zero hpat
  have hdiv6 : DivisibleBySixPattern H := by
    by_cases hcase : DivisibleBySixPattern H
    · exact hcase
    · have hle := first_subcritical_score_le_q_minus_one_of_not_six_lock hq hpat hcase
      unfold FirstSubcriticalScore at hle
      have hlt : q - 1 < 2 * (q - 2) := by omega
      have hcontr : FiniteResonanceNumerator [2, 3, q] H < 2 * (q - 2) :=
        Nat.lt_of_le_of_lt hle hlt
      rw [hscore] at hcontr
      exact False.elim (Nat.lt_irrefl _ hcontr)
  have h2 : LocalGateSurvivorCount 2 H = 1 :=
    local_two_eq_one_of_all_offsets_divisible_by6 hzero hdiv6
  have h3 : LocalGateSurvivorCount 3 H = 2 :=
    local_three_eq_two_of_all_offsets_divisible_by6 hzero hdiv6
  have hqsurv : LocalGateSurvivorCount q H = q - 2 := by
    unfold FiniteResonanceNumerator ProductLocalGateSurvivorCount at hscore
    simp [h2, h3] at hscore
    exact Nat.mul_left_cancel (by decide : 0 < 2) hscore
  have hshadowq : LocalResidueShadowCount q H = 2 := by
    rw [local_gate_survivor_count_eq_modulus_sub_shadow] at hqsurv
    have hleq := local_shadow_count_le_p q H
    omega
  exact ⟨hdiv6, hshadowq⟩

/-- BT-0010: first subcritical sacrifice theorem for gates `[2,3,q]`. -/
theorem bt0010_first_subcritical_sacrifice_theorem
    {q : Nat} {H : List Nat} (hq : 5 ≤ q) (hcop : Nat.Coprime q 6)
    (hpat : FirstSubcriticalPattern q H) :
    FiniteResonanceNumerator [2, 3, q] H ≤ 2 * (q - 2) ∧
      (FiniteResonanceNumerator [2, 3, q] H = 2 * (q - 2) ↔
        DivisibleBySixPattern H ∧ SacrificesQGate q H) := by
  constructor
  · exact first_subcritical_upper_bound_two_three_q hq hcop hpat
  · constructor
    · exact first_subcritical_equality_forces_six_lock_and_q_sacrifice hq hcop hpat
    · intro h
      exact first_subcritical_six_lock_and_q_sacrifice_attains hq hcop hpat h.left h.right

/-- The canonical candidate `[0, 6, 6q]` is a valid first-subcritical pattern. -/
theorem canonical_first_subcritical_attainer_pattern
    {q : Nat} (hq : 5 ≤ q) :
    FirstSubcriticalPattern q [0, 6, 6 * q] := by
  unfold FirstSubcriticalPattern NormalizedDistinctPattern AllOffsetsLE StartsAtZeroProp
  constructor
  · rfl
  constructor
  · simp
  constructor
  · simp
    omega
  · intro h hh
    simp at hh
    rcases hh with rfl | hh
    · omega
    rcases hh with rfl | hh
    · omega
    rcases hh with rfl | hh
    · omega

/-- The canonical candidate keeps the 2- and 3-gates locked. -/
theorem canonical_first_subcritical_attainer_six_lock
    (q : Nat) :
    DivisibleBySixPattern [0, 6, 6 * q] := by
  intro h hh
  simp at hh
  rcases hh with rfl | hh
  · exact Nat.dvd_zero 6
  rcases hh with rfl | hh
  · exact Nat.dvd_refl 6
  rcases hh with rfl | hh
  · exact Nat.dvd_mul_right 6 q

/--
Conditional Lean attainer theorem for the canonical candidate.

The remaining concrete-count sublemma is `SacrificesQGate q [0, 6, 6*q]`.
Python verifies this for the scanned q-values; once that residue-count lemma is
proved in Lean, this theorem gives the unconditional canonical attainer.
-/
theorem canonical_first_subcritical_attainer_attains_if_q_shadow_two
    {q : Nat} (hq : 5 ≤ q) (hcop : Nat.Coprime q 6)
    (hshadow : SacrificesQGate q [0, 6, 6 * q]) :
    FiniteResonanceNumerator [2, 3, q] [0, 6, 6 * q] = 2 * (q - 2) := by
  exact first_subcritical_six_lock_and_q_sacrifice_attains hq hcop
    (canonical_first_subcritical_attainer_pattern hq)
    (canonical_first_subcritical_attainer_six_lock q)
    hshadow

end NumBridge
