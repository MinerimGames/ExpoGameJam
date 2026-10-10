tick++;elapsed++;
if(elapsed>1200){check(false,"city encounter timed out");finish_tests();exit;}
if(tick<10)exit;
switch(stage)
{
    case 0:
        check(instance_number(city_object)==1,"one city boss in final plaza");
        n=instance_find(city_object,0);p=instance_find(obj_player,0);
        check(!n.encounter_started && p.movimento_liberado,"plaza arrival permits walking to boss");
        p.x=480;p.y=280;stage=1;tick=0;break;
    case 1:
        check(n.dialogue_active && !p.movimento_liberado && !instance_exists(obj_battle_controller),
            "proximity starts dialogue before combat and locks player");
        check(array_length(n.dialogue_pages)==8,"eight approved pages before combat");
        stage=2;tick=0;break;
    case 2:
        if(!instance_exists(obj_battle_controller))
        {
            if(!input_pulse){screen_save("city-dialogue-"+string(n.dialogue_page)+".png");keyboard_key_release(ord("E"));}
            else keyboard_key_press(ord("E"));
            input_pulse=!input_pulse;tick=8;exit;
        }
        keyboard_key_release(ord("E"));
        b=instance_find(obj_battle_controller,0);
        check(b.enemy_source==n && b.enemy_hp==220 && !b.tutorial_mode,
            "city boss is tougher than king with 220 HP");
        check(b.math_profile=="city_alternating" && b.math_phase==8 && b.math_phase_max==10,
            "city fight starts above royal math tier");
        check(n.battle_poses.peace!=n.battle_poses.talk && n.battle_poses.talk!=n.battle_poses.defense
            && n.battle_poses.defense!=n.battle_poses.attack,"four distinct sprites available for city leader");
        check(b.enemy_visual().sprite==n.battle_poses.talk,"normal intent shows speaking pose");
        b.battle_turn=2;b.update_enemy_intent();
        check(b.enemy_visual().sprite==n.battle_poses.attack,"strong intent shows attack pose");
        b.battle_turn=3;b.update_enemy_intent();
        check(b.enemy_visual().sprite==n.battle_poses.peace,"recovery shows original peace pose");
        b.restart_battle();
        for(var _phase=8;_phase<=10;_phase++)
        for(var _i=0;_i<100;_i++)
        {
            var _c=batalha_gerar_desafio(_phase,"city_alternating",_i);
            if(_i mod 2==0)
                check(_c.operacao=="+" && _c.x>=20 && _c.y>=10 && _c.resposta<=80+10*(_phase-7)
                    && _c.resposta==_c.x+_c.y,"city sums alternate and grow up to 110");
            else check(_c.operacao=="x" && _c.x>=2 && _c.y>=2 && _c.x<=_phase && _c.y<=_phase
                && _c.resposta==_c.x*_c.y,"city multiplication alternates and grows through table ten");
        }
        stage=20;tick=0;break;
    case 20:
        screen_save("city-pose-talk.png");
        b.battle_turn=2;b.update_enemy_intent();stage=21;tick=0;break;
    case 21:
        screen_save("city-pose-attack.png");
        b.battle_turn=3;b.update_enemy_intent();stage=22;tick=0;break;
    case 22:
        screen_save("city-pose-peace.png");
        b.restart_battle();b.request_action("attack");
        check(b.enemy_visual().sprite==n.battle_poses.defense,"pending player attack shows defense pose");
        stage=3;tick=0;break;
    case 3:
        screen_save("city-challenge.png");
        b.player_hp=1;b.answer_text=string(b.challenge.resposta+1);b.verify_answer();
        check(b.battle_screen=="defeat" && instance_exists(n) && !p.movimento_liberado,
            "wrong answer can defeat player without removing boss");
        b.restart_battle();
        check(b.math_phase==8 && b.math_question_count==0 && b.enemy_hp==220 && b.player_hp==100,
            "retry resets difficulty HP and alternation");
        b.request_action("attack");b.answer_text=string(b.challenge.resposta);b.verify_answer();
        check(b.math_phase==9,"first correct answer increases city math tier");
        b.request_action("attack");b.answer_text=string(b.challenge.resposta);b.verify_answer();
        check(b.math_phase==10,"second correct answer reaches bounded city math tier");
        for(var _run=0;_run<20;_run++)
        {
            random_set_seed(4100+_run);b.restart_battle();
            for(var _i=0;_i<100 && b.battle_screen=="actions";_i++)
            {
                var _action="attack";
                if(b.enemy_intent=="strong")_action="defense";
                else if(b.enemy_intent=="normal" && b.player_hp<=60 && b.heal_cooldown==0)_action="heal";
                b.request_action(_action);b.answer_text=string(b.challenge.resposta);b.verify_answer();
            }
            check(b.battle_screen=="victory","city boss beatable with defense healing and correct answers");
        }
        check(instance_exists(n) && !p.movimento_liberado,"victory waits for confirmation");
        stage=4;tick=0;break;
    case 4:
        screen_save("city-victory.png");b.leave_after_victory();
        check(room==rm_autumn_plaza && !instance_exists(n) && !instance_exists(obj_battle_controller)
            && p.movimento_liberado && instance_number(obj_portal)==1,
            "city victory frees plaza with a visible portal before traveling");
        check(instance_find(obj_portal,0).portal_destination==rm_commercial_district,
            "city portal leads to the commercial reality");
        stage=4.5;tick=0;break;
    case 4.5:
        if(instance_find(obj_portal,0).activation_delay>0)exit;
        var _city_portal=instance_find(obj_portal,0);
        keyboard_key_press(p.y<_city_portal.y-16?vk_down:vk_up);stage=5;tick=0;break;
    case 5:
        if(room==rm_autumn_plaza)exit;
        keyboard_key_release(vk_up);keyboard_key_release(vk_down);
        check(room==rm_commercial_district,"walking into city portal reaches commercial district");
        room_goto(rm_autumn_plaza);stage=6;tick=0;break;
    case 6:
        check(!instance_exists(city_object) && instance_number(obj_portal)==1
            && instance_find(obj_player,0).movimento_liberado,
            "returning to the plaza keeps its defeated leader removed and portal available");
        finish_tests();exit;
}
