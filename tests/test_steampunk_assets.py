"""Native art fidelity, frame linkage and usable transparency for the expansion."""
from pathlib import Path
import sys
import unittest
from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'tools'))
from evento_project import load


class ExpansionArt(unittest.TestCase):
    def test_registered_frames_preserve_supplied_and_generated_art(self):
        assets = {
            'spr_credit_yandere': 'output/credits/Yandere0.png',
            'spr_steampunk_idle': 'output/steampunk/Steampunk0-reference.png',
            'spr_steampunk_foundry': 'output/steampunk/foundry.png',
            **{'spr_steampunk_' + pose: 'output/steampunk/' + pose + '.png'
               for pose in ['talk', 'attack', 'defense']},
            **{'spr_city_flag_' + pose: 'output/city-flags/' + pose + '.png'
               for pose in ['salute', 'speech', 'resolve']},
        }
        project = load(ROOT / 'ParadoxoDeWilson.yyp')
        registered = {r['id']['path'] for r in project['resources']}
        for name, source in assets.items():
            with self.subTest(asset=name):
                path = f'sprites/{name}/{name}.yy'
                self.assertIn(path, registered)
                resource = load(ROOT / path)
                actual = ROOT / 'sprites' / name / (resource['frames'][0]['name'] + '.png')
                self.assertEqual(actual.read_bytes(), (ROOT / source).read_bytes())

    def test_character_poses_have_clean_transparent_edges_and_are_distinct(self):
        sources = [ROOT / 'output/steampunk' / (pose + '.png')
                   for pose in ['talk', 'attack', 'defense']]
        self.assertEqual(len({p.read_bytes() for p in sources}), 3)
        for source in sources + [ROOT / 'output/credits/Yandere0.png']:
            with self.subTest(asset=source.name), Image.open(source) as im:
                alpha = im.getchannel('A')
                self.assertEqual(alpha.getextrema(), (0, 255))
                # Supplied art may reach a canvas edge; the four corners must
                # remain transparent, without an opaque rectangular backdrop.
                for corner in [(0, 0), (im.width-1, 0), (0, im.height-1),
                               (im.width-1, im.height-1)]:
                    self.assertLessEqual(alpha.getpixel(corner), 8)
                self.assertGreater(sum(alpha.histogram()[:9]), im.width*im.height*.20)

    def test_posters_use_three_distinct_high_resolution_portraits(self):
        sources = [ROOT / 'output/city-flags' / (pose + '.png')
                   for pose in ['salute', 'speech', 'resolve']]
        self.assertEqual(len({p.read_bytes() for p in sources}), 3)
        for source in sources:
            with self.subTest(asset=source.name), Image.open(source) as im:
                self.assertGreaterEqual(min(im.size), 1024)


if __name__ == '__main__':
    unittest.main()
