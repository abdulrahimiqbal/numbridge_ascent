/-
BT-0012 elementary actual-prime wheel bridge.

This file pivots from finite-wheel optimization to an actual-prime counting
interface.  It proves that any prime-tuple translate whose entries are above
the gate moduli must land in a finite wheel survivor residue, and that any
Boolean enumerator sound for such translates is bounded by the number of wheel
survivor residues times the number of complete wheel blocks.

This is elementary.  It is not a Selberg sieve theorem and does not prove a
Hardy-Littlewood asymptotic.
-/

import Lean.Elab.Tactic.Omega
import NumBridge.GeneralFirstSubcriticalSacrifice

namespace NumBridge

/-- Every translated offset is locally prime. -/
def PrimeTupleTranslate (H : List Nat) (n : Nat) : Prop :=
  ∀ h : Nat, h ∈ H → Prime (n + h)

/-- Every translated offset lies above every gate. -/
def TupleAboveAllGates (gates H : List Nat) (n : Nat) : Prop :=
  ∀ g : Nat, g ∈ gates → ∀ h : Nat, h ∈ H → g < n + h

/-- A prime tuple translate whose entries are larger than the gate moduli. -/
def PrimeTupleTranslateAboveGates (gates H : List Nat) (n : Nat) : Prop :=
  PrimeTupleTranslate H n ∧ TupleAboveAllGates gates H n

/-- Boolean wheel-survivor predicate used by `WheelSurvivorCountGeneral`. -/
def WheelResidueSurvivorBool (gates H : List Nat) (a : Nat) : Bool :=
  gates.all (fun g => GateGoodResidue g H (a % g))

/-- Propositional wheel-survivor predicate: no offset is zero at any gate. -/
def WheelResidueSurvivor (gates H : List Nat) (a : Nat) : Prop :=
  ∀ g : Nat, g ∈ gates → ∀ h : Nat, h ∈ H → (a + h) % g ≠ 0

/-- A prime larger than a gate is not divisible by that gate. -/
theorem prime_above_gate_not_dvd
    {m g : Nat} (hm : Prime m) (hg : 1 < g) (hgt : g < m) :
    m % g ≠ 0 := by
  intro hmod
  have hdvd : g ∣ m := Nat.dvd_of_mod_eq_zero hmod
  have hcase := hm.2 g hdvd
  rcases hcase with hg1 | hgm
  · omega
  · omega

/-- Reducing `n` modulo a wheel preserves every gate coordinate. -/
theorem add_mod_gate_of_dvd_wheel
    {W g n h : Nat} (hgdvd : g ∣ W) :
    ((n % W) + h) % g = (n + h) % g := by
  calc
    ((n % W) + h) % g = (((n % W) % g) + h) % g := by
      rw [Nat.mod_add_mod]
    _ = ((n % g) + h) % g := by
      rw [Nat.mod_mod_of_dvd n hgdvd]
    _ = (n + h) % g := by
      rw [← Nat.mod_add_mod n g h]

/-- A prime tuple translate above the gates avoids every local gate residue. -/
theorem prime_translate_avoids_each_gate_residue
    {gates H : List Nat} {n g h : Nat}
    (hgt : GatesAboveOne gates)
    (hprime : PrimeTupleTranslateAboveGates gates H n)
    (hgmem : g ∈ gates) (hhmem : h ∈ H) :
    (n + h) % g ≠ 0 := by
  exact prime_above_gate_not_dvd
    (hprime.left h hhmem)
    (hgt g hgmem)
    (hprime.right g hgmem h hhmem)

/-- Prime tuple translates above all gates land in wheel-survivor residues. -/
theorem prime_tuple_translate_implies_wheel_survivor
    {gates H : List Nat} {n : Nat}
    (hgt : GatesAboveOne gates)
    (hprime : PrimeTupleTranslateAboveGates gates H n) :
    WheelResidueSurvivor gates H (n % gateProduct gates) := by
  intro g hgmem h hhmem
  have hgpos : 0 < g := by
    have hg := hgt g hgmem
    omega
  have hgdvd : g ∣ gateProduct gates := dvd_gateProduct_of_mem hgmem
  rw [add_mod_gate_of_dvd_wheel (W := gateProduct gates) (g := g) (n := n) (h := h)
    hgdvd]
  exact prime_translate_avoids_each_gate_residue hgt hprime hgmem hhmem

/-- The Boolean wheel-survivor predicate is true from the propositional one. -/
theorem wheel_residue_survivor_bool_of_prop
    {gates H : List Nat} {a : Nat}
    (hsurv : WheelResidueSurvivor gates H a) :
    WheelResidueSurvivorBool gates H a = true := by
  unfold WheelResidueSurvivorBool
  rw [List.all_eq_true]
  intro g hg
  have hbadfalse : GateBadResidue g H (a % g) = false := by
    unfold GateBadResidue
    apply Bool.eq_false_iff.mpr
    intro hbad
    rcases List.any_eq_true.mp hbad with ⟨h, hhmem, hzero⟩
    have hz : ((a % g) + h) % g = 0 := beq_iff_eq.mp hzero
    have heq : ((a % g) + h) % g = (a + h) % g := by
      rw [Nat.mod_add_mod]
    rw [heq] at hz
    exact hsurv g hg h hhmem hz
  simp [GateGoodResidue, hbadfalse]

/-- Boolean form of the prime-translate-to-wheel-survivor bridge. -/
theorem prime_tuple_translate_implies_wheel_survivor_bool
    {gates H : List Nat} {n : Nat}
    (hgt : GatesAboveOne gates)
    (hprime : PrimeTupleTranslateAboveGates gates H n) :
    WheelResidueSurvivorBool gates H (n % gateProduct gates) = true := by
  exact wheel_residue_survivor_bool_of_prop
    (prime_tuple_translate_implies_wheel_survivor hgt hprime)

/-- Monotonicity of `countP` under pointwise Boolean implication. -/
theorem countP_le_countP_of_imp_bool
    {α : Type} (l : List α) (P Q : α → Bool)
    (himp : ∀ x : α, x ∈ l → P x = true → Q x = true) :
    l.countP P ≤ l.countP Q := by
  induction l with
  | nil =>
      simp
  | cons x xs ih =>
      have htail : xs.countP P ≤ xs.countP Q := by
        apply ih
        intro y hy hPy
        exact himp y (by simp [hy]) hPy
      by_cases hP : P x = true
      · have hQ : Q x = true := himp x (by simp) hP
        simp [hP, hQ, htail]
      · have hPfalse : P x = false := Bool.eq_false_iff.mpr hP
        by_cases hQtrue : Q x = true
        · simp [hPfalse, hQtrue]
          omega
        · have hQfalse : Q x = false := Bool.eq_false_iff.mpr hQtrue
          simp [hPfalse, hQfalse, htail]

/-- One complete wheel block contains at most all survivor residues. -/
theorem one_block_count_le_wheel_survivor_count
    (P : Nat → Bool) (gates H : List Nat) {W block : Nat}
    (hP : ∀ n : Nat, P n = true → WheelResidueSurvivorBool gates H (n % W) = true) :
    (List.range W).countP (fun r => P (block * W + r)) ≤
      (List.range W).countP (WheelResidueSurvivorBool gates H) := by
  apply countP_le_countP_of_imp_bool
  intro r hr hPr
  have hrlt : r < W := List.mem_range.mp hr
  have hmod : (block * W + r) % W = r := by
    rw [Nat.add_comm]
    rw [Nat.mul_comm block W]
    exact add_mul_mod_left_eq hrlt
  have hsurv := hP (block * W + r) hPr
  rwa [hmod] at hsurv

/-- Count a sound candidate predicate across complete wheel blocks. -/
theorem count_complete_wheel_blocks_le
    (P : Nat → Bool) (gates H : List Nat) {W blocks : Nat}
    (hP : ∀ n : Nat, P n = true → WheelResidueSurvivorBool gates H (n % W) = true) :
    (List.range (blocks * W)).countP P ≤
      (List.range W).countP (WheelResidueSurvivorBool gates H) * blocks := by
  induction blocks with
  | zero =>
      simp
  | succ blocks ih =>
      rw [Nat.succ_mul, List.range_add, List.countP_append]
      have hblock :
          (List.map (fun x => blocks * W + x) (List.range W)).countP P ≤
            (List.range W).countP (WheelResidueSurvivorBool gates H) := by
        rw [List.countP_map]
        exact one_block_count_le_wheel_survivor_count P gates H hP
      have hsum := Nat.add_le_add ih hblock
      simpa [Nat.mul_succ, Nat.add_comm, Nat.add_left_comm, Nat.add_assoc] using hsum

/--
Generic wheel-block upper bound.

Any Boolean predicate whose true values imply wheel-survivor residues has at
most one complete block of candidates per survivor residue.
-/
theorem predicate_count_le_wheel_survivor_blocks
    (P : Nat → Bool) (gates H : List Nat) {W N : Nat} (hW : 0 < W)
    (hP : ∀ n : Nat, P n = true → WheelResidueSurvivorBool gates H (n % W) = true) :
    (List.range (N + 1)).countP P ≤
      (List.range W).countP (WheelResidueSurvivorBool gates H) * (N / W + 1) := by
  have hcover : N + 1 ≤ (N / W + 1) * W := by
    have hlt : N < W * (N / W + 1) := Nat.lt_mul_div_succ N hW
    have hlt' : N < (N / W + 1) * W := by
      simpa [Nat.mul_comm] using hlt
    omega
  have hsub : (List.range (N + 1)).Sublist (List.range ((N / W + 1) * W)) :=
    List.range_sublist.mpr hcover
  exact Nat.le_trans (List.Sublist.countP_le hsub)
    (count_complete_wheel_blocks_le P gates H hP)

/--
BT-0012 elementary actual-prime wheel upper bound.

If a Boolean enumerator only accepts actual prime tuple translates above the
gates, then its count up to `N` is bounded by the finite wheel survivor count
times the number of wheel blocks.
-/
theorem bt0012_prime_tuple_wheel_upper_bound
    (P : Nat → Bool) (gates H : List Nat) (N : Nat)
    (hgt : GatesAboveOne gates)
    (hP : ∀ n : Nat, P n = true → PrimeTupleTranslateAboveGates gates H n) :
    (List.range (N + 1)).countP P ≤
      WheelSurvivorCountGeneral gates H * (N / gateProduct gates + 1) := by
  have hpos : PositiveGates gates := positiveGates_of_gatesAboveOne hgt
  have hW : 0 < gateProduct gates := gateProduct_pos_of_positive hpos
  have hPs :
      ∀ n : Nat, P n = true →
        WheelResidueSurvivorBool gates H (n % gateProduct gates) = true := by
    intro n hn
    exact prime_tuple_translate_implies_wheel_survivor_bool hgt (hP n hn)
  simpa [WheelSurvivorCountGeneral, WheelResidueSurvivorBool] using
    predicate_count_le_wheel_survivor_blocks
      P gates H (W := gateProduct gates) (N := N) hW hPs

end NumBridge
