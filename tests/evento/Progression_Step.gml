tick++;elapsed++;
if(elapsed>1500){check(false,"progression test timeout");finish_tests();exit;}
if(tick<12)exit;
switch(stage)
{
    case 0:
        n=instance_find(obj_cavern_isleide,0);n.dialogue_active=false;
        b=batalha_iniciar(n,false);
        check(variable_instance_exists(b,"activate_paradox"),"battle exposes the approved paradox ability");
        if(!variable_instance_exists(b,"activate_paradox")){finish_tests();exit;}
        check(variable_global_exists("math_progress"),"mathematical progress exists across rooms");
        if(!variable_global_exists("math_progress")){finish_tests();exit;}
        check(global.math_progress.level==1 && global.math_progress.xp_total==0
            && !global.math_progress.paradox_unlocked,"new session starts level one without skill");
        check(!b.activate_paradox(),"paradox unavailable before cavern victory");
        b.player_hp=0;b.finish_check();
        check(global.math_progress.xp_total==0,"defeat gives no XP");
        b.restart_battle();b.enemy_hp=0;b.finish_check();b.finish_check();
        check(global.math_progress.xp_total==100 && global.math_progress.level==2
            && global.math_progress.paradox_unlocked && b.reward_paradox && !b.paradox_used,
            "cavern victory grants 100 XP level two and paradox exactly once");
        stage=10;tick=0;break;
    case 10:
        screen_save("progression-cavern-unlock.png");
        b.leave_after_victory();room_goto(rm_castelo);stage=12;tick=0;break;
    case 12:
        n=instance_find(obj_castle_guard,0);n.dialogue_active=false;
        b=batalha_iniciar(n,false);
        check(b.comprehension_level==2 && !b.paradox_used && b.activate_paradox(),
            "guard inherits cavern comprehension and one fresh unlocked charge");
        check(!b.activate_paradox(),"guard has no second paradox charge");
        b.enemy_hp=0;b.finish_check();b.finish_check();
        check(global.math_progress.xp_total==200 && global.math_progress.level==3
            && global.math_progress.paradox_unlocked && !b.reward_paradox && b.paradox_used,
            "guard reward gives XP once without repeating unlock or refilling spent charge");
        stage=13;tick=0;break;
    case 13:
        screen_save("progression-victory.png");
        b.leave_after_victory();room_goto(rm_throne_room);stage=1;tick=0;break;
    case 1:
        check(global.math_progress.xp_total==200 && global.math_progress.level==3,
            "room transition keeps XP and level");
        n=instance_find(obj_isleide_king,0);n.dialogue_active=false;
        b=batalha_iniciar(n,false);
        check(b.comprehension_level==3 && !b.paradox_used && global.math_progress.paradox_unlocked,
            "royal battle inherits comprehension and unlocked skill");
        random_set_seed(9001);var _raw=batalha_gerar_desafio(b.math_phase,b.math_profile,0);
        random_set_seed(9001);b.request_action("attack");
        check(b.challenge.operacao==_raw.operacao && b.challenge.x<_raw.x && b.challenge.y<_raw.y
            && b.challenge.resposta==b.challenge.x+b.challenge.y,"level growth makes real royal challenge smaller");
        check(b.activate_paradox() && !b.activate_paradox(),"royal battle has exactly one inherited charge");
        b.enemy_hp=0;b.finish_check();b.finish_check();
        check(global.math_progress.xp_total==300 && global.math_progress.level==4
            && global.math_progress.paradox_unlocked && !b.reward_paradox && b.paradox_used,
            "royal victory gives XP once without repeating unlock or refilling spent charge");
        stage=2;tick=0;break;
    case 2:
        screen_save("progression-royal-victory.png");b.leave_after_victory();
        stage=3;tick=0;break;
    case 3:
        check(room==rm_throne_room && instance_number(obj_portal)==1 && global.math_progress.paradox_unlocked
            && global.math_progress.level==4,"royal exit opens a visible portal while retaining progression");
        var _portal=instance_find(obj_portal,0);
        _portal.activation_delay=0;
        with(obj_player){x=_portal.x;y=_portal.y-16;}
        stage=30;tick=0;break;
    case 30:
        check(room==asset_get_index("rm_steampunk_foundry") && global.math_progress.paradox_unlocked
            && global.math_progress.level==4,"royal portal enters foundry with progression and unlocked skill");
        room_goto(rm_autumn_plaza);stage=4;tick=0;break;
    case 4:
        n=instance_find(obj_isleide_city,0);n.dialogue_active=false;
        b=batalha_iniciar(n,false);
        b.request_action("attack");keyboard_string="999";b.answer_text="999";
        var _turn=b.battle_turn;var _index=b.math_question_count;var _hp=b.enemy_hp;
        // Exercise the real keyboard path, not just the activation method.
        keyboard_key_press(ord("Q"));stage=5;tick=0;break;
    case 5:
        keyboard_key_release(ord("Q"));
        check(b.paradox_used && b.battle_screen=="challenge" && b.pending_action=="attack"
            && b.challenge.operacao=="+" && b.challenge.x>=1 && b.challenge.x<=5
            && b.challenge.y==b.challenge.x && b.challenge.resposta==b.challenge.x+b.challenge.y,
            "Q converts current challenge into a simple correct sum without changing action");
        check(b.battle_turn==0 && b.math_question_count==1 && b.enemy_hp==220
            && b.answer_text=="" && keyboard_string=="","activation clears old answer without consuming turn or damaging enemy");
        check(!b.activate_paradox(),"ability is limited to one activation per battle");
        stage=6;tick=0;break;
    case 6:
        screen_save("progression-paradox-challenge.png");
        b.answer_text=string(b.challenge.resposta);b.verify_answer();
        check(b.enemy_hp<220 && b.battle_turn==1,"simple answer executes attack normally");
        b.request_action("defense");
        check(b.challenge.operacao=="x","following challenge returns to ordinary alternation");
        b.player_hp=0;b.finish_check();b.restart_battle();
        check(!b.paradox_used && !b.paradox_pending && global.math_progress.xp_total==300,
            "defeat retry restores charge without awarding XP");
        check(!b.handle_paradox_input(10,10,true,false) && !b.paradox_used,
            "click outside ability does not activate");
        check(b.handle_paradox_input(120,142,true,false) && b.paradox_pending,
            "button arms next challenge when no challenge is open");
        b.request_action("heal");
        check(b.paradox_pending && b.math_question_count==0,"invalid full-health cure does not consume armed skill");
        b.request_action("defense");
        check(!b.paradox_pending && b.challenge.operacao=="+" && b.challenge.resposta<=10,
            "next valid action receives armed easy challenge");
        var _before_wrong=b.player_hp;
        b.answer_text=string(b.challenge.resposta+1);b.verify_answer();
        check(b.paradox_used && b.player_hp<_before_wrong,"easy question still requires correct answer and charge stays spent");
        // Enable this test-only shortcut explicitly; release battles disable it.
        b.battle_config.test_skip_enabled=true;
        b.handle_test_skip(800,40,true);
        check(global.math_progress.xp_total==400 && global.math_progress.level==5
            && global.math_progress.paradox_unlocked,"test skip follows normal XP reward path");
        // This fixture intentionally starts another battle to verify a fresh
        // skill charge; normal revisits keep the defeated leader removed.
        historia_newton_progresso().city_defeated=false;
        room_goto(rm_autumn_plaza);stage=7;tick=0;break;
    case 7:
        n=instance_find(obj_isleide_city,0);n.dialogue_active=false;
        b=batalha_iniciar(n,false);
        check(!b.paradox_used && b.activate_paradox(),"new battle starts with one fresh paradox charge");
        b.enemy_hp=0;b.finish_check();
        check(!b.activate_paradox(),"victory screen refuses ability activation");
        b.leave_after_victory();room_goto(rm_menu);stage=8;tick=0;break;
    case 8:
        check(global.math_progress.level>1,"returning to menu alone keeps current progression");
        show_debug_message("PROGRESSION_MENU_INPUT: selected="+string(obj_main_menu.menu_selected)
            +" mouse="+string(device_mouse_x_to_gui(0))+","+string(device_mouse_y_to_gui(0)));
        // Starting a new game through the actual menu must reset all progress.
        keyboard_key_press(vk_enter);stage=9;tick=0;break;
    case 9:
        keyboard_key_release(vk_enter);
        check(room==rm_tutorial && global.math_progress.level==1 && global.math_progress.xp_total==0
            && !global.math_progress.paradox_unlocked,"new game resets XP level and cavern skill");
        n=instance_find(obj_newton_npc,0);n.start_post_dialogue();
        stage=11;tick=0;break;
    case 11:
        screen_save("progression-newton-explanation.png");
        finish_tests();exit;
}
