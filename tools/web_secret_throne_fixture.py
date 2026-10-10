"""Observe the real ending without inserting test hooks into the game."""
from pathlib import Path
import os
from evento_project import prepare

root = Path(__file__).resolve().parents[1]
home = Path(os.environ.get('PARADOXO_FIXTURE_HOME', str(Path(os.environ['LOCALAPPDATA'])/'CodexBuilds/ParadoxoDeWilson')))
target = home/'web-secret-throne/project'
prepare(root, target, 'Credits')
test = target/'objects/obj_evento_test'
(test/'Create_0.gml').write_text('stage=0;tick=0;seen=[];frames=[];people=[];room_goto(rm_fatec_classroom);\n', encoding='utf-8')
(test/'Step_1.gml').write_text('''tick++;
if(stage==0 && tick>=30)
{
    e=instance_find(obj_fatec_ending,0);e.elapsed=e.showcase_start;e.professor_y=180;stage=1;
    show_debug_message("SECRET_SHADER:"+string(shader_is_compiled(shd_final_camera)));
}
if(stage==1 && e.phase=="showcase" && e.showcase_pose.index>=0 && e.showcase_pose.alpha>0.99)
{
    var _index=e.showcase_pose.index;
    if(!array_contains(people,_index))
    {array_push(people,_index);show_debug_message("CLASSROOM_PERSON:"+string(_index));}
}
if(stage==1 && e.secret_active)
{
    var _capture=e.phase=="NEWTON_QUOTE"?e.secret_quote_chars>=string_length(e.ending_quote)
        :(e.phase=="GLITCH_SEQUENCE"?e.secret_time>=3.2:e.secret_time>=0.20);
    if(_capture && !array_contains(seen,e.phase))
    {
        array_push(seen,e.phase);show_debug_message("SECRET_PHASE:"+e.phase);
        var _mix=som_estado();
        show_debug_message("SECRET_MUSIC:"+e.phase+":"+_mix.music_name+":"+string(_mix.music_id)+":"+string(audio_is_playing(_mix.music_id)));
    }
    if(string_pos("CINEMATIC_",e.phase)==1 && !array_contains(frames,e.secret_frame))
    {array_push(frames,e.secret_frame);show_debug_message("SECRET_FRAME:"+string(e.secret_frame));}
}
if(stage==1 && e.secret_complete)
{
    show_debug_message("SECRET_DONE:"+string(array_length(e.secret_history))+":"+string(e.secret_skipped));
    show_debug_message("SECRET_CLEANUP:"+string(!surface_exists(e.secret_surface)));
    stage=2;tick=0;
}
''', encoding='utf-8')
print(target)
