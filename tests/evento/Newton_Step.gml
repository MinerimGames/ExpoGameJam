tick++;elapsed++;
if(elapsed>2400){check(false,"Newton sequence timeout");finish_tests();exit;}
switch(stage)
{
case 0:
    if(tick<12)exit;
    p=instance_find(obj_player,0);p.x=480;p.y=68;
    check(!historia_newton_progresso().city_defeated,"exit initially gated");
    stage=1;tick=0;break;
case 1:
    if(tick<12)exit;
    check(room==rm_autumn_plaza,"no transition before city victory");
    n=instance_find(obj_isleide_city,0);n.dialogue_active=false;
    b=batalha_iniciar(n,false);b.enemy_hp=0;b.finish_check();b.leave_after_victory();
    check(historia_newton_progresso().city_defeated,"city victory unlocks district");
    stage=21;tick=0;break;
case 21:
    if(tick<12)exit;
    check(room==rm_autumn_plaza && instance_number(obj_portal)==1,"city victory visibly opens its portal before any change of reality");
    var _portal=instance_find(obj_portal,0);
    _portal.activation_delay=0;p.x=_portal.x;p.y=_portal.y+8;
    keyboard_key_press(vk_up);stage=22;tick=0;break;
case 22:
    if(room==rm_autumn_plaza){if(tick>45){clear_keys();check(false,"city portal remains unreachable");finish_tests();}exit;}
    clear_keys();stage=2;tick=0;break;
case 2:
    if(tick<12)exit;
    check(room==rm_commercial_district,"visible city portal enters district");
    check(instance_number(obj_capitalist_ally)==1,"one ally in district");
    p=instance_find(obj_player,0);n=instance_find(obj_capitalist_ally,0);
    check(array_length(n.dialogue_pages)==16,"approved revelation pages");
    screen_save("newton-district-entry.png");
    check(point_distance(p.x,p.y,480,600)<8,"port entry starts on central southern quay");
    var _water_blocked=false;
    with(p)_water_blocked=place_meeting(350,270,obj_colisor);
    check(_water_blocked,"canal water blocks the player");
    if(failures>0){finish_tests();exit;}
    port_route=[[480,500],[480,380],[480,270],[480,180],[480,105]];
    port_waypoint=0;stage=3;tick=0;break;
case 3:
    if(!n.dialogue_active)
    {
        if(port_waypoint>=array_length(port_route)){check(false,"ally reachable from market landing");finish_tests();exit;}
        var _target=port_route[port_waypoint];
        clear_keys();
        if(point_distance(p.x,p.y,_target[0],_target[1])<=5)
        {
            if(port_waypoint==2)screen_save("newton-port-bridge.png");
            port_waypoint++;tick=0;exit;
        }
        if(tick>150){show_debug_message("PORT_STUCK: "+string(port_waypoint)+" "+string(p.x)+","+string(p.y));check(false,"port footpath remains connected");finish_tests();exit;}
        if(p.x<_target[0]-2)keyboard_key_press(vk_right);
        if(p.x>_target[0]+2)keyboard_key_press(vk_left);
        if(p.y<_target[1]-2)keyboard_key_press(vk_down);
        if(p.y>_target[1]+2)keyboard_key_press(vk_up);
        exit;
    }
    clear_keys();
    check(point_distance(p.x,p.y,n.x,n.y)<=40,"actual walking crosses straight bridge and reaches ally");
    check(!p.movimento_liberado,"revelation locks movement");
    screen_save("newton-revelation.png");
    check(asset_get_index("rm_temporal_origin")!=-1,"temporal origin room available");
    stage=4;tick=0;input_pulse=false;break;
case 4:
    if(tick<12)exit;
    if(room!=rm_commercial_district)
    {
        keyboard_key_release(ord("E"));check(false,"agent revelation must open a visible portal before temporal return");finish_tests();exit;
    }
    if(n.dialogue_active)
    {
        screen_save("newton-revelation-"+string(n.dialogue_page)+".png");
        if(input_pulse)keyboard_key_release(ord("E"));else keyboard_key_press(ord("E"));
        input_pulse=!input_pulse;tick=0;exit;
    }
    keyboard_key_release(ord("E"));
    check(instance_number(obj_portal)==1 && p.movimento_liberado,"agent opens a portal and lets Wilson approach it");
    stage=41;tick=0;break;
case 41:
    if(tick<12)exit;
    var _return=instance_find(obj_portal,0);
    check(_return.portal_destination==rm_temporal_origin,"agent portal returns to the beginning of the paradox");
    screen_save("newton-agent-return-portal.png");
    _return.activation_delay=0;p.x=_return.x;p.y=_return.y-40;
    keyboard_key_press(vk_down);stage=42;tick=0;break;
case 42:
    if(room==rm_commercial_district){if(tick>45){clear_keys();check(false,"agent portal is unreachable");finish_tests();}exit;}
    clear_keys();stage=5;tick=0;break;
case 5:
    if(tick<60)exit;
    check(room==rm_temporal_origin,"revelation returns to origin");
    check(instance_number(obj_player)==1 && instance_number(obj_past_wilson)==1
        && instance_number(obj_newton_final)==1 && instance_number(obj_capitalist_ally)==1,
        "two Wilsons and ally present with one controlled player");
    check(instance_number(obj_portal)==0 && instance_number(obj_newton_npc)==0,"return never restarts tutorial or creates portal");
    t=instance_find(obj_temporal_scene,0);
    check(t.scene_mode=="exposure" && t.dialogue_page==0 && array_length(t.dialogue_pages)==10,"held entry key leaves ten exposure pages ready at first page");
    screen_save("newton-origin.png");stage=6;tick=0;input_pulse=false;break;
case 6:
    if(tick<12)exit;
    if(t.dialogue_active)
    {
        screen_save("newton-exposure-"+string(t.dialogue_page)+".png");
        if(input_pulse)keyboard_key_release(ord("E"));else keyboard_key_press(ord("E"));
        input_pulse=!input_pulse;tick=0;exit;
    }
    keyboard_key_release(ord("E"));
    check(instance_number(obj_battle_controller)==1,"one final battle starts after exposure");
    b=instance_find(obj_battle_controller,0);
    check(b.enemy_source.object_index==obj_newton_final && b.enemy_hp==420,"final Newton is distinct from tutorial");
    check(asset_get_index("newton_battle")!=-1,"Newton special battle rules registered");
    check(b.story_battle && b.story_stage==1,"final encounter uses first narrative stage");
    for(var _i=0;_i<400;_i++)
    {
        var _c=newton_gerar_desafio(1,_i);var _parts=string_split(_c.expressao," ");
        var _first=real(string_digits(_parts[0]));var _second=real(string_digits(_parts[2]));
        var _fourth=real(string_digits(_parts[6]));var _expected;
        if(_i mod 2==0)
        {
            var _power=real(string_split(_parts[4],"^")[0]);
            _expected=_first*_second+_power*_power-_fourth;
            check(_first>=12 && _first<=24 && _second>=6 && _second<=12 && _power>=7 && _power<=15,
                "complex multiplication and powers stay in approved range");
        }
        else
        {
            var _third=real(string_digits(_parts[4]));
            _expected=(_first/_second)*(_third+_fourth);
            check(_second>0 && _first mod _second==0,"complex division is exact and nonzero");
        }
        check(_c.resposta==_expected && floor(_expected)==_expected && _expected>0,"complex expression matches independent evaluation");
    }
    xp_before=matematica_progresso().xp_total;matematica_progresso().paradox_unlocked=true;
    b.request_action("heal");check(b.story_answers==0 && b.battle_screen=="actions","invalid heal does not consume narrative answer");
    b.request_action("attack");b.verify_answer();
    check(b.story_answers==0 && b.battle_screen=="challenge","blank answer cannot advance scripted defeat");
    stage=7;tick=0;break;
case 7:
    if(tick<12)exit;
    screen_save("newton-complex.png");
    display_set_gui_size(960,540);window_set_size(960,540);
    stage=70;tick=0;break;
case 70:
    if(tick<12)exit;
    screen_save("newton-complex-large.png");
    check(b.ui_scale==1 && b.ui_offset_x==0 && b.ui_offset_y==0,"large resolution battle transform stays correct");
    display_set_gui_size(640,380);window_set_size(640,380);
    keyboard_key_press(ord("Q"));stage=8;tick=0;break;
case 8:
    if(tick<8)exit;
    keyboard_key_release(ord("Q"));
    check(b.paradox_used && !variable_struct_exists(b.challenge,"expressao") && b.challenge.operacao=="+",
        "actual Q simplifies complex Newton question");
    b.answer_text=string(b.challenge.resposta);b.verify_answer();
    check(b.story_answers==1 && instance_exists(b),"correct first answer still keeps duel active");
    stage=9;tick=0;break;
case 9:
    if(tick<12)exit;
    b.player_hp=1;b.request_action("defense");b.answer_text="99999";b.verify_answer();
    check(b.story_answers==2 && b.player_hp>=1 && b.battle_screen=="actions","wrong answer and low HP do not trigger premature defeat");
    b.request_action("dodge");b.answer_text=string(b.challenge.resposta);b.verify_answer();
    check(!instance_exists(b) && t.scene_mode=="recovery","third submitted answer triggers recovery exactly once");
    check(matematica_progresso().xp_total==xp_before,"scripted defeat conserves XP");
    stage=10;tick=0;break;
case 10:
    if(tick<12)exit;
    screen_save("newton-recovery.png");
    check(variable_instance_exists(t,"support_sprites"),"four previous opponents return visibly as support");
    if(!variable_instance_exists(t,"support_sprites")){finish_tests();exit;}
    check(array_length(t.support_sprites)==4,"all four previous enemies offer help");
    check(asset_get_index("spr_steampunk_idle")!=-1 && t.support_sprites[1]==asset_get_index("spr_steampunk_idle"),"Steampunk joins the four returning reality anchors");
    for(var _i=0;_i<4;_i++)check(t.support_sprites[_i]!=spr_castle_guard,"castle guard does not replace a reality anchor in the supported duel");
    t.dialogue_page=2;t.start_recovery();check(t.dialogue_page==2,"duplicate fall cannot restart recovery");
    t.scene_mode="battle_first";n=instance_find(obj_newton_final,0);n.battle_stage=1;
    b=batalha_iniciar(n,false);b.request_action("attack");b.answer_text="12";keyboard_string="12";
    b.battle_config.test_skip_enabled=true; // Fixture shortcut; disabled in release.
    check(b.handle_test_skip(690,20,true),"first-stage skip accepts test button");
    check(!instance_exists(b) && t.scene_mode=="recovery" && keyboard_string==""
        && matematica_progresso().xp_total==xp_before,"first-stage skip clears open question and conserves XP");
    stage=11;tick=0;input_pulse=false;break;
case 11:
    if(tick<12)exit;
    if(t.dialogue_active)
    {
        screen_save("newton-recovery-"+string(t.dialogue_page)+".png");
        if(input_pulse)keyboard_key_release(ord("E"));else keyboard_key_press(ord("E"));
        input_pulse=!input_pulse;tick=0;exit;
    }
    keyboard_key_release(ord("E"));b=instance_find(obj_battle_controller,0);
    check(b.story_stage==2 && b.player_hp==170 && b.player_hp_max==170 && b.enemy_hp==240 && b.ally_bonus==8,"collective support adds forty HP to city reward and strengthens duo");
    check(matematica_progresso().xp_total==xp_before && !b.paradox_used,"support preserves XP and restores ability charge");
    for(var _i=0;_i<300;_i++)
    {
        var _c=newton_gerar_desafio(2,_i);
        var _expected=_c.operacao=="x"?_c.x*_c.y:(_c.operacao=="-"?_c.x-_c.y:_c.x+_c.y);
        check(_c.resposta==_expected && !variable_struct_exists(_c,"expressao"),"supported questions have correct simple answers");
        if(_i<2)check(_c.operacao=="+" && _c.x<=5 && _c.y<=5,"first two questions are visibly easier");
        if(_c.operacao=="x")check(_c.x<=5 && _c.y<=5 && _c.x>=2 && _c.y>=2,"supported multiplication stays easy");
        if(_c.operacao=="-")check(_c.resposta>=1 && _c.x<=14,"supported subtraction is positive and small");
    }
    b.request_action("attack");check(b.challenge.operacao=="+" && b.challenge.resposta<=10,"actual second-stage challenge starts simple");
    stage=12;tick=0;break;
case 12:
    if(tick<12)exit;
    screen_save("newton-easy.png");keyboard_key_press(ord("Q"));stage=13;tick=0;break;
case 13:
    if(tick<8)exit;
    keyboard_key_release(ord("Q"));check(b.paradox_used,"Q works again in supported stage");
    keyboard_string=string(b.challenge.resposta);keyboard_key_press(vk_enter);stage=14;tick=0;break;
case 14:
    if(tick<8)exit;
    keyboard_key_release(vk_enter);
    check(b.enemy_hp>=202 && b.enemy_hp<=208,"real answer entry delivers strengthened attack plus ally bonus");
    b.player_hp=0;b.finish_check();check(b.battle_screen=="defeat","supported stage allows normal defeat");
    stage=15;tick=0;break;
case 15:
    if(tick<8)exit;
    keyboard_key_press(vk_enter);stage=16;tick=0;break;
case 16:
    if(tick<8)exit;
    keyboard_key_release(vk_enter);
    check(b.story_stage==2 && b.player_hp==170 && b.enemy_hp==240 && !b.paradox_used && t.scene_mode=="battle_supported",
        "actual retry keeps supported stage and restores one charge");
    screen_save("newton-duo.png");
    b.enemy_hp=1;b.request_action("attack");b.answer_text=string(b.challenge.resposta);b.verify_answer();
    check(b.battle_screen=="victory" && b.player_hp==200 && b.player_hp_max==200,"finishing strengthened attack receives no retaliation and one boss HP reward");
    check(matematica_progresso().xp_total==xp_before+100,"final victory gives exactly one normal XP reward");
    b.reward_victory();check(matematica_progresso().xp_total==xp_before+100,"final XP cannot duplicate");
    b.leave_after_victory();check(t.scene_mode=="ending" && !instance_exists(b),"victory starts ending without destroying scene");
    stage=17;tick=0;input_pulse=false;break;
case 17:
    if(tick<12)exit;
    if(t.dialogue_active)
    {
        screen_save("newton-ending-"+string(t.dialogue_page)+".png");
        if(input_pulse)keyboard_key_release(ord("E"));else keyboard_key_press(ord("E"));
        input_pulse=!input_pulse;tick=0;exit;
    }
    keyboard_key_release(ord("E"));
    check(t.scene_mode=="departures" && !instance_find(obj_player,0).movimento_liberado,"ending starts locked cinematic departures");
    n=instance_find(obj_newton_final,0);n.battle_stage=2;
    b=batalha_iniciar(n,false);b.request_action("defense");
    b.battle_config.test_skip_enabled=true; // Fixture shortcut; disabled in release.
    b.handle_test_skip(690,20,true);
    check(!instance_exists(b) && t.scene_mode=="departures" && matematica_progresso().xp_total==xp_before+100,
        "supported skip cannot restart an existing finale or duplicate reward");
    historia_newton_progresso().steampunk_defeated=true;
    room_goto(rm_menu);stage=18;tick=0;break;
case 18:
    if(tick<12)exit;
    keyboard_key_press(vk_enter);stage=19;tick=0;break;
case 19:
    if(tick<12)exit;
    keyboard_key_release(vk_enter);
    var _story=historia_newton_progresso();
    check(room==rm_tutorial && !_story.steampunk_defeated && !_story.city_defeated && !_story.final_rewarded && !_story.finale_started && !_story.finale_transferred && _story.stage=="city",
        "actual JOGAR clears narrative progress");
    check(matematica_progresso().xp_total==0 && instance_number(obj_newton_npc)==1
        && instance_number(obj_newton_final)==0 && instance_number(obj_player)==1,
        "new game restores original tutorial and zero XP");
    finish_tests();exit;
}
