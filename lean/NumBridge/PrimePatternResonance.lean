/-
Prime-pattern resonance bridge layer.

Symbolic resonance is modeled as residue-shadow survival under small prime
moduli. This file records the Lean-visible bridge theorems for the first
resonance engine.
-/

import NumBridge.ResidueShadow

namespace NumBridge

/-- BT-0005 concrete resonance obstruction: the triplet shadow collapses modulo 3. -/
theorem resonance_triplet_obstructed_mod_three (n : Nat) :
    3 ∣ n ∨ 3 ∣ n + 2 ∨ 3 ∣ n + 4 :=
  triplet_mod_three_sieve_gate n

/-- The pattern [0,2,6] avoids total residue collapse modulo 3. -/
theorem resonance_zero_two_six_survives_mod_three :
    ¬ CoversResiduesMod 3 [0, 2, 6] :=
  zero_two_six_not_cover_residues_mod_three

/-- The twin-prime pattern [0,2] avoids total residue collapse modulo 2 and 3. -/
theorem resonance_zero_two_survives_mod_two_and_three :
    ¬ CoversResiduesMod 2 [0, 2] ∧ ¬ CoversResiduesMod 3 [0, 2] :=
  ⟨zero_two_not_cover_residues_mod_two, zero_two_not_cover_residues_mod_three⟩

/-- General search-enabling bridge: translation-zero covers force a sieve hit. -/
theorem resonance_cover_forces_sieve_hit
    (q : Nat) (hq : 0 < q) (offsets : List Nat)
    (cover : TranslationZeroCover q offsets) (n : Nat) :
    ∃ h : Nat, h ∈ offsets ∧ q ∣ n + h :=
  translation_zero_cover_hits_multiple q hq offsets cover n

end NumBridge
