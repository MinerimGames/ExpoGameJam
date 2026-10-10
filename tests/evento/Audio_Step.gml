tick++;elapsed++;
if(elapsed>1500){check(false,"audio integration timeout");finish_tests();exit;}
if(stage==0 && tick==15)
{
    var _rooms=[rm_tutorial,rm_bosque,rm_vila,rm_cavernas,rm_cavernas_2,
        rm_castelo,rm_castle_hall,rm_throne_room,rm_autumn_gate,rm_commercial_district];
    var _steps=["snd_step_grass","snd_step_leaves","snd_step_dirt","snd_step_gravel","snd_step_cave",
        "snd_step_stone","snd_step_wood","snd_step_marble","snd_step_cobbles","snd_step_stone"];
    for(var i=0;i<array_length(_rooms);i++)
    {
        var _floor=som_piso(_rooms[i],480,270);
        check(_floor==_steps[i],"footsteps match authored floor in "+room_get_name(_rooms[i]));
        check(asset_get_index(_floor)!=-1,"floor has a native Sound resource");
    }
    check(som_piso(rm_commercial_district,480,520)=="snd_step_cobbles","harbor quay differs from stone bridge");
    var _s=som_estado();
    check(variable_struct_exists(_s,"master_gain"),"master attenuation covers every audio channel including cinematic sounds");
    if(variable_struct_exists(_s,"master_gain"))check(abs(_s.master_gain-0.78)<0.001 && _s.effect_gain<=0.36,"overall mix is reduced and electronic effects are softer");
    check(_s.music_name=="snd_music_exploration" && audio_is_playing(_s.music_id),"exploration theme plays in native mixer");
    check(_s.ambience_name=="snd_amb_forest" && audio_is_playing(_s.ambience_id),"forest ambience plays separately");
    p=instance_find(obj_player,0);with(obj_newton_npc)dialogue_active=false;
    p.movimento_liberado=true;p.x=300;p.y=180;steps_before=_s.step_count;
    stage=1;tick=0;
}
if(stage==1 && tick>=1 && tick<31)keyboard_key_press(vk_left);
if(stage==1 && tick==31)
{
    clear_keys();var _s=som_estado();
    check(_s.step_count>steps_before,"actual walking produces audible footstep events");
    check(_s.step_count-steps_before<=4,"footsteps have a natural bounded cadence");
    steps_before=_s.step_count;p.movimento_liberado=false;
    stage=2;tick=0;
}
if(stage==2 && tick>=1 && tick<21)keyboard_key_press(vk_up);
if(stage==2 && tick==21)
{
    clear_keys();check(som_estado().step_count==steps_before,"locked player never makes footsteps");
    wall=instance_create_depth(0,0,0,obj_colisor);wall.x=p.x+7;wall.y=p.y-16;wall.image_xscale=1;wall.image_yscale=1;
    p.movimento_liberado=true;stage=3;tick=0;
}
if(stage==3 && tick>=1 && tick<41)keyboard_key_press(vk_right);
if(stage==3 && tick==41)
{
    clear_keys();check(som_estado().step_count==steps_before,"pushing a collider does not play footsteps");
    with(wall)instance_destroy();
    b=batalha_iniciar(noone,false);stage=4;tick=0;
}
if(stage==4 && tick==15)
{
    var _s=som_estado();check(_s.music_name=="snd_music_battle" && audio_is_playing(_s.music_id),"battle replaces exploration theme");
    b.request_action("attack");
    check(_s.last_effect=="select","valid battle action triggers its selection cue");
    b.answer_text=string(b.challenge.resposta);b.verify_answer();
    check(_s.last_effect=="attack","correct answer performs the attack sound with the action");
}
if(stage==4 && tick==22)
{
    var _keys=["select","correct","wrong","attack","defense","heal","dodge","portal","transform","level","victory","defeat"];
    for(var i=0;i<array_length(_keys);i++)check(som_efeito(_keys[i]),"effect plays: "+_keys[i]);
    check(!som_efeito("attack"),"same-frame duplicate effects are rate limited");
    with(b)instance_destroy();
    room_goto(rm_temporal_origin);stage=5;tick=0;
}
if(stage==5 && tick==15)
{
    t=instance_find(obj_temporal_scene,0);t.scene_mode="exposure";t.dialogue_active=false;
    n=instance_find(obj_newton_final,0);n.reveal_evil();
}
if(stage==5 && tick==30)
{
    check(som_estado().music_name=="snd_music_newton","Newton theme persists through dialogue after transformation");
    t.scene_mode="battle_first";b=batalha_iniciar(n,false);stage=6;tick=0;
}
if(stage==6 && tick==15)
{
    check(som_estado().music_name=="snd_music_newton","Newton duel has its own cosmic theme");
    with(b)instance_destroy();t.scene_mode="complete";stage=7;tick=0;
}
if(stage==7 && tick==15)
{
    check(som_estado().music_name=="snd_music_ending","ending resolves the musical theme");
    ending_handle=som_estado().music_id;
}
if(stage==7 && tick==660)
{
    check(!audio_is_playing(ending_handle) && som_estado().music_id==ending_handle,"ending cadence plays once without restarting");
    var _s=som_estado();var _old_music=_s.music_id;var _old_amb=_s.ambience_id;
    room_goto(rm_commercial_district);stage=8;tick=0;
    former_music=_old_music;former_ambience=_old_amb;
}
if(stage==8 && tick==50)
{
    var _s=som_estado();
    check(instance_number(obj_game_audio)==1,"room transitions keep only one audio controller");
    check(_s.music_name=="snd_music_exploration" && _s.ambience_name=="snd_amb_port","port changes ambience and exploration theme");
    check(!audio_is_playing(former_music) && !audio_is_playing(former_ambience),"old loops finish fading and cannot leak across rooms");
    room_goto(rm_temporal_origin);stage=9;tick=0;
}
if(stage==9 && tick==60)
{
    t=instance_find(obj_temporal_scene,0);n=instance_find(obj_newton_final,0);
    t.begin_transformation();
    var _s=som_estado();recording_handle=_s.music_id;
    check(_s.music_name=="snd_newton_recording" && audio_is_playing(recording_handle),"fresh final confrontation starts the supplied recording");
    // Simulate completion of the three-minute file without slowing the suite.
    audio_stop_sound(recording_handle);som_atualizar();
    check(t.newton_recording_finished && som_estado().music_name=="snd_music_newton","exhausted recording restores the original Newton score");
    stage=10;tick=0;
}
if(stage==10 && tick==90)
{
    check(n.evil_revealed && !t.transformation_active,"normal transformation completes after the recording finishes");
    t.begin_transformation();som_atualizar();
    check(!audio_is_playing(recording_handle) && som_estado().music_name=="snd_music_newton","completed recording never restarts on repeated transformation or dialogue");
    finish_tests();exit;
}
