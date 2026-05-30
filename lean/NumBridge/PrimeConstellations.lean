/-
Prime constellation sieve gates.

BT-0004: prime patterns survive only when they avoid total residue collapse.
-/

import NumBridge.PrimeDigitalRoot

namespace NumBridge

/-- If a local prime is divisible by 3, it is 3. -/
theorem prime_eq_three_of_three_dvd (p : Nat) (hp : Prime p) (h : 3 ∣ p) : p = 3 := by
  have hcase := hp.2 3 h
  rcases hcase with h31 | h3p
  · cases h31
  · exact h3p.symm

/-- Every natural number is congruent to 0, 1, or 2 modulo 3. -/
theorem mod_three_cases (n : Nat) : n % 3 = 0 ∨ n % 3 = 1 ∨ n % 3 = 2 := by
  have hlt : n % 3 < 3 := Nat.mod_lt n (by decide)
  cases h : n % 3 with
  | zero => exact Or.inl rfl
  | succ r1 => cases r1 with
    | zero => exact Or.inr (Or.inl rfl)
    | succ r2 => cases r2 with
      | zero => exact Or.inr (Or.inr rfl)
      | succ r3 =>
          rw [h] at hlt
          have hge : 3 ≤ r3 + 1 + 1 + 1 := by
            exact Nat.le_add_left 3 r3
          exact False.elim (Nat.not_lt_of_ge hge hlt)

/-- BT-0004 concrete sieve gate: one of n, n+2, n+4 is divisible by 3. -/
theorem triplet_mod_three_sieve_gate (n : Nat) :
    3 ∣ n ∨ 3 ∣ n + 2 ∨ 3 ∣ n + 4 := by
  rcases mod_three_cases n with h0 | h1 | h2
  · exact Or.inl (Nat.dvd_of_mod_eq_zero h0)
  · have hmod : (n + 2) % 3 = 0 := by
      rw [Nat.add_mod, h1]
    exact Or.inr (Or.inl (Nat.dvd_of_mod_eq_zero hmod))
  · have hmod : (n + 4) % 3 = 0 := by
      rw [Nat.add_mod, h2]
    exact Or.inr (Or.inr (Nat.dvd_of_mod_eq_zero hmod))

/-- If n, n+2, and n+4 are all locally prime, then n = 3. -/
theorem prime_triplet_start_eq_three
    (n : Nat) (hn : Prime n) (hn2 : Prime (n + 2)) (hn4 : Prime (n + 4)) :
    n = 3 := by
  rcases triplet_mod_three_sieve_gate n with hdiv | hdiv2 | hdiv4
  · exact prime_eq_three_of_three_dvd n hn hdiv
  · have hn2eq : n + 2 = 3 := prime_eq_three_of_three_dvd (n + 2) hn2 hdiv2
    have hn1 : n = 1 := by
      apply Nat.add_right_cancel (m := 2)
      change n + 2 = 1 + 2
      exact hn2eq
    subst n
    exact False.elim (Nat.lt_irrefl 1 hn.1)
  · have hn4eq : n + 4 = 3 := prime_eq_three_of_three_dvd (n + 4) hn4 hdiv4
    exact False.elim (by cases n <;> cases hn4eq)

/-- The only locally prime triplet of the form n, n+2, n+4 is 3,5,7. -/
theorem only_prime_triplet_three_five_seven
    (n : Nat) (hn : Prime n) (hn2 : Prime (n + 2)) (hn4 : Prime (n + 4)) :
    n = 3 ∧ n + 2 = 5 ∧ n + 4 = 7 := by
  have hstart := prime_triplet_start_eq_three n hn hn2 hn4
  subst n
  exact ⟨rfl, rfl, rfl⟩

/-- General finite-cover sieve schema:
if offsets cover every residue modulo q, every translate hits a multiple of q. -/
theorem residue_cover_translate_hits_multiple
    (q : Nat) (hq : 0 < q) (offsets : List Nat)
    (cover : ∀ r : Nat, r < q → ∃ h : Nat, h ∈ offsets ∧ (r + h) % q = 0)
    (n : Nat) :
    ∃ h : Nat, h ∈ offsets ∧ q ∣ n + h := by
  obtain ⟨h, hmem, hmod⟩ := cover (n % q) (Nat.mod_lt n hq)
  refine ⟨h, hmem, ?_⟩
  apply Nat.dvd_of_mod_eq_zero
  rw [← Nat.mod_add_mod n q h]
  exact hmod

/-- The offsets 0, 2, and 4 cover all residues modulo 3 after translation to 0. -/
theorem offsets_zero_two_four_cover_mod_three :
    ∀ r : Nat, r < 3 → ∃ h : Nat, h ∈ [0, 2, 4] ∧ (r + h) % 3 = 0 := by
  intro r hlt
  cases r with
  | zero =>
      exact ⟨0, by simp, rfl⟩
  | succ r1 => cases r1 with
    | zero =>
        exact ⟨2, by simp, rfl⟩
    | succ r2 => cases r2 with
      | zero =>
          exact ⟨4, by simp, rfl⟩
      | succ r3 =>
          have hge : 3 ≤ r3 + 1 + 1 + 1 := by
            exact Nat.le_add_left 3 r3
          exact False.elim (Nat.not_lt_of_ge hge hlt)

/-- The n,n+2,n+4 obstruction as an instance of the finite-cover schema. -/
theorem triplet_offsets_cover_hits_multiple (n : Nat) :
    ∃ h : Nat, h ∈ [0, 2, 4] ∧ 3 ∣ n + h :=
  residue_cover_translate_hits_multiple 3 (by decide) [0, 2, 4]
    offsets_zero_two_four_cover_mod_three n

end NumBridge
