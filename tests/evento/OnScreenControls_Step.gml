tick++;elapsed++;
if(elapsed>1800){clear_keys();clear_pointers();check(false,"keyboard-only exploration timeout");finish_tests();exit;}
if(stage==0)
{
    if(tick<12)exit;
    p=instance_find(obj_player,0);
    with(obj_newton_cavern_dialogue)dialogue_active=false;
    display_set_gui_size(640,380);stage=1;tick=0;exit;
}
if(stage==1)
{
    if(tick==1)
    {
        clear_keys();clear_pointers();
        p.x=155;p.y=178;p.velh=0;p.velv=0;p.movimento_liberado=true;
        with(p)inicia_estado(estado_idle);
        start_x=p.x;start_y=p.y;
        if(probe<4)point_former_arrow(probe);
        if(probe>=4 && probe<12)
        {
            keyboard_key_press(keys[probe-4]);
            point_former_arrow((probe-4+1) mod 4);
        }
        if(probe==12){keyboard_key_press(ord("W"));keyboard_key_press(vk_right);}
        if(probe==13){keyboard_key_press(ord("D"));p.movimento_liberado=false;}
        if(probe==14){wall=instance_create_depth(185,130,300,obj_colisor);wall.image_yscale=5;keyboard_key_press(vk_right);}
    }
    if(tick==14)
    {
        if(probe<4)check(p.x==start_x && p.y==start_y,"former GUI arrow target cannot move player "+string(probe));
        if(probe>=4 && probe<12)
        {
            check(sign(p.velh)==dx[probe-4] && sign(p.velv)==dy[probe-4],"keyboard direction ignores held pointer "+string(probe-4));
            check(point_distance(start_x,start_y,p.x,p.y)>12,"keyboard produces actual travel "+string(probe-4));
        }
        if(probe==12)check(p.velh>0 && p.velv<0 && abs(point_distance(0,0,p.velh,p.velv)-2)<0.001,"mixed keyboard diagonal retains normal speed");
        if(probe==13)check(p.x==start_x && p.y==start_y,"movement lock ignores held keyboard");
    }
    if(tick==35 && probe==14)
    {
        check(p.x<179 && p.x>170,"keyboard reaches but cannot pass collision");
        with(p)other.check(!place_meeting(x,y,obj_colisor),"keyboard foot mask never enters wall");
        with(wall)instance_destroy();
    }
    if(tick==36){clear_keys();clear_pointers();stop_x=p.x;stop_y=p.y;}
    if(tick==40)
    {
        check(p.x==stop_x && p.y==stop_y,"keyboard release stops without drift "+string(probe));
        check(p.world_frame==0,"keyboard release returns idle frame");
        probe++;tick=0;
        if(probe>14){screen_save("keyboard-only-exploration.png");stage=2;tick=0;}
    }
}
if(stage==2)
{
    if(tick==1)
    {
        clear_keys();
        p.dir=1;p.world_frame=4;
        with(p)update_player_art(true);
        check(p.sprite_index==spr_wilson_walk_back_a || p.sprite_index==spr_wilson_walk_back_b,"regression begins with rear-facing exploration avatar");
        b=batalha_iniciar(noone,false);
        check(p.dir==3 && p.world_frame==0 && p.sprite_index==spr_wilson_idle_front,"battle entry immediately turns world avatar to front idle");
        check(b.player_visual().sprite==spr_wilson_idle_front && b.player_visual().scale>0,"battle portrait preserves the provided idle artwork and positive size");
        keyboard_key_press(vk_up);point_former_arrow(3);
        start_x=p.x;start_y=p.y;
    }
    if(tick==12)
    {
        check(p.dir==3 && p.sprite_index==spr_wilson_idle_front && p.facing_sign==1,"front-facing world avatar survives locked battle steps");
        check(p.x==start_x && p.y==start_y,"keyboard and pointer cannot move during battle");
        screen_save("keyboard-only-front-battle.png");
        clear_keys();clear_pointers();finish_tests();exit;
    }
}
