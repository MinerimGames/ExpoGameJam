tick++;
if(phase=="rooms")
{
    // Finish the intentional entry transmission before testing free movement.
    if((room==rm_bosque || room==rm_vila) && instance_exists(obj_newton_cavern_dialogue))
    {
        var _d=instance_find(obj_newton_cavern_dialogue,0);
        if(_d.dialogue_active)
        {
            if(!entry_dialogue_seen)
            {
                check(!instance_find(obj_player,0).movimento_liberado,
                    "arrival transmission intentionally pauses exploration");
                entry_dialogue_seen=true;
            }
            if(entry_dialogue_pulse)keyboard_key_release(ord("E"));
            else keyboard_key_press(ord("E"));
            entry_dialogue_pulse=!entry_dialogue_pulse;
            tick=0;exit;
        }
        keyboard_key_release(ord("E"));
    }
    if(tick==30)
    {
        check(room==room_ids[room_index],"room loads: "+room_names[room_index]);
        check(instance_number(obj_player)==1,"new room has one real player");
        check(instance_number(obj_colisor)==collider_counts[room_index],"authored colliders retained");
        p=instance_find(obj_player,0);
        if (room==rm_castelo) check(p.x>=404 && p.x<=428 && p.y>=680,"castle starts on entrance bridge");
        if (room==rm_bosque) check(p.x>580 && p.y>192 && p.y<240,"forest starts on eastern trail");
        if (room==rm_vila) check(p.x>528 && p.x<592 && p.y>568,"village starts on southern trail");
        check(p.movimento_liberado,"player control available in imported room");
        with(p) other.check(!place_meeting(x,y,obj_colisor),"authored spawn has no collider overlap");
        check(camera_get_view_width(view_camera[0])==384 && camera_get_view_height(view_camera[0])==219,
            "authored camera dimensions retained");
        var _camera=view_camera[0];
        check(camera_get_view_x(_camera)>=0 && camera_get_view_y(_camera)>=0
            && camera_get_view_x(_camera)+384<=room_width
            && camera_get_view_y(_camera)+219<=room_height,"camera stays within map bounds");
        if (room==rm_castelo) screen_save("castle-entry.png");
        check(!instance_exists(obj_battle_controller) && !instance_exists(obj_ambient_controller),
            "room change leaves no old controllers");
        keyboard_key_press(vk_up);
    }
    if(tick==34)
    {
        check(p.up && !p.down,"arrow input works in imported room");
        clear_keys();keyboard_key_press(ord("W"));
    }
    if(tick==38)
    {
        check(p.up && !p.down,"WASD input works in imported room");clear_keys();
        room_index++;tick=0;
        if(room_index<array_length(room_ids)) room_goto(room_ids[room_index]);
        else {room_goto(rm_menu);phase="menu";}
    }
}
else if(phase=="menu" && tick>=30)
{
    check(room==rm_menu && !instance_exists(obj_player),"return to original menu removes imported room player");
    finish_tests();
}
