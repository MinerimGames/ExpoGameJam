tick++;elapsed++;
if(elapsed>1600){clear_keys();check(false,"steampunk phase timed out");finish_tests();exit;}
switch(stage)
{
    case 0:
        if(tick<12)exit;
        var _king=instance_find(obj_isleide_king,0);
        check(instance_exists(_king) && _king.battle_hp==180 && _king.battle_victory_room==steam_room,
            "king keeps 180 HP and confirmed victory leads to steampunk");
        if(!instance_exists(_king)){finish_tests();exit;}
        _king.dialogue_active=false;
        var _royal=batalha_iniciar(_king,false);
        _royal.enemy_hp=0;_royal.finish_check();_royal.leave_after_victory();
        check(room==rm_throne_room && instance_number(obj_portal)==1
            && instance_find(obj_player,0).movimento_liberado,
            "royal confirmation stays at the throne with a visible foundry portal");
        stage=0.25;tick=0;break;
    case 0.25:
        if(instance_find(obj_portal,0).activation_delay>0)exit;
        var _royal_portal=instance_find(obj_portal,0);
        var _royal_player=instance_find(obj_player,0);
        keyboard_key_press(_royal_player.y<_royal_portal.y-16?vk_down:vk_up);stage=0.5;tick=0;break;
    case 0.5:
        if(room==rm_throne_room)
        {
            if(tick>150){clear_keys();check(false,"royal portal remained unreachable");finish_tests();}
            exit;
        }
        clear_keys();stage=1;tick=0;break;
    case 1:
        if(tick<12)exit;
        check(room==steam_room,"royal victory enters the foundry instead of skipping to the city");
        if(room!=steam_room){finish_tests();exit;}
        p=instance_find(obj_player,0);s=instance_find(steam_scene,0);n=instance_find(steam_boss,0);
        intro=instance_find(obj_newton_cavern_dialogue,0);
        check(instance_exists(p) && instance_exists(s) && instance_exists(n) && instance_exists(intro),
            "foundry has one player, scene, boss and Newton transmission");
        if(!instance_exists(p) || !instance_exists(s) || !instance_exists(n) || !instance_exists(intro))
        {finish_tests();exit;}
        check(room_width==960 && room_height==640 && p.x==480
            && p.y>=500 && p.y+p.ground_offset<545,
            "royal portal arrives fully inside the foundry in front of the entrance arch");
        var _camera=view_camera[0];
        check(_camera!=-1 && camera_get_view_width(_camera)==480 && camera_get_view_height(_camera)==320,
            "foundry camera uses 480 by 320 exploration zoom");
        check(instance_number(obj_player)==1 && instance_number(steam_boss)==1 && instance_number(obj_portal)==0,
            "new phase has one boss and no portal shortcut");
        initial_activity=s.machine_activity[0];
        check(intro.dialogue_active && array_length(intro.dialogue_pages)==6 && !p.movimento_liberado
            && !instance_exists(obj_battle_controller),"Newton explains the industrial clock before exploration");
        check(string_pos("relóg",string_lower(string(intro.dialogue_pages)))>0,
            "Newton transmission refers to the industrial clock anchor");
        check(variable_instance_exists(s,"exit_gate") && instance_exists(s.exit_gate),
            "northern exit is physically gated before victory");
        if(!variable_instance_exists(s,"exit_gate")){finish_tests();exit;}
        with(p)other.check(!place_meeting(x,y,obj_colisor),"foundry entry is not embedded in a collider");
        for(var _y=120;_y<=520;_y+=40)
            with(p)other.check(!place_meeting(480,_y,obj_colisor),"central industrial route is walkable");
        with(p)
        {
            other.check(place_meeting(180,220,obj_colisor) && place_meeting(780,220,obj_colisor),
                "large machines block both sides of the central path");
            other.check(place_meeting(180,435,obj_colisor) && place_meeting(780,435,obj_colisor),
                "southern crates keep their collision geometry");
            other.check(place_meeting(480,90,obj_colisor),"clock gate stops a premature north exit");
        }
        intro_origin=[p.x,p.y];keyboard_key_press(vk_up);
        stage=2;tick=0;break;
    case 2:
        if(tick==12)
        {
            check(p.x==intro_origin[0] && p.y==intro_origin[1] && !p.movimento_liberado,
                "held movement cannot bypass Newton transmission");
            keyboard_key_release(vk_up);screen_save("steampunk-newton-intro.png");
        }
        if(tick<14)exit;
        var _key=intro_page mod 2==0?ord("E"):vk_space;
        if(tick==14)keyboard_key_press(_key);
        if(tick==16)keyboard_key_release(_key);
        if(tick<18)exit;
        intro_page++;
        if(intro_page<6){check(intro.dialogue_page==intro_page,"intro advances exactly one page");tick=12;exit;}
        check(!intro.dialogue_active && p.movimento_liberado && !instance_exists(obj_battle_controller),
            "finishing transmission releases walking without starting a battle");
        screen_save("steampunk-arrival-front.png");
        walk_start_y=p.y;keyboard_key_press(vk_down);stage=2.5;tick=0;break;
    case 2.5:
        if(tick<40)exit;
        clear_keys();
        check(p.y>=walk_start_y && p.y+p.ground_offset<=548 && room==steam_room,
            "walking back after arrival stops before the sealed entrance arch");
        with(p)
        {
            for(var _x=405;_x<=558;_x++)
                other.check(place_meeting(_x,548,obj_colisor),
                    "rear entrance seal meets both side walls without a bypass");
        }
        screen_save("steampunk-entry-blocked.png");
        walk_start_y=p.y;keyboard_key_press(vk_up);stage=3;tick=0;break;
    case 3:
        if(!n.dialogue_active)
        {
            check(room==steam_room && !instance_exists(obj_battle_controller),
                "walking through the foundry cannot skip its boss");
            if(tick>260){clear_keys();check(false,"central path did not reach steampunk boss");finish_tests();}
            exit;
        }
        clear_keys();
        check(p.y<walk_start_y-250 && !p.movimento_liberado && !instance_exists(obj_battle_controller),
            "actual northward walking reaches boss dialogue and locks before combat");
        check(n.x==480 && n.y==188 && n.world_height==34 && array_length(n.dialogue_pages)==8,
            "industrial boss has the approved position, world scale and eight dialogue pages");
        check(s.machine_activity[0]==initial_activity && s.effect_time==0 && n.breathing==0,
            "Steampunk scenery and character stay static during actual walking");
        screen_save("steampunk-foundry-boss.png");stage=4;tick=0;break;
    case 4:
        if(!instance_exists(obj_battle_controller))
        {
            if(tick<10)exit;
            if(pulse)keyboard_key_press(ord("E"));else keyboard_key_release(ord("E"));
            pulse=!pulse;tick=0;exit;
        }
        keyboard_key_release(ord("E"));b=instance_find(obj_battle_controller,0);
        check(b.enemy_source==n && b.enemy_hp==205 && !b.tutorial_mode && !p.movimento_liberado,
            "steampunk battle has 205 HP between king 180 and city 220");
        check(b.player_hp_max==130 && b.player_hp==130,
            "winning against the king preserves the permanent thirty HP into the foundry");
        check(b.math_profile=="steampunk_alternating" && b.math_phase==6 && b.math_phase_max==8,
            "industrial math uses its own six-to-eight alternating profile");
        check(n.battle_victory_room==rm_autumn_gate,"industrial victory portal leads to the autumn reality");
        check(n.battle_poses.peace==steam_idle && n.battle_poses.talk==steam_talk
            && n.battle_poses.defense==steam_defense && n.battle_poses.attack==steam_attack,
            "combat preserves original peace art and uses all three new poses");
        check(abs(b.enemy_battle_scale*(sprite_get_bbox_bottom(steam_idle)-sprite_get_bbox_top(steam_idle)+1)-232)<1,
            "industrial combat art uses 232 pixel figure height");
        check(b.enemy_visual().sprite==steam_talk,"normal intent shows steampunk talk pose");
        for(var _tier=6;_tier<=8;_tier++)
        for(var _i=0;_i<60;_i++)
        {
            var _q=batalha_gerar_desafio(_tier,"steampunk_alternating",_i);
            if(_i mod 2==0)
                check(_q.operacao=="+" && _q.x>=18 && _q.x<=52+5*(_tier-6)
                    && _q.y>=12 && _q.y<=32+5*(_tier-6) && _q.resposta<=84+10*(_tier-6)
                    && _q.resposta==_q.x+_q.y,"steampunk sums alternate and grow between royal and city ranges");
            else check(_q.operacao=="x" && _q.x>=2 && _q.y>=2 && _q.x<=min(8,7+_tier-6)
                && _q.y<=min(8,7+_tier-6) && _q.resposta==_q.x*_q.y,
                "steampunk multiplication alternates within tables two to eight");
        }
        xp_before=matematica_progresso().xp_total;
        stage=5;tick=0;break;
    case 5:
        if(tick<12)exit;
        screen_save("steampunk-pose-talk.png");b.battle_turn=2;b.update_enemy_intent();
        check(b.enemy_visual().sprite==steam_attack,"strong intent shows steampunk attack pose");
        stage=6;tick=0;break;
    case 6:
        if(tick<12)exit;
        screen_save("steampunk-pose-attack.png");b.battle_turn=3;b.update_enemy_intent();
        check(b.enemy_visual().sprite==steam_idle,"recovery shows original steampunk idle art");
        stage=7;tick=0;break;
    case 7:
        if(tick<12)exit;
        screen_save("steampunk-pose-peace.png");b.restart_battle();b.request_action("attack");
        check(b.enemy_visual().sprite==steam_defense,"pending attack shows steampunk defense pose");
        stage=8;tick=0;break;
    case 8:
        if(tick<12)exit;
        screen_save("steampunk-pose-defense.png");
        b.player_hp=1;b.answer_text=string(b.challenge.resposta+1);b.verify_answer();
        check(b.battle_screen=="defeat" && instance_exists(n) && instance_exists(s.exit_gate)
            && !p.movimento_liberado,"defeat preserves boss, gate and locked retry encounter");
        b.restart_battle();
        check(b.math_phase==6 && b.math_question_count==0 && b.enemy_hp==205 && b.player_hp==130,
            "steampunk retry restores HP, first tier and question alternation");
        for(var _i=0;_i<2;_i++)
        {b.request_action("attack");b.answer_text=string(b.challenge.resposta);b.verify_answer();}
        check(b.math_phase==8,"correct answers advance industrial math to tier eight");
        for(var _run=0;_run<8;_run++)
        {
            random_set_seed(6500+_run);b.restart_battle();
            for(var _i=0;_i<100 && b.battle_screen=="actions";_i++)
            {
                var _action="attack";
                if(b.enemy_intent=="strong")_action="defense";
                else if(b.enemy_intent=="normal" && b.player_hp<=60 && b.heal_cooldown==0)_action="heal";
                b.request_action(_action);b.answer_text=string(b.challenge.resposta);b.verify_answer();
            }
            check(b.battle_screen=="victory","industrial boss is beatable using correct strategic actions");
        }
        check(matematica_progresso().xp_total==xp_before+100,"retries and repeated victory reward only 100 XP");
        b.reward_victory();b.reward_victory();
        check(matematica_progresso().xp_total==xp_before+100,"repeated reward call cannot duplicate industrial XP");
        stage=9;tick=0;break;
    case 9:
        if(tick<12)exit;
        screen_save("steampunk-victory.png");
        check(instance_exists(s.exit_gate) && !p.movimento_liberado,
            "victory screen keeps the northern gate until battle confirmation");
        b.restart_battle();b.battle_config.test_skip_enabled=true;
        check(b.handle_test_skip(700,30,true),"test skip follows the industrial victory confirmation flow");
        check(matematica_progresso().xp_total==xp_before+100,"skip after rewarded retry cannot duplicate XP");
        stage=10;tick=0;break;
    case 10:
        if(tick<12)exit;
        if(instance_number(obj_portal)==1 && instance_find(obj_portal,0).activation_delay>0)exit;
        check(room==steam_room && !instance_exists(steam_boss) && !instance_exists(obj_battle_controller)
            && p.movimento_liberado && !instance_exists(s.exit_gate) && instance_number(obj_portal)==1,
            "confirmed victory removes boss and physical gate while exposing the traversal portal");
        var _story=historia_newton_progresso();
        check(variable_struct_exists(_story,"steampunk_defeated") && _story.steampunk_defeated,
            "industrial victory records progression before leaving");
        screen_save("steampunk-open-exit.png");
        var _steam_portal=instance_find(obj_portal,0);
        keyboard_key_press(p.y<_steam_portal.y-16?vk_down:vk_up);stage=11;tick=0;break;
    case 11:
        if(room==steam_room)
        {if(tick>160){clear_keys();check(false,"open northern exit remained blocked");finish_tests();}exit;}
        clear_keys();check(room==rm_autumn_gate,"walking into industrial portal reaches the autumn city entrance");
        check(matematica_progresso().xp_total==xp_before+100,"walking to the city does not duplicate rewards");
        room_goto(steam_room);stage=12;tick=0;break;
    case 12:
        if(tick<12)exit;
        s=instance_find(steam_scene,0);
        check(!instance_exists(steam_boss) && !instance_exists(s.exit_gate) && !instance_exists(obj_battle_controller)
            && instance_number(obj_portal)==1,
            "returning to a defeated foundry preserves its portal without repeating its fight");
        historia_newton_progresso(true);
        check(!historia_newton_progresso().steampunk_defeated,"new game reset clears industrial progression");
        finish_tests();exit;
}
