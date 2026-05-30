from pathlib import Path
import sys
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'src'))

import unittest

from numbridge.md import parse_frontmatter


class MarkdownTests(unittest.TestCase):
    def test_parse_frontmatter_lists(self):
        text = '''---\nid: L-0001\ntype: lead\ndomain:\n  - primes\n  - roots\n---\n# Body\n'''
        meta, body = parse_frontmatter(text)
        self.assertEqual(meta['id'], 'L-0001')
        self.assertEqual(meta['domain'], ['primes', 'roots'])
        self.assertTrue(body.startswith('# Body'))


if __name__ == '__main__':
    unittest.main()
