"""Register the intact generated seated portrait using the classroom renderer."""
from pathlib import Path
import shutil
from PIL import Image
import add_royal_interiors as res
from evento_project import load, save

source = Path('C:/Users/jrhre/.codex/generated_images/01a0faa6-48c6-76e2-99aa-fabcdcb85825/exec-fba7fc24-27b8-4886-af05-74663234aec0.png')
portrait = res.ROOT / 'output/imagegen/classroom-desk-guest.png'
shutil.copy2(source, portrait)
name = 'spr_fatec_desk_guest'
res.sprite(name, portrait)
bounds = Image.open(portrait).getchannel('A').point(lambda a: 255 if a >= 240 else 0).getbbox()
left, top, right, bottom = bounds
sprite_path = res.ROOT / f'sprites/{name}/{name}.yy'
sprite = load(sprite_path)
sprite.update(bbox_left=left, bbox_top=top, bbox_right=right-1, bbox_bottom=bottom-1)
sprite['sequence'].update(xorigin=(left+right)//2, yorigin=bottom)
save(sprite_path, sprite)
res.object_resource('obj_fatec_desk_guest', name, [(0,0),(3,0),(8,0)])
for event in ['Create_0.gml', 'Step_0.gml', 'Draw_0.gml']:
    destination = res.ROOT / f'objects/obj_fatec_desk_guest/{event}'
    if not destination.exists():
        shutil.copy2(res.ROOT / f'objects/obj_fatec_student/{event}', destination)
save(res.ROOT / 'ParadoxoDeWilson.yyp', res.PROJECT)
print('Registered seated classroom desk guest with original alpha and pixels.')
