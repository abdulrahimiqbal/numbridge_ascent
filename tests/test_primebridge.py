from pathlib import Path
import sys
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'src'))

import unittest

from bridge.residue_shadow import (
    gate_deficit,
    is_admissible,
    is_obstructed_mod,
    residue_shadow,
)
from bridge.resonance import rank_patterns_by_resonance, truncated_singular_series


class PrimeBridgeTests(unittest.TestCase):
    def test_triplet_obstructed_mod_three(self):
        self.assertTrue(is_obstructed_mod([0, 2, 4], 3))

    def test_twin_pattern_admissible(self):
        self.assertTrue(is_admissible([0, 2]))

    def test_prime_triplet_pattern_admissible(self):
        self.assertTrue(is_admissible([0, 2, 6]))

    def test_residue_shadow(self):
        self.assertEqual(residue_shadow([0, 2, 4], 3), {0, 1, 2})

    def test_gate_deficits(self):
        self.assertEqual(gate_deficit([0, 2, 4], 3), 0)
        self.assertEqual(gate_deficit([0, 2, 6], 3), 1)

    def test_singular_series_obstruction(self):
        self.assertEqual(truncated_singular_series([0, 2, 4], 31), 0.0)

    def test_ranker_places_obstructed_below_admissible(self):
        rows = rank_patterns_by_resonance(3, 6, 31)
        obstructed_index = next(i for i, row in enumerate(rows) if row["pattern"] == [0, 2, 4])
        admissible_index = next(i for i, row in enumerate(rows) if row["pattern"] == [0, 2, 6])
        self.assertLess(admissible_index, obstructed_index)


if __name__ == '__main__':
    unittest.main()
