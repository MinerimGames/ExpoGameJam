"""Verify complete, audible user audio and lossless decorative art delivery."""
import hashlib
import json
from pathlib import Path
import unittest
import wave

import numpy as np

ROOT = Path(__file__).resolve().parents[1]


class UserProvidedFinalAssets(unittest.TestCase):
    def test_complete_stereo_recording_has_headroom_and_native_registration(self):
        meta = json.loads((ROOT / 'output/audio/newton-recording.json').read_text())
        source = ROOT / meta['source']
        self.assertEqual(hashlib.sha256(source.read_bytes()).hexdigest(), meta['source_sha256'])
        with wave.open(str(ROOT / meta['wave_path']), 'rb') as wav:
            self.assertEqual((wav.getframerate(), wav.getnchannels(), wav.getsampwidth()), (44100, 2, 2))
            self.assertAlmostEqual(wav.getnframes() / wav.getframerate(), meta['duration_seconds'], places=4)
            self.assertGreater(meta['duration_seconds'], 181)
            audio = np.frombuffer(wav.readframes(wav.getnframes()), dtype='<i2') / 32768.
        self.assertLess(np.max(np.abs(audio)), .96)
        self.assertGreater(np.sqrt(np.mean(audio * audio)), .10)
        yy = json.loads((ROOT / meta['resource_path']).read_text())
        self.assertEqual(yy['compression'], 1)
        self.assertTrue(yy['preload'])
        self.assertFalse(meta['loop'])
        self.assertEqual(yy['soundFile'], Path(meta['wave_path']).name)

    def test_user_recording_is_not_claimed_as_original_cc0_score(self):
        original = json.loads((ROOT / 'output/audio/manifest.json').read_text())
        self.assertNotIn('snd_newton_recording', [a['name'] for a in original['assets']])
        imported = json.loads((ROOT / 'output/audio/newton-recording.json').read_text())
        self.assertIn('supplied by the user', imported['provenance'])

    def test_added_credit_art_is_imported_byte_for_byte(self):
        for name, filename in [('akatsuki', 'Akatsuki0.png'), ('steampunk', 'Steampunk0.png')]:
            folder = ROOT / 'sprites' / ('spr_credit_' + name)
            from tools.evento_project import load
            yy = load(folder / ('spr_credit_' + name + '.yy'))
            frame = yy['frames'][0]['name']
            self.assertEqual((folder / (frame + '.png')).read_bytes(),
                             (ROOT / 'output/credits' / filename).read_bytes())


if __name__ == '__main__':
    unittest.main()
