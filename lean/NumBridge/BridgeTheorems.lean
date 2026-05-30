/-
Bridge theorem layer.

A Bridge Theorem is a reusable theorem schema showing that a class of
numerology-like symbolic phrases corresponds to a precise mathematical
structure.
-/

import NumBridge.Palindrome11
import NumBridge.PrimeDigitalRoot

namespace NumBridge

/-- BT-0001 lightweight instance: decimal digital root preserves residue modulo 9. -/
theorem digital_root_10_mod_nine (n : Nat) :
    digital_root_10 n % 9 = n % 9 := by
  unfold digital_root_10
  cases h : n % 9 with
  | zero =>
      rfl
  | succ r =>
      have hlt : r + 1 < 9 := by
        have hmodlt : n % 9 < 9 := Nat.mod_lt n (by decide)
        rw [h] at hmodlt
        exact hmodlt
      exact Nat.mod_eq_of_lt hlt

/-- BT-0003 core: decimal residues 3, 6, and 0 modulo 9 are divisible by 3. -/
theorem residue_three_six_zero_mod_nine_implies_three_dvd (n : Nat) :
    n % 9 = 3 ∨ n % 9 = 6 ∨ n % 9 = 0 → 3 ∣ n := by
  intro h
  have hdiv : 3 ∣ 9 := by
    exists 3
  have hmod : n % 3 = 0 := by
    rw [← Nat.mod_mod_of_dvd n hdiv]
    rcases h with h3 | h6 | h0
    · rw [h3]
    · rw [h6]
    · rw [h0]
  exact Nat.dvd_of_mod_eq_zero hmod

/-- BT-0003: if lightweight decimal digital root is 3, 6, or 9, then 3 divides the number. -/
theorem digital_root_10_eq_three_six_nine_implies_three_dvd (n : Nat) :
    digital_root_10 n = 3 ∨ digital_root_10 n = 6 ∨ digital_root_10 n = 9 → 3 ∣ n := by
  intro hroot
  by_cases h0 : n % 9 = 0
  · exact residue_three_six_zero_mod_nine_implies_three_dvd n (Or.inr (Or.inr h0))
  · have hdr : digital_root_10 n = n % 9 := by
      unfold digital_root_10
      cases h : n % 9 with
      | zero =>
          exact False.elim (h0 h)
      | succ _ =>
          rfl
    rcases hroot with h3 | h6 | h9
    · have hr : n % 9 = 3 := by
        rw [← hdr]
        exact h3
      exact residue_three_six_zero_mod_nine_implies_three_dvd n (Or.inl hr)
    · have hr : n % 9 = 6 := by
        rw [← hdr]
        exact h6
      exact residue_three_six_zero_mod_nine_implies_three_dvd n (Or.inr (Or.inl hr))
    · have hr : n % 9 = 9 := by
        rw [← hdr]
        exact h9
      have hlt : n % 9 < 9 := Nat.mod_lt n (by decide)
      rw [hr] at hlt
      exact False.elim (Nat.lt_irrefl 9 hlt)

/-- BT-0003 closed instance: prime completion-root exclusions are residue obstructions. -/
theorem prime_completion_roots_vanish_bridge (p : Nat) (hp : Prime p) (hgt : 3 < p) :
    digital_root_10 p ≠ 3 ∧ digital_root_10 p ≠ 6 ∧ digital_root_10 p ≠ 9 :=
  prime_gt_three_digital_root_10_not_three_six_nine p hp hgt

/-- Algebraic factorization behind the 11-gate for six-digit mirror numbers. -/
theorem six_digit_mirror_factorization (a b c : Nat) :
    100000 * a + 10000 * b + 1000 * c + 100 * c + 10 * b + a =
      11 * (9091 * a + 910 * b + 100 * c) := by
  calc
    100000 * a + 10000 * b + 1000 * c + 100 * c + 10 * b + a
        = (100000 * a + a) + (10000 * b + 10 * b) + (1000 * c + 100 * c) := by ac_rfl
    _ = 100001 * a + 10010 * b + 1100 * c := by
        rw [← Nat.succ_mul 100000 a, ← Nat.add_mul 10000 10 b, ← Nat.add_mul 1000 100 c]
    _ = 11 * (9091 * a) + 11 * (910 * b) + 11 * (100 * c) := by
        congr 1
        · congr 1
          · change (11 * 9091) * a = 11 * (9091 * a)
            rw [Nat.mul_assoc]
          · change (11 * 910) * b = 11 * (910 * b)
            rw [Nat.mul_assoc]
        · change (11 * 100) * c = 11 * (100 * c)
          rw [Nat.mul_assoc]
    _ = 11 * (9091 * a + 910 * b + 100 * c) := by
        rw [Nat.mul_add, Nat.mul_add]

/-- BT-0002 intermediate theorem: six-digit mirror numbers are divisible by 11. -/
theorem six_digit_mirror_divisible_by_11 (a b c : Nat) :
    11 ∣ (100000 * a + 10000 * b + 1000 * c + 100 * c + 10 * b + a) := by
  exists 9091 * a + 910 * b + 100 * c
  exact six_digit_mirror_factorization a b c

/-- BT-0002 closed calibration schema currently proven in Lean. -/
theorem mirror_symmetry_creates_divisibility_gates_bridge (a b c : Nat) :
    11 ∣ (100000 * a + 10000 * b + 1000 * c + 100 * c + 10 * b + a) :=
  six_digit_mirror_divisible_by_11 a b c

end NumBridge
