from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'src'))

import unittest

from bridge.first_subcritical_sacrifice import (
    canonical_first_subcritical_attainer,
    find_counterexample_bt0010,
    first_subcritical_pattern,
    first_subcritical_score,
    first_subcritical_structural_condition,
    scan_first_subcritical_q_values,
    verify_first_subcritical_sacrifice,
)
from bridge.subcritical_resonance import verify_bt0009_subcritical_235


class FirstSubcriticalSacrificeTests(unittest.TestCase):
    def test_q5_recovers_bt0009(self):
        bt0009 = verify_bt0009_subcritical_235()
        bt0010 = verify_first_subcritical_sacrifice(5)
        self.assertTrue(bt0010["holds"])
        self.assertEqual(bt0010["max_score"], bt0009["max_score"])
        self.assertEqual(bt0010["maximizers"], bt0009["maximizers"])

    def test_q_7_11_13_pass(self):
        for q in [7, 11, 13]:
            with self.subTest(q=q):
                result = verify_first_subcritical_sacrifice(q)
                self.assertTrue(result["holds"])
                self.assertEqual(result["max_score"], 2 * (q - 2))

    def test_non_coprime_q_values_are_rejected(self):
        for q in [6, 9, 10, 12, 15]:
            with self.subTest(q=q):
                with self.assertRaises(ValueError):
                    verify_first_subcritical_sacrifice(q)

    def test_canonical_attainer_scores_predicted_max(self):
        for q in [5, 7, 11, 13]:
            pattern = canonical_first_subcritical_attainer(q)
            with self.subTest(q=q, pattern=pattern):
                self.assertTrue(first_subcritical_pattern(q, pattern))
                self.assertTrue(first_subcritical_structural_condition(q, pattern))
                self.assertEqual(first_subcritical_score(q, pattern), 2 * (q - 2))

    def test_duplicate_and_full_lattice_patterns_rejected(self):
        self.assertFalse(first_subcritical_pattern(7, [0, 0, 42]))
        with self.assertRaises(ValueError):
            first_subcritical_score(7, [0, 0, 42])

        self.assertFalse(first_subcritical_pattern(7, [0, 42, 84]))
        with self.assertRaises(ValueError):
            first_subcritical_score(7, [0, 42, 84])

    def test_computed_maximizers_satisfy_structural_condition(self):
        result = verify_first_subcritical_sacrifice(11)
        self.assertTrue(result["holds"])
        for pattern in result["maximizers"]:
            self.assertTrue(first_subcritical_structural_condition(11, pattern))

    def test_scan_and_counterexample_search(self):
        scan = scan_first_subcritical_q_values([5, 7, 11, 13])
        self.assertTrue(scan["holds"])
        self.assertEqual(scan["checked"], 4)

        search = find_counterexample_bt0010(17)
        self.assertTrue(search["holds"])
        self.assertIsNone(search["counterexample"])


if __name__ == '__main__':
    unittest.main()
