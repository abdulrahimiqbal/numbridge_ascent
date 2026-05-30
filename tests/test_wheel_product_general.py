from pathlib import Path
import random
import sys

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'src'))

import unittest

from bridge.wheel_product_general import (
    brute_force_crt_count_product,
    pairwise_coprime,
    product_local_survivor_counts,
    search_for_counterexample_to_wheel_product,
    verify_general_wheel_product,
    wheel_survivor_count_general,
)
from bridge.wheel_shadow import exact_wheel_distribution_holds, wheel_survivor_count


class WheelProductGeneralTests(unittest.TestCase):
    def test_general_product_formula_two_gates(self):
        check = verify_general_wheel_product([2, 3], [0, 2, 4])
        self.assertTrue(check["holds"])
        self.assertEqual(check["survivor_count"], 0)

    def test_general_product_formula_three_gates(self):
        check = verify_general_wheel_product([2, 3, 5], [0, 2, 6])
        self.assertTrue(check["holds"])
        self.assertEqual(check["survivor_count"], 2)

    def test_general_product_formula_four_gates(self):
        check = verify_general_wheel_product([2, 3, 5, 7], [0, 2, 6])
        self.assertTrue(check["holds"])
        self.assertEqual(
            check["survivor_count"],
            product_local_survivor_counts([2, 3, 5, 7], [0, 2, 6]),
        )

    def test_random_small_pairwise_coprime_gate_lists(self):
        rng = random.Random(20260530)
        gate_sets = [[2, 3], [2, 5], [3, 4, 5], [2, 3, 5], [2, 3, 5, 7]]
        patterns = [[0, 2], [0, 2, 6], [0, 4, 6], [0, 6, 10]]
        for _ in range(12):
            gates = rng.choice(gate_sets)
            pattern = rng.choice(patterns)
            self.assertTrue(pairwise_coprime(gates))
            with self.subTest(gates=gates, pattern=pattern):
                self.assertTrue(verify_general_wheel_product(gates, pattern)["holds"])

    def test_non_coprime_gate_lists_are_rejected(self):
        with self.assertRaises(ValueError):
            verify_general_wheel_product([2, 4], [0, 2])

    def test_expected_named_patterns(self):
        self.assertEqual(wheel_survivor_count_general([2, 3], [0, 2, 4]), 0)
        self.assertEqual(wheel_survivor_count_general([2, 3, 5], [0, 2, 6]), 2)

    def test_new_general_functions_match_old_wheel_functions(self):
        cases = [
            ([2, 3], [0, 2]),
            ([2, 3], [0, 2, 4]),
            ([2, 3, 5], [0, 2, 6]),
            ([2, 3, 5], [0, 4, 6]),
        ]
        for gates, pattern in cases:
            with self.subTest(gates=gates, pattern=pattern):
                old = exact_wheel_distribution_holds(pattern, gates)
                self.assertEqual(wheel_survivor_count_general(gates, pattern), old["survivor_count"])
                self.assertEqual(wheel_survivor_count_general(gates, pattern), wheel_survivor_count(pattern, old["W"]))

    def test_brute_force_crt_count_product(self):
        result = brute_force_crt_count_product(
            4,
            5,
            lambda x: x in {1, 3},
            lambda y: y in {0, 2, 4},
        )
        self.assertTrue(result["pairwise_coprime"])
        self.assertTrue(result["holds"])
        self.assertEqual(result["rhs"], 6)

    def test_counterexample_search_finds_no_coprime_failure_and_documents_non_coprime(self):
        result = search_for_counterexample_to_wheel_product(12, 20)
        self.assertIsNone(result["coprime_counterexample"])
        self.assertIsNotNone(result["non_coprime_counterexample"])
        self.assertFalse(result["non_coprime_counterexample"]["pairwise_coprime"])


if __name__ == '__main__':
    unittest.main()
