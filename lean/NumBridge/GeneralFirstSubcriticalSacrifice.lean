/-
BT-0011 general first-subcritical sacrifice layer.

This file closes the two-gate base-spine fallback theorem requested for
BT-0011.  It generalizes BT-0010 from the fixed base spine `[2,3]` to an
arbitrary pairwise-coprime two-gate spine `[a,b]`.

The fully arbitrary finite base-spine theorem remains open Lean work.
-/

import Lean.Elab.Tactic.Omega
import NumBridge.FirstSubcriticalSacrifice

namespace NumBridge

/-- The two-gate base product. -/
def TwoGateSpineProduct (a b : Nat) : Nat :=
  a * b

/-- The two-gate product upper bound. -/
def TwoGateSpineUpperBound (a b : Nat) : Nat :=
  (a - 1) * (b - 1)

/-- Normalized distinct first-subcritical three-point patterns for `[a,b,q]`. -/
def TwoGateFirstSubcriticalPattern (a b q : Nat) (H : List Nat) : Prop :=
  NormalizedDistinctPattern 3 (2 * ((a * b) * q) - 1) H

/-- The pattern keeps the two-gate base spine locked. -/
def TwoGateSpineLocked (a b : Nat) (H : List Nat) : Prop :=
  AllOffsetsDivisibleBy (a * b) H

/-- The pattern sacrifices exactly one residue at the last gate. -/
def SacrificesLastGate (q : Nat) (H : List Nat) : Prop :=
  LocalResidueShadowCount q H = 2

/-- The first-subcritical finite resonance score for gates `[a,b,q]`. -/
def TwoGateFirstSubcriticalScore (a b q : Nat) (H : List Nat) : Nat :=
  FiniteResonanceNumerator [a, b, q] H

/-- A two-gate first-subcritical normalized pattern contains zero. -/
theorem two_gate_first_subcritical_mem_zero {a b q : Nat} {H : List Nat}
    (hpat : TwoGateFirstSubcriticalPattern a b q H) :
    0 ∈ H :=
  startsAtZero_mem_zero hpat.left

/--
If `x <= 2M - 1` and `M` divides `x`, then `x` is one of the first two
multiples of `M`.
-/
theorem multiple_bounded_twoM_minus_one_eq_zero_or_M
    {M x : Nat} (hM : 0 < M) (hxle : x ≤ 2 * M - 1) (hdvd : M ∣ x) :
    x = 0 ∨ x = M := by
  rcases hdvd with ⟨m, rfl⟩
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
          have hlarge : 2 * M ≤ M * (n + 1 + 1) := by
            have hbase : M * 2 ≤ M * (n + 1 + 1) :=
              Nat.mul_le_mul_left M (by omega)
            omega
          omega

/--
Three distinct normalized offsets bounded by `2M - 1` cannot all be multiples
of `M`: the third possible multiple would be `2M`.
-/
theorem no_three_distinct_bounded_twoM_minus_one_all_dvd
    {M : Nat} {H : List Nat} (hM : 0 < M)
    (hpat : NormalizedDistinctPattern 3 (2 * M - 1) H) :
    ¬ AllOffsetsDivisibleBy M H := by
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
                  have hb_le : b ≤ 2 * M - 1 := hbound b (by simp)
                  have hc_le : c ≤ 2 * M - 1 := hbound c (by simp)
                  have hb_dvd : M ∣ b := hall b (by simp)
                  have hc_dvd : M ∣ c := hall c (by simp)
                  have hb_cases : b = 0 ∨ b = M :=
                    multiple_bounded_twoM_minus_one_eq_zero_or_M hM hb_le hb_dvd
                  have hc_cases : c = 0 ∨ c = M :=
                    multiple_bounded_twoM_minus_one_eq_zero_or_M hM hc_le hc_dvd
                  simp at hnodup
                  rcases hb_cases with hb0 | hbM
                  · exact hnodup.left.left hb0.symm
                  · rcases hc_cases with hc0 | hcM
                    · exact hnodup.left.right hc0.symm
                    · subst b
                      subst c
                      exact hnodup.right rfl
              | cons d t4 =>
                  simp at hlen

/-- The threshold and coprimality force the new gate beyond the left base gate. -/
theorem q_gt_left_of_two_gate_threshold
    {a b q : Nat} (ha : 2 ≤ a) (hb : 2 ≤ b)
    (hcopq : Nat.Coprime q (a * b))
    (hthreshold : (a - 1) * (b - 1) + 1 ≤ q) :
    a < q := by
  by_cases hlt : a < q
  · exact hlt
  · have hqle : q ≤ a := Nat.not_lt.mp hlt
    have hApos : 0 < a - 1 := by omega
    have hmul : (a - 1) * (b - 1) ≤ (a - 1) * 1 := by omega
    have hbsub : b - 1 ≤ 1 := Nat.le_of_mul_le_mul_left hmul hApos
    have hb2 : b = 2 := by omega
    subst b
    have hqa : q = a := by omega
    subst q
    have hdvd : a ∣ a * 2 := Nat.dvd_mul_right a 2
    have ha1 : a = 1 := hcopq.eq_one_of_dvd hdvd
    omega

/-- The threshold and coprimality force the new gate beyond the right base gate. -/
theorem q_gt_right_of_two_gate_threshold
    {a b q : Nat} (ha : 2 ≤ a) (hb : 2 ≤ b)
    (hcopq : Nat.Coprime q (a * b))
    (hthreshold : (a - 1) * (b - 1) + 1 ≤ q) :
    b < q := by
  have hcopq' : Nat.Coprime q (b * a) := by
    simpa [Nat.mul_comm] using hcopq
  have hthreshold' : (b - 1) * (a - 1) + 1 ≤ q := by
    simpa [Nat.mul_comm] using hthreshold
  exact q_gt_left_of_two_gate_threshold hb ha hcopq' hthreshold'

/-- One dropped left local factor is strictly below the first-subcritical bound. -/
theorem dropped_left_two_gate_product_lt
    {a b q : Nat} (ha : 2 ≤ a) (hb : 2 ≤ b) (hq : 2 ≤ q)
    (hcopq : Nat.Coprime q (a * b))
    (hthreshold : (a - 1) * (b - 1) + 1 ≤ q) :
    (a - 2) * (b - 1) * (q - 1) <
      (a - 1) * (b - 1) * (q - 2) := by
  have haq : a < q := q_gt_left_of_two_gate_threshold ha hb hcopq hthreshold
  have hinner : (a - 2) * (q - 1) < (a - 1) * (q - 2) := by
    have hq1 : q - 1 = (q - 2) + 1 := by omega
    have ha1 : a - 1 = (a - 2) + 1 := by omega
    calc
      (a - 2) * (q - 1) = (a - 2) * ((q - 2) + 1) := by rw [hq1]
      _ = (a - 2) * (q - 2) + (a - 2) := by
        rw [Nat.mul_add]
        simp
      _ < (a - 2) * (q - 2) + (q - 2) := by
        exact Nat.add_lt_add_left (by omega : a - 2 < q - 2) _
      _ = ((a - 2) + 1) * (q - 2) := by
        rw [Nat.add_mul]
        simp
      _ = (a - 1) * (q - 2) := by rw [ha1]
  have hpos : 0 < b - 1 := by omega
  have hmul := Nat.mul_lt_mul_of_pos_right hinner hpos
  simpa [Nat.mul_assoc, Nat.mul_comm, Nat.mul_left_comm] using hmul

/-- One dropped right local factor is strictly below the first-subcritical bound. -/
theorem dropped_right_two_gate_product_lt
    {a b q : Nat} (ha : 2 ≤ a) (hb : 2 ≤ b) (hq : 2 ≤ q)
    (hcopq : Nat.Coprime q (a * b))
    (hthreshold : (a - 1) * (b - 1) + 1 ≤ q) :
    (a - 1) * (b - 2) * (q - 1) <
      (a - 1) * (b - 1) * (q - 2) := by
  have hcopq' : Nat.Coprime q (b * a) := by
    simpa [Nat.mul_comm] using hcopq
  have hthreshold' : (b - 1) * (a - 1) + 1 ≤ q := by
    simpa [Nat.mul_comm] using hthreshold
  have h := dropped_left_two_gate_product_lt hb ha hq hcopq' hthreshold'
  simpa [Nat.mul_assoc, Nat.mul_comm, Nat.mul_left_comm] using h

/-- A base-locked pattern cannot have only one q-shadow in the first-subcritical window. -/
theorem two_gate_first_subcritical_base_lock_forces_q_shadow_ge_two
    {a b q : Nat} {H : List Nat} (ha : 2 ≤ a) (hb : 2 ≤ b) (hq : 2 ≤ q)
    (_hab : Nat.Coprime a b) (hcopq : Nat.Coprime q (a * b))
    (hpat : TwoGateFirstSubcriticalPattern a b q H)
    (hlock : TwoGateSpineLocked a b H) :
    2 ≤ LocalResidueShadowCount q H := by
  have hzero : 0 ∈ H := two_gate_first_subcritical_mem_zero hpat
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
    have hallabq : AllOffsetsDivisibleBy ((a * b) * q) H := by
      intro h hh
      have habdvd : a * b ∣ h := hlock h hh
      have hqdvd : q ∣ h := Nat.dvd_of_mod_eq_zero (hallq h hh)
      have hcopabq : Nat.Coprime (a * b) q := hcopq.symm
      exact hcopabq.mul_dvd_of_dvd_of_dvd habdvd hqdvd
    have hMpos : 0 < (a * b) * q := by
      exact Nat.mul_pos (Nat.mul_pos (by omega) (by omega)) (by omega)
    exact False.elim
      (no_three_distinct_bounded_twoM_minus_one_all_dvd
        (M := (a * b) * q) hMpos hpat hallabq)
  · omega

/-- A base-locked pattern has at most `q - 2` local survivors at the last gate. -/
theorem two_gate_local_q_le_q_minus_two_of_base_lock
    {a b q : Nat} {H : List Nat} (ha : 2 ≤ a) (hb : 2 ≤ b) (hq : 2 ≤ q)
    (hab : Nat.Coprime a b) (hcopq : Nat.Coprime q (a * b))
    (hpat : TwoGateFirstSubcriticalPattern a b q H)
    (hlock : TwoGateSpineLocked a b H) :
    LocalGateSurvivorCount q H ≤ q - 2 := by
  rw [local_gate_survivor_count_eq_modulus_sub_shadow]
  have hge2 := two_gate_first_subcritical_base_lock_forces_q_shadow_ge_two
    ha hb hq hab hcopq hpat hlock
  have hleq := local_shadow_count_le_p q H
  omega

/-- Base lock forces the two base local factors to attain their maxima. -/
theorem two_gate_base_local_factor_eq_of_lock
    {a b : Nat} {H : List Nat} (ha : 2 ≤ a) (hb : 2 ≤ b)
    (hzero : 0 ∈ H) (hlock : TwoGateSpineLocked a b H) :
    LocalGateSurvivorCount a H = a - 1 ∧
      LocalGateSurvivorCount b H = b - 1 := by
  constructor
  · apply local_survivor_count_eq_p_minus_one_of_all_mod_zero a H (by omega) hzero
    intro h hh
    have habdvd : a * b ∣ h := hlock h hh
    have hadvdab : a ∣ a * b := Nat.dvd_mul_right a b
    exact Nat.mod_eq_zero_of_dvd (Nat.dvd_trans hadvdab habdvd)
  · apply local_survivor_count_eq_p_minus_one_of_all_mod_zero b H (by omega) hzero
    intro h hh
    have habdvd : a * b ∣ h := hlock h hh
    have hbdvdab : b ∣ a * b := Nat.dvd_mul_left b a
    exact Nat.mod_eq_zero_of_dvd (Nat.dvd_trans hbdvdab habdvd)

/-- If both base local factors are maximal, the two-gate spine is locked. -/
theorem two_gate_lock_of_base_local_factors_eq
    {a b : Nat} {H : List Nat} (ha : 2 ≤ a) (hb : 2 ≤ b)
    (hab : Nat.Coprime a b) (hzero : 0 ∈ H)
    (haeq : LocalGateSurvivorCount a H = a - 1)
    (hbeq : LocalGateSurvivorCount b H = b - 1) :
    TwoGateSpineLocked a b H := by
  intro h hh
  have halla : ∀ x : Nat, x ∈ H → x % a = 0 :=
    (local_survivor_count_eq_p_minus_one_iff_all_mod_zero a H (by omega) hzero).mp haeq
  have hallb : ∀ x : Nat, x ∈ H → x % b = 0 :=
    (local_survivor_count_eq_p_minus_one_iff_all_mod_zero b H (by omega) hzero).mp hbeq
  have hadvd : a ∣ h := Nat.dvd_of_mod_eq_zero (halla h hh)
  have hbdvd : b ∣ h := Nat.dvd_of_mod_eq_zero (hallb h hh)
  exact hab.mul_dvd_of_dvd_of_dvd hadvd hbdvd

/-- If the two-gate spine is not locked, the score is strictly suboptimal. -/
theorem two_gate_not_locked_score_drop
    {a b q : Nat} {H : List Nat} (ha : 2 ≤ a) (hb : 2 ≤ b) (hq : 2 ≤ q)
    (hab : Nat.Coprime a b) (hcopq : Nat.Coprime q (a * b))
    (hthreshold : (a - 1) * (b - 1) + 1 ≤ q)
    (hpat : TwoGateFirstSubcriticalPattern a b q H)
    (hnot : ¬ TwoGateSpineLocked a b H) :
    FiniteResonanceNumerator [a, b, q] H <
      (a - 1) * (b - 1) * (q - 2) := by
  have hzero : 0 ∈ H := two_gate_first_subcritical_mem_zero hpat
  have hale : LocalGateSurvivorCount a H ≤ a - 1 :=
    local_survivor_count_le_p_minus_one a H (by omega) hzero
  have hble : LocalGateSurvivorCount b H ≤ b - 1 :=
    local_survivor_count_le_p_minus_one b H (by omega) hzero
  have hqle : LocalGateSurvivorCount q H ≤ q - 1 :=
    local_survivor_count_le_p_minus_one q H (by omega) hzero
  by_cases haeq : LocalGateSurvivorCount a H = a - 1
  · have hbne : LocalGateSurvivorCount b H ≠ b - 1 := by
      intro hbeq
      exact hnot (two_gate_lock_of_base_local_factors_eq ha hb hab hzero haeq hbeq)
    have hblt : LocalGateSurvivorCount b H < b - 1 :=
      Nat.lt_of_le_of_ne hble hbne
    have hble_drop : LocalGateSurvivorCount b H ≤ b - 2 := by omega
    have hscore_le :
        (LocalGateSurvivorCount a H * LocalGateSurvivorCount b H) *
            LocalGateSurvivorCount q H ≤
          (a - 1) * (b - 2) * (q - 1) := by
      exact Nat.mul_le_mul (Nat.mul_le_mul hale hble_drop) hqle
    exact Nat.lt_of_le_of_lt
      (by
        simpa [FiniteResonanceNumerator, ProductLocalGateSurvivorCount,
          Nat.mul_assoc] using hscore_le)
      (dropped_right_two_gate_product_lt ha hb hq hcopq hthreshold)
  · have halt : LocalGateSurvivorCount a H < a - 1 :=
      Nat.lt_of_le_of_ne hale haeq
    have hale_drop : LocalGateSurvivorCount a H ≤ a - 2 := by omega
    have hscore_le :
        (LocalGateSurvivorCount a H * LocalGateSurvivorCount b H) *
            LocalGateSurvivorCount q H ≤
          (a - 2) * (b - 1) * (q - 1) := by
      exact Nat.mul_le_mul (Nat.mul_le_mul hale_drop hble) hqle
    exact Nat.lt_of_le_of_lt
      (by
        simpa [FiniteResonanceNumerator, ProductLocalGateSurvivorCount,
          Nat.mul_assoc] using hscore_le)
      (dropped_left_two_gate_product_lt ha hb hq hcopq hthreshold)

/-- BT-0011 two-gate fallback: first-subcritical upper bound for `[a,b,q]`. -/
theorem two_gate_first_subcritical_upper_bound
    {a b q : Nat} {H : List Nat} (ha : 2 ≤ a) (hb : 2 ≤ b) (hq : 2 ≤ q)
    (hab : Nat.Coprime a b) (hcopq : Nat.Coprime q (a * b))
    (hthreshold : (a - 1) * (b - 1) + 1 ≤ q)
    (hpat : TwoGateFirstSubcriticalPattern a b q H) :
    FiniteResonanceNumerator [a, b, q] H ≤
      (a - 1) * (b - 1) * (q - 2) := by
  by_cases hlock : TwoGateSpineLocked a b H
  · have hzero : 0 ∈ H := two_gate_first_subcritical_mem_zero hpat
    have hbase := two_gate_base_local_factor_eq_of_lock ha hb hzero hlock
    have hqle := two_gate_local_q_le_q_minus_two_of_base_lock
      ha hb hq hab hcopq hpat hlock
    simpa [FiniteResonanceNumerator, ProductLocalGateSurvivorCount,
      hbase.left, hbase.right, Nat.mul_assoc] using
      Nat.mul_le_mul_left ((a - 1) * (b - 1)) hqle
  · exact Nat.le_of_lt
      (two_gate_not_locked_score_drop ha hb hq hab hcopq hthreshold hpat hlock)

/-- Any two-gate base lock with exactly two q-shadows attains the BT-0011 bound. -/
theorem two_gate_first_subcritical_lock_and_q_sacrifice_attains
    {a b q : Nat} {H : List Nat} (ha : 2 ≤ a) (hb : 2 ≤ b) (_hq : 2 ≤ q)
    (_hab : Nat.Coprime a b) (_hcopq : Nat.Coprime q (a * b))
    (hpat : TwoGateFirstSubcriticalPattern a b q H)
    (hlock : TwoGateSpineLocked a b H)
    (hshadowq : SacrificesLastGate q H) :
    FiniteResonanceNumerator [a, b, q] H =
      (a - 1) * (b - 1) * (q - 2) := by
  have hzero : 0 ∈ H := two_gate_first_subcritical_mem_zero hpat
  have hbase := two_gate_base_local_factor_eq_of_lock ha hb hzero hlock
  have hqsurv : LocalGateSurvivorCount q H = q - 2 := by
    rw [local_gate_survivor_count_eq_modulus_sub_shadow]
    unfold SacrificesLastGate at hshadowq
    rw [hshadowq]
  simp [FiniteResonanceNumerator, ProductLocalGateSurvivorCount,
    hbase.left, hbase.right, hqsurv, Nat.mul_assoc]

/-- Equality in the BT-0011 two-gate bound forces base lock and q-sacrifice. -/
theorem two_gate_first_subcritical_equality_forces_lock_and_q_sacrifice
    {a b q : Nat} {H : List Nat} (ha : 2 ≤ a) (hb : 2 ≤ b) (hq : 2 ≤ q)
    (hab : Nat.Coprime a b) (hcopq : Nat.Coprime q (a * b))
    (hthreshold : (a - 1) * (b - 1) + 1 ≤ q)
    (hpat : TwoGateFirstSubcriticalPattern a b q H)
    (hscore : FiniteResonanceNumerator [a, b, q] H =
      (a - 1) * (b - 1) * (q - 2)) :
    TwoGateSpineLocked a b H ∧ SacrificesLastGate q H := by
  have hzero : 0 ∈ H := two_gate_first_subcritical_mem_zero hpat
  have hlock : TwoGateSpineLocked a b H := by
    by_cases hcase : TwoGateSpineLocked a b H
    · exact hcase
    · have hlt := two_gate_not_locked_score_drop
        ha hb hq hab hcopq hthreshold hpat hcase
      rw [hscore] at hlt
      exact False.elim (Nat.lt_irrefl _ hlt)
  have hbase := two_gate_base_local_factor_eq_of_lock ha hb hzero hlock
  have hscore_factor :
      FiniteResonanceNumerator [a, b, q] H =
        ((a - 1) * (b - 1)) * LocalGateSurvivorCount q H := by
    simp [FiniteResonanceNumerator, ProductLocalGateSurvivorCount,
      hbase.left, hbase.right, Nat.mul_assoc]
  have hqsurv : LocalGateSurvivorCount q H = q - 2 := by
    rw [hscore_factor] at hscore
    have hBpos : 0 < (a - 1) * (b - 1) :=
      Nat.mul_pos (by omega) (by omega)
    exact Nat.mul_left_cancel hBpos hscore
  have hshadowq : LocalResidueShadowCount q H = 2 := by
    rw [local_gate_survivor_count_eq_modulus_sub_shadow] at hqsurv
    have hleq := local_shadow_count_le_p q H
    omega
  exact ⟨hlock, hshadowq⟩

/--
BT-0011 two-gate first-subcritical sacrifice theorem.

This is the closed Lean fallback theorem for arbitrary two-gate base spines.
-/
theorem bt0011_two_gate_first_subcritical_sacrifice_theorem
    {a b q : Nat} {H : List Nat} (ha : 2 ≤ a) (hb : 2 ≤ b) (hq : 2 ≤ q)
    (hab : Nat.Coprime a b) (hcopq : Nat.Coprime q (a * b))
    (hthreshold : (a - 1) * (b - 1) + 1 ≤ q)
    (hpat : TwoGateFirstSubcriticalPattern a b q H) :
    FiniteResonanceNumerator [a, b, q] H ≤
        (a - 1) * (b - 1) * (q - 2) ∧
      (FiniteResonanceNumerator [a, b, q] H =
          (a - 1) * (b - 1) * (q - 2) ↔
        TwoGateSpineLocked a b H ∧ SacrificesLastGate q H) := by
  constructor
  · exact two_gate_first_subcritical_upper_bound ha hb hq hab hcopq hthreshold hpat
  · constructor
    · exact two_gate_first_subcritical_equality_forces_lock_and_q_sacrifice
        ha hb hq hab hcopq hthreshold hpat
    · intro h
      exact two_gate_first_subcritical_lock_and_q_sacrifice_attains
        ha hb hq hab hcopq hpat h.left h.right

end NumBridge
