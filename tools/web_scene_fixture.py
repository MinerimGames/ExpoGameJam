"""Prepare an isolated HTML5 render fixture; never modify production assets."""
from pathlib import Path
import os
from evento_project import prepare

root = Path(__file__).resolve().parents[1]
target = Path(os.environ['LOCALAPPDATA']) / 'CodexBuilds/ParadoxoDeWilson/web-scene-fixture/project'
prepare(root, target, 'CityFlags')
test = target / 'objects/obj_evento_test'
create = '''stage=0;tick=0;
matematica_progresso(true);historia_newton_progresso(true);
room_goto(rm_autumn_streets);
'''
step = '''if(stage>=6)exit;
tick++;
if(tick==20)
{
    var _p=instance_find(obj_player,0);_p.movimento_liberado=false;
    camera_set_view_target(view_camera[0],noone);
    camera_set_view_size(view_camera[0],400,300);
    if(stage==0){_p.x=100;_p.y=160;camera_set_view_pos(view_camera[0],0,0);}
    if(stage==1){_p.x=600;_p.y=400;camera_set_view_pos(view_camera[0],400,250);}
    if(stage==2){_p.x=480;_p.y=320;camera_set_view_size(view_camera[0],480,320);camera_set_view_pos(view_camera[0],240,160);}
    if(stage==3){_p.x=480;_p.y=270;camera_set_view_pos(view_camera[0],280,150);}
    if(stage==4){_p.x=480;_p.y=290;camera_set_view_size(view_camera[0],640,360);camera_set_view_pos(view_camera[0],160,100);}
    if(stage==5){_p.x=400;_p.y=300;camera_set_view_size(view_camera[0],640,380);camera_set_view_pos(view_camera[0],80,95);}
}
if(tick==35)show_debug_message("WEB_SCENE:"+string(stage));
if(tick>=140)
{
    stage++;tick=0;
    if(stage==1)room_goto(rm_autumn_streets);
    if(stage==2)room_goto(rm_steampunk_foundry);
    if(stage==3)room_goto(rm_commercial_district);
    if(stage==4)room_goto(rm_autumn_plaza);
    if(stage==5)room_goto(rm_castle_hall);
}
'''
(test / 'Create_0.gml').write_text(create,encoding='utf-8')
(test / 'Step_1.gml').write_text(step,encoding='utf-8')
print(target)
