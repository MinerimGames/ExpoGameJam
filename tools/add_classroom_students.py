"""Register intact ImageGen sprites; alpha bounds affect metadata only."""
from pathlib import Path
import shutil
import copy
from PIL import Image
import add_royal_interiors as res
from evento_project import load, save

GENERATED = Path('C:/Users/jrhre/.codex/generated_images/01a0faa6-48c6-76e2-99aa-fabcdcb85825')
FILES = ['exec-2fb9d7df-cd2e-4eda-a672-cb01600d9fd8.png',
         'exec-7dec5d51-30fe-47b3-a23b-0cb4a1a73344.png',
         'exec-a8078e93-6bca-4931-a7d1-d328447bdd80.png',
         'exec-7f396173-516b-4f8f-98e6-6b4d42c19d20.png']

def main():
    out = res.ROOT / 'output/imagegen/classroom-students'
    out.mkdir(parents=True, exist_ok=True)
    for i, filename in enumerate(FILES, 1):
        source = out / f'student-{i:02}.png'
        shutil.copy2(GENERATED / filename, source)
        name = f'spr_fatec_student_{i:02}'
        res.sprite(name, source)
        # Reading alpha to set the native anchor avoids using the faint halo
        # as the actor's feet. The imported PNG is never modified.
        alpha = Image.open(source).getchannel('A')
        bounds = alpha.point(lambda a: 255 if a >= 240 else 0).getbbox()
        if not bounds:
            raise ValueError(f'Empty solid silhouette: {name}')
        left, top, right, bottom = bounds
        path = res.ROOT / f'sprites/{name}/{name}.yy'
        sprite = load(path)
        sprite.update(bbox_left=left, bbox_top=top, bbox_right=right-1, bbox_bottom=bottom-1)
        sprite['sequence'].update(xorigin=(left+right)//2, yorigin=bottom)
        save(path, sprite)
    res.object_resource('obj_fatec_student', 'spr_fatec_student_01', [(0,0),(3,0),(8,0)])
    shader_name = 'shd_fatec_student'
    shader = load(res.ROOT / 'shaders/shd_wilson_walk/shd_wilson_walk.yy')
    shader['name'] = shader['%Name'] = shader_name
    save(res.ROOT / f'shaders/{shader_name}/{shader_name}.yy', shader)
    shutil.copy2(res.ROOT / 'shaders/shd_wilson_walk/shd_wilson_walk.vsh',
                 res.ROOT / f'shaders/{shader_name}/{shader_name}.vsh')
    res.register(shader_name, 'shaders')
    save(res.ROOT / 'ParadoxoDeWilson.yyp', res.PROJECT)
    print('Registered four distinct classroom portraits, student object and transparent sprite renderer.')

if __name__ == '__main__':
    main()
