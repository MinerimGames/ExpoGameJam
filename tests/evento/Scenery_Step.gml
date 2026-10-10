tick++;elapsed++;
if(elapsed>1600){check(false,"scenery regression timeout");finish_tests();exit;}
if(phase=="arch" && tick==12)
{
    check(instance_number(obj_world_foreground)>0,"city entrance arch has a foreground layer");
    if(failures>0){finish_tests();exit;}
    p=instance_find(obj_player,0);p.x=414;p.y=100;p.movimento_liberado=true;
    with(obj_newton_cavern_dialogue)dialogue_active=false;
    with(p)other.check(!place_meeting(x,y,obj_colisor),"arch opening allows full player mask");
}
if(phase=="arch" && tick==20)screen_save("scenery-arch-under.png");
if(phase=="arch" && tick>=12 && tick<43)keyboard_key_press(vk_up);
if(phase=="arch" && tick==43)
{
    clear_keys();check(room==rm_autumn_streets,"player walks underneath arch and reaches next street");
    phase="arch_pixels";tick=0;room_goto(rm_autumn_gate);exit;
}
if(phase=="arch_pixels")
{
    if(tick==12)
    {
        p=instance_find(obj_player,0);p.x=414;p.y=93;p.visible=false;p.movimento_liberado=false;
        with(obj_newton_cavern_dialogue)dialogue_active=false;
        with(obj_world_foreground)visible=false;
    }
    if(tick==20)screen_save("scenery-arch-background.png");
    if(tick==21)with(obj_world_foreground)visible=true;
    if(tick==29)screen_save("scenery-arch-overlay.png");
    if(tick==30){p.visible=true;with(obj_world_foreground)visible=false;}
    if(tick==38)screen_save("scenery-arch-actor-above.png");
    if(tick==39)with(obj_world_foreground)visible=true;
    if(tick==47)
    {
        screen_save("scenery-arch-actor-under.png");
        phase="port";tick=0;room_goto(rm_commercial_district);exit;
    }
}
if(phase=="port" && tick==12)
{
    p=instance_find(obj_player,0);
    with(obj_capitalist_ally){encounter_started=true;dialogue_active=false;}
    p.movimento_liberado=true;p.x=448+lane*32;p.y=530;start_y=p.y;
    with(p)other.check(!place_meeting(x,y,obj_colisor),"bridge lane starts clear");
}
if(phase=="port" && tick>=12 && tick<208)keyboard_key_press(vk_up);
if(phase=="port" && tick==125)screen_save("scenery-bridge-lane-"+string(lane)+".png");
if(phase=="port" && tick==209)
{
    clear_keys();check(p.y<145,"wide bridge and landing stay unobstructed in lane "+string(lane));
    check(abs(p.x-(448+lane*32))<1,"straight bridge never forces diagonal drift");
    with(p)other.check(!place_meeting(x,y,obj_colisor),"bridge traversal finishes clear");
    lane++;tick=11;
    if(lane>=3){phase="limits";tick=0;p.x=480;p.y=270;}
}
if(phase=="limits" && tick>=1 && tick<60)keyboard_key_press(vk_left);
if(phase=="limits" && tick==60)
{
    clear_keys();check(p.x>=434.4 && p.x<445,"bridge west rail blocks water without snags");
    p.x=480;p.y=270;
}
if(phase=="limits" && tick>=61 && tick<121)keyboard_key_press(vk_right);
if(phase=="limits" && tick==121)
{
    clear_keys();check(p.x>510 && p.x<=520,"bridge east rail blocks water");
    screen_save("scenery-port-rail.png");finish_tests();exit;
}
