from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'src'))

import unittest

from bridge.bt0012_breakthrough import (
    bt0012_breakthrough_audit,
    prime_tuple_translate_above_gates,
    verify_arbitrary_base_spine_check,
    verify_prime_wheel_upper_bound,
    wheel_residue_survivors,
)
from bridge.general_first_subcritical_sacrifice import verify_general_first_subcritical


class BT0012BreakthroughTests(unittest.TestCase):
    def test_arbitrary_base_check_recovers_bt0011_base_len_two(self):
        bt0011 = verify_general_first_subcritical([2, 5], 7)
        bt0012 = verify_arbitrary_base_spine_check([2, 5], 7)
        self.assertTrue(bt0012["holds"])
        self.assertEqual(bt0012["predicted_max_score"], bt0011["predicted_max_score"])
        self.assertEqual(bt0012["canonical_attainer"], bt0011["canonical_attainer"])

    def test_arbitrary_base_sample_passes_python_edge_check(self):
        result = verify_arbitrary_base_spine_check([2, 3, 5], 31)
        self.assertTrue(result["holds"])
        self.assertFalse(result["exact_bruteforce"])
        self.assertIsNone(result["edge_counterexample"])

    def test_arbitrary_base_rejects_invalid_inputs(self):
        with self.assertRaises(ValueError):
            verify_arbitrary_base_spine_check([2, 4], 31)
        with self.assertRaises(ValueError):
            verify_arbitrary_base_spine_check([2, 3, 5], 7)

    def test_prime_wheel_upper_bound_holds_for_small_patterns(self):
        result = verify_prime_wheel_upper_bound([2, 3, 5], [0, 2, 6], 10_000)
        self.assertTrue(result["holds"])
        self.assertLessEqual(result["prime_tuple_count"], result["block_bound"])
        self.assertEqual(result["bad_translate_count"], 0)

    def test_prime_translate_lands_in_wheel_survivors(self):
        gates = [2, 3, 5]
        H = [0, 2, 6]
        survivors = set(wheel_residue_survivors(gates, H))
        examples = [
            n
            for n in range(1000)
            if prime_tuple_translate_above_gates(gates, H, n)
        ]
        self.assertTrue(examples)
        for n in examples:
            self.assertIn(n % 30, survivors)

    def test_duplicate_offsets_rejected(self):
        with self.assertRaises(ValueError):
            verify_prime_wheel_upper_bound([2, 3, 5], [0, 0, 2], 100)

    def test_breakthrough_audit(self):
        audit = bt0012_breakthrough_audit()
        self.assertEqual(audit["path_landed"], "B actual-prime wheel upper bound")
        self.assertEqual(audit["classification"], "ACTUAL_PRIME_BRIDGE_ELEMENTARY")
        self.assertTrue(audit["part_b_sample_holds"])


if __name__ == '__main__':
    unittest.main()
