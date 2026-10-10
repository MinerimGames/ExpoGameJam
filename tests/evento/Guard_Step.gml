tick++; elapsed++;
if (elapsed>1200) {check(false,"guard encounter did not finish");finish_tests();exit;}
if (tick<10) exit;
switch(stage)
{
    case 0:
        check(guard_object!=-1 && instance_number(guard_object)==1,"castle entrance has one guard");
        if (guard_object==-1 || !instance_exists(guard_object)) {finish_tests();exit;}
        p=instance_find(obj_player,0); n=instance_find(guard_object,0);
        p.x=416; p.y=528; // Attempt the doorway before talking or winning.
        stage=1;tick=0;break;
    case 1:
        check(room==rm_castelo,"guard prevents bypass through castle doorway");
        if(room!=rm_castelo){finish_tests();exit;}
        check(n.dialogue_active && !p.movimento_liberado,"approaching guard starts dialogue and locks player");
        screen_save("guard-dialogue.png");
        p.x=416;p.y=580;
        stage=2;tick=0;break;
    case 2:
        if (!instance_exists(obj_battle_controller))
        {
            if (!input_pulse)
            {
                screen_save("guard-dialogue-"+string(n.dialogue_page)+".png");
                if(n.dialogue_page==0) screen_save("guard-dialogue.png");
                keyboard_key_release(ord("E"));input_pulse=true;
            }
            else {keyboard_key_press(ord("E"));input_pulse=false;}
            tick=8;exit;
        }
        keyboard_key_release(ord("E"));input_pulse=false;
        check(instance_number(obj_battle_controller)==1 && !n.dialogue_active && !p.movimento_liberado,
            "full guard dialogue starts exactly one locked battle");
        b=instance_find(obj_battle_controller,0);
        check(b.enemy_hp==150 && !b.tutorial_mode && b.enemy_source==n,"guard enters full-strength ordinary battle");
        stage=3;tick=0;break;
    case 3:
        screen_save("guard-battle.png");
        b.request_action("attack");
        stage=4;tick=0;break;
    case 4:
        screen_save("guard-challenge.png");
        check(b.challenge.x>=10 && b.challenge.y>=10,"initial guard question has two-digit operands");
        b.player_hp=1; b.answer_text=string(b.challenge.resposta+1); b.verify_answer();
        check(b.battle_screen=="defeat" && instance_exists(n) && !p.movimento_liberado,
            "defeat keeps guard and castle gate locked");
        b.restart_battle();
        check(b.enemy_hp==150 && b.player_hp==100 && b.battle_screen=="actions",
            "retry restores both fighters");
        for(var _run=0;_run<5;_run++)
        {
            if(_run>0) b.restart_battle();
            for(var _i=0;_i<60 && b.battle_screen=="actions";_i++)
            {
                var _action="attack";
                if(b.enemy_intent=="strong") _action="defense";
                else if(b.enemy_intent=="normal" && b.player_hp<=60 && b.heal_cooldown==0) _action="heal";
                solve_guard(b,_action);
            }
            check(b.battle_screen=="victory","guard can be beaten with attack defense and healing");
        }
        check(instance_exists(n) && !p.movimento_liberado,"victory waits for confirmation before unlocking gate");
        stage=5;tick=0;break;
    case 5:
        screen_save("guard-victory.png");
        b.leave_after_victory();
        check(room==rm_castelo && !instance_exists(n) && !instance_exists(obj_battle_controller)
            && p.movimento_liberado && instance_number(obj_portal)==0,
            "confirmed victory removes guard and restores walking without a portal");
        p.x=416;p.y=528; stage=6;tick=0;break;
    case 6:
        check(room==rm_castle_hall,"castle doorway enters illuminated hall after guard victory");
        room_goto(rm_castelo);stage=7;tick=0;break;
    case 7:
        check(instance_number(guard_object)==1 && !instance_find(guard_object,0).encounter_started,
            "new castle visit starts with a fresh guard encounter");
        finish_tests();exit;
}
