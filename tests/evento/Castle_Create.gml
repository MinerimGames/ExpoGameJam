room_names=["rm_vila","rm_castelo","rm_bosque"];
collider_counts=[133,67,36];
room_ids=[];
for(var _i=0;_i<array_length(room_names);_i++)
{
    var _room=asset_get_index(room_names[_i]);
    check(_room!=-1,"new room registered: "+room_names[_i]);
    if(_room==-1){finish_tests();exit;}
    array_push(room_ids,_room);
}
check(asset_get_index("obj_cutscene_controller")==-1,"removed scene stays absent");
room_index=0;
tick=0;
phase="rooms";
entry_dialogue_seen=false;
entry_dialogue_pulse=false;
room_goto(room_ids[room_index]);
