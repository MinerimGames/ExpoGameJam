"""Import the intact generated chair and anchor its opaque silhouette."""
from pathlib import Path
import shutil
from PIL import Image
import add_royal_interiors as res
from evento_project import load, save

source = Path('C:/Users/jrhre/.codex/generated_images/01a0faa6-48c6-76e2-99aa-fabcdcb85825/exec-f5070797-5dde-4848-a675-eb2a02a1d301.png')
portrait = res.ROOT / 'output/imagegen/classroom-desk-chair.png'
shutil.copy2(source, portrait)
name = 'spr_fatec_desk_chair'
res.sprite(name, portrait)
left, top, right, bottom = Image.open(portrait).getchannel('A').point(lambda a: 255 if a >= 240 else 0).getbbox()
sprite_path = res.ROOT / f'sprites/{name}/{name}.yy'
sprite = load(sprite_path)
sprite.update(bbox_left=left, bbox_top=top, bbox_right=right-1, bbox_bottom=bottom-1)
sprite['sequence'].update(xorigin=(left+right)//2, yorigin=bottom)
save(sprite_path, sprite)
save(res.ROOT / 'ParadoxoDeWilson.yyp', res.PROJECT)
print('Registered classroom desk chair, preserving generated pixels and alpha.')
