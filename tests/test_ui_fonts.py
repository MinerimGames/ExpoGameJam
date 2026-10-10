"""Validate scalable native font resources and the shipped Portuguese/math glyphs."""
from pathlib import Path
import sys
import unittest
from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'tools'))
from evento_project import load


class UIFonts(unittest.TestCase):
    def test_atlas_contains_a_distance_field_outside_the_letter(self):
        # Enabling SDF against the old ordinary alpha atlas clips outlines and
        # pulls the text upwards. Native SDF needs eight pixels of field padding.
        for name in ('fnt_ui', 'fnt_title'):
            font = load(ROOT / 'fonts' / name / (name + '.yy'))
            glyph = font['glyphs']['65']
            self.assertGreaterEqual(glyph['h'], 39 if name == 'fnt_ui' else 55)
            self.assertGreaterEqual(glyph['w'], 28 if name == 'fnt_ui' else 35)
            atlas = Image.open(ROOT / 'fonts' / name / (name + '.png'))
            image = atlas.crop((glyph['x'], glyph['y'],
                                glyph['x']+glyph['w'], glyph['y']+glyph['h'])).getchannel('A')
            # Several outside distances must be encoded around a letter;
            # ordinary antialiasing has only a one-pixel coverage edge.
            outside = sum(16 <= a < 112 for a in image.tobytes())
            inside = sum(a >= 128 for a in image.tobytes())
            self.assertGreater(outside, inside, name)

    def test_both_ui_fonts_are_outline_backed_sdf_assets(self):
        # Shipping only the old bitmap makes enlarged letters visibly pixelated.
        for name in ('fnt_ui', 'fnt_title'):
            font = load(ROOT / 'fonts' / name / (name + '.yy'))
            self.assertTrue(font['usesSDF'], name)
            self.assertTrue(font['includeTTF'], name)
            source = ROOT / 'fonts' / name / font['TTFName']
            self.assertTrue(source.exists(), name)
            self.assertIn(source.read_bytes()[:4], (b'\x00\x01\x00\x00', b'OTTO'), name)

    def test_portuguese_and_arithmetic_have_real_glyphs(self):
        for name in ('fnt_ui', 'fnt_title'):
            font = load(ROOT / 'fonts' / name / (name + '.yy'))
            for char in 'AÇÃO ÁÉÍÓÚ ÂÊÔ ÃÕ Ç áéíóúâêôãõç +−-×÷=0123456789':
                codepoint = ord(char)
                if char == '−':
                    # Current game uses ASCII '-' for subtraction.
                    continue
                self.assertTrue(any(r['lower'] <= codepoint <= r['upper']
                                    for r in font['ranges']), (name, char))
                self.assertIn(str(codepoint), font['glyphs'], (name, char))


if __name__ == '__main__':
    unittest.main()
