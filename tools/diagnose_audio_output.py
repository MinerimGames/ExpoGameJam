"""Windows render-device/session diagnosis. Never opens microphones.

Snapshot (no capture): python tools/diagnose_audio_output.py
Output-only PCM metrics, while ONLY our game plays audio:
  python tools/diagnose_audio_output.py --measure 6 --game-pid PID --device Fuxi --only-game-audio
Session-only peak meter (no audio capture): --session-meter 6 --game-pid PID
Explicit game-only mute correction: --unmute-game --game-pid PID
The measurement refuses other active app sessions. No samples are saved. No
Windows volume/settings are changed; only --unmute-game can clear mute on the
specified known game process, preserving every other session. PyAudioWPatch is used only for
explicit measurement, installed in ~/.cache/game-audio-diagnostics.
Primary references: Microsoft IMMDeviceEnumerator / IAudioEndpointVolume /
IAudioSessionManager2 / ISimpleAudioVolume; PyAudioWPatch's loopback API.
"""
import argparse
import ctypes as C
from ctypes import wintypes as W
import json
import math
from pathlib import Path
import sys
import time
import uuid

import numpy as np

ROOT = Path(__file__).resolve().parents[1]


def measure_pcm16(data):
    values = np.frombuffer(data, dtype="<i2").astype(np.float64) / 32768.
    rms = float(np.sqrt(np.mean(values * values))) if len(values) else 0.
    return {"rms": rms, "peak": float(np.max(np.abs(values))) if len(values) else 0.,
            "rms_dbfs": 20 * math.log10(rms) if rms > 0 else None,
            "nonzero_fraction": float(np.count_nonzero(values) / len(values)) if len(values) else 0.}


def select_loopback(devices, target):
    matches = [d for d in devices if d.get("isLoopbackDevice") is True
               and d.get("maxInputChannels", 0) > 0 and target.casefold() in d["name"].casefold()]
    if len(matches) != 1:
        raise ValueError(f"Expected exactly one output loopback matching {target!r}; found {len(matches)}")
    return matches[0]


class GUID(C.Structure):
    _fields_ = [("Data1", C.c_uint32), ("Data2", C.c_uint16), ("Data3", C.c_uint16), ("Data4", C.c_ubyte * 8)]

    @classmethod
    def parse(cls, value):
        return cls.from_buffer_copy(uuid.UUID(value).bytes_le)


class PROPERTYKEY(C.Structure):
    _fields_ = [("fmtid", GUID), ("pid", C.c_uint32)]


class PROPUNION(C.Union):
    _fields_ = [("pointer", C.c_void_p), ("storage", C.c_byte * 16)]


class PROPVARIANT(C.Structure):
    _fields_ = [("vt", C.c_uint16), ("r1", C.c_uint16), ("r2", C.c_uint16), ("r3", C.c_uint16), ("value", PROPUNION)]


def process_image(pid):
    if pid == 0:
        return "Windows system sounds"
    kernel = C.WinDLL("kernel32", use_last_error=True)
    kernel.OpenProcess.argtypes = [W.DWORD, W.BOOL, W.DWORD]
    kernel.OpenProcess.restype = W.HANDLE
    kernel.QueryFullProcessImageNameW.argtypes = [W.HANDLE, W.DWORD, W.LPWSTR, C.POINTER(W.DWORD)]
    kernel.CloseHandle.argtypes = [W.HANDLE]
    handle = kernel.OpenProcess(0x1000, False, pid)
    if not handle:
        return ""
    try:
        text = C.create_unicode_buffer(32768)
        size = W.DWORD(len(text))
        return text.value if kernel.QueryFullProcessImageNameW(handle, 0, text, C.byref(size)) else ""
    finally:
        kernel.CloseHandle(handle)


def is_game_image(image):
    """Allow only the installed GameMaker runner or this delivered game."""
    candidate = Path(image).resolve()
    normalized = str(candidate).replace("\\", "/").casefold()
    if candidate.name.casefold() == "runner.exe":
        return normalized.startswith("c:/programdata/gamemakerstudio2-lts2026/cache/runtimes/")
    if candidate.name.casefold() != "paradoxodewilson.exe":
        return False
    if candidate == (ROOT.parent / 'Paradoxo de Wilson - Final/Windows/ParadoxoDeWilson.exe').resolve():
        return True
    return any(candidate.is_relative_to(folder.resolve()) for folder in
               (ROOT / "dist", Path.home() / "OneDrive/Desktop/Paradoxo de Wilson"))


class CoreAudio:
    """COM reader; its only optional setter clears mute on a validated game PID."""
    def __init__(self):
        self.pointers = []
        self.session_controls = {}
        self.ole = C.OleDLL("ole32")
        self.ole.CoInitializeEx(None, 0)
        self.ole.CoCreateInstance.argtypes = [C.POINTER(GUID), C.c_void_p, W.DWORD, C.POINTER(GUID), C.POINTER(C.c_void_p)]
        self.ole.CoTaskMemFree.argtypes = [C.c_void_p]
        self.enumerator = C.c_void_p()
        self.ole.CoCreateInstance(C.byref(GUID.parse("bcde0395-e52f-467c-8e3d-c4579291692e")), None, 1,
                                  C.byref(GUID.parse("a95664d2-9614-4f35-a746-de8db63617e6")), C.byref(self.enumerator))
        self.pointers.append(self.enumerator)

    def call(self, pointer, slot, types=(), values=()):
        table = C.cast(pointer, C.POINTER(C.POINTER(C.c_void_p))).contents
        function = C.WINFUNCTYPE(C.c_long, C.c_void_p, *types)(table[slot])
        result = function(pointer, *values)
        if result < 0:
            raise OSError(f"CoreAudio HRESULT 0x{result & 0xffffffff:08X}, slot {slot}")
        return result

    def interface(self, pointer, iid, activate=False):
        out = C.c_void_p()
        guid = GUID.parse(iid)
        if activate:
            self.call(pointer, 3, (C.POINTER(GUID), W.DWORD, C.c_void_p, C.POINTER(C.c_void_p)), (C.byref(guid), 23, None, C.byref(out)))
        else:
            self.call(pointer, 0, (C.POINTER(GUID), C.POINTER(C.c_void_p)), (C.byref(guid), C.byref(out)))
        self.pointers.append(out)
        return out

    def child(self, pointer, slot, types=(), values=()):
        out = C.c_void_p()
        self.call(pointer, slot, (*types, C.POINTER(C.c_void_p)), (*values, C.byref(out)))
        self.pointers.append(out)
        return out

    def value(self, pointer, slot, kind):
        out = kind()
        self.call(pointer, slot, (C.POINTER(kind),), (C.byref(out),))
        return out.value

    def string(self, pointer, slot):
        out = C.c_void_p()
        self.call(pointer, slot, (C.POINTER(C.c_void_p),), (C.byref(out),))
        value = C.wstring_at(out) if out else ""
        self.ole.CoTaskMemFree(out)
        return value

    def friendly_name(self, device):
        store = self.child(device, 4, (W.DWORD,), (0,))
        key = PROPERTYKEY(GUID.parse("a45c254e-df1c-4efd-8020-67d146a850e0"), 14)
        variant = PROPVARIANT()
        self.call(store, 5, (C.POINTER(PROPERTYKEY), C.POINTER(PROPVARIANT)), (C.byref(key), C.byref(variant)))
        name = C.wstring_at(variant.value.pointer) if variant.vt == 31 and variant.value.pointer else ""
        self.ole.PropVariantClear(C.byref(variant))
        return name

    def sessions(self, device):
        manager = self.interface(device, "77aa99a0-1bd6-484f-8bc7-2c654c9a9b6f", True)
        enumerator = self.child(manager, 5)
        count = self.value(enumerator, 3, C.c_int)
        sessions = []
        for i in range(count):
            control = self.child(enumerator, 4, (C.c_int,), (i,))
            control2 = self.interface(control, "bfb7ff88-7239-4fc9-8fa2-07c950be9c6d")
            pid = self.value(control2, 14, W.DWORD)
            volume = self.interface(control, "87ce5498-68d6-44e5-9215-6da47ef883d8")
            item = {"pid": pid, "process_image": process_image(pid),
                    "state": self.value(control, 3, C.c_int), "display_name": self.string(control, 4),
                    "session_identifier": self.string(control2, 12),
                    "volume_scalar": self.value(volume, 4, C.c_float), "mute": bool(self.value(volume, 6, W.BOOL))}
            try:
                meter = self.interface(control, "c02216f6-8c67-4b5b-9d00-d008e73e0064")
                item["session_peak"] = self.value(meter, 3, C.c_float)
            except OSError:
                meter = None
                item["session_peak"] = None
            self.session_controls.setdefault(pid, []).append((item, volume, meter))
            sessions.append(item)
        return sessions

    def snapshot(self):
        self.session_controls.clear()
        defaults = {}
        for role, label in ((0, "console"), (1, "multimedia"), (2, "communications")):
            device = self.child(self.enumerator, 4, (C.c_int, C.c_int), (0, role))
            defaults[label] = self.string(device, 5)
        collection = self.child(self.enumerator, 3, (C.c_int, W.DWORD), (0, 1))
        count = self.value(collection, 3, W.UINT)
        devices = []
        for i in range(count):
            device = self.child(collection, 4, (W.UINT,), (i,))
            name, identifier = self.friendly_name(device), self.string(device, 5)
            volume = self.interface(device, "5cdf2c82-841e-4546-9722-0cf74078229a", True)
            item = {"name": name, "id": identifier,
                    "default_roles": [role for role, value in defaults.items() if value == identifier],
                    "master_volume_scalar": self.value(volume, 9, C.c_float),
                    "master_volume_db": self.value(volume, 8, C.c_float),
                    "master_mute": bool(self.value(volume, 15, W.BOOL)), "sessions": self.sessions(device)}
            devices.append(item)
        return {"render_devices": devices, "default_render_ids": defaults}

    def close(self):
        for pointer in reversed(self.pointers):
            self.call(pointer, 2)
        self.pointers.clear()
        self.ole.CoUninitialize()


def snapshot():
    audio = CoreAudio()
    try:
        return audio.snapshot()
    finally:
        audio.close()


def game_session_probe(game_pid, seconds=0, unmute=False):
    image = process_image(game_pid)
    if not is_game_image(image):
        raise RuntimeError(f"PID {game_pid} is not an allowed installed Runner or delivered ParadoxoDeWilson.exe: {image!r}")
    audio = CoreAudio()
    try:
        before = audio.snapshot()
        controls = audio.session_controls.get(game_pid, [])
        if not controls:
            raise RuntimeError("Specified game has no Windows render session")
        changes = 0
        if unmute:
            for item, volume, _ in controls:
                if item["mute"]:
                    # ISimpleAudioVolume::SetMute only. No volume or endpoint setter.
                    audio.call(volume, 5, (W.BOOL, C.POINTER(GUID)), (False, None))
                    changes += 1
        meters = [meter for _, _, meter in controls if meter]
        observations = []
        if seconds and not meters:
            raise RuntimeError("Game session does not expose an IAudioMeterInformation interface")
        end = time.monotonic() + seconds
        while seconds and time.monotonic() < end:
            observations.append(max(audio.value(meter, 3, C.c_float) for meter in meters))
            time.sleep(.05)
        after = audio.snapshot()
        subset = lambda report: [{"device": d["name"], "master_mute": d["master_mute"],
                                  "master_volume_scalar": d["master_volume_scalar"], "session": s}
                                 for d in report["render_devices"] for s in d["sessions"] if s["pid"] == game_pid]
        return {"game_pid": game_pid, "process_image": image, "mute_flags_cleared": changes,
                "source": "Game-only Windows session peak meter; no audio capture", "before": subset(before), "after": subset(after),
                "meter_duration_seconds": seconds, "session_peak_max": max(observations) if observations else None,
                "peak_observations": len(observations), "nonzero_observations": sum(v > 0 for v in observations)}
    finally:
        audio.close()


def verify_only_game_audio(report, game_pid, target):
    endpoints = [d for d in report["render_devices"] if target.casefold() in d["name"].casefold()]
    if len(endpoints) != 1:
        raise RuntimeError("Choose exactly one render endpoint by --device")
    game = [s for s in endpoints[0]["sessions"] if s["pid"] == game_pid]
    if not game:
        raise RuntimeError(f"Game PID {game_pid} has no session on selected render endpoint")
    other = [s for s in endpoints[0]["sessions"] if s["state"] == 1 and s["pid"] != game_pid
             and not s["mute"] and s["volume_scalar"] > 0]
    if other:
        raise RuntimeError("Other active output sessions detected; refusing capture: " + ", ".join(str(s["pid"]) for s in other))
    return endpoints[0]


def loopback_metrics(seconds, game_pid, target):
    sys.path.insert(0, str(Path.home() / ".cache/game-audio-diagnostics"))
    import pyaudiowpatch as pa
    before = snapshot()
    endpoint = verify_only_game_audio(before, game_pid, target)
    if not is_game_image(process_image(game_pid)):
        raise RuntimeError("PID is not a recognized game/Runner executable")
    with pa.PyAudio() as audio:
        device = select_loopback(list(audio.get_loopback_device_info_generator()), target)
        rate, channels = round(device["defaultSampleRate"]), device["maxInputChannels"]
        blocks, read = [], 0
        count = max(1, round(seconds * rate))
        with audio.open(format=pa.paInt16, channels=channels, rate=rate, input=True,
                        input_device_index=device["index"], frames_per_buffer=1024) as stream:
            while read < count:
                frames = min(1024, count - read)
                blocks.append(stream.read(frames, exception_on_overflow=False))
                read += frames
        after = snapshot()
        verify_only_game_audio(after, game_pid, target)
        metrics = measure_pcm16(b"".join(blocks))
        return {"source": "WASAPI output loopback; no microphone", "device": device["name"], "rate": rate,
                "channels": channels, "seconds": read / rate, "metrics": metrics,
                "before_endpoint": endpoint, "after_endpoint": verify_only_game_audio(after, game_pid, target)}


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--measure", type=float, default=0, help="Seconds to measure output; opt-in only")
    parser.add_argument("--game-pid", type=int)
    parser.add_argument("--session-meter", type=float, default=0, help="Seconds to read only specified game's session peak, no capture")
    parser.add_argument("--unmute-game", action="store_true", help="Clear mute only on the validated game PID; preserve other settings")
    parser.add_argument("--device", default="Fuxi")
    parser.add_argument("--only-game-audio", action="store_true", help="Confirm no other applications are playing audio")
    parser.add_argument("--output", type=Path, help="Save JSON metrics/metadata only, never audio samples")
    args = parser.parse_args()
    if args.unmute_game or args.session_meter:
        if not args.game_pid or not 0 <= args.session_meter <= 30 or args.measure:
            parser.error("Game-only probe requires --game-pid, 0 <= meter seconds <= 30, and no --measure")
        result = game_session_probe(args.game_pid, args.session_meter, args.unmute_game)
    elif args.measure:
        if not args.only_game_audio or not args.game_pid or not 0 < args.measure <= 30:
            parser.error("Measurement requires --only-game-audio, --game-pid, and 0 < seconds <= 30")
        result = loopback_metrics(args.measure, args.game_pid, args.device)
    else:
        result = snapshot()
    text = json.dumps(result, indent=2, ensure_ascii=False)
    if args.output:
        args.output.parent.mkdir(parents=True, exist_ok=True)
        args.output.write_text(text + "\n", encoding="utf-8")
    print(text)


if __name__ == "__main__":
    main()
