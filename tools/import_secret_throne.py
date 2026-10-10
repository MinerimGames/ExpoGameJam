"""Register supplied stills without resampling or changing PNG bytes."""
import hashlib
from pathlib import Path
import shutil
import zipfile
from PIL import Image
import add_royal_interiors as res
from evento_project import load, save

NAMES = ['01_Inicio_da_Trilha.png', '02_Aproximacao_Inicial.png',
         '03_Aproximacao_Intermediaria.png', '04_Escadaria_do_Trono.png',
         '05_Trono_Vazio.png']

for index, filename in enumerate(NAMES, 1):
    source = res.ROOT / 'datafiles/secret_throne' / filename
    name = f'spr_secret_throne_{index:02}'
    if not (res.ROOT / f'sprites/{name}/{name}.yy').exists():
        res.sprite(name, source, background=True)
    res.register(name, 'sprites')
    data = load(res.ROOT / f'sprites/{name}/{name}.yy')
    frame = res.ROOT / f'sprites/{name}' / (data['frames'][0]['name'] + '.png')
    layer = res.ROOT / f'sprites/{name}/layers' / data['frames'][0]['name'] / (data['layers'][0]['name'] + '.png')
    shutil.copy2(source, frame)
    shutil.copy2(source, layer)
    with Image.open(source) as image:
        width,height=image.size
    data.update(width=width,height=height,bbox_left=0,bbox_top=0,bbox_right=width-1,bbox_bottom=height-1)
    save(res.ROOT / f'sprites/{name}/{name}.yy',data)
    if index==5:
        assert frame.read_bytes() == Path('C:/Users/jrhre/Downloads/Trono Gótico no Vazio Verde.png').read_bytes()
    else:
        with zipfile.ZipFile('C:/Users/jrhre/Downloads/Telas_Animacao_Trono.zip') as archive:
            assert frame.read_bytes() == archive.read('Telas_Animacao_Trono/' + filename)
    print(filename, hashlib.sha256(frame.read_bytes()).hexdigest())

script = load(res.ROOT / 'scripts/game_audio/game_audio.yy')
script['name'] = script['%Name'] = 'secret_throne'
save(res.ROOT / 'scripts/secret_throne/secret_throne.yy', script)
res.register('secret_throne', 'scripts')
save(res.ROOT / 'ParadoxoDeWilson.yyp', res.PROJECT)
