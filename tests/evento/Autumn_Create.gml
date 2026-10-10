gate=asset_get_index("rm_autumn_gate");
streets=asset_get_index("rm_autumn_streets");
plaza=asset_get_index("rm_autumn_plaza");
check(gate!=-1 && streets!=-1 && plaza!=-1,"three autumn route sections are registered");
if(gate==-1 || streets==-1 || plaza==-1){finish_tests();exit;}
stage=0;tick=0;frames=0;point_index=0;phase="wait";
city_input_pulse=false;
room_goto(rm_steampunk_foundry);

begin_autumn_walk=function(_room,_next,_points)
{
    check(room==_room,"autumn section enters "+room_get_name(_room));
    check(instance_number(obj_player)==1 && instance_number(obj_portal)==0,
        "autumn section has one player without a portal");
    p=instance_find(obj_player,0);
    with(p)other.check(!place_meeting(x,y,obj_colisor),"autumn entry has no collider overlap");
    var _cam=view_camera[0];
    check(camera_get_view_width(_cam)==384 && camera_get_view_height(_cam)==219,
        "autumn camera is zoomed like the cavern camera");
    check(p.x>=camera_get_view_x(_cam) && p.x<camera_get_view_x(_cam)+384
        && p.y>=camera_get_view_y(_cam) && p.y<camera_get_view_y(_cam)+219,
        "zoomed camera frames autumn entry");
    expected_room=_room;next_room=_next;points=_points;point_index=0;frames=0;phase="walk";
    screen_save(room_get_name(_room)+"-entry.png");
    check(surface_getpixel(application_surface,32,32)!=c_white,
        "autumn background is visible instead of covered by blank room layer");
};
