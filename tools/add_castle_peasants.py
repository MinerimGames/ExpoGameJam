"""Import peasant art: apple woman in Bosque, other five near village houses."""
import copy
import uuid
import zipfile
import io
from PIL import Image
import add_royal_interiors as resources
from evento_project import load, save

ROOT = resources.ROOT
STATES = ['parado', 'baixo', 'cima', 'esquerda', 'direita']

if __name__ == '__main__':
    with zipfile.ZipFile('C:/Users/jrhre/Downloads/camponeses_sprites.zip') as archive:
        folders = sorted({n.split('/')[1] for n in archive.namelist() if '/frames/' in n})
        for variant, folder in enumerate(folders):
            name = f'spr_castle_peasant_{variant + 1}'
            data = load(ROOT / 'sprites/spr_player_walk_front/spr_player_walk_front.yy')
            data['name'] = data['%Name'] = name
            data['sequence']['name'] = data['sequence']['%Name'] = name
            data['parent'] = {'name': 'Sprites', 'path': 'folders/Sprites.yy'}
            layer = str(uuid.uuid4())
            data['layers'][0]['name'] = data['layers'][0]['%Name'] = layer
            template_frame = copy.deepcopy(data['frames'][0])
            keys = data['sequence']['tracks'][0]['keyframes']['Keyframes']
            template_key = copy.deepcopy(keys[0])
            keys.clear()
            data['frames'] = []
            for state in STATES:
                for number in range(1, 6):
                    pixels = archive.read(f'camponeses_sprites/{folder}/frames/{state}_{number:02}.png')
                    width, height = Image.open(io.BytesIO(pixels)).size
                    frame_id = str(uuid.uuid4())
                    frame = copy.deepcopy(template_frame)
                    frame['name'] = frame['%Name'] = frame_id
                    data['frames'].append(frame)
                    key = copy.deepcopy(template_key)
                    key['id'] = str(uuid.uuid4())
                    key['Key'] = float(len(keys))
                    key['Channels']['0']['Id'] = {'name': frame_id, 'path': f'sprites/{name}/{name}.yy'}
                    keys.append(key)
                    base = ROOT / f'sprites/{name}'
                    (base / f'layers/{frame_id}').mkdir(parents=True, exist_ok=True)
                    (base / f'{frame_id}.png').write_bytes(pixels)
                    (base / f'layers/{frame_id}/{layer}.png').write_bytes(pixels)
            data.update(width=width, height=height, bboxMode=0, bbox_left=0, bbox_top=0,
                        bbox_right=width-1, bbox_bottom=height-1)
            data['sequence'].update(length=25.0, xorigin=width//2, yorigin=height)
            save(base / f'{name}.yy', data)
            resources.register(name, 'sprites')
    resources.object_resource('obj_castle_peasant', 'spr_castle_peasant_1', [(0,0),(3,0),(8,0)])
    resources.object_resource('obj_castle_population', None, [(0,0)])
    script = load(ROOT / 'scripts/battle_system/battle_system.yy')
    script['name'] = script['%Name'] = 'castle_peasants'
    save(ROOT / 'scripts/castle_peasants/castle_peasants.yy', script)
    resources.register('castle_peasants', 'scripts')
    castle_path = ROOT / 'rooms/rm_castelo/rm_castelo.yy'
    castle = load(castle_path)
    removed = {i['name'] for layer in castle['layers'] for i in layer.get('instances', [])
               if i['objectId']['name'] == 'obj_castle_population'}
    for layer in castle['layers']:
        if 'instances' in layer:
            layer['instances'] = [i for i in layer['instances'] if i['name'] not in removed]
    castle['instanceCreationOrder'] = [i for i in castle['instanceCreationOrder'] if i['name'] not in removed]
    save(castle_path, castle)
    room_path = ROOT / 'rooms/rm_bosque/rm_bosque.yy'
    room = load(room_path)
    layer = next(l for l in room['layers'] if l['name'] == 'Player')
    if not any(i['objectId']['name'] == 'obj_castle_population' for i in layer['instances']):
        inst = copy.deepcopy(layer['instances'][0])
        inst['name'] = inst['%Name'] = 'inst_BOSQUE_POPULATION'
        inst.update(x=0.0, y=0.0, scaleX=1.0, scaleY=1.0,
                    objectId={'name': 'obj_castle_population', 'path': 'objects/obj_castle_population/obj_castle_population.yy'})
        layer['instances'].append(inst)
        room['instanceCreationOrder'].append({'name': inst['name'], 'path': 'rooms/rm_bosque/rm_bosque.yy'})
    save(room_path, room)
    village_path = ROOT / 'rooms/rm_vila/rm_vila.yy'
    village = load(village_path)
    village_layer = next(l for l in village['layers'] if l['name'] == 'Player')
    if not any(i['objectId']['name'] == 'obj_castle_population' for i in village_layer['instances']):
        resident = copy.deepcopy(village_layer['instances'][0])
        resident['name'] = resident['%Name'] = 'inst_VILA_POPULATION'
        resident.update(x=0.0, y=0.0, scaleX=1.0, scaleY=1.0,
                        objectId={'name': 'obj_castle_population', 'path': 'objects/obj_castle_population/obj_castle_population.yy'})
        village_layer['instances'].append(resident)
        village['instanceCreationOrder'].append({'name': resident['name'], 'path': 'rooms/rm_vila/rm_vila.yy'})
        save(village_path, village)
    save(ROOT / 'ParadoxoDeWilson.yyp', resources.PROJECT)
    print('Imported six unique residents and population for forest clearing and village yards.')
