"""Output diagnostics must distinguish silence and never select a microphone."""
import importlib.util
from pathlib import Path
import unittest
import numpy as np

TOOL = Path(__file__).resolve().parents[1] / "tools/diagnose_audio_output.py"


class OutputDiagnostics(unittest.TestCase):
    def module(self):
        self.assertTrue(TOOL.exists(), "Audio output diagnostic tool is missing")
        spec = importlib.util.spec_from_file_location("audio_diagnostic", TOOL)
        module = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(module)
        return module

    def test_pcm_metrics_distinguish_silence_from_known_signal(self):
        module = self.module()
        silent = module.measure_pcm16(bytes(512))
        self.assertEqual(silent["rms"], 0)
        self.assertIsNone(silent["rms_dbfs"])
        signal = np.array([16384, -16384] * 128, dtype="<i2").tobytes()
        measured = module.measure_pcm16(signal)
        self.assertAlmostEqual(measured["rms"], .5)
        self.assertAlmostEqual(measured["rms_dbfs"], -6.020599913)

    def test_requested_microphone_is_rejected_as_loopback(self):
        module = self.module()
        devices = [{"index": 2, "name": "Microphone (Fuxi-H3)", "isLoopbackDevice": False, "maxInputChannels": 1}]
        with self.assertRaises(ValueError):
            module.select_loopback(devices, "Fuxi")

    def test_only_output_loopback_is_selected_when_names_match(self):
        module = self.module()
        devices = [{"index": 2, "name": "Microphone (Fuxi-H3)", "isLoopbackDevice": False},
                   {"index": 15, "name": "Headphones (Fuxi-H3) [Loopback]", "isLoopbackDevice": True, "maxInputChannels": 2}]
        self.assertEqual(module.select_loopback(devices, "Fuxi")["index"], 15)

    def test_unmute_authorization_excludes_ide_and_unrelated_programs(self):
        module = self.module()
        self.assertTrue(hasattr(module, "is_game_image"), "Game-only unmute guard is missing")
        self.assertFalse(module.is_game_image("C:/Program Files/GameMaker-LTS2026/GameMaker-LTS2026.exe"))
        self.assertFalse(module.is_game_image("C:/Other/Runner.exe"))
        self.assertFalse(module.is_game_image("C:/Other/ParadoxoDeWilson.exe"))
        self.assertTrue(module.is_game_image("C:/ProgramData/GameMakerStudio2-LTS2026/Cache/runtimes/runtime-2026.0.0.23/windows/x64/Runner.exe"))
        self.assertTrue(module.is_game_image(str(TOOL.parents[1] / "dist/ParadoxoDeWilson-Windows-evil-newton-audio-20261007/Jogo/ParadoxoDeWilson.exe")))

    def test_final_delivered_game_is_allowed_but_other_final_executables_are_not(self):
        module = self.module()
        delivered = TOOL.parents[2] / 'Paradoxo de Wilson - Final/Windows/ParadoxoDeWilson.exe'
        self.assertTrue(module.is_game_image(str(delivered)))
        self.assertFalse(module.is_game_image(str(delivered.with_name('OtherGame.exe'))))
        self.assertFalse(module.is_game_image('C:/Other/Paradoxo de Wilson - Final/Windows/ParadoxoDeWilson.exe'))


if __name__ == "__main__":
    unittest.main()
