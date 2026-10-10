"""Catch dropped/reordered frames and changes to pixels during native packing."""
import hashlib
import json
import unittest
import zipfile
from pathlib import Path
from PIL import Image

ROOT = Path(__file__).resolve().parents[1]

class FinalCinematicAssets(unittest.TestCase):
    def test_every_supplied_frame_is_registered_in_numeric_folder_order(self):
        receipt = ROOT/'output/ending-20261010/import.json'
        self.assertTrue(receipt.is_file(), 'The supplied cinematic has not been imported')
        report = json.loads(receipt.read_text())
        expected = [(1, n) for n in range(1, 6)] + [(2, n) for n in (1,2,3,4,6,7,8,9,10)] + [(3, n) for n in range(1, 6)]
        self.assertEqual([(f['folder'], f['number']) for f in report['frames']], expected)
        with zipfile.ZipFile('C:/Users/jrhre/Downloads/Cenas para animar corrigido.zip') as archive:
            for frame in report['frames']:
                with self.subTest(frame=frame['entry']):
                    with archive.open(frame['entry']) as stream:
                        source = Image.open(stream).convert('RGBA')
                    packed = Image.open(ROOT/'sprites/spr_final_cinematic'/(frame['frame']+'.png')).convert('RGBA')
                    self.assertEqual(packed.size, (1672, 941))
                    original_bounds = packed.crop((0, 0, source.width, source.height))
                    self.assertEqual(original_bounds.tobytes(), source.tobytes())
                    self.assertEqual(hashlib.sha256(source.tobytes()).hexdigest(), frame['pixel_sha256'])

if __name__ == '__main__':
    unittest.main()
