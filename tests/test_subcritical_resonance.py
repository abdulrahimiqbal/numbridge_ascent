from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'src'))

import unittest

from bridge.subcritical_resonance import (
    explain_bt0009_maximizers,
    pattern_235_subcritical,
    subcritical_235_score,
    subcritical_235_structural_condition,
    verify_bt0009_subcritical_235,
)


KNOWN_MAXIMIZERS = [
    [0, 6, 30], [0, 6, 36],
    [0, 12, 30], [0, 12, 42],
    [0, 18, 30], [0, 18, 48],
    [0, 24, 30], [0, 24, 54],
    [0, 30, 36], [0, 30, 42],
    [0, 30, 48], [0, 30, 54],
]


class SubcriticalResonanceTests(unittest.TestCase):
    def test_known_maximizers_satisfy_structural_condition(self):
        for pattern in KNOWN_MAXIMIZERS:
            with self.subTest(pattern=pattern):
                self.assertTrue(subcritical_235_structural_condition(pattern))
                self.assertEqual(subcritical_235_score(pattern), 6)

    def test_structural_patterns_are_exactly_known_maximizers(self):
        explanation = explain_bt0009_maximizers()
        self.assertEqual(explanation["structural_patterns"], KNOWN_MAXIMIZERS)
        self.assertEqual(explanation["maximizers"], KNOWN_MAXIMIZERS)

    def test_every_maximizer_satisfies_structural_condition(self):
        result = verify_bt0009_subcritical_235()
        self.assertTrue(result["holds"])
        self.assertEqual(result["maximizers"], KNOWN_MAXIMIZERS)
        self.assertEqual(result["bad_maximizers"], [])

    def test_no_pattern_exceeds_six(self):
        result = verify_bt0009_subcritical_235()
        self.assertEqual(result["max_score"], 6)
        self.assertEqual(result["over_bound"], [])

    def test_duplicate_patterns_are_rejected(self):
        self.assertFalse(pattern_235_subcritical([0, 0, 30]))
        with self.assertRaises(ValueError):
            subcritical_235_score([0, 0, 30])

    def test_sixty_is_rejected_at_d59(self):
        self.assertFalse(pattern_235_subcritical([0, 30, 60]))
        with self.assertRaises(ValueError):
            subcritical_235_score([0, 30, 60])

    def test_named_positive_and_negative_examples(self):
        self.assertEqual(subcritical_235_score([0, 30, 54]), 6)
        self.assertTrue(subcritical_235_structural_condition([0, 30, 54]))

        self.assertNotEqual(subcritical_235_score([0, 6, 12]), 6)
        self.assertFalse(subcritical_235_structural_condition([0, 6, 12]))

        self.assertNotEqual(subcritical_235_score([0, 6, 18]), 6)
        self.assertFalse(subcritical_235_structural_condition([0, 6, 18]))


if __name__ == '__main__':
    unittest.main()
