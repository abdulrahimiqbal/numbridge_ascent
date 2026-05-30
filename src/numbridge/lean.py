from __future__ import annotations

from pathlib import Path

from .md import MarkdownDoc


def lean_filename_for(conjecture_id: str, theorem_kind: str) -> str:
    if theorem_kind == "even_palindrome_divisible_by_11":
        return "Palindrome11.lean"
    if theorem_kind == "prime_digital_root_exclusion":
        return "PrimeDigitalRoot.lean"
    if theorem_kind == "base_b_even_palindrome":
        return "PalindromeBase.lean"
    return f"{conjecture_id.replace('-', '_')}.lean"


def lean_template(doc: MarkdownDoc) -> str:
    cid = str(doc.meta.get("id", "C-UNKNOWN"))
    title = str(doc.meta.get("title", "Untitled conjecture"))
    theorem_kind = str(doc.meta.get("theorem_kind", "generic"))

    if theorem_kind == "even_palindrome_divisible_by_11":
        return f"""/-
Source conjecture: {cid}
Title: {title}
Bridge: mirror symmetry -> divisibility by 11

This file closes the first small Lean-solvable target for the mirror/11 bridge
without requiring a full digit-list library. The next target is to generalize
from four-digit mirror numbers to constructed even-length palindromes.
-/

import Init

namespace NumBridge

/-- Algebraic factorization behind the 11-gate for four-digit mirror numbers. -/
theorem four_digit_mirror_factorization (a b : Nat) :
    1000 * a + 100 * b + 10 * b + a = 11 * (91 * a + 10 * b) := by
  calc
    1000 * a + 100 * b + 10 * b + a
        = (1000 * a + a) + (100 * b + 10 * b) := by ac_rfl
    _ = 1001 * a + 110 * b := by
        rw [← Nat.succ_mul 1000 a, ← Nat.add_mul 100 10 b]
    _ = 11 * (91 * a) + 11 * (10 * b) := by
        congr 1
        · change (11 * 91) * a = 11 * (91 * a)
          rw [Nat.mul_assoc]
        · change (11 * 10) * b = 11 * (10 * b)
          rw [Nat.mul_assoc]
    _ = 11 * (91 * a + 10 * b) := by
        rw [Nat.mul_add]

/-- Four-digit mirror numbers are divisible by 11.
This is the minimal bridge target: mirror symmetry creates an 11-gate. -/
theorem four_digit_mirror_divisible_by_11 (a b : Nat) :
    11 ∣ (1000 * a + 100 * b + 10 * b + a) := by
  exists 91 * a + 10 * b
  exact four_digit_mirror_factorization a b

/-- Marker for the next target: prove the real even-palindrome theorem using
the alternating digit-sum test or mirrored digit-list evaluation modulo 11. -/
def even_decimal_palindrome_divisible_by_11_next_target : Prop := True

end NumBridge
"""

    if theorem_kind == "prime_digital_root_exclusion":
        return f"""/-
Source conjecture: {cid}
Title: {title}
Bridge: digital root -> modular arithmetic modulo 9

This file closes the prime/divisibility core and a lightweight digital-root
exclusion theorem using only Lean's standard library.
-/

import Init

namespace NumBridge

/-- A small standard-library prime predicate sufficient for the calibration bridge. -/
def Prime (p : Nat) : Prop :=
  1 < p ∧ ∀ d : Nat, d ∣ p → d = 1 ∨ d = p

/-- Backward-compatible name for the divisor form used by earlier scaffolds. -/
abbrev DivisorPrime (p : Nat) : Prop :=
  Prime p

/-- A number satisfying the divisor form of primality and greater than 3 is not divisible by 3. -/
theorem prime_gt_three_not_dvd_by_three (p : Nat) (hp : Prime p) (hgt : 3 < p) :
    ¬ 3 ∣ p := by
  intro h
  have hcase := hp.2 3 h
  rcases hcase with h31 | h3p
  · cases h31
  · subst p
    exact Nat.lt_irrefl 3 hgt

/-- The same prime/divisibility obstruction expressed as a modulo-3 statement. -/
theorem prime_gt_three_mod_three_ne_zero (p : Nat) (hp : Prime p) (hgt : 3 < p) :
    p % 3 ≠ 0 := by
  intro hmod
  exact prime_gt_three_not_dvd_by_three p hp hgt (Nat.dvd_of_mod_eq_zero hmod)

/-- Residues below 9 that are not divisible by 3 are exactly 1, 2, 4, 5, 7, and 8. -/
theorem residue_lt_nine_mod_three_ne_zero_allowed
    (r : Nat) (hlt : r < 9) (h3 : r % 3 ≠ 0) :
    r = 1 ∨ r = 2 ∨ r = 4 ∨ r = 5 ∨ r = 7 ∨ r = 8 := by
  cases r with
  | zero => exact False.elim (h3 rfl)
  | succ r1 => cases r1 with
    | zero => exact Or.inl rfl
    | succ r2 => cases r2 with
      | zero => exact Or.inr (Or.inl rfl)
      | succ r3 => cases r3 with
        | zero => exact False.elim (h3 rfl)
        | succ r4 => cases r4 with
          | zero => exact Or.inr (Or.inr (Or.inl rfl))
          | succ r5 => cases r5 with
            | zero => exact Or.inr (Or.inr (Or.inr (Or.inl rfl)))
            | succ r6 => cases r6 with
              | zero => exact False.elim (h3 rfl)
              | succ r7 => cases r7 with
                | zero => exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inl rfl))))
                | succ r8 => cases r8 with
                  | zero => exact Or.inr (Or.inr (Or.inr (Or.inr (Or.inr rfl))))
                  | succ _ => nomatch hlt

/-- Prime numbers greater than 3 can only occupy the nonmultiples-of-3 classes modulo 9. -/
theorem prime_gt_three_mod_nine_allowed (p : Nat) (hp : Prime p) (hgt : 3 < p) :
    p % 9 = 1 ∨ p % 9 = 2 ∨ p % 9 = 4 ∨ p % 9 = 5 ∨ p % 9 = 7 ∨ p % 9 = 8 := by
  have hmod3 : p % 3 ≠ 0 := prime_gt_three_mod_three_ne_zero p hp hgt
  have hres3 : (p % 9) % 3 ≠ 0 := by
    intro hz
    have hdiv : 3 ∣ 9 := by
      exists 3
    have hpmod : p % 3 = 0 := by
      rw [← Nat.mod_mod_of_dvd p hdiv]
      exact hz
    exact hmod3 hpmod
  exact residue_lt_nine_mod_three_ne_zero_allowed (p % 9) (Nat.mod_lt p (by decide)) hres3

/-- Lightweight decimal digital root, represented by the modulo-9 residue with 0 sent to 9. -/
def digital_root_10 (n : Nat) : Nat :=
  match n % 9 with
  | 0 => 9
  | r => r

/-- Prime numbers greater than 3 cannot have decimal digital root 3, 6, or 9. -/
theorem prime_gt_three_digital_root_10_not_three_six_nine
    (p : Nat) (hp : Prime p) (hgt : 3 < p) :
    digital_root_10 p ≠ 3 ∧ digital_root_10 p ≠ 6 ∧ digital_root_10 p ≠ 9 := by
  have hallowed := prime_gt_three_mod_nine_allowed p hp hgt
  rcases hallowed with h1 | h2 | h4 | h5 | h7 | h8
  · simp [digital_root_10, h1]
  · simp [digital_root_10, h2]
  · simp [digital_root_10, h4]
  · simp [digital_root_10, h5]
  · simp [digital_root_10, h7]
  · simp [digital_root_10, h8]

end NumBridge
"""

    if theorem_kind == "base_b_even_palindrome":
        return f"""/-
Source conjecture: {cid}
Title: {title}
Bridge: mirror symmetry -> divisibility by b + 1

This is an ambitious generalization. Prefer proving Palindrome11.lean first.
-/

import Init

namespace NumBridge

/-- Marker for the future base-b palindrome theorem. -/
def base_b_even_palindrome_next_target : Prop := True

end NumBridge
"""

    return f"""/-
Source conjecture: {cid}
Title: {title}
Generic NumBridge theorem scaffold.
-/

import Init

namespace NumBridge

/-- Marker for a future precise bridge theorem. -/
def generic_bridge_next_target : Prop := True

end NumBridge
"""


def export_lean(doc: MarkdownDoc, out_dir: Path) -> Path:
    theorem_kind = str(doc.meta.get("theorem_kind", "generic"))
    filename = lean_filename_for(str(doc.meta.get("id", "C-UNKNOWN")), theorem_kind)
    out_dir.mkdir(parents=True, exist_ok=True)
    path = out_dir / filename
    path.write_text(lean_template(doc), encoding="utf-8")
    return path
