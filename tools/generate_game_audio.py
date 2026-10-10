"""Compose the original score and import natural Kenney CC0 footstep foley.

Run: python tools/generate_game_audio.py
All emitted waveforms and melodies are released under CC0-1.0. Deterministic
seed, 44.1 kHz PCM16, stereo scores and mono effects; requires numpy/scipy/soundfile.
"""
from pathlib import Path
import json
import hashlib
import sys
import wave

import numpy as np
import soundfile as sf
from scipy.signal import butter, sosfilt

ROOT = Path(__file__).resolve().parents[1]
RATE = 44100
RNG = np.random.default_rng(20261007)
TAU = 2 * np.pi


def time(duration):
    return np.arange(round(duration * RATE)) / RATE


def fade(sound, attack=.004, release=.012):
    sound = sound.copy()
    for length, front in ((min(round(attack * RATE), len(sound) // 2), True),
                          (min(round(release * RATE), len(sound) // 2), False)):
        ramp = np.sin(np.linspace(0, np.pi / 2, length)) ** 2
        if sound.ndim == 2:
            ramp = ramp[:, None]
        if front:
            sound[:length] *= ramp
        else:
            sound[-length:] *= ramp[::-1]
    return sound


def noise(duration, cutoff=2200, high=None):
    n = RNG.normal(0, 1, len(time(duration)))
    bounds = cutoff if high is None else [high, cutoff]
    n = sosfilt(butter(2, bounds, btype="lowpass" if high is None else "bandpass", fs=RATE, output="sos"), n)
    return n / (np.std(n) + 1e-9)


def note(midi, duration, voice="harp"):
    t = time(duration)
    freq = 440 * 2 ** ((midi - 69) / 12)
    if voice == "pad":
        body = sum(np.sin(TAU * freq * (1 + detune) * t + phase) * weight
                   for detune, phase, weight in [(-.0015, 0, .4), (.0015, .8, .4), (0, 0, .5)])
        body += .11 * np.sin(TAU * freq * 2 * t)
        return fade(body, .25, .4)
    if voice == "bass":
        return fade((np.sin(TAU * freq * t) + .2 * np.sin(TAU * freq * 2 * t)) * np.exp(-t * 1.4), .008, .08)
    if voice == "bell":
        body = sum(np.sin(TAU * freq * ratio * t) * weight * np.exp(-t * decay)
                   for ratio, weight, decay in [(1, 1, 2), (2, .32, 3), (2.76, .1, 4), (4, .06, 7)])
    elif voice == "lead":
        vibrato = .002 * np.sin(TAU * 4.6 * t)
        body = np.sin(TAU * freq * t + vibrato) + .2 * np.sin(TAU * freq * 2 * t)
        body *= np.exp(-t * 2.2)
    else:
        body = sum(np.sin(TAU * freq * harmonic * t) * weight * np.exp(-t * decay)
                   for harmonic, weight, decay in [(1, 1, 2.9), (2, .35, 5.5), (3, .12, 8), (4, .05, 10)])
    return fade(body, .005, .06)


def add(track, sound, start, gain=1, pan=0, wrap=False):
    start = round(start * RATE)
    if track.ndim == 2:
        sound = sound[:, None] * np.array([np.cos((pan + 1) * np.pi / 4), np.sin((pan + 1) * np.pi / 4)])[None, :]
    sound = sound * gain
    if wrap:
        indexes = (start + np.arange(len(sound))) % len(track)
        np.add.at(track, indexes, sound)
    elif start < len(track):
        count = min(len(sound), len(track) - start)
        track[start:start + count] += sound[:count]


def drum(kind, duration=.2):
    t = time(duration)
    if kind == "kick":
        return fade(np.sin(TAU * (52 * t + 5 * (1 - np.exp(-t * 40)))) * np.exp(-t * 19), .002, .012)
    if kind == "snare":
        return fade((noise(duration, 4600, 350) * .5 + np.sin(TAU * 190 * t) * .25) * np.exp(-t * 23))
    return fade(noise(duration, 7500, 4200) * np.exp(-t * 65), .002, .015)


def score(kind):
    bpm = 96 if kind in ("exploration", "ending") else 120
    beat = 60 / bpm
    bars = 4 if kind == "ending" else 16
    total = bars * 4 * beat
    out = np.zeros((round(total * RATE), 2))
    # A shared five-note Wilson motif; authored pitch/length phrases, no sampled material.
    chords = [[57, 60, 64, 71], [53, 57, 60, 64], [48, 55, 59, 64], [52, 56, 59, 62],
              [50, 57, 60, 65], [57, 60, 64, 67], [58, 62, 65, 69], [52, 56, 59, 64]]
    phrases = [[(76, 0, 1), (79, 1.5, .5), (83, 2, 1), (81, 3, .75)],
               [(81, 0, 1.5), (76, 2, .75), (72, 3, .75)],
               [(76, 0, .75), (79, 1, .75), (74, 2, 1.5)],
               [(75, 0, 1), (76, 1.5, .5), (80, 2, 1), (71, 3, .75)]]
    if kind == "ending":
        chords = [[60, 64, 67, 72], [53, 57, 60, 65], [55, 59, 62, 67], [60, 64, 67, 72]]
        phrases = [[(76, 0, .5), (79, .5, .5), (84, 1, 1.5), (83, 3, .8)],
                   [(81, 0, 1), (79, 1.5, .5), (77, 2, 1.5)],
                   [(79, 0, .75), (83, 1, .75), (86, 2, 1.5)],
                   [(84, 0, 3.5)]]
    for bar in range(bars):
        start = bar * 4 * beat
        chord = chords[bar % len(chords)]
        intensity = 1 + .1 * np.sin(bar * 1.2)
        if kind == "newton":
            chord = [n - 12 for n in chord]
            # Suspended dissonance opens into the dominant at each 8-bar cycle.
            chord[-1] += 1 if bar % 4 != 3 else 0
        for i, pitch in enumerate(chord):
            add(out, note(pitch, 4 * beat + .6, "pad"), start, .044 * intensity,
                -.75 + i * .5, wrap=kind != "ending")
        bass = chord[0] - 12
        for position in (0, 2):
            add(out, note(bass, beat * 1.85, "bass"), start + beat * position, .17 * intensity)
        if kind == "exploration" or kind == "ending":
            for eighth in range(8):
                pitch = chord[[0, 2, 1, 3, 2, 1, 3, 2][eighth]] + 12
                add(out, note(pitch, 1.2, "harp"), start + eighth * beat / 2, .095 * intensity,
                    -.5 if eighth % 2 else .5, wrap=kind != "ending")
            for pitch, pos, length in phrases[bar % 4]:
                add(out, note(pitch + (12 if bar >= 12 and pos == 0 else 0), beat * length + .35, "lead"),
                    start + pos * beat, .16 if bar % 8 < 4 else .12, -.12, wrap=kind != "ending")
            if bar >= 4 and bar % 2 == 0:
                add(out, note(chord[2] + 24, 2.2, "bell"), start + beat * 2.5, .035, .7, wrap=True)
            for pos in (0, 2):
                add(out, drum("kick"), start + pos * beat, .045)
            for pos in (1, 3):
                add(out, drum("hat", .12), start + pos * beat, .016, -.2)
        elif kind == "battle":
            for eighth in range(8):
                pitch = chord[[0, 1, 2, 1, 0, 2, 3, 2][eighth]] + 12
                add(out, note(pitch, beat * .8, "harp"), start + eighth * beat / 2, .16, (-1) ** eighth * .35)
                add(out, drum("hat", .10), start + eighth * beat / 2, .035, .5)
            for pos in (0, 1.5, 2, 3.5):
                add(out, drum("kick"), start + pos * beat, .27)
            for pos in (1, 3):
                add(out, drum("snare"), start + pos * beat, .14, -.2)
            for pitch, pos, length in phrases[bar % 4]:
                add(out, note(pitch - 12, length * beat, "lead"), start + pos * beat, .22 * intensity, -.2)
        else:
            for pos, index in ((0, 0), (1.5, 2), (3, 3)):
                add(out, note(chord[index] + 24, 2.4, "bell"), start + pos * beat, .09,
                    -.6 if index % 2 else .6, wrap=True)
            if bar % 2 == 0:
                add(out, note(45, 3.2, "bass"), start, .29)
            for eighth in range(8):
                add(out, note(chord[eighth % 4] + 12, .28, "harp"), start + eighth * beat / 2, .055,
                    .5 * np.sin(eighth))
            for pos in (0, 2):
                add(out, drum("kick", .28), start + pos * beat, .12)
            if bar >= 8:
                add(out, note(76 if bar % 2 == 0 else 75, 1.4, "lead"), start + beat, .11, -.3)
    # Circular stereo delay retains tails across the musical bar boundary.
    dry = out.copy()
    for delay, gain in ((beat * .75, .19), (beat * 1.5, .11), (beat * 2.25, .055)):
        if kind == "ending":
            shift = round(delay * RATE)
            out[shift:] += dry[:-shift, ::-1] * gain
        else:
            out += np.roll(dry[:, ::-1], round(delay * RATE), axis=0) * gain
    return fade(out, .005, .005 if kind != "ending" else .8), bpm


def effect(kind):
    if kind in ("ui_select", "correct", "wrong", "heal", "levelup", "victory", "defeat"):
        phrases = {"ui_select": ([76, 81], .065), "correct": ([76, 79, 84], .12),
                   "wrong": ([63, 58], .14), "heal": ([69, 72, 76, 81], .18),
                   "levelup": ([72, 76, 79, 84, 88], .14), "victory": ([72, 76, 79, 84, 83, 84], .16),
                   "defeat": ([64, 63, 60, 57], .22)}
        pitches, spacing = phrases[kind]
        out = np.zeros(round((len(pitches) * spacing + .5) * RATE))
        for i, pitch in enumerate(pitches):
            add(out, note(pitch, .5, "bell" if kind not in ("wrong", "defeat") else "harp"), i * spacing, .4)
        return out
    duration = {"attack": .23, "defense": .4, "dodge": .23, "portal": 1.3, "transformation": 1.8}[kind]
    t = time(duration)
    if kind == "attack":
        return fade(noise(duration, 5400, 500) * np.exp(-t * 28) * .45 + np.sin(TAU * (100 * t + 10 * (1 - np.exp(-t * 18)))) * np.exp(-t * 22))
    if kind == "defense":
        return fade((np.sin(TAU * 520 * t) + .25 * np.sin(TAU * 1220 * t)) * np.exp(-t * 11) + noise(duration, 3000) * np.exp(-t * 30) * .18)
    if kind == "dodge":
        return fade(noise(duration, 2500, 180) * np.sin(np.pi * t / duration) ** 2)
    phase = TAU * (120 * t + (270 if kind == "portal" else 150) * t ** 2)
    env = np.sin(np.pi * t / duration) ** 1.4
    return fade((np.sin(phase) + .2 * np.sin(phase * 1.5) + noise(duration, 1400) * .12) * env)


FOOTSTEP_SOURCES = {
    "grass":"grass_000", "leaves":"grass_001", "dirt":"grass_002",
    "gravel":"snow_000", "cave":"concrete_004", "stone":"concrete_000",
    "wood":"wood_000", "marble":"concrete_001", "cobbles":"concrete_002", "dockwood":"wood_001",
}


def footstep_source(material):
    return ROOT / "audio_sources/kenney-impact" / ("footstep_"+FOOTSTEP_SOURCES[material]+".ogg")


def footstep_provenance(material):
    source=footstep_source(material)
    return {"source_url":"https://kenney.nl/assets/impact-sounds",
            "source_path":source.relative_to(ROOT).as_posix(),
            "source_sha256":hashlib.sha256(source.read_bytes()).hexdigest(),
            "source_license":"CC0-1.0", "description":"Kenney footstep foley; mono, quiet-tail trimmed, unchanged pitch."}


def footstep(material):
    # Preserve the supplied timbre and speed; no oscillator or pitched impacts.
    samples,rate=sf.read(footstep_source(material),always_2d=True)
    assert rate==RATE, "Expected 44.1 kHz source foley"
    mono=samples.mean(axis=1)
    active=np.flatnonzero(np.abs(mono)>np.max(np.abs(mono))*.005)
    if not len(active): raise ValueError("Silent footstep source")
    start=max(0,int(active[0])-round(.005*RATE))
    end=min(len(mono),int(active[-1])+1+round(.01*RATE))
    return fade(mono[start:end],.002,.008)


def preserve_ambience_noise_sequence():
    # Earlier releases consumed these random samples while generating walking
    # sounds. Discard the same draws so a full rebuild retains the original
    # ambience beds, without generating or playing any synthetic footsteps.
    for duration in (.19,.23,.18,.24,.48,.18,.22,.22,.24,.32):
        RNG.normal(0,1,round(duration*RATE))


def refresh_footsteps():
    """Replace only walking sounds; music, ambience and combat files stay intact."""
    path=ROOT/"output/audio/manifest.json"
    manifest=json.loads(path.read_text(encoding="utf-8"))
    for asset in manifest["assets"]:
        if asset["category"]!="footstep": continue
        material=asset["name"].removeprefix("snd_step_")
        audio=master_footstep(footstep(material),.60)
        with wave.open(str(ROOT/asset["wave_path"]),"wb") as dest:
            dest.setnchannels(1);dest.setsampwidth(2);dest.setframerate(RATE)
            dest.writeframes(np.round(audio*32767).astype("<i2").tobytes())
        duration=len(audio)/RATE
        (ROOT/asset["resource_path"]).write_text(json.dumps(sound_resource(asset["name"],duration,1),indent=2)+"\n")
        asset.update(footstep_provenance(material))
        asset.update(duration_seconds=duration,peak_dbfs=round(20*np.log10(.60),2),rms_dbfs=round(20*np.log10(np.sqrt(np.mean(audio*audio))),2))
    manifest["provenance"]="Original procedural score, ambience and combat cues; footsteps from Kenney Impact Sounds, CC0-1.0."
    manifest["recommended_master_gain"]=.78
    manifest.update(recommended_music_gain=.32,recommended_ambience_gain=.16,
                    recommended_effect_gain=.36,recommended_footstep_gain=.38)
    path.write_text(json.dumps(manifest,indent=2)+"\n",encoding="utf-8")
    print("FOLEY_IMPORT: 10 walking sounds replaced; music, ambience and combat payloads unchanged.")


def ambience(kind):
    duration = 8
    t = time(duration)
    out = noise(duration, 700 if kind != "port" else 1200) * (.07 + .04 * np.sin(TAU * t / duration))
    if kind == "forest":
        for start, pitch in ((.7, 1950), (2.3, 2400), (5.5, 1700), (6.4, 2100)):
            chirp_t = time(.23)
            chirp = np.sin(TAU * (pitch * chirp_t + 320 * chirp_t ** 2 + 20 * np.sin(TAU * 8 * chirp_t)))
            add(out, fade(chirp * np.sin(np.pi * chirp_t / .23) ** 2), start, .14)
    elif kind == "cave":
        out *= .3
        for start, pitch in ((.5, 84), (2.6, 88), (5.1, 81), (6.9, 86)):
            drip = note(pitch, .6, "bell")
            add(out, drip, start, .16, wrap=True)
            add(out, drip, start + .12, .05, wrap=True)
    elif kind == "castle":
        out *= .35
        for pitch in (45, 52, 64):
            out += .025 * np.sin(TAU * 440 * 2 ** ((pitch - 69) / 12) * t) * np.sin(np.pi * t / duration) ** 2
    elif kind == "ghostcity":
        out *= .6
        out += .07 * np.sin(TAU * (130 * t + 6 * np.sin(TAU * t / duration))) * np.sin(np.pi * t / duration) ** 2
    else:
        out += noise(duration, 3200) * .055 * (1 + np.sin(TAU * 3 * t / duration))
        for start in (1.3, 4.2, 6.4):
            splash_t = time(.7)
            splash = noise(.7, 1900) * np.exp(-splash_t * 6)
            add(out, fade(splash, .02, .05), start, .09)
    return fade(out, .03, .03)


def master(audio, peak):
    audio = audio - audio.mean(axis=0)
    audio = fade(audio, .004, .008)
    return audio * peak / (np.max(np.abs(audio)) + 1e-12)


def master_footstep(audio, peak):
    # Weighted DC removal stays zero-mean after the edge taper, avoiding a
    # low-frequency click from microphone offset in short source recordings.
    window=fade(np.ones(len(audio)),.004,.008)
    offset=np.sum(audio*window)/np.sum(window)
    clean=(audio-offset)*window
    return clean*peak/(np.max(np.abs(clean))+1e-12)


def sound_resource(name, duration, channels):
    # Native primary reference: installed GameMaker-LTS2026/CoreResources.dll,
    # YoYoStudio.Resources.GMSound and eGMSoundChannelFormat. The v2 schema
    # uses channelFormat/compressionQuality; legacy type/bitRate are obsolete.
    return {"$GMSound": "v2", "%Name": name,
            "audioGroupId": {"name": "audiogroup_default", "path": "audiogroups/audiogroup_default"},
            "bitDepth": 1, "channelFormat": 1 if channels == 2 else 0,
            "compression": 0, "compressionQuality": 4, "conversionMode": 0,
            "duration": duration, "exportDir": "", "name": name,
            "parent": {"name": "Sounds", "path": "folders/Sounds.yy"}, "preload": False,
            "resourceType": "GMSound", "resourceVersion": "2.0", "sampleRate": RATE,
            "soundFile": name + ".wav", "volume": 1.0}


def refresh_resources():
    """Update native metadata from existing WAVs without regenerating audio."""
    manifest = json.loads((ROOT / "output/audio/manifest.json").read_text(encoding="utf-8"))
    for asset in manifest["assets"]:
        with wave.open(str(ROOT / asset["wave_path"]), "rb") as source:
            duration = source.getnframes() / source.getframerate()
            resource = sound_resource(asset["name"], duration, source.getnchannels())
        (ROOT / asset["resource_path"]).write_text(json.dumps(resource, indent=2) + "\n")
    print(f"Updated {len(manifest['assets'])} native sound resources; WAV files preserved")


def main():
    assets, resources = [], []
    def emit(name, audio, category, loop=False, bpm=None, description=""):
        peak = .72 if category == "music" else .34 if category == "ambience" else .60 if category == "footstep" else .70
        audio = master_footstep(audio, peak) if category == "footstep" else master(audio, peak)
        folder = ROOT / "sounds" / name
        folder.mkdir(parents=True, exist_ok=True)
        filename = name + ".wav"
        pcm = np.round(audio * 32767).astype("<i2")
        with wave.open(str(folder / filename), "wb") as destination:
            destination.setnchannels(2 if audio.ndim == 2 else 1)
            destination.setsampwidth(2)
            destination.setframerate(RATE)
            destination.writeframes(pcm.tobytes())
        duration = len(audio) / RATE
        resource = sound_resource(name, duration, 2 if audio.ndim == 2 else 1)
        path = f"sounds/{name}/{name}.yy"
        (folder / (name + ".yy")).write_text(json.dumps(resource, indent=2) + "\n")
        rms = np.sqrt(np.mean(audio * audio))
        assets.append({"name": name, "resource_path": path, "wave_path": f"sounds/{name}/{filename}",
                       "category": category, "duration_seconds": duration, "loop": loop, "bpm": bpm,
                       "peak_dbfs": round(20 * np.log10(peak), 2), "rms_dbfs": round(20 * np.log10(rms), 2),
                       "description": description})
        resources.append({"id": {"name": name, "path": path}})
    descriptions = {"exploration": "Wilson's Motif: A minor harp arpeggios, airy warm pads, expressive melody and soft pulse; 16 bars.",
                    "battle": "The Equation Breaks: urgent sixteenth-note harp pulse, bass, drum accents and Wilson motif in the lower register; 16 bars.",
                    "newton": "Newton's Gravity: suspended chromatic pads, low pulse, distant bells and fragmented Wilson motif; 16 bars.",
                    "ending": "The Multiverse Remembers: Wilson motif resolves to C major over rising bells and a warm final cadence; 4 bars."}
    for kind in ("exploration", "battle", "newton", "ending"):
        audio, bpm = score(kind)
        emit("snd_music_" + kind, audio, "music", kind != "ending", bpm, descriptions[kind])
    for kind in ("ui_select", "correct", "wrong", "attack", "defense", "heal", "dodge", "portal", "transformation", "levelup", "victory", "defeat"):
        emit("snd_" + kind, effect(kind), "effect", description="Original synthesized " + kind.replace("_", " ") + " cue.")
    for kind in ("grass", "leaves", "dirt", "gravel", "cave", "stone", "wood", "marble", "cobbles", "dockwood"):
        emit("snd_step_" + kind, footstep(kind), "footstep", description="Kenney footstep foley at original pitch.")
        assets[-1].update(footstep_provenance(kind))
    preserve_ambience_noise_sequence()
    for kind in ("forest", "cave", "castle", "ghostcity", "port"):
        emit("snd_amb_" + kind, ambience(kind), "ambience", True, description="Quiet original " + kind + " environment bed.")
    output = ROOT / "output/audio"
    output.mkdir(parents=True, exist_ok=True)
    manifest = {"title": "Paradoxo de Wilson: original multiverse soundtrack and sound palette", "license": "CC0-1.0",
                "provenance": "Original procedural score, ambience and combat cues; footsteps from Kenney Impact Sounds, CC0-1.0.",
                "sample_rate": RATE, "format": "WAV PCM16", "seed": 20261007,
                "recommended_master_gain": .78, "recommended_music_gain": .32,
                "recommended_ambience_gain": .16, "recommended_effect_gain": .36, "recommended_footstep_gain": .38,
                "resources": resources, "assets": assets}
    (output / "manifest.json").write_text(json.dumps(manifest, indent=2) + "\n", encoding="utf-8")
    (output / "README.md").write_text("# Audio for Paradoxo de Wilson\n\n"
        "Music, ambience and combat cues are original procedural compositions dedicated to the public domain under CC0-1.0. "
        "The ten footsteps use Kenney Impact Sounds foley, also CC0-1.0: https://kenney.nl/assets/impact-sounds. "
        "Unmodified source clips and the supplied license are preserved in `audio_sources/kenney-impact`. "
        "Run `python tools/generate_game_audio.py --footsteps-only` to refresh only the walking sounds, preserving the existing score, ambience and combat cues.\n\n"
        "Music is stereo; effects, footsteps and ambience are mono. Every file is 44.1 kHz PCM16 with headroom and tapered edges. "
        "The three 16-bar scores and five ambience beds loop; the 10-second ending score plays once. Delay tails in the scores wrap into the next phrase. "
        "`manifest.json` includes resource registration entries, exact duration, BPM, measured peak/RMS level and descriptions.\n\n"
        "Current playback: master gain 0.78, music 0.32, ambience 0.16, combat effects 0.36 and footsteps 0.38 before the master multiplier. "
        "Footsteps retain their original pitch, are downmixed to mono, trimmed only around quiet tails, and normalized with headroom. "
        "Emit them only after actual movement, respecting the existing cadence, walls and dialogue/battle locks. Fade music and ambience when changing context; restore exploration after combat. "
        "`manifest.json` records the exact source SHA-256, source URL and license for every footstep.\n", encoding="utf-8")
    print(f"Generated {len(assets)} original sound resources, {sum((ROOT / a['wave_path']).stat().st_size for a in assets) / 1e6:.2f} MB")


if __name__ == "__main__":
    if "--footsteps-only" in sys.argv:
        refresh_footsteps()
    elif "--resources-only" in sys.argv:
        refresh_resources()
    else:
        main()
