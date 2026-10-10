"""Open an isolated interactive final duel, one correct attack from victory."""
from pathlib import Path
from evento_project import prepare

root = Path(__file__).resolve().parents[1]
target = Path('E:/CodexBuilds/Paradoxo-classroom-desk-20261010/project')
prepare(root, target, 'Credits')
test = target / 'objects/obj_evento_test'
# Replace the test harness completely: the preview uses real keyboard/mouse input.
(test / 'Create_0.gml').write_text('stage=0;tick=0;room_goto(rm_temporal_origin);\n', encoding='utf-8')
(test / 'Step_1.gml').write_text('''tick++;
if(stage==0 && room==rm_temporal_origin && tick>=60)
{
    var _scene=instance_find(obj_temporal_scene,0);
    var _newton=instance_find(obj_newton_final,0);
    if(instance_exists(_scene) && instance_exists(_newton))
    {
        _newton.reveal_evil();
        _scene.start_recovery();
        for(var _page=0;_page<8;_page++)_scene.advance_dialogue();
        var _battle=instance_find(obj_battle_controller,0);
        if(instance_exists(_battle))
        {
            _battle.enemy_hp=1;
            _battle.battle_message="Teste do final: Evil Newton está com 1 de vida. Acerte um ataque para vencer.";
            stage=1;
            window_set_caption("Paradoxo de Wilson - Teste final Evil Newton");
            show_debug_message("FINAL_BATTLE_PREVIEW_READY:"+string(_battle.story_stage)+":"+string(_battle.enemy_hp));
        }
    }
}
if(stage==1 && tick==120)screen_save("final-evil-newton-ready.png");
''', encoding='utf-8')
print(target)
