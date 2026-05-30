/-
Residue-shadow bridge layer.

This file gives standard-library-only predicates for residue coverage and the
finite-cover obstruction used by the PrimeBridge Resonance Engine.
-/

import NumBridge.PrimeConstellations

namespace NumBridge

/-- A list covers all residues modulo q when every residue below q appears as h % q. -/
def CoversResiduesMod (q : Nat) (offsets : List Nat) : Prop :=
  ∀ r : Nat, r < q → ∃ h : Nat, h ∈ offsets ∧ h % q = r

/-- Translation-zero cover: for every residue r, some offset h makes r+h vanish modulo q. -/
def TranslationZeroCover (q : Nat) (offsets : List Nat) : Prop :=
  ∀ r : Nat, r < q → ∃ h : Nat, h ∈ offsets ∧ (r + h) % q = 0

/-- General residue-cover obstruction schema used by the resonance layer. -/
theorem translation_zero_cover_hits_multiple
    (q : Nat) (hq : 0 < q) (offsets : List Nat)
    (cover : TranslationZeroCover q offsets) (n : Nat) :
    ∃ h : Nat, h ∈ offsets ∧ q ∣ n + h :=
  residue_cover_translate_hits_multiple q hq offsets cover n

/-- The concrete offsets [0,2,4] form a translation-zero cover modulo 3. -/
theorem zero_two_four_translation_zero_cover_mod_three :
    TranslationZeroCover 3 [0, 2, 4] :=
  offsets_zero_two_four_cover_mod_three

/-- The offsets [0,2,6] do not cover all residues modulo 3. -/
theorem zero_two_six_not_cover_residues_mod_three :
    ¬ CoversResiduesMod 3 [0, 2, 6] := by
  intro hcover
  obtain ⟨h, hmem, hmod⟩ := hcover 1 (by decide)
  simp at hmem
  rcases hmem with hh | hh | hh
  · subst h
    cases hmod
  · subst h
    cases hmod
  · subst h
    cases hmod

/-- The offsets [0,2] do not cover all residues modulo 2. -/
theorem zero_two_not_cover_residues_mod_two :
    ¬ CoversResiduesMod 2 [0, 2] := by
  intro hcover
  obtain ⟨h, hmem, hmod⟩ := hcover 1 (by decide)
  simp at hmem
  rcases hmem with hh | hh
  · subst h
    cases hmod
  · subst h
    cases hmod

/-- The offsets [0,2] do not cover all residues modulo 3. -/
theorem zero_two_not_cover_residues_mod_three :
    ¬ CoversResiduesMod 3 [0, 2] := by
  intro hcover
  obtain ⟨h, hmem, hmod⟩ := hcover 1 (by decide)
  simp at hmem
  rcases hmem with hh | hh
  · subst h
    cases hmod
  · subst h
    cases hmod

end NumBridge
