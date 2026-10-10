tick++;
if(stage==0 && tick>=20)
{
    with(obj_newton_cavern_dialogue)dialogue_active=false;
    var _inventor=instance_find(obj_isleide_steampunk,0);
    _inventor.dialogue_active=false;
    var _battle=batalha_iniciar(_inventor,false);
    _battle.enemy_hp=0;_battle.finish_check();_battle.leave_after_victory();
    stage=0.5;tick=0;exit;
}
if(stage==0.5 && tick>=5)
{
    check(room==rm_steampunk_foundry && instance_number(obj_portal)==1,
        "foundry victory exposes the city portal before travel");
    if(instance_number(obj_portal)!=1){finish_tests();exit;}
    var _port=instance_find(obj_portal,0);var _player=instance_find(obj_player,0);
    _port.activation_delay=0;_player.x=_port.x;_player.y=_port.y+8;
    keyboard_key_press(vk_up);stage=0.75;tick=0;exit;
}
if(stage==0.75)
{
    if(room==rm_steampunk_foundry)
    {
        if(tick>40){clear_keys();check(false,"foundry city portal traversal failed");finish_tests();}
        exit;
    }
    clear_keys();stage=1;tick=0;exit;
}
if(stage==1 && tick>=5)
{
    check(room==gate && !instance_exists(obj_isleide_steampunk) && !instance_exists(obj_battle_controller),
        "traversed foundry portal starts city phase cleanly");
    if(room!=gate){finish_tests();exit;}
    game_set_speed(240,gamespeed_fps);
    transmission=instance_find(obj_newton_cavern_dialogue,0);
    check(instance_exists(transmission),"ghost city Newton transmission starts after foundry victory");
    if(!instance_exists(transmission)){finish_tests();exit;}
    p=instance_find(obj_player,0);
    check(instance_number(obj_newton_cavern_dialogue)==1 && transmission.dialogue_active
        && transmission.dialogue_page==0 && array_length(transmission.dialogue_pages)==6
        && !p.movimento_liberado,"ghost city opens with one six-page transmission and locked movement");
    transmission_origin=[p.x,p.y];transmission_page=0;
    keyboard_key_press(vk_right);
    phase="ghost_transmission";stage=2;tick=0;exit;
}
if(phase=="ghost_transmission")
{
    if(tick==3)screen_save("newton-ghost-city-page-"+string(transmission_page)+".png");
    if(tick==5)
    {
        check(p.x==transmission_origin[0] && p.y==transmission_origin[1]
            && !p.movimento_liberado,"ghost city transmission holds player position");
        keyboard_key_release(vk_right);
    }
    var _advance=transmission_page mod 2==0?ord("E"):vk_space;
    if(tick==8)keyboard_key_press(_advance);
    if(tick==10)keyboard_key_release(_advance);
    if(tick>=12)
    {
        if(transmission_page<5)
        {
            transmission_page++;
            check(transmission.dialogue_active && transmission.dialogue_page==transmission_page
                && !p.movimento_liberado,"E and Space advance ghost city transmission one page each");
            tick=0;
        }
        else
        {
            check(!transmission.dialogue_active && p.movimento_liberado
                && !instance_exists(obj_battle_controller) && instance_number(obj_portal)==0,
                "ghost city transmission releases player without battle or portal");
            begin_autumn_walk(gate,streets,[[416,248],[550,248],[416,248],[416,50]]);
        }
    }
    exit;
}
if(phase=="settle" && tick>=5)
{
    if(room==streets)
        begin_autumn_walk(streets,plaza,[[416,388],[416,310],[416,260],[336,310],[336,130],[400,130],[400,70]]);
    else if(room==plaza)
        begin_autumn_walk(plaza,noone,[[480,516],[480,400],[480,260]]);
    else {check(false,"unknown autumn section");finish_tests();}
    exit;
}
if(phase!="walk")exit;
frames++;
if(frames>1600){clear_keys();check(false,"autumn trail blocked in "+room_get_name(room));finish_tests();exit;}
if(room!=expected_room)
{
    clear_keys();
    check(room==next_room,"walking crosses designated autumn transition");
    tick=0;phase="settle";exit;
}
var _point=points[min(point_index,array_length(points)-1)];
if(room==plaza && instance_exists(obj_isleide_city))
{
    var _city=instance_find(obj_isleide_city,0);
    if(_city.dialogue_active)
    {
        clear_keys();
        if(city_input_pulse)keyboard_key_release(ord("E"));
        else keyboard_key_press(ord("E"));
        city_input_pulse=!city_input_pulse;exit;
    }
    if(instance_exists(obj_battle_controller))
    {
        clear_keys();keyboard_key_release(ord("E"));
        var _b=instance_find(obj_battle_controller,0);
        check(_b.enemy_source==_city,"autumn route reaches the final plaza boss");
        for(var _i=0;_i<100 && _b.battle_screen=="actions";_i++)
        {
            var _action="attack";
            if(_b.enemy_intent=="strong")_action="defense";
            else if(_b.enemy_intent=="normal" && _b.player_hp<=60 && _b.heal_cooldown==0)_action="heal";
            _b.request_action(_action);_b.answer_text=string(_b.challenge.resposta);_b.verify_answer();
        }
        check(_b.battle_screen=="victory","autumn route ends with a winnable city battle");
        if(_b.battle_screen!="victory"){finish_tests();exit;}
        _b.leave_after_victory();exit;
    }
}
if(room==gate && point_index==1 && frames>110)
{
    check(p.x<516,"bridge parapet prevents entering water");
    point_index++;clear_keys();exit;
}
if(room==streets && point_index==2 && frames>110)
{
    check(p.y>=290,"statue garden blocks the straight road and requires walking around");
    point_index++;clear_keys();exit;
}
if(abs(p.x-_point[0])<=1.1 && abs(p.y-_point[1])<=1.1)
{
    if(point_index<array_length(points)-1){point_index++;_point=points[point_index];}
    else if(room==plaza)
    {
        clear_keys();
        check(!instance_exists(obj_battle_controller) && p.movimento_liberado,
            "final plaza is playable after city boss victory");
        with(p)other.check(!place_meeting(x,y,obj_colisor),"boss plaza center is clear");
        screen_save("autumn-plaza-center.png");finish_tests();exit;
    }
}
clear_keys();
if(abs(p.x-_point[0])>1.1)keyboard_key_press(p.x<_point[0]?vk_right:vk_left);
else if(abs(p.y-_point[1])>1.1)keyboard_key_press(p.y<_point[1]?vk_down:vk_up);
