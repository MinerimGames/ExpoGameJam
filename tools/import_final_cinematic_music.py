"""Import the complete user-supplied finale track without touching other music."""
import hashlib
import json
import shutil
import subprocess
import wave
from pathlib import Path

import imageio_ffmpeg
from evento_project import load, save
from generate_game_audio import sound_resource

ROOT = Path(__file__).resolve().parents[1]
NAME = 'snd_final_cinematic_music'

if __name__ == '__main__':
    supplied = Path('C:/Users/jrhre/Downloads/avengers-doomsday-epic-cinematic-music-no-copyright_qlFNRUJo.mp3.mpeg')
    source = ROOT / 'audio_sources/final-cinematic/user-supplied-original.mpeg'
    source.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(supplied, source)
    folder = ROOT / 'sounds' / NAME
    folder.mkdir(parents=True, exist_ok=True)
    target = folder / (NAME + '.wav')
    subprocess.run([imageio_ffmpeg.get_ffmpeg_exe(), '-hide_banner', '-loglevel', 'error',
                    '-y', '-i', str(source), '-vn', '-ar', '44100', '-ac', '2',
                    '-c:a', 'pcm_s16le', str(target)], check=True)
    with wave.open(str(target), 'rb') as audio:
        duration = audio.getnframes() / audio.getframerate()
        resource = sound_resource(NAME, duration, audio.getnchannels())
    resource['compression'] = 1
    resource['preload'] = True
    resource_path = f'sounds/{NAME}/{NAME}.yy'
    save(ROOT / resource_path, resource)
    project = load(ROOT / 'ParadoxoDeWilson.yyp')
    entry = {'id': {'name': NAME, 'path': resource_path}}
    if entry not in project['resources']:
        project['resources'].append(entry)
    save(ROOT / 'ParadoxoDeWilson.yyp', project)
    metadata = {
        'provenance': 'Music supplied by the user; separate from the original CC0 soundtrack.',
        'source': str(source.relative_to(ROOT)),
        'source_sha256': hashlib.sha256(source.read_bytes()).hexdigest(),
        'resource_path': resource_path, 'duration_seconds': duration,
        'conversion': 'Complete recording decoded to 44.1 kHz stereo PCM16; no cut or tempo change.',
        'loop': True, 'trigger': 'FINAL_SCREEN', 'stop': 'end of CREDITS', 'gain': 0.26
    }
    (source.parent / 'provenance.json').write_text(json.dumps(metadata, indent=2)+'\n', encoding='utf-8')
    print(f'Imported complete finale track: {duration:.3f}s, compressed stereo.')
