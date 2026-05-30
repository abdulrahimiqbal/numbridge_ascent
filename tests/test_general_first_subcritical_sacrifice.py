from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'src'))

import unittest

from bridge.general_first_subcritical_sacrifice import (
    all_offsets_divisible_by,
    counterexample_search_general_first_subcritical,
    finite_resonance_numerator,
    general_first_subcritical_condition,
    normalized_distinct_three_pattern,
    verify_general_first_subcritical,
)


class GeneralFirstSubcriticalSacrificeTests(unittest.TestCase):
    def test_bt0010_recovered_from_base_two_three_q5(self):
        result = verify_general_first_subcritical([2, 3], 5)
        self.assertTrue(result["holds"])
        self.assertTrue(result["exact_bruteforce"])
        self.assertEqual(result["L"], 6)
        self.assertEqual(result["B"], 2)
        self.assertEqual(result["D"], 59)
        self.assertEqual(result["max_score"], 6)
        self.assertEqual(result["predicted_max_score"], 6)

    def test_two_gate_parametric_cases_pass(self):
        for base, q in [([2, 3], 7), ([2, 5], 7), ([3, 4], 7)]:
            with self.subTest(base=base, q=q):
                result = verify_general_first_subcritical(base, q)
                self.assertTrue(result["holds"])
                self.assertEqual(result["lean_scope"], "two-gate")
                self.assertEqual(result["canonical_score"], result["predicted_max_score"])

    def test_rejects_outside_theorem_assumptions(self):
        with self.assertRaises(ValueError):
            verify_general_first_subcritical([3, 4], 5)
        with self.assertRaises(ValueError):
            verify_general_first_subcritical([2, 4], 7)
        with self.assertRaises(ValueError):
            verify_general_first_subcritical([2, 5], 5)
        with self.assertRaises(ValueError):
            verify_general_first_subcritical([2, 3, 5], 7)

    def test_pattern_predicate_and_structural_condition(self):
        result = verify_general_first_subcritical([2, 5], 7)
        L = int(result["L"])
        D = int(result["D"])
        canonical = list(result["canonical_attainer"])

        self.assertTrue(normalized_distinct_three_pattern(canonical, D))
        self.assertTrue(all_offsets_divisible_by(canonical, L))
        self.assertTrue(general_first_subcritical_condition([2, 5], 7, canonical))
        self.assertEqual(
            finite_resonance_numerator([2, 5, 7], canonical),
            result["predicted_max_score"],
        )
        self.assertFalse(normalized_distinct_three_pattern([0, 0, L], D))

    def test_counterexample_search_finds_no_theorem_range_failure(self):
        search = counterexample_search_general_first_subcritical(8, 13, 3)
        self.assertTrue(search["holds"])
        self.assertIsNone(search["counterexample"])
        self.assertGreater(search["outside_theorem_cases"], 0)


if __name__ == '__main__':
    unittest.main()
