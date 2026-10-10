tick++;elapsed++;
if(elapsed==1)show_debug_message("EPILOGUE_STEP_ENTER "+room_get_name(room));
if(stage>=1 && stage<=4)finale_elapsed+=min(delta_time/1000000,0.1);
if(stage>=1 && stage<=4 && room==rm_temporal_origin)
    check(!p.movimento_liberado && p.x==locked_x && p.y==locked_y && !instance_exists(obj_battle_controller),"all departures and final fracture keep movement and duels locked");
if(elapsed>9000){check(false,"epilogue cinematic finishes within native test budget");finish_tests();exit;}
switch(stage)
{
case 0:
    if(tick<12)exit;
    t=instance_find(obj_temporal_scene,0);n=instance_find(obj_newton_final,0);p=instance_find(obj_player,0);
    xp_before=matematica_progresso().xp_total;
    n.reveal_evil();n.battle_stage=1;t.scene_mode="battle_first";t.dialogue_active=false;
    b=batalha_iniciar(n,false);
    for(var _i=0;_i<3;_i++)
    {
        b.request_action("attack");b.answer_text="99999";b.verify_answer();
    }
    check(!instance_exists(b) && t.scene_mode=="recovery" && matematica_progresso().xp_total==xp_before,"first scripted defeat preserves recovery rather than starting finale");
    for(var _i=0;_i<8;_i++)t.advance_dialogue();
    b=instance_find(obj_battle_controller,0);
    b.player_hp=0;b.finish_check();
    check(b.battle_screen=="defeat" && t.scene_mode=="battle_supported","supported player defeat offers retry without ending");
    b.restart_battle();
    check(b.story_stage==2 && b.enemy_hp==240 && b.player_hp==140 && n.evil_revealed,"retry preserves supported duel and Evil Newton");
    b.enemy_hp=1;b.request_action("attack");b.answer_text=string(b.challenge.resposta);b.verify_answer();
    check(b.battle_screen=="victory" && matematica_progresso().xp_total==xp_before+100,"defeating second-stage Evil Newton awards XP once");
    b.reward_victory();b.leave_after_victory();
    check(!instance_exists(b) && t.scene_mode=="ending" && matematica_progresso().xp_total==xp_before+100,"victory starts one ending without a surviving battle");
    check(camera_get_view_width(view_camera[0])==room_width && camera_get_view_height(view_camera[0])==room_height
        && camera_get_view_x(view_camera[0])==0 && camera_get_view_y(view_camera[0])==0,
        "farewell opens the camera to keep every ally fully inside the room view");
    check(som_estado().last_effect=="transform","reality begins collapsing with one sound at final victory");
    var _effects=som_estado().effect_count;
    t.dialogue_page=1;t.start_ending();
    check(t.dialogue_page==1,"repeated final-victory notification cannot restart dialogue");
    check(som_estado().effect_count==_effects,"repeated final-victory notification cannot repeat collapse sound");
    for(var _i=0;_i<array_length(t.dialogue_pages);_i++)t.advance_dialogue();
    check(t.scene_mode=="departures" && !p.movimento_liberado,"ending starts cinematic departures with player locked");
    if(!variable_instance_exists(t,"portals") || !variable_instance_exists(t,"depart_count"))
    {
        check(false,"finale opens six inspectable portals instead of legacy free roam");finish_tests();exit;
    }
    check(array_length(t.portals)==6 && t.depart_count==0,"six portals open before any traveller leaves");
    check(variable_instance_exists(t,"portal_label_layout"),"portal labels have readable GUI-space layout independent of the world surface");
    if(variable_instance_exists(t,"portal_label_layout"))
    {
        var _labels=t.portal_label_layout();
        check(array_length(_labels)==6,"each returning traveller has its own readable label");
        for(var _li=0;_li<array_length(_labels);_li++)
        {
            var _label=_labels[_li];var _portal=t.portals[_li];
            check(_label.scale>=0.7 && _label.height>=14,"portal label remains readable at baseline GUI size "+string(_li));
            check(abs(_label.centre_x-_portal.x)<0.01 && _label.y+_label.height<=_portal.y-55,
                "label stays aligned above its own portal "+string(_li));
            check(_label.x>=0 && _label.y>=0 && _label.x+_label.width<=display_get_gui_width(),
                "portal label stays inside the screen "+string(_li));
            for(var _lj=0;_lj<_li;_lj++)
            {
                var _other=_labels[_lj];
                check(_label.x+_label.width<=_other.x || _other.x+_other.width<=_label.x
                    || _label.y+_label.height<=_other.y || _other.y+_other.height<=_label.y,
                    "neighbouring portal labels never overlap "+string(_lj)+"/"+string(_li));
            }
        }
    }
    check(variable_struct_exists(t.portals[5],"direction") && t.portals[5].direction==0,
        "Wilson uses a right-facing walk for the nearly horizontal final portal approach");
    var _want=["cavern","steampunk","king","city","agent","wilson"];
    for(var _i=0;_i<6;_i++)check(t.portals[_i].key==_want[_i] && !t.portals[_i].departed,"each reality has its own portal and traveller "+string(_i));
    check(t.portals[1].name=="STEAMPUNK" && asset_get_index("spr_steampunk_idle")!=-1
        && t.portals[1].sprite==asset_get_index("spr_steampunk_idle"),"Steampunk has its own farewell portrait and portal");
    for(var _i=0;_i<6;_i++)check(t.portals[_i].sprite!=spr_castle_guard,"castle guard stays in the king reality rather than returning through a separate portal");
    check(asset_get_index("rm_fatec_classroom")!=-1 && asset_get_index("obj_fatec_ending")!=-1,"Fatec room and arrival controller registered");
    if(asset_get_index("rm_fatec_classroom")==-1 || asset_get_index("obj_fatec_ending")==-1){finish_tests();exit;}
    t.start_departures();t.start_ending();t.start_recovery();
    check(t.scene_mode=="departures" && t.depart_count==0,"repeated ending recovery or departure calls cannot reenter the duel or restart finale");
    locked_x=p.x;locked_y=p.y;
    keyboard_key_press(ord("E"));keyboard_key_press(vk_space);keyboard_key_press(vk_enter);keyboard_key_press(vk_right);keyboard_key_press(vk_escape);
    stage=1;tick=0;break;
case 1:
    if(tick<12)exit;
    check(room==rm_temporal_origin && t.depart_count==0 && !p.movimento_liberado,"held confirmation and movement cannot cut portal opening");
    check(som_musica()=="snd_music_newton","collapsing reality uses tension music during departures");
    screen_save("epilogue-six-portals.png");
    stage=2;tick=0;break;
case 2:
    if(room!=rm_temporal_origin)
    {
        check(false,"Wilson cannot return before all five companions leave");finish_tests();exit;
    }
    check(t.depart_count>=last_depart_count && t.depart_count<=last_depart_count+1,"departures occur one traveller at a time");
    last_depart_count=t.depart_count;
    check(!p.movimento_liberado && p.x==locked_x && p.y==locked_y && !instance_exists(obj_battle_controller),"finale locks movement and battle while the scene fractures");
    if(t.depart_count<5)exit;
    for(var _i=0;_i<5;_i++)check(t.portals[_i].departed,"companion returns before Wilson "+string(_i));
    check(!t.portals[5].departed && t.scene_mode=="departures","Wilson remains the sixth and last traveller");
    stage=3;tick=0;break;
case 3:
    if(tick<12)exit;
    screen_save("epilogue-wilson-last.png");
    stage=4;tick=0;break;
case 4:
    if(room==rm_temporal_origin)
    {
        if(t.depart_count<6)exit;
        check(t.portals[5].departed && t.scene_mode=="fracture","last departure finishes before the classroom transition");
        exit;
    }
    check(room==asset_get_index("rm_fatec_classroom") && finale_elapsed<8,"six returns end in the Fatec classroom without held-input shortcuts");
    check(historia_newton_progresso().finale_transferred && !instance_exists(obj_temporal_scene) && !instance_exists(obj_newton_final) && !instance_exists(obj_battle_controller),"classroom arrival removes the old scene duel and enemy");
    check(matematica_progresso().xp_total==xp_before+100,"cinematic transfer never duplicates victory XP");
    classroom_steps_start=som_estado().step_count;
    stage=5;tick=0;break;
case 5:
    if(tick<12)exit;
    e=instance_find(asset_get_index("obj_fatec_ending"),0);
    p=instance_find(obj_player,0);
    check(instance_exists(e) && e.phase=="arrival","classroom begins with Wilson arrival rather than immediate credits");
    check(instance_exists(obj_player) && !instance_find(obj_player,0).movimento_liberado && !instance_find(obj_player,0).visible,"classroom input remains locked while professor is drawn by its controller");
    check(som_musica()=="snd_music_ending" && som_piso(room,480,180)=="snd_step_wood","classroom has ending score and wooden-floor footsteps");
    end_errors_seen=false;end_quote_seen=false;end_fim_captured=false;end_errors_captured=false;secret_blackout_seen=false;credits_seen=false;
    var _students=asset_get_index("obj_fatec_student");
    check(_students!=-1,"four photographed people have classroom character resources");
    if(_students!=-1)
    {
        check(instance_number(_students)==4,"exactly four distinct students observe the homecoming");
        student_ids=[];student_poses=[];
        for(var _si=0;_si<instance_number(_students);_si++)
        {
            var _student=instance_find(_students,_si);
            check(_student.photo_index==_si && _student.sprite_index!=-1,"each supplied photograph has its own sprite "+string(_si));
            var _art=_student.sprite_index;
            var _scale=_student.student_height/(sprite_get_bbox_bottom(_art)-sprite_get_bbox_top(_art)+1);
            var _half=(sprite_get_bbox_right(_art)-sprite_get_bbox_left(_art)+1)*_scale/2;
            check(_student.student_height>=64 && _student.student_height<=84
                && e.professor_height>=64 && e.professor_height<=84,
                "people have a readable scale relative to classroom desks "+string(_si));
            check(_student.x-_half>180 && _student.x+_half<438
                && _student.y>=180 && _student.y<=208,
                "whole student silhouette fits left of the professor near the green board above first desks "+string(_si));
            for(var _sj=0;_sj<_si;_sj++)
            {
                var _other=student_ids[_sj];
                var _other_half=(sprite_get_bbox_right(_other.sprite_index)-sprite_get_bbox_left(_other.sprite_index)+1)
                    *_other.student_height/(sprite_get_bbox_bottom(_other.sprite_index)-sprite_get_bbox_top(_other.sprite_index)+1)/2;
                check(abs(_student.x-_other.x)>_half+_other_half+4,"left-side observers have space between silhouettes");
            }
            check(_student.look_sign==sign(480-_student.x),"student looks toward the arriving professor "+string(_si));
            check(_student.depth==mundo_profundidade(_student.y),"student feet set the same depth as furniture "+string(_si));
            array_push(student_ids,_student.id);array_push(student_poses,_student.idle_time);
            for(var _sj=0;_sj<_si;_sj++)check(_student.sprite_index!=student_ids[_sj].sprite_index,"photo sprites are never reused");
        }
    }
    // Observe the real production reveal; tests never force cinematic completion.
    screen_save("epilogue-fatec-arrival.png");
    stage=6;tick=0;break;
case 6:
    if(e.secret_active && e.phase!="COMPLETE")
    {
        var _mix=som_estado();
        if(!variable_instance_exists(id,"ending_music_handle"))ending_music_handle=_mix.music_id;
        check(_mix.music_name=="snd_final_cinematic_music" && _mix.music_id==ending_music_handle
            && audio_is_playing(ending_music_handle),"natural FIM through credits keeps one continuous music instance");
    }
    if(!variable_instance_exists(id,"secret_last_phase") || secret_last_phase!=e.phase)
    {
        secret_last_phase=e.phase;
        show_debug_message("EPILOGUE_PHASE: "+e.phase+" / seconds="+string(e.elapsed));
    }
    if(!variable_instance_exists(id,"classroom_walk_captured") && e.elapsed>=2)
    {
        screen_save("epilogue-fatec-students-walk.png");classroom_walk_captured=true;
    }
    if(e.elapsed<4.2)check(e.phase=="arrival","professor remains in arrival until reaching teaching area");
    else if(e.elapsed<e.showcase_start)
    {
        home_seen=true;check(e.phase=="home","professor settles visibly in the classroom before fade");
        if(!professor_captured && e.elapsed>=5.2)
        {
            check(som_estado().step_count>classroom_steps_start && som_estado().last_step_name=="snd_step_wood","Wilson arrival produces actual wooden-floor footsteps");
            if(variable_instance_exists(id,"student_ids"))
            for(var _si=0;_si<array_length(student_ids);_si++)
            {
                var _student=student_ids[_si];
                check(instance_exists(_student) && _student.idle_time>student_poses[_si],"each student remains alive with subtle idle animation "+string(_si));
                check(_student.x==_student.home_x && _student.y==_student.home_y,"students stay by their desks during professor's walk "+string(_si));
                check(_student.look_sign==sign(e.professor_x-_student.x),"student attention follows the professor "+string(_si));
            }
            screen_save("epilogue-fatec-professor.png");professor_captured=true;
        }
    }
    else if(e.elapsed<e.home_duration)
    {
        check(e.phase=="showcase" && !p.movimento_liberado,"presentation remains protected from held farewell input");
        if(!variable_instance_exists(id,"showcase_seen"))showcase_seen=[];
        var _pose=e.showcase_pose;
        if(_pose.index>=0 && _pose.alpha>0.99 && !array_contains(showcase_seen,_pose.index))
        {
            check(_pose.index==array_length(showcase_seen),"natural camera visits all six people in order");
            check(abs(camera_get_view_width(view_camera[0])-320)<0.01,"actual classroom camera zooms into the portrait");
            var _person=e.showcase_people[_pose.index];
            var _label=fatec_apresentacao_layout(_person,_pose,640,380);
            check(_label.top>=0 && _label.bottom<_label.head_y,"both label lines remain above the head");
            array_push(showcase_seen,_pose.index);
            screen_save("classroom-showcase-"+string(_pose.index)+".png");
        }
    }
    else if(e.elapsed<e.blackout_time)
    {
        fade_seen=true;check(e.phase=="fade","classroom fades before separate black ending");
        check(camera_get_view_width(view_camera[0])==room_width && camera_get_view_x(view_camera[0])==0,"full classroom camera is restored before FIM");
    }
    else if(e.phase=="FINAL_SCREEN" || e.phase=="GLITCH_SEQUENCE")
    {
        end_errors_seen=true;
        check(historia_newton_progresso().stage!="credits_ready" && !p.movimento_liberado,
            "black FIM and error sequence cannot be skipped by held farewell input");
        if(e.phase=="FINAL_SCREEN" && !end_fim_captured && e.secret_time>=0.20)
        {
            check(e.terminal_visible==0,"black FIM appears before the green errors");
            screen_save("epilogue-ending-fim.png");end_fim_captured=true;
        }
        if(e.phase=="GLITCH_SEQUENCE" && !end_errors_captured && e.secret_time>=3.2)
        {
            check(e.terminal_visible==array_length(e.terminal_lines),"green errors accumulate fully before the quote");
            screen_save("epilogue-ending-errors.png");end_errors_captured=true;
        }
    }
    else if(e.phase=="BLACKOUT"){secret_blackout_seen=true;check(som_musica()=="snd_final_cinematic_music" && audio_is_playing(som_estado().music_id),"supplied music continues through blackout");}
    else if(string_pos("CINEMATIC_",e.phase)==1 || e.phase=="REVEAL_HOLD")
    {
        if(!variable_instance_exists(id,"cinematic_seen"))cinematic_seen=[];
        check(e.secret_frame>=0 && e.secret_frame<19,"cinematic uses only the nineteen corrected images");
        check(surface_exists(e.secret_surface),"cinematic renders into a live composite surface");
        // Observe every rendered frame immediately. Delaying observation can
        // miss frame zero while its first texture upload stalls the renderer.
        if(!array_contains(cinematic_seen,e.secret_frame))
        {
            if(array_length(cinematic_seen)>0)check(e.secret_frame>cinematic_seen[array_length(cinematic_seen)-1],"cinematic advances without repeating numbered images");
            array_push(cinematic_seen,e.secret_frame);
            screen_save("ending-cinematic-"+string(e.secret_frame)+".png");
        }
    }
    else if(e.phase=="NEWTON_QUOTE")
    {
        check(e.ending_quote=="O que sabemos é uma gota, o que ignoramos é um oceano" && e.ending_author=="Isaac Newton","exact quote and author preserved");
        if(!end_quote_seen && e.secret_quote_chars==string_length(e.ending_quote))
        {screen_save("epilogue-ending-quote.png");end_quote_seen=true;}
    }
    else if(e.phase=="FINAL_FADEOUT")
    {
        check(array_length(e.secret_sound_ids)==0 && audio_is_playing(som_estado().music_id),"quote fade preserves the supplied track without extra cues");
    }
    else if(e.phase=="CREDITS")
    {
        credits_seen=true;
        check(array_length(e.secret_sound_ids)==0 && som_musica()=="snd_final_cinematic_music"
            && audio_is_playing(som_estado().music_id) && som_ambiente(room)=="","credits retain the supplied track even after its first loop");
        if(!variable_instance_exists(id,"credits_captured"))
        {screen_save("epilogue-ending-credits.png");credits_captured=true;}
    }
    if(!e.secret_complete)exit;
    check(variable_instance_exists(id,"showcase_seen") && array_length(showcase_seen)==6,"all six named portraits appeared before the original ending");
    check(e.elapsed>=e.credits_time && home_seen && fade_seen && professor_captured
        && end_fim_captured && end_errors_captured && secret_blackout_seen && end_quote_seen
        && credits_seen && !e.secret_skipped,"ending completes naturally after FIM, quote and credits");
    check(e.phase=="COMPLETE" && e.secret_active && historia_newton_progresso().stage=="ending_complete","completion holds after credits without automatic menu");
    check(!instance_exists(obj_battle_controller) && matematica_progresso().xp_total==xp_before+100,"completion keeps combat closed and rewards stable");
    check(array_length(e.secret_history)==12 && array_length(e.secret_sound_ids)==0,"all twelve ending states ran once and cleaned audio");
    check(variable_instance_exists(id,"cinematic_seen") && array_length(cinematic_seen)==19,"all nineteen corrected frames played naturally in order");
    check(!surface_exists(e.secret_surface),"cinematic surface is released before quote and credits");
    stage=60;tick=0;break;
case 60:
    if(tick<12)exit;
    check(room==asset_get_index("rm_fatec_classroom") && e.phase=="COMPLETE","held input cannot cut terminal black before fresh confirmation");
    screen_save("epilogue-ending-complete.png");
    keyboard_key_release(ord("E"));keyboard_key_release(vk_space);keyboard_key_release(vk_enter);keyboard_key_release(vk_right);keyboard_key_release(vk_escape);
    stage=7;tick=0;break;
case 7:
    if(tick<12)exit;
    keyboard_key_press(vk_enter);stage=8;tick=0;break;
case 8:
    if(tick<12)exit;
    keyboard_key_release(vk_enter);check(room==rm_menu,"fresh ending confirmation returns to menu");
    stage=9;tick=0;break;
case 9:
    if(tick<12)exit;
    with(obj_main_menu){button_x=-10000;menu_selected=0;activate_option=true;}
    stage=10;tick=0;break;
case 10:
    if(tick<12)exit;
    var _story=historia_newton_progresso();
    check(room==rm_tutorial && !_story.finale_started && !_story.finale_transferred && !_story.final_rewarded && _story.stage=="city","new game resets finale and victory progression");
    check(matematica_progresso().xp_total==0 && instance_number(obj_newton_npc)==1 && instance_number(obj_newton_final)==0,"new game restores the original tutorial with zero XP");
    finish_tests();exit;
}
