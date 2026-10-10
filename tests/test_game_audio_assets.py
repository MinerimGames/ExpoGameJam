"""Checks audible delivery risks: silence, clipping, clicks, and reused footfalls."""
import hashlib
import json
from pathlib import Path
import unittest
import wave

import numpy as np

ROOT = Path(__file__).resolve().parents[1]
MANIFEST = ROOT / "output/audio/manifest.json"


def samples(asset):
    with wave.open(str(ROOT / asset["wave_path"]), "rb") as source:
        rate, channels, width = source.getframerate(), source.getnchannels(), source.getsampwidth()
        audio = np.frombuffer(source.readframes(source.getnframes()), dtype="<i2").reshape(-1, channels) / 32768.
    return rate, channels, width, audio


class GameAudioAssets(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.manifest = json.loads(MANIFEST.read_text()) if MANIFEST.exists() else None

    def test_original_manifest_and_playable_resources_exist(self):
        # Missing source audio or wrong YY filename would produce missing sounds in GameMaker.
        self.assertIsNotNone(self.manifest, "Original audio delivery has not been generated")
        for asset in self.manifest["assets"]:
            path = ROOT / asset["resource_path"]
            self.assertTrue(path.exists(), asset["name"])
            resource = json.loads(path.read_text())
            self.assertEqual(resource["resourceType"], "GMSound")
            self.assertEqual(resource["name"], asset["name"])
            self.assertTrue((path.parent / resource["soundFile"]).exists())
        self.assertEqual(self.manifest["license"], "CC0-1.0")

    def test_native_channel_format_matches_source_audio(self):
        # LTS2026 rejects missing channelFormat; stereo scores must remain stereo.
        self.assertIsNotNone(self.manifest)
        for asset in self.manifest["assets"]:
            resource = json.loads((ROOT / asset["resource_path"]).read_text())
            _, channels, _, _ = samples(asset)
            self.assertIn("channelFormat", resource, asset["name"])
            self.assertEqual(resource["channelFormat"], 1 if channels == 2 else 0, asset["name"])
            self.assertIn("compressionQuality", resource, asset["name"])
            self.assertIn("exportDir", resource, asset["name"])

    def test_sound_payload_has_headroom_and_no_dc_offset(self):
        self.assertIsNotNone(self.manifest, "Original audio delivery has not been generated")
        total = 0
        for asset in self.manifest["assets"]:
            rate, channels, width, audio = samples(asset)
            self.assertEqual((rate, width), (44100, 2), asset["name"])
            self.assertEqual(channels, 2 if asset["category"] == "music" else 1)
            self.assertLessEqual(float(np.max(np.abs(audio))), .86, asset["name"])
            self.assertGreater(float(np.sqrt(np.mean(audio * audio))), .006, asset["name"])
            self.assertLess(abs(float(audio.mean())), .003, asset["name"])
            self.assertAlmostEqual(len(audio) / rate, asset["duration_seconds"], places=4)
            total += (ROOT / asset["wave_path"]).stat().st_size
        self.assertLess(total, 40_000_000)

    def test_loops_join_without_discontinuity_and_music_has_phrase_dynamics(self):
        self.assertIsNotNone(self.manifest, "Original audio delivery has not been generated")
        for asset in self.manifest["assets"]:
            rate, _, _, audio = samples(asset)
            # A removed edge taper or lost wrapped reverb tail produces an audible loop click.
            self.assertLess(float(np.max(np.abs(audio[0]))), .002)
            self.assertLess(float(np.max(np.abs(audio[-1]))), .002)
            if asset["loop"]:
                self.assertLess(float(np.max(np.abs(audio[0] - audio[-1]))), .002)
            if asset["category"] == "music":
                self.assertGreater(len(audio) / rate, 9)
                mono = audio.mean(axis=1)
                windows = [np.sqrt(np.mean(chunk * chunk)) for chunk in np.array_split(mono, 32)]
                self.assertGreater(np.std(windows) / np.mean(windows), .045, asset["name"])
                self.assertGreater(float(np.mean(np.abs(audio[:, 0] - audio[:, 1]))), .004)

    def test_footsteps_are_short_and_have_distinct_material_spectra(self):
        self.assertIsNotNone(self.manifest, "Original audio delivery has not been generated")
        steps = [a for a in self.manifest["assets"] if a["category"] == "footstep"]
        self.assertGreaterEqual(len(steps), 10)
        fingerprints, centroids = set(), []
        for asset in steps:
            rate, _, _, audio = samples(asset)
            self.assertGreater(len(audio) / rate, .1)
            self.assertLess(len(audio) / rate, .6)
            fingerprints.add(hashlib.sha256(audio.tobytes()).digest())
            spectrum = np.abs(np.fft.rfft(audio[:, 0]))
            centroids.append(np.sum(np.fft.rfftfreq(len(audio), 1 / rate) * spectrum) / spectrum.sum())
        self.assertEqual(len(fingerprints), len(steps))
        self.assertGreater(np.std(centroids), 180., "Materials must not all sound like the same footfall")

    def test_current_footsteps_use_foley_sources_instead_of_old_synthesis(self):
        self.assertIsNotNone(self.manifest)
        for asset in self.manifest['assets']:
            if asset['category'] != 'footstep': continue
            with self.subTest(asset=asset['name']):
                self.assertEqual(asset.get('source_url'), 'https://kenney.nl/assets/impact-sounds')
                source=ROOT / asset.get('source_path', 'missing-foley-source')
                self.assertTrue(source.is_file())
                self.assertEqual(hashlib.sha256(source.read_bytes()).hexdigest(), asset.get('source_sha256'))
                _, _, _, audio=samples(asset)
                old=ROOT/'output/audio/previous-synth-footsteps.json'
                self.assertTrue(old.is_file())
                previous=json.loads(old.read_text())
                self.assertNotEqual(hashlib.sha256((ROOT/asset['wave_path']).read_bytes()).hexdigest(), previous[asset['name']])


if __name__ == "__main__":
    unittest.main()
