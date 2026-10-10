route_rooms=[rm_cavernas_2,rm_vila,rm_bosque,rm_castelo,rm_castle_hall,rm_throne_room,rm_steampunk_foundry,rm_autumn_gate,rm_autumn_streets,rm_autumn_plaza];
route_names=["rm_cavernas_2","rm_vila","rm_bosque","rm_castelo","rm_castle_hall","rm_throne_room","rm_steampunk_foundry","rm_autumn_gate","rm_autumn_streets","rm_autumn_plaza"];
route_destinations=[rm_vila,rm_bosque,rm_castelo,rm_castle_hall,rm_throne_room,rm_steampunk_foundry,rm_autumn_gate,rm_autumn_streets,rm_autumn_plaza];
route_stage=0;
tick=0;
phase="victory";
room_goto(rm_cavernas_2);

waypoints=[];
waypoint_index=0;
walk_frames=0;
expected_room=noone;
next_room=noone;
guard_handled=false;
guard_input_pulse=false;
steam_dialogue_seen=false;
steam_victory_confirmed=false;
begin_walk=function(_room,_next,_points)
{
    check(room==_room,"natural route enters "+room_get_name(_room));
    check(instance_number(obj_portal)==0,"medieval route has no portals");
    var _p=instance_find(obj_player,0);
    with (_p) other.check(!place_meeting(x,y,obj_colisor),"entry is on walkable ground");
    var _cam=view_camera[0];
    var _cx=camera_get_view_x(_cam); var _cy=camera_get_view_y(_cam);
    check(_p.x>=_cx && _p.x<_cx+camera_get_view_width(_cam)
        && _p.y>=_cy && _p.y<_cy+camera_get_view_height(_cam),"camera frames room entry");
    expected_room=_room; next_room=_next;
    waypoints=_points;waypoint_index=0;walk_frames=0;phase="walk";
};
