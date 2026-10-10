tick++;elapsed++;
if(elapsed>1500){check(false,"battle facing regression timeout");finish_tests();exit;}
switch(stage)
{
    case 0:
        if(tick<12)exit;
        p=instance_find(obj_player,0);
        n=instance_find(obj_castle_guard,0);n.dialogue_active=false;
        p.x=416;p.y=580;
        b=batalha_iniciar(n,false);
        check_battle_pose(spr_wilson_idle_front,-1,"initial idle");
        check(p.dir==3 && p.sprite_index==spr_wilson_idle_front && p.facing_sign==1,
            "battle portrait direction does not reflect the exploration avatar");
        stage=1;tick=0;break;
    case 1:
        if(tick<12)exit;
        screen_save("battle-facing-idle-right.png");
        stage=2;tick=0;break;
    case 2:
        if(tick==1)
        {
            b.restart_battle();b.player_hp=50;
            check_battle_pose(spr_wilson_idle_front,-1,"restart idle");
            b.request_action(actions[action_index]);
            check(b.battle_screen=="challenge","real action opens the challenge");
            check_battle_pose(expected_sprites[action_index],1,actions[action_index]+" challenge");
        }
        if(tick==12)
        {
            b.answer_text=string(b.challenge.resposta);b.verify_answer();
            check(b.player_pose_timer>0,"correct answer retains the real action pose");
            check_battle_pose(expected_sprites[action_index],1,actions[action_index]+" result");
            b.result_visible=false;
        }
        if(tick==16)screen_save("battle-facing-"+actions[action_index]+"-right.png");
        if(tick>16 && b.player_pose_timer==0)
        {
            check_battle_pose(spr_wilson_idle_front,-1,actions[action_index]+" expired pose");
            action_index++;tick=0;
            if(action_index>=array_length(actions)){stage=3;tick=0;}
        }
        break;
    case 3:
        if(tick==1)
        {
            b.restart_battle();b.request_action("attack");
            b.answer_text=string(b.challenge.resposta+1);b.verify_answer();
            check_battle_pose(spr_wilson_idle_front,-1,"wrong answer returns idle");
            b.result_visible=false;
        }
        if(tick==12)
        {
            screen_save("battle-facing-wrong-answer-idle-right.png");
            b.story_battle=true;b.story_stage=2;
            check_battle_pose(spr_wilson_idle_front,-1,"story battle idle");
            stage=4;tick=0;
        }
        break;
    case 4:
        if(tick<12)exit;
        screen_save("battle-facing-story-idle-right.png");
        check(p.dir==3 && p.sprite_index==spr_wilson_idle_front && p.facing_sign==1,
            "all battle poses leave the world avatar front-facing");
        finish_tests();exit;
}
