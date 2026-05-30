from pathlib import Path
import sys
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'src'))

import unittest

from numbridge.features import digital_root, digits, from_digits, mirror_number, omega, sieve_primes


class FeatureTests(unittest.TestCase):
    def test_digits_roundtrip(self):
        for base in range(2, 17):
            for n in [0, 1, base - 1, base, 1234]:
                self.assertEqual(from_digits(digits(n, base), base), n)

    def test_digital_root_mod_relation(self):
        for base in range(2, 17):
            for n in range(1, 1000):
                self.assertEqual((digital_root(n, base) - n) % (base - 1), 0)

    def test_mirror_number_divisible_by_11(self):
        for prefix in range(1, 200):
            self.assertEqual(mirror_number(prefix, 10) % 11, 0)

    def test_sieve_primes(self):
        self.assertEqual(sieve_primes(20), [2, 3, 5, 7, 11, 13, 17, 19])

    def test_omega(self):
        self.assertEqual(omega(12), 3)  # 2 * 2 * 3


if __name__ == '__main__':
    unittest.main()
