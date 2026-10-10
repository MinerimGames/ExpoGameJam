"""Prepare an isolated preview that replays the actual classroom camera tour."""
from pathlib import Path
from evento_project import prepare

root = Path(__file__).resolve().parents[1]
target = Path('E:/CodexBuilds/Paradoxo-classroom-desk-20261010/project')
prepare(root, target, 'Credits')
test = target / 'objects/obj_evento_test'
(test / 'Create_0.gml').write_text('tick=0;room_goto(rm_fatec_classroom);\n', encoding='utf-8')
(test / 'Step_1.gml').write_text('''tick++;
if(room==rm_fatec_classroom)
{
    var _ending=instance_find(obj_fatec_ending,0);
    if(instance_exists(_ending))
    {
        _ending.elapsed=_ending.showcase_start+((tick/60) mod (6*_ending.showcase_slot+_ending.showcase_return));
        _ending.professor_y=180;_ending.phase="showcase";
        _ending.depth=mundo_profundidade(187);
        window_set_caption("Paradoxo de Wilson - Sala final");
        if(tick==120)
        {
            screen_save("classroom-desk-guest.png");
            show_debug_message("CLASSROOM_PREVIEW_READY:"+string(instance_exists(_ending.desk_guest)));
        }
    }
}
''', encoding='utf-8')
print(target)
