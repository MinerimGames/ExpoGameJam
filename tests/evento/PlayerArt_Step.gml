tick++;elapsed++;
if(elapsed>1800){check(false,"player art test timeout");finish_tests();exit;}
switch(stage)
{
    case 0:
        if(tick<12)exit;
        var _newton=instance_find(obj_newton_cavern_dialogue,0);
        if(instance_exists(_newton))_newton.dialogue_active=false;
        p=instance_find(obj_player,0);p.movimento_liberado=true;p.x=155;p.y=178;
        check(p.mask_index==spr_player_idle_front && p.bbox_right-p.bbox_left==14
            && p.bbox_bottom-p.bbox_top==9,"new visual keeps old independent foot collision mask");
        check(p.sprite_index==idle_front,"initial down view is the provided front sprite");
        stage=1;tick=0;break;
    case 1:
        if(tick==1)
        {
            keyboard_key_press(directions[direction_index]);
            walk_seen_a=false;walk_seen_b=false;
            rendered_frames=array_create(6,false);
        }
        if(tick>=3 && tick<=22)
        {
            var _prefix=direction_index==0?"front":(direction_index==1?"back":"side");
            if(p.sprite_index==asset_get_index("spr_wilson_walk_"+_prefix+"_a"))walk_seen_a=true;
            if(p.sprite_index==asset_get_index("spr_wilson_walk_"+_prefix+"_b"))walk_seen_b=true;
            if(!rendered_frames[p.world_frame])screen_save("wilson-frame-"+direction_names[direction_index]+"-"+string(p.world_frame)+".png");
            rendered_frames[p.world_frame]=true;
        }
        if(tick==8)first_walk_sprite=p.sprite_index;
        if(tick==22)
        {
            var _prefix=direction_index==0?"front":(direction_index==1?"back":"side");
            check(p.sprite_index==asset_get_index("spr_wilson_walk_"+_prefix+"_a")
                || p.sprite_index==asset_get_index("spr_wilson_walk_"+_prefix+"_b"),
                "actual movement selects new "+direction_names[direction_index]+" walking art");
            check(p.facing_sign==(direction_index==2?-1:1),"only left side reflects the sprite");
            check(walk_seen_a && walk_seen_b,"real walking cycles through both different stride sprites");
            var _distinct=0;for(var _i=0;_i<6;_i++)if(rendered_frames[_i])_distinct++;
            check(_distinct>=4,"actual renderer advances through distinct walking frames");
            var _row=direction_index==0?0:(direction_index==1?1:2);
            var _frames=wilson_quadros();
            for(var _i=1;_i<6;_i++)check(_frames[_row*6+_i].x!=_frames[_row*6].x,
                "rendered direction uses distinct source cells");
            screen_save("wilson-walk-"+direction_names[direction_index]+".png");
            keyboard_key_release(directions[direction_index]);
        }
        if(tick>=30)
        {
            var _idle=direction_index==0?idle_front:(direction_index==1?idle_back:idle_side);
            check(p.sprite_index==_idle,"stopping selects new idle art in current direction");
            screen_save("wilson-idle-"+direction_names[direction_index]+".png");
            direction_index++;tick=0;
            if(direction_index>=4){stage=2;tick=0;}
        }
        break;
    case 2:
        if(tick<12)exit;
        p.movimento_liberado=false;
        b=batalha_iniciar(noone,false);
        actions=["attack","defense","heal","dodge"];action_index=0;
        stage=3;tick=0;break;
    case 3:
        if(tick==1)
        {
            b.restart_battle();b.player_hp=50;b.request_action(actions[action_index]);
            check(b.player_visual().sprite==asset_get_index("spr_wilson_"+actions[action_index]),
                "real battle action selects corresponding Wilson pose");
        }
        if(tick==12)screen_save("wilson-action-"+actions[action_index]+".png");
        if(tick==18)
        {
            b.answer_text=string(b.challenge.resposta);b.verify_answer();
            check(b.player_visual().sprite==asset_get_index("spr_wilson_"+actions[action_index]),
                "pose stays visible while action result is shown");
        }
        if(tick==20)
        {
            screen_save("wilson-result-"+actions[action_index]+".png");
            action_index++;tick=0;
            if(action_index>=4){with(b)instance_destroy();room_goto(rm_menu);stage=4;tick=0;}
        }
        break;
    case 4:
        if(tick<12)exit;
        screen_save("wilson-menu-without-demo.png");
        room_goto(rm_cavernas_2);stage=5;tick=0;break;
    case 5:
        if(tick<12)exit;
        n=instance_find(obj_cavern_isleide,0);n.dialogue_active=false;
        b=batalha_iniciar(n,false);b.enemy_hp=0;b.finish_check();
        stage=6;tick=0;break;
    case 6:
        if(tick<12)exit;
        screen_save("wilson-cavern-continue.png");b.leave_after_victory();
        check(instance_number(obj_portal)==1 && instance_find(obj_player,0).movimento_liberado,
            "continue victory still creates cave portal and frees new Wilson");
        finish_tests();exit;
}
