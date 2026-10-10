tick++;elapsed++;
if(elapsed==1)show_debug_message("MAP_SAFETY_BEGIN");
// Keep every collision probe actively pushing. Displacement assertions below
// prevent a stalled input source from making a wall check pass at rest.
if(phase=="port_house")keyboard_key_press(vk_up);
if(phase=="bridge_north")keyboard_key_press(vk_left);
if(phase=="bridge_south")keyboard_key_press(vk_right);
if(phase=="village_edge" && tick>=12 && tick<40)keyboard_key_press(vk_right);
if(phase=="castle_edge" && tick>=12 && tick<40)keyboard_key_press(vk_down);
if(phase=="motion" && ((tick>=12 && tick<30) || (tick>=34 && tick<50)))keyboard_key_press(vk_up);
if((phase=="port_house" || phase=="motion") && tick==20)show_debug_message("KEY_DIAG: "+phase+" up "+string(keyboard_check(vk_up))+" left "+string(keyboard_check(vk_left))+" pos "+string(p.x)+","+string(p.y));
if(elapsed>3000){clear_keys();check(false,"world safety test timeout");finish_tests();exit;}
if(phase=="rooms")
{
    if(tick<12)exit;
    p=instance_find(obj_player,0);
    check(instance_exists(p),"one player available in "+room_get_name(room));
    if(!instance_exists(p)){finish_tests();exit;}
    var _clear=false;with(p)_clear=!place_meeting(x,y,obj_colisor);
    check(_clear,"entry foot mask clear in "+room_get_name(room));
    var _cam=view_camera[0];
    check(camera_get_view_x(_cam)>=0 && camera_get_view_y(_cam)>=0
        && camera_get_view_x(_cam)+camera_get_view_width(_cam)<=room_width
        && camera_get_view_y(_cam)+camera_get_view_height(_cam)<=room_height,
        "camera contains no area beyond "+room_get_name(room));
    var _low=room==rm_vila?200:0;
    var _high=room==rm_vila?500:(room==rm_bosque?300:
        ((room==rm_tutorial || room==rm_temporal_origin)?400:199));
    check(p.depth>_low && p.depth<_high,"player respects foreground and ground layer band in "+room_get_name(room));
    screen_save("safety-"+room_get_name(room)+".png");
    map_index++;tick=0;
    if(map_index<array_length(room_ids)){room_goto(room_ids[map_index]);exit;}
    p=instance_find(obj_player,0);
    var _blocked=false;with(p)_blocked=place_meeting(90,100,obj_colisor);
    check(_blocked,"port western building roof is blocked");
    with(p)_blocked=place_meeting(410,270,obj_colisor);
    check(_blocked,"upper bridge west railing has no canal opening");
    check(asset_get_index("spr_wilson_walk_atlas")!=-1,"relaxed walking atlas available");
    show_debug_message("PORT_UV: "+string(sprite_get_uvs(spr_commercial_district,0)));
    check(variable_instance_exists(p,"walk_distance"),"animation tracks actual movement distance");
    // Start outside the known west-house opening and push toward its façade.
    with(obj_capitalist_ally){encounter_started=true;dialogue_active=false;}
    p.movimento_liberado=true;p.x=170;p.y=135;keyboard_key_press(vk_up);
    phase="port_house";tick=0;exit;
}
if(phase=="port_house" && tick>=35)
{
    clear_keys();
    show_debug_message("HOUSE_STOP: "+string(p.x)+","+string(p.y));
    check(p.y>=124.4 && p.y<132,"holding up reaches but cannot climb west port building");
    p.x=480;p.y=270;keyboard_key_press(vk_left);
    phase="bridge_north";tick=0;exit;
}
if(phase=="bridge_north" && tick>=40)
{
    clear_keys();
    show_debug_message("BRIDGE_NORTH_STOP: "+string(p.x)+","+string(p.y));
    check(p.x>=434.4 && p.x<442,"walking reaches straight bridge west railing without entering canal");
    screen_save("safety-bridge-north-rail.png");
    p.x=480;p.y=270;keyboard_key_press(vk_right);
    phase="bridge_south";tick=0;exit;
}
if(phase=="bridge_south" && tick>=40)
{
    clear_keys();
    check(p.x>510 && p.x<=520,"walking reaches bridge east railing without entering canal");
    screen_save("safety-bridge-south-rail.png");
    room_goto(rm_vila);phase="village_edge";tick=0;exit;
}
if(phase=="village_edge")
{
    if(tick==12){p=instance_find(obj_player,0);p.x=632;p.y=448;p.movimento_liberado=true;keyboard_key_press(vk_right);}
    if(tick>=40)
    {
        clear_keys();check(p.bbox_right<room_width,"unintended village edge cannot leave map");
        room_goto(rm_castelo);phase="castle_edge";tick=0;exit;
    }
}
if(phase=="castle_edge")
{
    if(tick==12){p=instance_find(obj_player,0);p.x=416;p.y=712;p.movimento_liberado=true;keyboard_key_press(vk_down);}
    if(tick>=40)
    {
        clear_keys();check(p.bbox_bottom<room_height,"castle bridge entry cannot leave map to south");
        room_goto(rm_commercial_district);phase="motion";tick=0;exit;
    }
}
if(phase=="motion")
{
    if(tick==12)
    {
        p=instance_find(obj_player,0);with(obj_capitalist_ally){encounter_started=true;dialogue_active=false;}
        p.x=480;p.y=600;p.movimento_liberado=true;keyboard_key_press(vk_up);
        if(variable_instance_exists(p,"walk_distance"))distance_before=p.walk_distance;
    }
    if(tick==30)
    {
        clear_keys();
        if(variable_instance_exists(p,"walk_distance"))check(p.walk_distance>distance_before,"walking animation advances on traveled distance");
        else check(false,"movement-distance animation missing");
    }
    if(tick==34)
    {
        p.movimento_liberado=false;stopped_x=p.x;stopped_y=p.y;
        if(variable_instance_exists(p,"walk_cycle"))stopped_cycle=p.walk_cycle;
        keyboard_key_press(vk_up);
    }
    if(tick>=50)
    {
        clear_keys();check(p.x==stopped_x && p.y==stopped_y,"locked player never drifts");
        if(variable_instance_exists(p,"walk_cycle"))check(p.walk_cycle==stopped_cycle,"locked player does not animate steps");
        phase="fixtures";tick=0;room_goto(fixtures[0][0]);exit;
    }
}
if(phase=="fixtures")
{
    var _f=fixtures[fixture_index];
    if(tick==12)
    {
        clear_keys();p=instance_find(obj_player,0);
        with(obj_newton_npc){dialogue_active=false;}
        with(obj_newton_cavern_dialogue){dialogue_active=false;}
        with(obj_temporal_scene){scene_mode="complete";dialogue_active=false;}
        with(obj_fatec_ending)instance_destroy();
        p.x=_f[1];p.y=_f[2];p.movimento_liberado=true;
        fixture_distance=p.walk_distance;
        with(p)other.check(!place_meeting(x,y,obj_colisor),"fixture starts clear: "+_f[8]);
    }
    if(tick>=12 && tick<12+_f[7])keyboard_key_press(_f[3]);
    if(tick==12+_f[7])clear_keys();
    if(tick>=16+_f[7])
    {
        var _value=_f[4]=="x"?p.x:p.y;
        show_debug_message("WALL_STOP: "+_f[8]+" "+string(p.x)+","+string(p.y));
        // move_and_collide resolves at a fractional pixel outside the wall;
        // retain the independently authored limits with subpixel tolerance.
        check(_value>=_f[5]-0.6 && _value<=_f[6]+0.6,"actual movement respects "+_f[8]);
        if(_f[8]!="village river bank")check(p.walk_distance>fixture_distance,"fixture actually moved: "+_f[8]);
        with(p)other.check(!place_meeting(x,y,obj_colisor),"foot mask remains clear: "+_f[8]);
        screen_save("safety-wall-"+string(fixture_index)+".png");
        fixture_index++;tick=0;
        if(fixture_index>=array_length(fixtures))
        {
            phase="foreground";tick=0;room_goto(rm_commercial_district);exit;
        }
        room_goto(fixtures[fixture_index][0]);exit;
    }
}
if(phase=="foreground")
{
    if(tick==12)
    {
        p=instance_find(obj_player,0);p.x=480;p.y=270;p.visible=false;
        with(obj_capitalist_ally){visible=false;encounter_started=true;dialogue_active=false;}
        with(obj_world_foreground)visible=false;
    }
    if(tick==20)screen_save("safety-rail-background.png");
    if(tick==21)with(obj_world_foreground)visible=true;
    if(tick==29)
    {
        screen_save("safety-rail-overlay.png");finish_tests();exit;
    }
}
