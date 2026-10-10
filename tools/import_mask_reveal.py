"""Import supplied poses in reading order, without resampling or editing the sheet."""
import copy
import hashlib
import json
import shutil
import uuid
from pathlib import Path
from PIL import Image, ImageChops
from evento_project import load, save

ROOT = Path(__file__).resolve().parents[1]
SOURCE = Path('C:/Users/jrhre/Downloads/Sprite Sheet_ Remoção da Máscara do Guardião.png')
NAME = 'spr_secret_mask_reveal'
# Row 4 starts at y=760, so a regular y=768 cut would sever the hood.
# These boundaries lie within the independently inspected black row gutters.
ROW_EDGES = [0, 255, 507, 754, 1024]
SIZE, FOOT_X, FOOT_Y = 256, 128, 252


def import_sheet():
    source_bytes = SOURCE.read_bytes()
    sheet = Image.open(SOURCE).convert('RGB')
    if sheet.size != (1536, 1024):
        raise ValueError('Supplied 6 x 4 sheet dimensions changed; reinspect row gutters.')
    original = ROOT / 'datafiles/secret_throne/06_Remocao_da_Mascara.png'
    shutil.copy2(SOURCE, original)
    target = ROOT / 'sprites' / NAME
    yy = target / (NAME + '.yy')
    template = load(ROOT / 'sprites/spr_secret_throne_05/spr_secret_throne_05.yy')
    old_name = template['name']
    data = json.loads(json.dumps(template).replace(old_name, NAME))
    previous = load(yy) if yy.exists() else None
    layer = previous['layers'][0]['name'] if previous else str(uuid.uuid4())
    data['layers'][0].update(name=layer, **{'%Name': layer})
    data.update(width=SIZE, height=SIZE, bbox_left=0, bbox_top=0,
                bbox_right=255, bbox_bottom=255, origin=9, edgeFiltering=False)
    data['sequence'].update(length=24.0, playbackSpeed=24.0, xorigin=FOOT_X, yorigin=FOOT_Y)
    data['frames'] = []
    keyframes = []
    report = {'source_sha256': hashlib.sha256(source_bytes).hexdigest(),
              'sheet': [1536, 1024], 'grid': [6, 4], 'row_edges': ROW_EDGES,
              'frame_size': [SIZE, SIZE], 'anchor': [FOOT_X, FOOT_Y], 'frames': []}
    for i in range(24):
        col, row = i % 6, i // 6
        cell = sheet.crop((col * SIZE, ROW_EDGES[row], (col + 1) * SIZE, ROW_EDGES[row + 1]))
        red, green, blue = cell.split()
        # Detection only: original RGB pixels are copied unchanged, including dark outlines.
        mask = ImageChops.lighter(ImageChops.lighter(red, green), blue).point(lambda v: 255 if v > 32 else 0)
        bounds = mask.getbbox()
        if not bounds:
            raise ValueError(f'Frame {i+1} is empty.')
        feet = mask.crop((0, bounds[3]-12, SIZE, bounds[3])).getbbox()
        anchor_x = (feet[0] + feet[2]) // 2
        anchor_y = bounds[3]-1
        rect = (max(0, bounds[0]-3), max(0, bounds[1]-3),
                min(SIZE, bounds[2]+3), min(cell.height, bounds[3]+3))
        pixels = cell.crop(rect)
        dest = (FOOT_X - (anchor_x - rect[0]), FOOT_Y - (anchor_y - rect[1]))
        if min(dest) < 0 or dest[0]+pixels.width > SIZE or dest[1]+pixels.height > SIZE:
            raise ValueError(f'Frame {i+1} would be clipped after anchoring.')
        frame_image = Image.new('RGB', (SIZE, SIZE), 'black')
        frame_image.paste(pixels, dest)
        frame = previous['frames'][i]['name'] if previous else str(uuid.uuid4())
        frame_data = copy.deepcopy(template['frames'][0])
        frame_data.update(name=frame, **{'%Name': frame})
        data['frames'].append(frame_data)
        key = copy.deepcopy(template['sequence']['tracks'][0]['keyframes']['Keyframes'][0])
        key.update(id=str(uuid.uuid4()), Key=float(i))
        key['Channels']['0']['Id'] = {'name': frame, 'path': f'sprites/{NAME}/{NAME}.yy'}
        keyframes.append(key)
        (target / 'layers' / frame).mkdir(parents=True, exist_ok=True)
        frame_image.save(target / (frame + '.png'))
        shutil.copy2(target / (frame + '.png'), target / 'layers' / frame / (layer + '.png'))
        report['frames'].append({'number': i+1, 'row': row+1, 'column': col+1,
                                 'cell': [col*SIZE, ROW_EDGES[row], (col+1)*SIZE, ROW_EDGES[row+1]],
                                 'copy_rect': list(rect), 'destination': list(dest), 'frame': frame})
    data['sequence']['tracks'][0]['keyframes']['Keyframes'] = keyframes
    save(yy, data)
    project = load(ROOT / 'ParadoxoDeWilson.yyp')
    entry = {'id': {'name': NAME, 'path': f'sprites/{NAME}/{NAME}.yy'}}
    if entry not in project['resources']:
        project['resources'].append(entry)
    save(ROOT / 'ParadoxoDeWilson.yyp', project)
    save(ROOT / 'output/revision-20261009/mask-reveal-import.json', report)
    assert SOURCE.read_bytes() == source_bytes == original.read_bytes()
    print('Imported 24 native frames; source preserved:', report['source_sha256'])


if __name__ == '__main__':
    import_sheet()
