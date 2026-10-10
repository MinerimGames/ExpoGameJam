tick += 1;
if(tick < 30) exit;
var _obj=asset_get_index("obj_ambient_controller");
var _expected=(room==rm_tutorial || room==rm_cavernas || room==rm_cavernas_2) ? 1 : 0;
check(instance_number(_obj)==_expected,"ambient count " + room_get_name(room));
if(_expected==1) {
    var _a=instance_find(_obj,0);
    check(!_a.persistent,"ambient not persistent");
    if(room==rm_tutorial) check(array_length(_a.water_points)==0 && array_length(_a.leaf_points)>0,"tutorial tree and no invented water");
    if(room==rm_cavernas) check(array_length(_a.water_points)>0 && array_length(_a.fire_points)==0,"river points only");
    if(room==rm_cavernas_2) check(array_length(_a.water_points)>0 && array_length(_a.fire_points)==1,"pond and single campfire");
    var _duplicate=instance_create_depth(0,0,150,_obj);
    check(instance_number(_obj)==1,"duplicate ambient rejected");
    for(var _i=0;_i<100;_i++) _a.ambient_spawn("dust",100,100);
    check(array_length(_a.particles)==40,"particle hard cap");
    for(var _j=0;_j<10000;_j++) { _a.ambient_update(1/60); if(array_length(_a.particles)>40) check(false,"particle cap under updates"); }
    _a.water_enabled=false; _a.leaves_enabled=false; _a.dust_enabled=false; _a.fire_enabled=false; _a.embers_enabled=false;
    for(var _k=0;_k<1000;_k++) _a.ambient_update(1/60);
    check(array_length(_a.particles)==0,"particles expire without emission");
    show_debug_message("AMBIENT_"+room_get_name(room)+": water="+string(array_length(_a.water_points))+" leaves="+string(array_length(_a.leaf_points))+" fire="+string(array_length(_a.fire_points)));
}
stage++; tick=0;
if(stage>=array_length(targets)) finish_tests(); else room_goto(targets[stage]);
