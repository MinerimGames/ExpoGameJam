"""Check native resource links, intact art and the classroom arrival corridor."""
from pathlib import Path
import sys
import unittest
from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'tools'))
from evento_project import load


class FatecResources(unittest.TestCase):
    def test_classroom_resources_registered(self):
        project = load(ROOT / 'ParadoxoDeWilson.yyp')
        paths = {r['id']['path'] for r in project['resources']}
        for name, kind in [('rm_fatec_classroom', 'rooms'), ('obj_fatec_ending', 'objects'),
                           ('spr_fatec_classroom', 'sprites'), ('spr_wilson_professor', 'sprites')]:
            self.assertIn(f'{kind}/{name}/{name}.yy', paths)

    def test_professor_keeps_native_alpha_and_image(self):
        source = ROOT / 'output/imagegen/wilson-professor.png'
        self.assertEqual(Image.open(source).getchannel('A').getextrema(), (0, 255))
        resource = load(ROOT / 'sprites/spr_wilson_professor/spr_wilson_professor.yy')
        actual = ROOT / 'sprites/spr_wilson_professor' / (resource['frames'][0]['name'] + '.png')
        self.assertEqual(actual.read_bytes(), source.read_bytes())
        self.assertEqual(resource['sequence']['yorigin'], resource['bbox_bottom'] + 1)

    def test_classroom_camera_and_clear_center_corridor(self):
        room = load(ROOT / 'rooms/rm_fatec_classroom/rm_fatec_classroom.yy')
        self.assertEqual((room['roomSettings']['Width'], room['roomSettings']['Height']), (960, 640))
        view = room['views'][0]
        self.assertEqual((view['wview'], view['hview'], view['objectId']), (960, 640, None))
        instances = [i for layer in room['layers'] for i in layer.get('instances', [])]
        self.assertEqual(sum(i['objectId']['name'] == 'obj_player' for i in instances), 1)
        self.assertEqual(sum(i['objectId']['name'] == 'obj_fatec_ending' for i in instances), 1)
        for i in instances:
            if i['objectId']['name'] != 'obj_colisor':
                continue
            left, top = i['x'], i['y']
            right, bottom = left + 32*i['scaleX'], top + 32*i['scaleY']
            # The entire entrance-to-front walk stays inside an open central aisle.
            self.assertFalse(left < 492 and right > 468 and top < 568 and bottom > 180,
                             f'Collider blocks homecoming: {i["name"]}')


if __name__ == '__main__':
    unittest.main()
