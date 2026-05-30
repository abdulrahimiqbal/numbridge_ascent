from pathlib import Path
import sys
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'src'))

import unittest

from numbridge.experiments import base_invariance, palindrome_divisibility, prime_digital_roots


class ExperimentTests(unittest.TestCase):
    def test_prime_digital_roots(self):
        result = prime_digital_roots(1000)
        self.assertEqual(result.metrics['prime_forbidden_count'], 0)
        self.assertEqual(result.metrics['null_forbidden_count'], 0)

    def test_palindrome_divisibility(self):
        result = palindrome_divisibility(50)
        self.assertEqual(result.metrics['base10_counterexample_count'], 0)

    def test_base_invariance(self):
        result = base_invariance(200)
        self.assertEqual(result.metrics['failure_count'], 0)


if __name__ == '__main__':
    unittest.main()
