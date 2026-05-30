/-
BT-0013 finite Gallagher resonance conservation.

This file proves the first non-example finite Gallagher conservation layer:
single-gate and two-gate conservation for arbitrary tuple length `k`.

The arbitrary pairwise-coprime gate-list theorem is deliberately not claimed
here.  Its remaining proof obligation is the full residue-choice CRT induction.
-/

import Lean.Elab.Tactic.Omega
import NumBridge.ResonanceOptimization

namespace NumBridge

open List

/-- All length-`k` tuples drawn from an explicit finite universe. -/
def TuplesFromList : Nat → List Nat → List (List Nat)
  | 0, _ => [[]]
  | Nat.succ k, U =>
      U.flatMap (fun h => (TuplesFromList k U).map (fun tail => h :: tail))

/-- All length-`k` tuples of residues `0, ..., m - 1`. -/
def TuplesOfLength (k m : Nat) : List (List Nat) :=
  TuplesFromList k (List.range m)

theorem sum_const_list_fg {α : Type} (l : List α) (c : Nat) :
    (l.map (fun _ => c)).sum = l.length * c := by
  induction l with
  | nil => simp
  | cons _ xs ih => simp [ih, Nat.succ_mul, Nat.add_comm]

/-- `m^k` residue tuples of length `k` modulo `m`. -/
theorem tuples_from_list_length_count (k : Nat) (U : List Nat) :
    (TuplesFromList k U).length = U.length ^ k := by
  induction k with
  | zero => simp [TuplesFromList]
  | succ k ih =>
      unfold TuplesFromList
      rw [List.length_flatMap]
      have hmap :
          (List.map (fun x => (List.map (fun tail => x :: tail) (TuplesFromList k U)).length)
            U) = U.map (fun _ => U.length ^ k) := by
        apply List.map_inj_left.mpr
        intro _ _
        simp [ih]
      rw [hmap, sum_const_list_fg]
      rw [Nat.pow_succ]
      exact (Nat.mul_comm (U.length ^ k) U.length).symm

theorem tuples_length_count (k m : Nat) :
    (TuplesOfLength k m).length = m ^ k := by
  unfold TuplesOfLength
  rw [tuples_from_list_length_count, List.length_range]

theorem sum_if_eq_countP_mul_fg {α : Type} (l : List α) (P : α → Bool) (C : Nat) :
    (l.map (fun x => if P x then C else 0)).sum = l.countP P * C := by
  induction l with
  | nil => simp
  | cons a t ih =>
      by_cases h : P a
      · simp [h, ih, Nat.add_mul, Nat.add_comm]
      · simp [h, ih]

/-- Tuples whose entries all satisfy `P` are counted by `(#P)^k`. -/
theorem tuples_all_count
    (k : Nat) (U : List Nat) (P : Nat → Bool) :
    (TuplesFromList k U).countP (fun H => H.all P) =
      (U.countP P) ^ k := by
  induction k with
  | zero => simp [TuplesFromList]
  | succ k ih =>
      unfold TuplesFromList
      rw [countP_flatMap_eq_sum]
      have hblocks :
          (List.map
              (fun h => (List.map (fun tail => h :: tail) (TuplesFromList k U)).countP
                (fun H => H.all P)) U) =
            U.map (fun h => if P h then (U.countP P) ^ k else 0) := by
        apply List.map_inj_left.mpr
        intro h _
        rw [List.countP_map]
        by_cases hgood : P h
        · simpa [Function.comp_def, hgood] using ih
        · simp [Function.comp_def, hgood]
      rw [hblocks]
      rw [sum_if_eq_countP_mul_fg]
      rw [Nat.pow_succ]
      exact Nat.mul_comm (U.countP P) ((U.countP P) ^ k)

theorem countP_nonzero_range_fg (p : Nat) :
    (List.range p).countP (fun a => !(a == 0)) = p - 1 := by
  induction p with
  | zero => simp
  | succ n ih =>
      rw [List.range_succ, List.countP_append]
      change (List.range n).countP (fun a => !(a == 0)) +
          ([n].countP (fun a => !(a == 0))) = n
      rw [ih]
      by_cases hn : n = 0
      · subst n
        simp
      · simp [hn]
        omega

theorem countP_add_ne_zero_range (p r : Nat) (hp : 0 < p) :
    (List.range p).countP (fun h => !(((r + h) % p) == 0)) = p - 1 := by
  have h := affine_residue_count_eq (M := 1) (p := p) (x := r) hp
      (by simp : Nat.Coprime 1 p) (fun a => !(a == 0))
  simpa [Nat.one_mul] using h.trans (countP_nonzero_range_fg p)

/-- A tuple avoids residue `r` modulo `p` when every entry misses `-r`. -/
def AvoidsResidue (p r : Nat) (H : List Nat) : Bool :=
  H.all (fun h => !(((r + h) % p) == 0))

/-- Number of residues avoided by the tuple modulo `p`. -/
def AvoidedResidueCount (p : Nat) (H : List Nat) : Nat :=
  (List.range p).countP (fun r => AvoidsResidue p r H)

theorem list_all_not_eq_not_any_fg (H : List Nat) (P : Nat → Bool) :
    H.all (fun h => ! P h) = ! H.any P := by
  induction H with
  | nil => simp
  | cons h t ih =>
      by_cases hp : P h
      · simp [hp]
      · simp [hp, ih]

theorem gate_good_residue_eq_avoids_residue (p r : Nat) (H : List Nat) :
    GateGoodResidue p H r = AvoidsResidue p r H := by
  unfold GateGoodResidue GateBadResidue AvoidsResidue
  rw [list_all_not_eq_not_any_fg]
  by_cases hb : H.any (fun h => (r + h) % p == 0)
  · simp [hb]
  · simp [hb]

theorem avoided_residue_count_eq_local_gate_survivor_count (p : Nat) (H : List Nat) :
    AvoidedResidueCount p H = LocalGateSurvivorCount p H := by
  unfold AvoidedResidueCount LocalGateSurvivorCount
  apply List.countP_congr
  intro r _
  rw [gate_good_residue_eq_avoids_residue]

theorem tuples_avoiding_fixed_residue_count
    (p k r : Nat) (hp : 0 < p) :
    (TuplesOfLength k p).countP (AvoidsResidue p r) = (p - 1) ^ k := by
  unfold TuplesOfLength AvoidsResidue
  rw [tuples_all_count]
  rw [countP_add_ne_zero_range p r hp]

theorem sum_map_zero_fg {α : Type} (l : List α) :
    (l.map (fun _ => 0)).sum = 0 := by
  induction l with
  | nil => simp
  | cons _ xs ih => simp [ih]

theorem sum_map_add_fg {α : Type} (l : List α) (f g : α → Nat) :
    (l.map (fun x => f x + g x)).sum = (l.map f).sum + (l.map g).sum := by
  induction l with
  | nil => simp
  | cons _ xs ih => simp [ih, Nat.add_assoc, Nat.add_left_comm]

theorem sum_map_indicator_eq_countP_fg {α : Type} (l : List α) (P : α → Bool) :
    (l.map (fun x => if P x then 1 else 0)).sum = l.countP P := by
  induction l with
  | nil => simp
  | cons x xs ih =>
      by_cases h : P x
      · simp [h, ih, Nat.add_comm]
      · simp [h, ih]

/-- Swap a finite sum of finite counts. -/
theorem sum_countP_swap_fg {α β : Type} (xs : List α) (ys : List β) (P : α → β → Bool) :
    (xs.map (fun x => ys.countP (fun y => P x y))).sum =
      (ys.map (fun y => xs.countP (fun x => P x y))).sum := by
  induction xs with
  | nil => simp [sum_map_zero_fg]
  | cons x xs ih =>
      calc
        ((x :: xs).map (fun x => ys.countP (fun y => P x y))).sum
            = ys.countP (fun y => P x y) +
                (xs.map (fun x => ys.countP (fun y => P x y))).sum := by simp
        _ = ys.countP (fun y => P x y) +
              (ys.map (fun y => xs.countP (fun x => P x y))).sum := by rw [ih]
        _ = (ys.map (fun y => (if P x y then 1 else 0))).sum +
              (ys.map (fun y => xs.countP (fun x => P x y))).sum := by
              rw [sum_map_indicator_eq_countP_fg]
        _ = (ys.map (fun y => (if P x y then 1 else 0) +
              xs.countP (fun x => P x y))).sum := by
              rw [sum_map_add_fg]
        _ = (ys.map (fun y => (x :: xs).countP (fun x => P x y))).sum := by
              apply congrArg List.sum
              apply List.map_congr_left
              intro y _
              by_cases h : P x y
              · simp [h, Nat.add_comm]
              · simp [h]

/--
Single-gate finite Gallagher conservation.

Summing avoided residues over all length-`k` tuples modulo `p` gives
`p * (p - 1)^k`.
-/
theorem single_gate_avoided_residue_sum
    (p k : Nat) (hp : 0 < p) :
    ((TuplesOfLength k p).map (AvoidedResidueCount p)).sum =
      p * (p - 1) ^ k := by
  unfold AvoidedResidueCount
  rw [sum_countP_swap_fg]
  have hmap :
      (List.map
          (fun r => (TuplesOfLength k p).countP (fun x => AvoidsResidue p r x))
          (List.range p)) =
        (List.range p).map (fun _ => (p - 1) ^ k) := by
    apply List.map_inj_left.mpr
    intro r _
    exact tuples_avoiding_fixed_residue_count p k r hp
  rw [hmap]
  exact sum_const_range p ((p - 1) ^ k)

theorem single_gate_local_survivor_sum
    (p k : Nat) (hp : 0 < p) :
    ((TuplesOfLength k p).map (LocalGateSurvivorCount p)).sum =
      p * (p - 1) ^ k := by
  have hrewrite :
      ((TuplesOfLength k p).map (LocalGateSurvivorCount p)).sum =
        ((TuplesOfLength k p).map (AvoidedResidueCount p)).sum := by
    apply congrArg List.sum
    apply List.map_congr_left
    intro H _
    rw [avoided_residue_count_eq_local_gate_survivor_count]
  rw [hrewrite]
  exact single_gate_avoided_residue_sum p k hp

def ResiduePairs (p q : Nat) : List (Nat × Nat) :=
  (List.range p).flatMap (fun r => (List.range q).map (fun s => (r, s)))

def AvoidsResiduePair (p q : Nat) (pair : Nat × Nat) (H : List Nat) : Bool :=
  AvoidsResidue p pair.fst H && AvoidsResidue q pair.snd H

def PairAvoidedResidueCount (p q : Nat) (H : List Nat) : Nat :=
  (ResiduePairs p q).countP (fun pair => AvoidsResiduePair p q pair H)

theorem pair_avoided_residue_count_eq_product
    (p q : Nat) (H : List Nat) :
    PairAvoidedResidueCount p q H = AvoidedResidueCount p H * AvoidedResidueCount q H := by
  unfold PairAvoidedResidueCount ResiduePairs AvoidedResidueCount AvoidsResiduePair
  rw [countP_flatMap_eq_sum]
  have hblocks :
      (List.map
          (fun r => (List.map (fun s => (r, s)) (List.range q)).countP
            (fun pair => AvoidsResidue p pair.fst H && AvoidsResidue q pair.snd H))
          (List.range p)) =
        (List.range p).map
          (fun r =>
            if AvoidsResidue p r H then
              (List.range q).countP (fun s => AvoidsResidue q s H)
            else 0) := by
    apply List.map_inj_left.mpr
    intro r _
    rw [List.countP_map]
    by_cases hr : AvoidsResidue p r H
    · simp [Function.comp_def, hr]
    · simp [Function.comp_def, hr]
  rw [hblocks]
  rw [sum_if_eq_countP_mul_fg]

theorem countP_pair_avoids_single_entry
    {p q : Nat} (hp : 0 < p) (hq : 0 < q) (hcop : Nat.Coprime p q) (r s : Nat) :
    (List.range (p * q)).countP
      (fun h => !(((r + h) % p) == 0) && !(((s + h) % q) == 0)) =
      (p - 1) * (q - 1) := by
  let Pp := fun x => !(((r + x) % p) == 0)
  let Pq := fun x => !(((s + x) % q) == 0)
  have hcrt := crt_count_product_two_moduli (M := p) (p := q) hp hq hcop Pp Pq
  have hpcount : (List.range p).countP Pp = p - 1 := by
    unfold Pp
    exact countP_add_ne_zero_range p r hp
  have hqcount : (List.range q).countP Pq = q - 1 := by
    unfold Pq
    exact countP_add_ne_zero_range q s hq
  simpa [Pp, Pq, hpcount, hqcount] using hcrt

theorem list_all_and_fg (H : List Nat) (P Q : Nat → Bool) :
    H.all (fun h => P h && Q h) = (H.all P && H.all Q) := by
  induction H with
  | nil => simp
  | cons _ _ ih => simp [ih, Bool.and_assoc, Bool.and_left_comm]

theorem tuples_avoiding_fixed_residue_pair_count
    {p q : Nat} (hp : 0 < p) (hq : 0 < q) (hcop : Nat.Coprime p q)
    (k r s : Nat) :
    (TuplesOfLength k (p * q)).countP
      (fun H => AvoidsResidue p r H && AvoidsResidue q s H) =
      ((p - 1) * (q - 1)) ^ k := by
  unfold TuplesOfLength AvoidsResidue
  let P := fun h => !(((r + h) % p) == 0) && !(((s + h) % q) == 0)
  have hcount :
      (TuplesFromList k (List.range (p * q))).countP
          (fun H => (H.all fun h => !(((r + h) % p) == 0)) &&
            H.all fun h => !(((s + h) % q) == 0)) =
        (TuplesFromList k (List.range (p * q))).countP (fun H => H.all P) := by
    apply List.countP_congr
    intro H _
    unfold P
    rw [list_all_and_fg]
  rw [hcount]
  rw [tuples_all_count]
  unfold P
  rw [countP_pair_avoids_single_entry hp hq hcop r s]

/--
Two-gate finite Gallagher conservation.

For coprime positive gates `p` and `q`, summing the product of avoided local
counts over all length-`k` tuples modulo `p*q` gives
`p*q*(p-1)^k*(q-1)^k`.
-/
theorem two_gate_finite_gallagher_conservation
    {p q : Nat} (hp : 0 < p) (hq : 0 < q) (hcop : Nat.Coprime p q) (k : Nat) :
    ((TuplesOfLength k (p * q)).map
        (fun H => AvoidedResidueCount p H * AvoidedResidueCount q H)).sum =
      p * q * (p - 1) ^ k * (q - 1) ^ k := by
  have hpairprod :
      ((TuplesOfLength k (p * q)).map
          (fun H => AvoidedResidueCount p H * AvoidedResidueCount q H)).sum =
        ((TuplesOfLength k (p * q)).map (PairAvoidedResidueCount p q)).sum := by
    apply congrArg List.sum
    apply List.map_congr_left
    intro H _
    rw [pair_avoided_residue_count_eq_product]
  rw [hpairprod]
  unfold PairAvoidedResidueCount
  rw [sum_countP_swap_fg]
  have hmap :
      (List.map
          (fun pair => (TuplesOfLength k (p * q)).countP
            (fun H => AvoidsResiduePair p q pair H))
          (ResiduePairs p q)) =
        (ResiduePairs p q).map (fun _ => ((p - 1) * (q - 1)) ^ k) := by
    apply List.map_inj_left.mpr
    intro pair _
    cases pair with
    | mk r s =>
        exact tuples_avoiding_fixed_residue_pair_count hp hq hcop k r s
  rw [hmap]
  have hlen : (ResiduePairs p q).length = p * q := by
    unfold ResiduePairs
    rw [List.length_flatMap]
    have hblocks :
        (List.map (fun r => (List.map (fun s => (r, s)) (List.range q)).length)
          (List.range p)) =
          (List.range p).map (fun _ => q) := by
      apply List.map_inj_left.mpr
      intro _ _
      simp
    rw [hblocks, sum_const_range]
  rw [sum_const_list_fg, hlen]
  rw [Nat.mul_pow]
  simp [Nat.mul_assoc]

theorem two_gate_finite_gallagher_conservation_local
    {p q : Nat} (hp : 0 < p) (hq : 0 < q) (hcop : Nat.Coprime p q) (k : Nat) :
    ((TuplesOfLength k (p * q)).map
        (fun H => LocalGateSurvivorCount p H * LocalGateSurvivorCount q H)).sum =
      p * q * (p - 1) ^ k * (q - 1) ^ k := by
  have hrewrite :
      ((TuplesOfLength k (p * q)).map
          (fun H => LocalGateSurvivorCount p H * LocalGateSurvivorCount q H)).sum =
        ((TuplesOfLength k (p * q)).map
          (fun H => AvoidedResidueCount p H * AvoidedResidueCount q H)).sum := by
    apply congrArg List.sum
    apply List.map_congr_left
    intro H _
    rw [avoided_residue_count_eq_local_gate_survivor_count,
      avoided_residue_count_eq_local_gate_survivor_count]
  rw [hrewrite]
  exact two_gate_finite_gallagher_conservation hp hq hcop k

/-- Main BT-0013 theorem closed in this pass: arbitrary-`k`, two-gate conservation. -/
theorem bt0013_two_gate_finite_gallagher_resonance_conservation
    {p q : Nat} (hp : 0 < p) (hq : 0 < q) (hcop : Nat.Coprime p q) (k : Nat) :
    ((TuplesOfLength k (p * q)).map
        (fun H => LocalGateSurvivorCount p H * LocalGateSurvivorCount q H)).sum =
      p * q * (p - 1) ^ k * (q - 1) ^ k :=
  two_gate_finite_gallagher_conservation_local hp hq hcop k

end NumBridge
