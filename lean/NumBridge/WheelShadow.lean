/-
Wheel-shadow finite-sieve facts.

This standard-library-only layer proves concrete wheel residue facts and leaves
the full squarefree product theorem as a roadmap target.
-/

import NumBridge.PrimePatternResonance

namespace NumBridge

set_option linter.unnecessarySimpa false

/-- A pattern survives a list of prime gates when no offset lands at 0 modulo any gate. -/
def SurvivesOffsetsMod (mods offsets : List Nat) (a : Nat) : Prop :=
  ∀ p : Nat, p ∈ mods → ∀ h : Nat, h ∈ offsets → (a + h) % p ≠ 0

/-- For the twin pattern `[0,2]`, the only wheel-6 survivor residue is 5. -/
theorem twin_survives_mod_two_three_iff_mod_six_five (a : Nat) :
    SurvivesOffsetsMod [2, 3] [0, 2] a ↔ a % 6 = 5 := by
  constructor
  · intro hsurv
    have hlt : a % 6 < 6 := Nat.mod_lt a (by decide)
    cases h : a % 6 with
    | zero =>
        have h2 : a % 2 = 0 := by
          rw [← Nat.mod_mod_of_dvd a (show 2 ∣ 6 by exists 3)]
          rw [h]
        exact False.elim ((hsurv 2 (by simp) 0 (by simp)) (by simpa using h2))
    | succ r1 => cases r1 with
      | zero =>
          have h3 : (a + 2) % 3 = 0 := by
            rw [Nat.add_mod]
            have ha3 : a % 3 = 1 := by
              rw [← Nat.mod_mod_of_dvd a (show 3 ∣ 6 by exists 2)]
              rw [h]
            rw [ha3]
          exact False.elim ((hsurv 3 (by simp) 2 (by simp)) h3)
      | succ r2 => cases r2 with
        | zero =>
            have h2 : a % 2 = 0 := by
              rw [← Nat.mod_mod_of_dvd a (show 2 ∣ 6 by exists 3)]
              rw [h]
            exact False.elim ((hsurv 2 (by simp) 0 (by simp)) (by simpa using h2))
        | succ r3 => cases r3 with
          | zero =>
              have h3 : a % 3 = 0 := by
                rw [← Nat.mod_mod_of_dvd a (show 3 ∣ 6 by exists 2)]
                rw [h]
              exact False.elim ((hsurv 3 (by simp) 0 (by simp)) (by simpa using h3))
          | succ r4 => cases r4 with
            | zero =>
                have h2 : a % 2 = 0 := by
                  rw [← Nat.mod_mod_of_dvd a (show 2 ∣ 6 by exists 3)]
                  rw [h]
                exact False.elim ((hsurv 2 (by simp) 0 (by simp)) (by simpa using h2))
            | succ r5 => cases r5 with
              | zero => simpa using h
              | succ r6 =>
                  rw [h] at hlt
                  have hge : 6 ≤ r6 + 1 + 1 + 1 + 1 + 1 + 1 := by
                    exact Nat.le_add_left 6 r6
                  exact False.elim (Nat.not_lt_of_ge hge hlt)
  · intro h5
    intro p hp h hoff hzero
    simp at hp
    simp at hoff
    rcases hp with hp | hp
    · subst p
      rcases hoff with hh | hh
      · subst h
        have ha2 : (a + 0) % 2 = 1 := by
          rw [Nat.add_zero]
          rw [← Nat.mod_mod_of_dvd a (show 2 ∣ 6 by exists 3)]
          rw [h5]
        rw [hzero] at ha2
        cases ha2
      · subst h
        have ha2 : (a + 2) % 2 = 1 := by
          rw [Nat.add_mod]
          have ha : a % 2 = 1 := by
            rw [← Nat.mod_mod_of_dvd a (show 2 ∣ 6 by exists 3)]
            rw [h5]
          rw [ha]
        rw [hzero] at ha2
        cases ha2
    · subst p
      rcases hoff with hh | hh
      · subst h
        have ha3 : (a + 0) % 3 = 2 := by
          rw [Nat.add_zero]
          rw [← Nat.mod_mod_of_dvd a (show 3 ∣ 6 by exists 2)]
          rw [h5]
        rw [hzero] at ha3
        cases ha3
      · subst h
        have ha3 : (a + 2) % 3 = 1 := by
          rw [Nat.add_mod]
          have ha : a % 3 = 2 := by
            rw [← Nat.mod_mod_of_dvd a (show 3 ∣ 6 by exists 2)]
            rw [h5]
          rw [ha]
        rw [hzero] at ha3
        cases ha3

/-- The pattern `[0,2,4]` has no survivor through the 2,3 wheel gates. -/
theorem zero_two_four_no_survivor_mod_two_three (a : Nat) :
    ¬ SurvivesOffsetsMod [2, 3] [0, 2, 4] a := by
  intro hsurv
  rcases triplet_mod_three_sieve_gate a with h0 | h2 | h4
  · have hm : a % 3 = 0 := Nat.mod_eq_zero_of_dvd h0
    exact (hsurv 3 (by simp) 0 (by simp)) (by simpa using hm)
  · have hm : (a + 2) % 3 = 0 := Nat.mod_eq_zero_of_dvd h2
    exact (hsurv 3 (by simp) 2 (by simp)) hm
  · have hm : (a + 4) % 3 = 0 := Nat.mod_eq_zero_of_dvd h4
    exact (hsurv 3 (by simp) 4 (by simp)) hm

/-- Product-side arithmetic for the `[0,2,6]` pattern over the 2,3,5 wheel. -/
theorem zero_two_six_wheel30_product_count_arithmetic :
    (2 - 1) * (3 - 2) * (5 - 3) = 2 := by
  rfl

end NumBridge
