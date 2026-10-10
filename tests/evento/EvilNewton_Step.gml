tick++;elapsed++;
if(elapsed>1200){check(false,"evil Newton sequence timeout");finish_tests();exit;}
switch(stage)
{
case 0:
    if(tick<12)exit;
    n=instance_find(obj_newton_npc,0);
    check(instance_exists(n) && n.sprite_index==spr_battle_newton,"original tutorial Newton remains normal");
    b=batalha_iniciar(n,true);
    check(b.enemy_battle_sprite==spr_battle_newton && b.enemy_name=="Isleide Newton","tutorial battle keeps original Newton identity");
    with(b)instance_destroy();
    room_goto(rm_temporal_origin);stage=1;tick=0;break;
case 1:
    if(tick<60)exit;
    t=instance_find(obj_temporal_scene,0);n=instance_find(obj_newton_final,0);p=instance_find(obj_player,0);
    check(t.scene_mode=="exposure" && t.dialogue_page==0 && array_length(t.dialogue_pages)==10,"exposure preserves all ten pages");
    check(n.battle_sprite==spr_battle_newton && n.battle_name=="Newton","final Newton enters the scene in normal form");
    check(t.dialogue_pages[3].speaker=="ISLEIDE AGENTE","ally is presented as Agente before accusation");
    for(var _i=0;_i<4;_i++)t.advance_dialogue();
    check(t.dialogue_page==4 && n.battle_sprite==spr_battle_newton && !instance_exists(obj_battle_controller),"Newton stays normal until Agent accusation");
    check(som_estado().music_name!="snd_newton_recording","attached recording waits until transformation");
    if(!variable_instance_exists(t,"transformation_active") || !variable_instance_exists(n,"evil_revealed"))
    {
        check(false,"Agent accusation requires a timed Newton transformation");finish_tests();exit;
    }
    t.advance_dialogue();
    recording_handle=som_estado().music_id;
    check(asset_get_index("snd_newton_recording")!=-1 && som_estado().music_name=="snd_newton_recording" && audio_is_playing(recording_handle),"attached recording starts exactly when transformation begins");
    check(t.dialogue_page==5 && t.dialogue_pages[5].speaker=="ISLEIDE AGENTE" && t.transformation_active,"Agent accusation starts transformation on its own page");
    check(!n.evil_revealed && n.battle_sprite==spr_battle_newton,"evil form is not committed at the start of the effect");
    for(var _i=0;_i<20;_i++)t.advance_dialogue();
    keyboard_key_press(ord("E"));keyboard_key_press(vk_space);keyboard_key_press(vk_right);
    stage=2;tick=0;transform_elapsed=0;break;
case 2:
    transform_elapsed+=min(delta_time/1000000,0.1);
    check(t.dialogue_page==5 && !instance_exists(obj_battle_controller) && !p.movimento_liberado,"repeated input cannot skip transformation or start battle");
    if(transform_elapsed<0.38)exit;
    check(t.transformation_active && !n.evil_revealed,"transformation remains visible after rapid confirmation input");
    check(som_estado().music_id==recording_handle && audio_is_playing(recording_handle),"rapid confirmations do not restart or duplicate recording");
    screen_save("evil-newton-transform.png");
    keyboard_key_release(ord("E"));keyboard_key_release(vk_space);keyboard_key_release(vk_right);
    stage=3;break;
case 3:
    transform_elapsed+=min(delta_time/1000000,0.1);
    if(t.transformation_active)exit;
    check(transform_elapsed>=0.90 && transform_elapsed<=1.50,"transformation completes in approximately one second");
    var _evil=asset_get_index("spr_newton_evil");
    check(_evil!=-1 && n.evil_revealed && n.battle_sprite==_evil && n.battle_name=="Evil Newton","completed reveal commits evil art and boss name");
    check(t.dialogue_page==5 && !instance_exists(obj_battle_controller),"effect completion preserves accusation page and waits for dialogue");
    t.advance_dialogue();t.advance_dialogue();
    check(t.dialogue_page==7,"Newton response after reveal is still present");
    stage=4;tick=0;break;
case 4:
    if(tick<12)exit;
    screen_save("evil-newton-exposure-portrait.png");
    t.advance_dialogue();t.advance_dialogue();t.advance_dialogue();
    check(t.scene_mode=="battle_first" && instance_number(obj_battle_controller)==1,"first duel starts only after all exposure pages");
    b=instance_find(obj_battle_controller,0);
    check(b.story_stage==1 && b.enemy_battle_sprite==asset_get_index("spr_newton_evil") && b.enemy_name=="Evil Newton","first duel uses revealed Evil Newton");
    check(som_estado().music_id==recording_handle && audio_is_playing(recording_handle),"transformation recording continues into first duel");
    for(var _answer=0;_answer<3 && instance_exists(b);_answer++)
    {
        b.request_action("attack");
        b.answer_text=string(b.challenge.resposta);
        b.verify_answer();
    }
    check(t.scene_mode=="recovery" && n.evil_revealed && n.battle_name=="Evil Newton","scripted fall does not restore normal Newton");
    check(array_length(t.dialogue_pages)==8 && t.dialogue_pages[2].speaker=="STEAMPUNK"
        && asset_get_index("spr_steampunk_idle")!=-1 && t.dialogue_pages[2].portrait==asset_get_index("spr_steampunk_idle"),
        "eight-page recovery includes Steampunk's support instead of a castle guard");
    stage=5;tick=0;break;
case 5:
    if(tick<12)exit;
    screen_save("evil-newton-recovery-portrait.png");
    for(var _i=0;_i<8;_i++)t.advance_dialogue();
    check(t.scene_mode=="battle_supported" && instance_number(obj_battle_controller)==1,"recovery starts one supported duel");
    b=instance_find(obj_battle_controller,0);
    check(b.story_stage==2 && b.enemy_battle_sprite==asset_get_index("spr_newton_evil") && b.enemy_name=="Evil Newton","supported duel keeps evil art and name");
    b.player_hp=0;b.finish_check();b.restart_battle();
    som_atualizar();
    check(som_estado().music_name=="snd_newton_recording" && som_estado().music_id==recording_handle && audio_is_playing(recording_handle),"recording continues across recovery supported duel and retry without restarting");
    check(n.evil_revealed && b.story_stage==2 && b.enemy_battle_sprite==asset_get_index("spr_newton_evil") && b.enemy_name=="Evil Newton","supported retry never resets Newton form");
    var _revelation=historia_newton_dialogo("revelation");
    var _recovery=historia_newton_dialogo("recovery");var _ending=historia_newton_dialogo("ending");
    check(_revelation[0].speaker=="ISLEIDE AGENTE" && _recovery[6].speaker=="ISLEIDE AGENTE" && _ending[1].speaker=="ISLEIDE AGENTE","Agente name persists through revelation recovery and ending");
    b.enemy_hp=0;b.finish_check();b.leave_after_victory();
    som_atualizar();stage=6;tick=0;break;
case 6:
    if(tick<30)exit;
    check(!audio_is_playing(recording_handle) && som_estado().music_name=="snd_music_ending","recording fades out for the epilogue without leaking");
    finish_tests();exit;
}
