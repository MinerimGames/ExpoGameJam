"""Preserve the user recording and import the complete track as a native Sound."""
import hashlib
import json
import subprocess
import wave
from pathlib import Path

import imageio_ffmpeg

from evento_project import load, save
from generate_game_audio import sound_resource

ROOT = Path(__file__).resolve().parents[1]
NAME = 'snd_newton_recording'

if __name__ == '__main__':
    source = ROOT / 'output/audio/newton-transform-original.mpeg'
    folder = ROOT / 'sounds' / NAME
    folder.mkdir(parents=True, exist_ok=True)
    target = folder / (NAME + '.wav')
    subprocess.run([imageio_ffmpeg.get_ffmpeg_exe(), '-hide_banner', '-loglevel', 'error',
                    '-y', '-i', str(source), '-vn', '-ar', '44100', '-ac', '2',
                    '-af', 'volume=0.90', '-c:a', 'pcm_s16le', str(target)], check=True)
    with wave.open(str(target), 'rb') as audio:
        duration = audio.getnframes() / audio.getframerate()
        resource = sound_resource(NAME, duration, audio.getnchannels())
    # eGMSoundCompression.Compressed=1 in installed CoreResources.dll.
    # Embedded compressed audio keeps the Windows package self-contained.
    resource['compression'] = 1
    resource['preload'] = True
    path = f'sounds/{NAME}/{NAME}.yy'
    save(ROOT / path, resource)
    project = load(ROOT / 'ParadoxoDeWilson.yyp')
    entry = {'id': {'name': NAME, 'path': path}}
    if entry not in project['resources']:
        project['resources'].append(entry)
    save(ROOT / 'ParadoxoDeWilson.yyp', project)
    metadata = {'provenance': 'Recording supplied by the user; separate from the original CC0 score.',
                'source': str(source.relative_to(ROOT)),
                'source_sha256': hashlib.sha256(source.read_bytes()).hexdigest(),
                'resource_path': path, 'wave_path': str(target.relative_to(ROOT)),
                'duration_seconds': duration, 'sample_rate': 44100, 'channels': 2,
                'conversion': 'Complete MP3 recording decoded to PCM16; gain 0.90 to prevent clipping. No cut.',
                'loop': False, 'trigger': 'begin_transformation in final Newton confrontation'}
    (ROOT / 'output/audio/newton-recording.json').write_text(
        json.dumps(metadata, indent=2) + '\n', encoding='utf-8')
    print(f'Imported full user recording: {duration:.3f} seconds, embedded compressed audio.')
