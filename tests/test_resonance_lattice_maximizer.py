from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'src'))

import unittest

from bridge.resonance_lattice_maximizer import (
    all_offsets_divisible_by,
    brute_force_verify_bt0008,
    canonical_lattice_pattern,
    lattice_maximum_attainable,
    normalized_distinct_pattern,
    resonance_upper_bound,
    structural_maximizer_check,
    verify_bt0008,
)
from bridge.wheel_product_general import product_local_survivor_counts


class ResonanceLatticeMaximizerTests(unittest.TestCase):
    def test_duplicate_patterns_are_rejected(self):
        self.assertFalse(normalized_distinct_pattern([0, 0, 0], 3, 10))
        self.assertFalse(normalized_distinct_pattern([0, 2, 2], 3, 10))

    def test_gate_product_and_upper_bound_for_two_three_five(self):
        self.assertEqual(resonance_upper_bound([2, 3, 5]), 8)
        self.assertEqual(canonical_lattice_pattern(3, 30), [0, 30, 60])

    def test_canonical_pattern_attains_upper_bound_when_threshold_met(self):
        result = structural_maximizer_check([2, 3, 5], [0, 30, 60])
        self.assertTrue(normalized_distinct_pattern([0, 30, 60], 3, 60))
        self.assertTrue(result["attains_upper_bound"])
        self.assertTrue(result["lattice_condition"])
        self.assertEqual(result["numerator"], result["upper_bound"])

    def test_upper_bound_not_attainable_below_threshold(self):
        result = brute_force_verify_bt0008(3, 59, [2, 3, 5])
        self.assertFalse(result["threshold_attainable"])
        self.assertEqual(result["upper_attainer_count"], 0)
        self.assertLess(result["max_score"], result["upper_bound"])

    def test_threshold_case_has_lattice_maximizers(self):
        result = brute_force_verify_bt0008(3, 60, [2, 3, 5])
        self.assertTrue(result["threshold_attainable"])
        self.assertTrue(result["holds"])
        self.assertIn([0, 30, 60], result["upper_attainers"])
        self.assertTrue(all_offsets_divisible_by([0, 30, 60], 30))
        self.assertTrue(all_offsets_divisible_by(result["maximizers"][0], 30))

    def test_lattice_maximum_attainable_threshold(self):
        self.assertTrue(lattice_maximum_attainable(3, 60, 30))
        self.assertFalse(lattice_maximum_attainable(3, 59, 30))

    def test_bruteforce_scores_match_direct_product_counts(self):
        result = brute_force_verify_bt0008(3, 20, [2, 3, 5])
        for pattern in result["maximizers"]:
            self.assertEqual(
                product_local_survivor_counts([2, 3, 5], pattern),
                result["max_score"],
            )

    def test_small_window_verifier(self):
        result = verify_bt0008(4, 18, [2, 3, 5])
        self.assertTrue(result["holds"])
        self.assertEqual(result["checked"], 4 * 19)


if __name__ == '__main__':
    unittest.main()
