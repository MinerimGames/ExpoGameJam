"""Import the supplied numbered folders in order; no source pixels are resampled."""
import copy
import hashlib
import json
import re
import uuid
import zipfile
from pathlib import Path
from PIL import Image
from evento_project import load, save

ROOT = Path(__file__).resolve().parents[1]
SOURCE = Path('C:/Users/jrhre/Downloads/Cenas para animar corrigido.zip')
NAME = 'spr_final_cinematic'

def main():
    template = load(ROOT/'sprites/spr_secret_throne_01/spr_secret_throne_01.yy')
    project = load(ROOT/'ParadoxoDeWilson.yyp')
    target = ROOT/'sprites'/NAME
    target.mkdir(parents=True, exist_ok=True)
    yy = target/(NAME+'.yy')
    old = load(yy) if yy.exists() else None
    data = json.loads(json.dumps(template).replace(template['name'], NAME))
    layer = old['layers'][0]['name'] if old else str(uuid.uuid4())
    data['layers'][0].update(name=layer, **{'%Name': layer})
    data.update(width=1672, height=941, bbox_right=1671, bbox_bottom=940)
    data['sequence'].update(playbackSpeed=1.0)
    data['frames'] = []
    keys = []
    report = {'source': str(SOURCE), 'source_sha256': hashlib.sha256(SOURCE.read_bytes()).hexdigest(), 'frames': []}
    with zipfile.ZipFile(SOURCE) as archive:
        entries = []
        for entry in archive.infolist():
            match = re.fullmatch(r'[^/]+/(0[123])/(\d+)[^/]*\.png', entry.filename)
            if match:
                entries.append((int(match[1]), int(match[2]), entry))
        entries.sort(key=lambda item: item[:2])
        assert [sum(group == g for group, _, _ in entries) for g in (1, 2, 3)] == [5, 9, 5]
        data['sequence']['length'] = float(len(entries))
        for index, (group, number, entry) in enumerate(entries):
            with archive.open(entry) as stream:
                image = Image.open(stream).convert('RGBA')
            assert image.size in ((1672, 941), (1671, 941), (1600, 900))
            frame_id = old['frames'][index]['name'] if old else str(uuid.uuid4())
            frame = copy.deepcopy(template['frames'][0])
            frame.update(name=frame_id, **{'%Name': frame_id})
            data['frames'].append(frame)
            key = copy.deepcopy(template['sequence']['tracks'][0]['keyframes']['Keyframes'][0])
            key.update(id=str(uuid.uuid4()), Key=float(index))
            key['Channels']['0']['Id'] = {'name': frame_id, 'path': f'sprites/{NAME}/{NAME}.yy'}
            keys.append(key)
            # Transparent padding preserves both narrower sources unchanged.
            # Rendering uses each original image's recorded bounds.
            packed = Image.new('RGBA', (1672, 941))
            packed.paste(image, (0, 0))
            (target/'layers'/frame_id).mkdir(parents=True, exist_ok=True)
            packed.save(target/(frame_id+'.png'))
            packed.save(target/'layers'/frame_id/(layer+'.png'))
            report['frames'].append({'index': index, 'folder': group, 'number': number,
                'entry': entry.filename, 'size': list(image.size), 'frame': frame_id,
                'pixel_sha256': hashlib.sha256(image.tobytes()).hexdigest()})
    data['sequence']['tracks'][0]['keyframes']['Keyframes'] = keys
    save(yy, data)
    for name, kind in ((NAME, 'sprites'), ('shd_final_camera', 'shaders')):
        ref = {'id': {'name': name, 'path': f'{kind}/{name}/{name}.yy'}}
        if ref not in project['resources']:
            project['resources'].append(ref)
    save(ROOT/'ParadoxoDeWilson.yyp', project)
    save(ROOT/'output/ending-20261010/import.json', report)
    print('Imported 19 corrected frames: folder 01 (5), 02 (9), 03 (5); source pixels preserved.')

if __name__ == '__main__':
    main()
