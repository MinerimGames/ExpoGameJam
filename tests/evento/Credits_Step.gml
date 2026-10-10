tick++;elapsed++;
if(elapsed>600){check(false,"cutscene input test timeout");finish_tests();exit;}
switch(stage)
{
case 0:
    if(tick<12)exit;
    e=instance_find(obj_fatec_ending,0);
    check(instance_exists(e),"existing classroom controller owns ending");
    if(asset_get_index("snd_final_cinematic_music")==-1)
    {check(false,"supplied music is available for the complete ending");finish_tests();exit;}
    var _music_handle=-1;var _scene_start=e.blackout_time;
    for(var _music_scene=0;_music_scene<array_length(e.secret_config.scenes)-1;_music_scene++)
    {
        var _music_part=e.secret_config.scenes[_music_scene];
        e.elapsed=_scene_start+0.2;segredo_trono_atualizar(e,0);
        check(som_musica()=="snd_final_cinematic_music" && audio_is_playing(som_estado().music_id),"supplied track plays during "+_music_part.key);
        if(_music_handle==-1)_music_handle=som_estado().music_id;
        else check(som_estado().music_id==_music_handle,"music never restarts between ending scenes "+_music_part.key);
        check(e.secret_music_gain>0 && e.secret_music_gain<=0.32,"ending music respects reduced volume");
        _scene_start+=_music_part.duration;
    }
    var _credits_start=_scene_start-e.secret_config.scenes[10].duration;
    e.elapsed=_credits_start+19.5;segredo_trono_atualizar(e,0);
    check(e.secret_music_gain>0 && e.secret_music_gain<0.12,"music fades gently at the end of the credits");
    segredo_trono_finalizar(e);
    check(!audio_is_playing(_music_handle),"ending completion stops the supplied track");
    e.secret_complete=false;e.secret_active=false;e.secret_index=-1;e.secret_history=[];
    e.elapsed=0;e.phase="arrival";som_atualizar();
    if(!variable_instance_exists(e,"showcase_people"))
    {
        check(false,"homecoming presents six named people before FIM");finish_tests();exit;
    }
    var _names=["Guilherme Batistela","Jahel","Matheus Silva","Thiago Kodaira","Professor Isleide Wilson","Adriano"];
    var _roles=["Gestor do projeto","Design de background e dev","Dev geral","Design de personagem e direção artística","Personagem principal","Professor responsável pelo GameJam"];
    check(array_length(e.showcase_people)==6,"six people receive camera portraits");
    for(var _person=0;_person<6;_person++)
    {
        var _credit=e.showcase_people[_person];
        check(_credit.name==_names[_person] && _credit.role==_roles[_person],"correct name and role for person "+string(_person));
        if(_person>0)check(_credit.x>e.showcase_people[_person-1].x,"camera visits the people from left to right");
        var _age=_person*e.showcase_slot+1.1;
        var _pose=fatec_apresentacao_amostra(e,_age);
        check(_pose.index==_person && _pose.alpha>0.99,"each person has a readable uninterrupted close-up");
        check(abs(_pose.x+_pose.w/2-_credit.x)<0.001 && _pose.w==320,"camera centres the selected person at close range");
        var _label=fatec_apresentacao_layout(_credit,_pose,640,380);
        check(_label.bottom<_label.head_y && _label.top>=0 && _label.left>=0 && _label.right<=640,"name and role fit above the person's head "+string(_person));
        if(_person==3)check(string_pos("\n",_label.role)>0,"long artistic direction role wraps into readable lines");
    }
    var _restored=fatec_apresentacao_amostra(e,e.home_duration-e.showcase_start);
    check(_restored.index==-1 && abs(_restored.w-room_width)<0.001
        && abs(_restored.h-room_height)<0.001 && _restored.x==0 && _restored.y==0,"camera returns to the whole classroom before FIM");
    var _states=["FINAL_SCREEN","GLITCH_SEQUENCE","BLACKOUT","CINEMATIC_01","CINEMATIC_02","CINEMATIC_03","REVEAL_HOLD","QUOTE_BLACKOUT","NEWTON_QUOTE","FINAL_FADEOUT","CREDITS","COMPLETE"];
    check(array_length(e.secret_config.scenes)==12,"ending plays corruption and all three supplied folders before quote and credits");
    for(var _i=0;_i<min(12,array_length(e.secret_config.scenes));_i++)check(e.secret_config.scenes[_i].key==_states[_i],"cinematic state order "+_states[_i]);
    check(e.ending_quote=="O que sabemos é uma gota, o que ignoramos é um oceano" && e.ending_author=="Isaac Newton","original quote and named author preserved");
    check(abs(e.quote_start-(e.blackout_time+26.2))<0.001,"quote begins after the faster corrected cinematic");
    check(sprite_get_number(spr_final_cinematic)==19,"all nineteen corrected images are available in the game");
    check(shader_is_compiled(shd_final_camera),"camera effect compiles on the native renderer");
    check(segredo_trono_delta("CINEMATIC_01",2)==0.1
        && segredo_trono_delta("CINEMATIC_03",2)==0.1,"a renderer stall cannot jump over supplied cinematic frames");
    check(segredo_trono_delta("BLACKOUT",2)==0.1
        && segredo_trono_delta("REVEAL_HOLD",2)==0.1,"cinematic entry and final pose survive texture-loading stalls");
    check(segredo_trono_delta("CINEMATIC_02",0.016)==0.016
        && segredo_trono_delta("NEWTON_QUOTE",2)==2,"normal animation timing and original quote clock are preserved");
    var _starts=[0,5,14];var _counts=[5,9,5];
    check(abs(e.secret_config.scenes[3].duration+e.secret_config.scenes[4].duration
        +e.secret_config.scenes[5].duration+e.secret_config.scenes[6].duration-17.65)<0.001,
        "corrected scenes play about twenty-two percent faster with the final pose held");
    for(var _group=0;_group<3;_group++)
    {
        var _cinema=e.secret_config.scenes[3+_group];
        for(var _frame=0;_frame<_counts[_group];_frame++)
        {
            var _sample=segredo_trono_amostra(_cinema,_frame*_cinema.frame_seconds);
            check(_sample.current==_starts[_group]+_frame && _sample.blend==0,"each numbered frame starts fully aligned in folder order: group="+string(_group)+" frame="+string(_frame)+" current="+string(_sample.current)+" blend="+string(_sample.blend));
            var _half=segredo_trono_amostra(_cinema,(_frame+0.5)*_cinema.frame_seconds);
            check(_half.next<=_starts[_group]+_counts[_group]-1,"dissolve cannot spill into next folder");
            if(_frame<_counts[_group]-1)check(abs(_half.blend-0.5)<0.0001,"midpoint is a continuous half dissolve");
        }
    }
    var _last=segredo_trono_amostra(e.secret_config.scenes[6],2);
    check(_last.current==18 && _last.next==18,"unmasked final pose holds without looping");
    check(sprite_get_number(spr_secret_path_approach)==36 && sprite_get_number(spr_secret_guardian_approach)==36
        && sprite_get_number(spr_secret_mask_reveal)==24,"old guard animation assets remain available but are not part of the ending");
    var _duplicate=instance_create_depth(0,0,0,obj_fatec_ending);
    check(instance_number(obj_fatec_ending)==1 && instance_number(obj_fatec_student)==4,"one controller and four observers");
    e.secret_config=segredo_trono_config();
    e.elapsed=e.blackout_time+3+4.5-0.05;e.phase="GLITCH_SEQUENCE";
    e.elapsed+=segredo_trono_delta(e.phase,2);segredo_trono_atualizar(e,0);
    check(e.phase=="BLACKOUT","a stall at the corruption boundary cannot skip cinematic entry or frame zero");
    check(segredo_trono_delta("FINAL_SCREEN",30)==0.1
        && segredo_trono_delta("arrival",30)==0.1,"long stalls before cinema cannot jump over supplied frames");
    e.elapsed=e.quote_start+0.30;segredo_trono_atualizar(e,0);
    check(e.phase=="NEWTON_QUOTE" && e.secret_quote_chars>0 && e.secret_quote_chars<string_length(e.ending_quote),"quote uses progressive characters");
    e.elapsed=e.quote_start+string_length(e.ending_quote)/24+3.99;segredo_trono_atualizar(e,0);
    check(e.phase=="NEWTON_QUOTE" && e.secret_quote_chars==string_length(e.ending_quote),"quote holds after the typewriter finishes");
    e.elapsed=e.quote_start+string_length(e.ending_quote)/24+4+1+0.25;segredo_trono_atualizar(e,0);
    check(e.phase=="CREDITS" && array_length(e.secret_sound_ids)==0,"credits follow the quote after the guardian cinematic");
    keyboard_key_press(vk_enter);
    e.elapsed=e.credits_time+0.1;segredo_trono_atualizar(e,0);
    check(e.secret_complete && e.phase=="COMPLETE" && e.secret_active && array_length(e.secret_sound_ids)==0,"credits end in a silent terminal state");
    stage=1;tick=0;break;
case 1:
    if(tick<25)exit;
    check(room==rm_fatec_classroom && e.phase=="COMPLETE","held input cannot dismiss definitive ending");
    check(som_musica()=="" && som_ambiente(room)=="","terminal black stays silent");
    keyboard_key_release(vk_enter);stage=2;tick=0;break;
case 2:
    if(tick<12)exit;
    keyboard_key_press(vk_enter);stage=3;tick=0;break;
case 3:
    if(tick<12)exit;
    keyboard_key_release(vk_enter);check(room==rm_menu,"only fresh intentional confirmation returns to menu");
    finish_tests();exit;
}
