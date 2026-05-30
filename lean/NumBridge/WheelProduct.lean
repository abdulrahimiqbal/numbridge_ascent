/-
BT-0006 product-formula formalization layer.

This file pushes the wheel-shadow theorem beyond concrete named patterns:
for arbitrary finite offset lists, it proves the local `p - nu_p(H)` gate count
and exact product formulas for the squarefree wheels 6 = 2 * 3 and
30 = 2 * 3 * 5.

The remaining full theorem is the arbitrary squarefree-wheel CRT/cardinality
statement.
-/

import Init.Data.List.Count
import NumBridge.WheelShadow

namespace NumBridge

/-- A residue is locally blocked modulo `p` when some offset lands at zero. -/
def GateBadResidue (p : Nat) (offsets : List Nat) (a : Nat) : Bool :=
  offsets.any (fun h => (a + h) % p == 0)

/-- A residue survives one prime gate when no offset lands at zero. -/
def GateGoodResidue (p : Nat) (offsets : List Nat) (a : Nat) : Bool :=
  ¬ GateBadResidue p offsets a

/-- The local residue-shadow size `nu_p(H)`, counted among residues `0..p-1`. -/
def LocalResidueShadowCount (p : Nat) (offsets : List Nat) : Nat :=
  (List.range p).countP (GateBadResidue p offsets)

/-- The number of locally surviving residue classes modulo `p`. -/
def LocalGateSurvivorCount (p : Nat) (offsets : List Nat) : Nat :=
  (List.range p).countP (GateGoodResidue p offsets)

/-- Product of local survivor counts over a list of gates. -/
def ProductLocalGateSurvivorCount (mods offsets : List Nat) : Nat :=
  (mods.map (fun p => LocalGateSurvivorCount p offsets)).foldr (fun a b => a * b) 1

/-- Local gate survivors are exactly `p - nu_p(H)` for every offset list. -/
theorem local_gate_survivor_count_eq_modulus_sub_shadow (p : Nat) (offsets : List Nat) :
    LocalGateSurvivorCount p offsets = p - LocalResidueShadowCount p offsets := by
  unfold LocalGateSurvivorCount LocalResidueShadowCount GateGoodResidue
  have h := List.length_eq_countP_add_countP (p := GateBadResidue p offsets) (l := List.range p)
  rw [List.length_range] at h
  rw [Nat.add_comm] at h
  exact Nat.eq_sub_of_add_eq h.symm

/-- Count true entries in a Boolean list. -/
def boolCount (xs : List Bool) : Nat :=
  xs.countP id

/-- Boolean CRT table for the squarefree wheel `2 * 3`. -/
theorem bool_product_two_three
    (b20 b21 b30 b31 b32 : Bool) :
    boolCount [b20 && b30, b21 && b31, b20 && b32,
      b21 && b30, b20 && b31, b21 && b32] =
    boolCount [b20, b21] * boolCount [b30, b31, b32] := by
  decide +revert

/-- Boolean CRT table for the squarefree wheel `2 * 3 * 5`. -/
theorem bool_product_two_three_five
    (b20 b21 b30 b31 b32 b50 b51 b52 b53 b54 : Bool) :
    boolCount [b20 && b30 && b50, b21 && b31 && b51, b20 && b32 && b52,
      b21 && b30 && b53, b20 && b31 && b54, b21 && b32 && b50,
      b20 && b30 && b51, b21 && b31 && b52, b20 && b32 && b53,
      b21 && b30 && b54, b20 && b31 && b50, b21 && b32 && b51,
      b20 && b30 && b52, b21 && b31 && b53, b20 && b32 && b54,
      b21 && b30 && b50, b20 && b31 && b51, b21 && b32 && b52,
      b20 && b30 && b53, b21 && b31 && b54, b20 && b32 && b50,
      b21 && b30 && b51, b20 && b31 && b52, b21 && b32 && b53,
      b20 && b30 && b54, b21 && b31 && b50, b20 && b32 && b51,
      b21 && b30 && b52, b20 && b31 && b53, b21 && b32 && b54] =
    boolCount [b20, b21] * boolCount [b30, b31, b32] *
      boolCount [b50, b51, b52, b53, b54] := by
  decide +revert

/-- Surviving residues through the 6-wheel, expressed by local gate coordinates. -/
def Wheel6ResidueSurvivorCount (offsets : List Nat) : Nat :=
  (List.range 6).countP (fun a =>
    GateGoodResidue 2 offsets (a % 2) && GateGoodResidue 3 offsets (a % 3))

/-- Exact 6-wheel product formula for every finite offset list. -/
theorem wheel6_residue_product_formula (offsets : List Nat) :
    Wheel6ResidueSurvivorCount offsets =
      LocalGateSurvivorCount 2 offsets * LocalGateSurvivorCount 3 offsets := by
  unfold Wheel6ResidueSurvivorCount LocalGateSurvivorCount
  change boolCount [GateGoodResidue 2 offsets 0 && GateGoodResidue 3 offsets 0,
      GateGoodResidue 2 offsets 1 && GateGoodResidue 3 offsets 1,
      GateGoodResidue 2 offsets 0 && GateGoodResidue 3 offsets 2,
      GateGoodResidue 2 offsets 1 && GateGoodResidue 3 offsets 0,
      GateGoodResidue 2 offsets 0 && GateGoodResidue 3 offsets 1,
      GateGoodResidue 2 offsets 1 && GateGoodResidue 3 offsets 2] =
    boolCount [GateGoodResidue 2 offsets 0, GateGoodResidue 2 offsets 1] *
      boolCount [GateGoodResidue 3 offsets 0, GateGoodResidue 3 offsets 1,
        GateGoodResidue 3 offsets 2]
  exact bool_product_two_three
    (GateGoodResidue 2 offsets 0) (GateGoodResidue 2 offsets 1)
    (GateGoodResidue 3 offsets 0) (GateGoodResidue 3 offsets 1)
    (GateGoodResidue 3 offsets 2)

/-- Exact 6-wheel product formula in the `p - nu_p(H)` form. -/
theorem wheel6_residue_product_formula_as_shadow_sub (offsets : List Nat) :
    Wheel6ResidueSurvivorCount offsets =
      (2 - LocalResidueShadowCount 2 offsets) *
        (3 - LocalResidueShadowCount 3 offsets) := by
  rw [wheel6_residue_product_formula,
    local_gate_survivor_count_eq_modulus_sub_shadow,
    local_gate_survivor_count_eq_modulus_sub_shadow]

/-- Surviving residues through the 30-wheel, expressed by local gate coordinates. -/
def Wheel30ResidueSurvivorCount (offsets : List Nat) : Nat :=
  (List.range 30).countP (fun a =>
    (GateGoodResidue 2 offsets (a % 2) && GateGoodResidue 3 offsets (a % 3)) &&
      GateGoodResidue 5 offsets (a % 5))

/-- Exact 30-wheel product formula for every finite offset list. -/
theorem wheel30_residue_product_formula (offsets : List Nat) :
    Wheel30ResidueSurvivorCount offsets =
      LocalGateSurvivorCount 2 offsets * LocalGateSurvivorCount 3 offsets *
        LocalGateSurvivorCount 5 offsets := by
  unfold Wheel30ResidueSurvivorCount LocalGateSurvivorCount
  change boolCount [GateGoodResidue 2 offsets 0 && GateGoodResidue 3 offsets 0 && GateGoodResidue 5 offsets 0,
      GateGoodResidue 2 offsets 1 && GateGoodResidue 3 offsets 1 && GateGoodResidue 5 offsets 1,
      GateGoodResidue 2 offsets 0 && GateGoodResidue 3 offsets 2 && GateGoodResidue 5 offsets 2,
      GateGoodResidue 2 offsets 1 && GateGoodResidue 3 offsets 0 && GateGoodResidue 5 offsets 3,
      GateGoodResidue 2 offsets 0 && GateGoodResidue 3 offsets 1 && GateGoodResidue 5 offsets 4,
      GateGoodResidue 2 offsets 1 && GateGoodResidue 3 offsets 2 && GateGoodResidue 5 offsets 0,
      GateGoodResidue 2 offsets 0 && GateGoodResidue 3 offsets 0 && GateGoodResidue 5 offsets 1,
      GateGoodResidue 2 offsets 1 && GateGoodResidue 3 offsets 1 && GateGoodResidue 5 offsets 2,
      GateGoodResidue 2 offsets 0 && GateGoodResidue 3 offsets 2 && GateGoodResidue 5 offsets 3,
      GateGoodResidue 2 offsets 1 && GateGoodResidue 3 offsets 0 && GateGoodResidue 5 offsets 4,
      GateGoodResidue 2 offsets 0 && GateGoodResidue 3 offsets 1 && GateGoodResidue 5 offsets 0,
      GateGoodResidue 2 offsets 1 && GateGoodResidue 3 offsets 2 && GateGoodResidue 5 offsets 1,
      GateGoodResidue 2 offsets 0 && GateGoodResidue 3 offsets 0 && GateGoodResidue 5 offsets 2,
      GateGoodResidue 2 offsets 1 && GateGoodResidue 3 offsets 1 && GateGoodResidue 5 offsets 3,
      GateGoodResidue 2 offsets 0 && GateGoodResidue 3 offsets 2 && GateGoodResidue 5 offsets 4,
      GateGoodResidue 2 offsets 1 && GateGoodResidue 3 offsets 0 && GateGoodResidue 5 offsets 0,
      GateGoodResidue 2 offsets 0 && GateGoodResidue 3 offsets 1 && GateGoodResidue 5 offsets 1,
      GateGoodResidue 2 offsets 1 && GateGoodResidue 3 offsets 2 && GateGoodResidue 5 offsets 2,
      GateGoodResidue 2 offsets 0 && GateGoodResidue 3 offsets 0 && GateGoodResidue 5 offsets 3,
      GateGoodResidue 2 offsets 1 && GateGoodResidue 3 offsets 1 && GateGoodResidue 5 offsets 4,
      GateGoodResidue 2 offsets 0 && GateGoodResidue 3 offsets 2 && GateGoodResidue 5 offsets 0,
      GateGoodResidue 2 offsets 1 && GateGoodResidue 3 offsets 0 && GateGoodResidue 5 offsets 1,
      GateGoodResidue 2 offsets 0 && GateGoodResidue 3 offsets 1 && GateGoodResidue 5 offsets 2,
      GateGoodResidue 2 offsets 1 && GateGoodResidue 3 offsets 2 && GateGoodResidue 5 offsets 3,
      GateGoodResidue 2 offsets 0 && GateGoodResidue 3 offsets 0 && GateGoodResidue 5 offsets 4,
      GateGoodResidue 2 offsets 1 && GateGoodResidue 3 offsets 1 && GateGoodResidue 5 offsets 0,
      GateGoodResidue 2 offsets 0 && GateGoodResidue 3 offsets 2 && GateGoodResidue 5 offsets 1,
      GateGoodResidue 2 offsets 1 && GateGoodResidue 3 offsets 0 && GateGoodResidue 5 offsets 2,
      GateGoodResidue 2 offsets 0 && GateGoodResidue 3 offsets 1 && GateGoodResidue 5 offsets 3,
      GateGoodResidue 2 offsets 1 && GateGoodResidue 3 offsets 2 && GateGoodResidue 5 offsets 4] =
    boolCount [GateGoodResidue 2 offsets 0, GateGoodResidue 2 offsets 1] *
      boolCount [GateGoodResidue 3 offsets 0, GateGoodResidue 3 offsets 1,
        GateGoodResidue 3 offsets 2] *
      boolCount [GateGoodResidue 5 offsets 0, GateGoodResidue 5 offsets 1,
        GateGoodResidue 5 offsets 2, GateGoodResidue 5 offsets 3,
        GateGoodResidue 5 offsets 4]
  exact bool_product_two_three_five
    (GateGoodResidue 2 offsets 0) (GateGoodResidue 2 offsets 1)
    (GateGoodResidue 3 offsets 0) (GateGoodResidue 3 offsets 1)
    (GateGoodResidue 3 offsets 2)
    (GateGoodResidue 5 offsets 0) (GateGoodResidue 5 offsets 1)
    (GateGoodResidue 5 offsets 2) (GateGoodResidue 5 offsets 3)
    (GateGoodResidue 5 offsets 4)

/-- Exact 30-wheel product formula in the `p - nu_p(H)` form. -/
theorem wheel30_residue_product_formula_as_shadow_sub (offsets : List Nat) :
    Wheel30ResidueSurvivorCount offsets =
      (2 - LocalResidueShadowCount 2 offsets) *
        (3 - LocalResidueShadowCount 3 offsets) *
        (5 - LocalResidueShadowCount 5 offsets) := by
  rw [wheel30_residue_product_formula,
    local_gate_survivor_count_eq_modulus_sub_shadow,
    local_gate_survivor_count_eq_modulus_sub_shadow,
    local_gate_survivor_count_eq_modulus_sub_shadow]

end NumBridge
