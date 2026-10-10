tick++;elapsed++;
if(elapsed>1500){clear_keys();check(false,"royal encounter timeout");finish_tests();exit;}
switch(stage)
{
    case 0:
        if(tick<20)exit;
        check(room==hall && instance_number(obj_player)==1 && instance_number(obj_portal)==0,
            "castle entrance leads to playable hall without portal");
        p=instance_find(obj_player,0);
        with(p)other.check(!place_meeting(x,y,obj_colisor),"hall spawn has no collision overlap");
        screen_save("royal-hall-entry.png");
        keyboard_key_press(vk_up);stage=1;tick=0;break;
    case 1:
        if(room==hall)exit;
        clear_keys();check(room==throne,"walking along hall carpet enters throne room");
        p=instance_find(obj_player,0);n=instance_find(king_object,0);
        check(!p.movimento_liberado,"throne arrival locks movement for king encounter");
        stage=2;tick=0;break;
    case 2:
        if(tick==2)screen_save("royal-king-seated.png");
        if(tick==80)
        {
            rising_seen=n.pose_mix>0 && n.pose_mix<1;
            screen_save("royal-king-rising.png");
        }
        if(!n.dialogue_active)exit;
        check(rising_seen,"king has a visible seated-to-standing transition before dialogue");
        check(!instance_exists(obj_battle_controller),"king stands and speaks before fight");
        screen_save("royal-king-standing.png");
        stage=3;tick=0;break;
    case 3:
        if(instance_exists(obj_battle_controller))
        {
            keyboard_key_release(ord("E"));b=instance_find(obj_battle_controller,0);
            check(instance_number(obj_battle_controller)==1 && !p.movimento_liberado
                && b.enemy_hp==180 && b.enemy_source==n,"king dialogue starts one stronger battle");
            stage=4;tick=0;exit;
        }
        if(tick<4)exit;
        if(pulse)keyboard_key_press(ord("E"));else
        {
            screen_save("royal-dialogue-"+string(n.dialogue_page)+".png");
            keyboard_key_release(ord("E"));
        }
        pulse=!pulse;tick=0;break;
    case 4:
        if(tick<10)exit;
        screen_save("royal-battle.png");
        royal_solve(b,"attack",false);
        royal_solve(b,"defense");
        check(instance_exists(n) && !p.movimento_liberado,"wrong answer keeps royal encounter locked");
        b.player_hp=1;b.battle_turn=0;b.update_enemy_intent();royal_solve(b,"attack",false);
        check(b.battle_screen=="defeat" && instance_exists(n),"king defeat preserves retry encounter");
        b.restart_battle();questions=0;
        check(b.enemy_hp==180 && b.player_hp==100 && b.battle_screen=="actions","royal retry restores fighters");
        for(var _run=0;_run<8;_run++)
        {
            if(_run>0){b.restart_battle();questions=0;}
            for(var _i=0;_i<80 && b.battle_screen=="actions";_i++)
            {
                var _action="attack";
                if(b.enemy_intent=="strong")_action="defense";
                else if(b.enemy_intent=="normal" && b.player_hp<=60 && b.heal_cooldown==0)_action="heal";
                royal_solve(b,_action);
            }
            check(b.battle_screen=="victory","king can be beaten with strategic actions");
        }
        stage=5;tick=0;break;
    case 5:
        if(tick<10)exit;
        screen_save("royal-victory.png");b.leave_after_victory();stage=6;tick=0;break;
    case 6:
        if(tick<10)exit;
        if(instance_number(obj_portal)==1 && instance_find(obj_portal,0).activation_delay>0)exit;
        check(room==throne && !instance_exists(obj_battle_controller) && !instance_exists(king_object)
            && instance_number(obj_portal)==1 && p.movimento_liberado,
            "king confirmation exposes a portal and frees movement in the throne room");
        check(instance_find(obj_portal,0).portal_destination==rm_steampunk_foundry,
            "royal portal leads to the foundry");
        var _royal_portal=instance_find(obj_portal,0);
        keyboard_key_press(p.y<_royal_portal.y-16?vk_down:vk_up);stage=6.1;tick=0;break;
    case 6.1:
        if(room==throne)
        {
            if(tick>150){clear_keys();check(false,"walking did not cross the royal portal");finish_tests();}
            exit;
        }
        clear_keys();
        check(room==rm_steampunk_foundry && !instance_exists(obj_battle_controller) && !instance_exists(king_object),
            "walking into royal portal reaches the foundry entrance cleanly");
        var _transmission=instance_find(obj_newton_cavern_dialogue,0);
        check(instance_exists(_transmission),"royal victory creates Newton transmission in the foundry");
        if(instance_exists(_transmission))
            check(_transmission.dialogue_active && !instance_find(obj_player,0).movimento_liberado,
                "foundry introduction locks exploration until confirmation");
        room_goto(throne);stage=7;tick=0;break;
    case 7:
        if(tick<10)exit;
        check(instance_number(king_object)==0 && !instance_exists(obj_battle_controller)
            && instance_number(obj_portal)==1 && instance_find(obj_player,0).movimento_liberado,
            "new throne visit keeps the defeated king removed and its portal available");
        finish_tests();exit;
}
