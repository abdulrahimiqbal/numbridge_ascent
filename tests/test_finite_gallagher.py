from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'src'))

import unittest

from bridge.finite_gallagher import (
    avoided_residue_count,
    finite_gallagher_rhs,
    finite_resonance_numerator,
    product_local_max_powers,
    scan_finite_gallagher,
    search_counterexample_finite_gallagher,
    tuples_of_length,
    verify_finite_gallagher,
)


class FiniteGallagherTests(unittest.TestCase):
    def test_tuples_of_length_base_case(self):
        self.assertEqual(list(tuples_of_length(0, 5)), [[]])

    def test_single_gate_formula_p5_k3(self):
        p = 5
        k = 3
        lhs = sum(avoided_residue_count(p, H) for H in tuples_of_length(k, p))
        self.assertEqual(lhs, p * (p - 1) ** k)

    def test_two_gate_formula_exact_bruteforce(self):
        result = verify_finite_gallagher([2, 3], 2)
        self.assertTrue(result["holds"])
        self.assertTrue(result["exact_bruteforce"])
        self.assertEqual(result["lhs"], result["rhs"])

    def test_three_gate_formula_exact_bruteforce(self):
        result = verify_finite_gallagher([2, 3, 5], 3)
        self.assertTrue(result["holds"])
        self.assertTrue(result["exact_bruteforce"])

    def test_larger_three_gate_uses_factorized_count(self):
        result = verify_finite_gallagher([2, 5, 7], 4)
        self.assertTrue(result["holds"])
        self.assertFalse(result["exact_bruteforce"])
        self.assertEqual(result["lhs"], result["rhs"])

    def test_k_zero(self):
        result = verify_finite_gallagher([2, 3, 5], 0)
        self.assertTrue(result["holds"])
        self.assertEqual(result["lhs"], 30)

    def test_rejects_non_coprime_gates(self):
        with self.assertRaises(ValueError):
            verify_finite_gallagher([2, 4], 2)

    def test_numerator_matches_expected_small_tuple(self):
        self.assertEqual(finite_resonance_numerator([2, 3], [0, 2]), 1)
        self.assertEqual(product_local_max_powers([2, 3], 2), 4)
        self.assertEqual(finite_gallagher_rhs([2, 3], 2), 24)

    def test_scan_has_no_coprime_failure(self):
        result = scan_finite_gallagher(max_gate=8, max_k=3, max_gate_len=3)
        self.assertTrue(result["holds"])
        self.assertIsNone(result["first_failure"])

    def test_counterexample_search_marks_outside_assumptions(self):
        result = search_counterexample_finite_gallagher(max_gate=6, max_k=2)
        self.assertIsNone(result["coprime_counterexample"])
        self.assertIsNotNone(result["outside_assumptions_counterexample"])


if __name__ == '__main__':
    unittest.main()
