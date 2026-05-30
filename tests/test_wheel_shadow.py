from pathlib import Path
import sys
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'src'))

import unittest

from bridge.wheel_shadow import (
    compare_patterns_by_wheel_distribution,
    exact_wheel_distribution_holds,
    normalized_wheel_density,
    product_local_survival_count,
    wheel_survivor_count,
)


class WheelShadowTests(unittest.TestCase):
    def test_triplet_collapse_mod_six(self):
        self.assertEqual(wheel_survivor_count([0, 2, 4], 6), 0)

    def test_twin_pattern_one_survivor_mod_six(self):
        self.assertEqual(wheel_survivor_count([0, 2], 6), 1)

    def test_prime_triplet_wheel_count_matches_product(self):
        check = exact_wheel_distribution_holds([0, 2, 6], [2, 3, 5])
        self.assertTrue(check["holds"])
        self.assertEqual(check["survivor_count"], product_local_survival_count([0, 2, 6], [2, 3, 5]))

    def test_other_triplet_wheel_count_matches_product(self):
        check = exact_wheel_distribution_holds([0, 4, 6], [2, 3, 5])
        self.assertTrue(check["holds"])

    def test_product_formula_small_patterns(self):
        patterns = [[0, 2], [0, 2, 6], [0, 4, 6], [0, 6, 12]]
        prime_sets = [[2, 3], [2, 3, 5], [2, 3, 5, 7]]
        for pattern in patterns:
            for primes in prime_sets:
                with self.subTest(pattern=pattern, primes=primes):
                    self.assertTrue(exact_wheel_distribution_holds(pattern, primes)["holds"])

    def test_obstructed_patterns_have_zero_density(self):
        self.assertEqual(normalized_wheel_density([0, 2, 4], [2, 3]), 0.0)

    def test_admissible_patterns_have_positive_density(self):
        self.assertGreater(normalized_wheel_density([0, 2, 6], [2, 3, 5]), 0.0)

    def test_comparison_ranks_positive_density_above_obstructed(self):
        rows = compare_patterns_by_wheel_distribution([[0, 2, 4], [0, 2, 6]], [2, 3, 5])
        self.assertEqual(rows[0]["pattern"], [0, 2, 6])
        self.assertEqual(rows[-1]["pattern"], [0, 2, 4])


if __name__ == '__main__':
    unittest.main()
