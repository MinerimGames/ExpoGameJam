tick++;
if(tick<30) exit;
show_debug_message("FLOW_"+string(stage)+": "+room_get_name(room)+" fps="+string(fps)+" capacity="+string(fps_real));
switch(stage) {
    case 0:
        check(room==rm_menu,"start menu");
        with(obj_main_menu) { button_x=-10000; menu_selected=0; activate_option=true; }
        break;
    case 1:
        keyboard_key_release(vk_enter); check(room==rm_tutorial,"menu starts tutorial");
        if(room!=rm_tutorial) { finish_tests(); exit; }
        n=instance_find(obj_newton_npc,0); p=instance_find(obj_player,0); p.x=n.x; p.y=n.y;
        if (!skip_probe_done)
        {
            n.dialogue_active=true; n.dialogue_mode="intro"; n.dialogue_page=0;
            keyboard_key_press(ord("P")); skip_probe_done=true; tick=29; exit;
        }
        // Wait for the real NPC event to process the injected key.
        if(!n.tutorial_completed && skip_probe_ticks<120)
        {
            if(!input_pulse){keyboard_key_release(ord("P"));input_pulse=true;}
            else {keyboard_key_press(ord("P"));input_pulse=false;}
            skip_probe_ticks++;tick=29;exit;
        }
        keyboard_key_release(ord("P"));
        input_pulse=false;
        check(n.tutorial_started && n.tutorial_completed && !n.dialogue_active && n.portal_created && p.movimento_liberado,"Newton skip button bypasses tutorial");
        with (obj_portal) instance_destroy();
        n.tutorial_started=false; n.tutorial_completed=false; n.portal_created=false; n.dialogue_mode="intro"; n.dialogue_page=0; n.dialogue_active=false;
        keyboard_key_press(ord("E")); break;
    case 2:
        if (!n.dialogue_active)
        {
            // O NPC pode processar sua etapa antes desta fixture no mesmo frame;
            // mantenha a tentativa atÃ© a entrada chegar ao objeto real.
            if (!input_pulse) { keyboard_key_release(ord("E")); input_pulse=true; }
            else { keyboard_key_press(ord("E")); input_pulse=false; }
            tick=29;
            exit;
        }
        keyboard_key_release(ord("E")); input_pulse=false; check(n.dialogue_active && !p.movimento_liberado,"Newton dialogue locks player");
        n.dialogue_page=array_length(n.dialogue_intro)-1; break;
    case 3:
        if (!instance_exists(obj_battle_controller))
        {
            if (!input_pulse) { keyboard_key_release(ord("E")); input_pulse=true; }
            else { keyboard_key_press(ord("E")); input_pulse=false; }
            tick=29; exit;
        }
        keyboard_key_release(ord("E")); input_pulse=false;
        break;
    case 4:
        keyboard_key_release(ord("E")); check(instance_number(obj_battle_controller)==1,"Newton starts one battle");
        if(!instance_exists(obj_battle_controller)) { finish_tests(); exit; }
        b=instance_find(obj_battle_controller,0); check(b.tutorial_mode && !p.movimento_liberado,"tutorial locks movement");
        solve(b,"attack",false); solve(b,"attack"); solve(b,"heal"); solve(b,"defense"); solve(b,"dodge");
        check(!b.tutorial_mode && b.guided_tutorial_completed,"all four guided actions complete"); win(b); b.leave_after_victory();
        check(n.dialogue_active && n.tutorial_completed && !p.movimento_liberado,"victory returns to Newton dialogue");
        n.dialogue_page=array_length(n.dialogue_post)-1; break;
    case 5: keyboard_key_press(ord("E")); break;
    case 6:
        keyboard_key_release(ord("E")); check(instance_number(obj_portal)==1 && p.movimento_liberado,"post dialogue creates one portal");
        var _portal=instance_find(obj_portal,0); _portal.activation_delay=0; p.x=_portal.x; p.y=_portal.y-16; break;
    case 7:
        check(room==rm_cavernas,"portal enters cavern"); p=instance_find(obj_player,0); d=instance_find(obj_newton_cavern_dialogue,0);
        check(d.dialogue_active && !p.movimento_liberado,"cavern transmission locks player");
        d.dialogue_page=array_length(d.dialogue_pages)-1; keyboard_key_press(ord("E")); break;
    case 8:
        keyboard_key_release(ord("E")); check(p.movimento_liberado,"cavern transmission unlocks player");
        p.x=room_width-20; break;
    case 9:
        check(room==rm_cavernas_2,"right edge enters second cavern"); p=instance_find(obj_player,0); n=instance_find(obj_cavern_isleide,0); p.x=n.x; p.y=n.y; break;
    case 10:
        check(n.dialogue_active && !p.movimento_liberado,"boss encounter dialogue locks player");
        n.dialogue_page=array_length(n.dialogue_pages)-1; keyboard_key_press(ord("E")); break;
    case 11:
        keyboard_key_release(ord("E")); check(instance_number(obj_battle_controller)==1,"boss starts one battle");
        b=instance_find(obj_battle_controller,0);
        check(b.enemy_hp==150 && b.math_phase_max==1 && b.battle_environment=="cavern_camp","boss settings and origin");
        b.player_hp=1; solve(b,"attack",false); check(b.battle_screen=="defeat","wrong answer can cause defeat");
        b.restart_battle(); check(b.player_hp==100 && b.enemy_hp==150 && instance_number(obj_battle_controller)==1 && !p.movimento_liberado,"retry clean and locked");
        win(b); b.leave_after_victory(); break;
    case 12:
        check(room==rm_cavernas_2 && !instance_exists(obj_battle_controller) && instance_number(obj_portal)==1,"boss victory creates cave exit portal");
        _portal=instance_find(obj_portal,0); p=instance_find(obj_player,0); _portal.activation_delay=0; p.x=_portal.x; p.y=_portal.y-16; break;
    case 13:
        check(room==rm_vila && instance_number(obj_portal)==0,"cave exit enters village without portal");
        p=instance_find(obj_player,0);d=instance_find(obj_newton_cavern_dialogue,0);
        if(!medieval_probe_done)
        {
            check(instance_exists(d),"medieval Newton transmission exists after victory");
            if(!instance_exists(d)){finish_tests();exit;}
            check(d.dialogue_active && d.dialogue_page==0 && array_length(d.dialogue_pages)==6
                && !p.movimento_liberado,"medieval transmission locks movement before exploration");
            d.dialogue_page=array_length(d.dialogue_pages)-1;
            keyboard_key_press(ord("E"));input_pulse=true;
            medieval_probe_done=true;tick=29;exit;
        }
        if(d.dialogue_active)
        {
            if(input_pulse){keyboard_key_release(ord("E"));input_pulse=false;}
            else {keyboard_key_press(ord("E"));input_pulse=true;}
            tick=29;exit;
        }
        keyboard_key_release(ord("E"));input_pulse=false;
        check(p.movimento_liberado,"medieval transmission releases player before trail transition");
        p.x=20;p.y=164;break;
    case 14:
        check(room==rm_bosque && instance_number(obj_portal)==0,"village edge enters trail without portal");
        p=instance_find(obj_player,0); p.x=304; p.y=20; break;
    case 15:
        check(room==rm_castelo && instance_number(obj_portal)==0,"trail edge enters castle without portal");
        p=instance_find(obj_player,0); p.x=416; p.y=580; break;
    case 16:
        n=instance_find(obj_castle_guard,0);
        check(room==rm_castelo && n.dialogue_active && !p.movimento_liberado,
            "castle guard intercepts player before doorway");
        n.dialogue_page=array_length(n.dialogue_pages)-1; break;
    case 17:
        if (!instance_exists(obj_battle_controller))
        {
            if (!input_pulse) {keyboard_key_release(ord("E"));input_pulse=true;}
            else {keyboard_key_press(ord("E"));input_pulse=false;}
            tick=29;exit;
        }
        keyboard_key_release(ord("E"));input_pulse=false;
        check(instance_number(obj_battle_controller)==1,"guard starts one battle");
        b=instance_find(obj_battle_controller,0);
        check(b.enemy_hp==150 && b.math_phase==4 && b.math_phase_max==6 && b.battle_environment=="medieval",
            "guard uses next math tier in castle setting");
        win(b);b.leave_after_victory();
        check(!instance_exists(obj_castle_guard) && p.movimento_liberado && instance_number(obj_portal)==0,
            "guard victory opens walking route without portal");
        p.x=416;p.y=528;break;
    case 18:
        check(room==rm_castle_hall && instance_number(obj_portal)==0,"castle door enters illuminated hall");
        p=instance_find(obj_player,0);p.x=400;p.y=158;break;
    case 19:
        check(room==rm_throne_room,"hall carpet leads to throne room");
        p=instance_find(obj_player,0);
        check(instance_exists(p),"throne arrival has its own live player instance");
        if(!instance_exists(p)){finish_tests();exit;}
        n=instance_find(obj_isleide_king,0);
        if(!n.dialogue_active){tick=29;exit;}
        n.dialogue_page=array_length(n.dialogue_pages)-1;break;
    case 20:
        if(!instance_exists(obj_battle_controller))
        {
            if(!input_pulse){keyboard_key_release(ord("E"));input_pulse=true;}
            else {keyboard_key_press(ord("E"));input_pulse=false;}
            tick=29;exit;
        }
        keyboard_key_release(ord("E"));input_pulse=false;
        b=instance_find(obj_battle_controller,0);
        check(b.enemy_hp==180 && b.math_profile=="royal_alternating" && b.battle_environment=="throne",
            "king starts alternating math battle in throne room");
        win(b);b.leave_after_victory();stage=20.1;tick=0;exit;
    case 20.1:
        if(instance_number(obj_portal)==1 && instance_find(obj_portal,0).activation_delay>0){tick=29;exit;}
        p=instance_find(obj_player,0);
        if(!instance_exists(p)){check(false,"royal portal approach needs a live player");finish_tests();exit;}
        check(room==rm_throne_room && instance_number(obj_portal)==1
            && !instance_exists(obj_battle_controller) && !instance_exists(obj_isleide_king)
            && p.movimento_liberado,
            "king confirmation keeps throne exploration available with one visible portal");
        var _royal_portal=instance_find(obj_portal,0);
        keyboard_key_press(p.y<_royal_portal.y-16?vk_down:vk_up);stage=20.2;tick=0;exit;
    case 20.2:
        if(room==rm_throne_room){tick=29;exit;}
        keyboard_key_release(vk_up);keyboard_key_release(vk_down);stage=21;tick=0;exit;
    case 21:
        check(room==rm_steampunk_foundry && instance_number(obj_portal)==0
            && !instance_exists(obj_battle_controller),"crossing royal portal enters foundry without old battle");
        if(room!=rm_steampunk_foundry){finish_tests();exit;}
        p=instance_find(obj_player,0);d=instance_find(obj_newton_cavern_dialogue,0);
        if(!variable_instance_exists(id,"steam_probe_done"))steam_probe_done=false;
        if(!steam_probe_done)
        {
            check(instance_exists(d),"industrial transmission follows normal king victory");
            if(!instance_exists(d)){finish_tests();exit;}
            check(d.dialogue_active && d.dialogue_page==0 && array_length(d.dialogue_pages)==6
                && !p.movimento_liberado,"industrial transmission pauses arrival before exploration");
            d.dialogue_page=array_length(d.dialogue_pages)-1;
            keyboard_key_press(ord("E"));input_pulse=true;
            steam_probe_done=true;tick=29;exit;
        }
        if(d.dialogue_active)
        {
            if(input_pulse){keyboard_key_release(ord("E"));input_pulse=false;}
            else{keyboard_key_press(ord("E"));input_pulse=true;}
            tick=29;exit;
        }
        keyboard_key_release(ord("E"));input_pulse=false;
        check(p.movimento_liberado && !instance_exists(obj_battle_controller),
            "industrial transmission releases walking without battle");
        p.x=480;p.y=220;stage=21.1;tick=0;exit;
    case 21.1:
        n=instance_find(obj_isleide_steampunk,0);
        check(instance_exists(n),"industrial boss remains available after transmission");
        if(!instance_exists(n)){finish_tests();exit;}
        if(!n.dialogue_active){tick=29;exit;}
        check(array_length(n.dialogue_pages)==8 && !p.movimento_liberado
            && !instance_exists(obj_battle_controller),"industrial encounter speaks before combat");
        n.dialogue_page=array_length(n.dialogue_pages)-1;
        stage=21.2;tick=0;exit;
    case 21.2:
        if(!instance_exists(obj_battle_controller))
        {
            if(!input_pulse){keyboard_key_release(ord("E"));input_pulse=true;}
            else{keyboard_key_press(ord("E"));input_pulse=false;}
            tick=29;exit;
        }
        keyboard_key_release(ord("E"));input_pulse=false;
        b=instance_find(obj_battle_controller,0);
        check(b.enemy_hp==205 && b.math_phase==6 && b.math_phase_max==8
            && b.math_profile=="steampunk_alternating" && !p.movimento_liberado,
            "industrial guardian starts its bounded intermediate math battle");
        steam_xp_before=matematica_progresso().xp_total;
        win(b);b.reward_victory();
        check(matematica_progresso().xp_total==steam_xp_before+100,
            "industrial integration victory adds one 100 XP reward");
        b.leave_after_victory();stage=21.3;tick=0;exit;
    case 21.3:
        if(instance_number(obj_portal)==1 && instance_find(obj_portal,0).activation_delay>0){tick=29;exit;}
        p=instance_find(obj_player,0);
        if(!instance_exists(p)){check(false,"industrial portal approach needs a live player");finish_tests();exit;}
        var _steam_scene=instance_find(obj_steampunk_scene,0);
        check(room==rm_steampunk_foundry && !instance_exists(obj_battle_controller)
            && !instance_exists(obj_isleide_steampunk) && p.movimento_liberado
            && !instance_exists(_steam_scene.exit_gate) && historia_newton_progresso().steampunk_defeated
            && instance_number(obj_portal)==1,
            "industrial confirmation opens the physical gate and retains one visible traversal portal");
        var _steam_portal=instance_find(obj_portal,0);
        keyboard_key_press(p.y<_steam_portal.y-16?vk_down:vk_up);stage=21.35;tick=0;exit;
    case 21.35:
        if(room==rm_steampunk_foundry){tick=29;exit;}
        keyboard_key_release(vk_up);keyboard_key_release(vk_down);stage=21.4;tick=0;exit;
    case 21.4:
        check(room==rm_autumn_gate && instance_number(obj_portal)==0 && !instance_exists(obj_battle_controller),
            "industrial portal enters autumn gate without old battle");
        p=instance_find(obj_player,0);d=instance_find(obj_newton_cavern_dialogue,0);
        if(!ghost_probe_done)
        {
            check(instance_exists(d),"ghost city transmission follows industrial victory and exit");
            if(!instance_exists(d)){finish_tests();exit;}
            check(d.dialogue_active && d.dialogue_page==0 && array_length(d.dialogue_pages)==6
                && !p.movimento_liberado,"ghost city transmission pauses arrival");
            d.dialogue_page=array_length(d.dialogue_pages)-1;
            keyboard_key_press(ord("E"));input_pulse=true;
            ghost_probe_done=true;tick=29;exit;
        }
        if(d.dialogue_active)
        {
            if(input_pulse){keyboard_key_release(ord("E"));input_pulse=false;}
            else {keyboard_key_press(ord("E"));input_pulse=true;}
            tick=29;exit;
        }
        keyboard_key_release(ord("E"));input_pulse=false;
        check(p.movimento_liberado,"ghost city transmission releases player before street transition");
        p.x=416;p.y=60;stage=22;tick=0;exit;
    case 22:
        check(room==rm_autumn_streets && instance_number(obj_portal)==0,"gate crosses into autumn streets");
        p=instance_find(obj_player,0);p.x=400;p.y=76;break;
    case 23:
        check(room==rm_autumn_plaza && instance_number(obj_portal)==0,"stairs lead to final autumn plaza");
        p=instance_find(obj_player,0);p.x=480;p.y=260;
        with(p)other.check(!place_meeting(x,y,obj_colisor),"future plaza boss area is clear");
        // Smoke-test the retained ending UI separately from the new route.
        room_goto(rm_demo_end);break;
    case 24:
        check(room==rm_demo_end && !instance_exists(obj_battle_controller) && !instance_exists(obj_ambient_controller),
            "existing ending UI still loads cleanly");
        keyboard_key_press(vk_enter); break;
    case 25: keyboard_key_release(vk_enter); check(room==rm_menu,"end returns to menu"); break;
    case 26:
        with(obj_main_menu) { button_x=-10000; menu_selected=0; activate_option=true; }
        break;
    case 27:
        keyboard_key_release(vk_enter); check(room==rm_tutorial,"new session starts");
        n=instance_find(obj_newton_npc,0); check(!n.tutorial_completed && instance_number(obj_portal)==0 && instance_number(obj_ambient_controller)==1,"new session has no old state");
        check(!historia_newton_progresso().steampunk_defeated,"new session clears industrial victory progression");
        finish_tests(); exit;
}
stage++; tick=0;
