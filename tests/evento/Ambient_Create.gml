if (asset_get_index("obj_ambient_controller") == -1) { check(false,"ambient controller registered"); finish_tests(); exit; }
var _neutral=instance_create_depth(0,0,150,asset_get_index("obj_ambient_controller"));
check(array_length(_neutral.water_points)==0 && array_length(_neutral.leaf_points)==0 && array_length(_neutral.fire_points)==0,"missing layers have no emitters");
with(_neutral) instance_destroy();
stage = 0; tick = 0;
targets = [rm_menu,rm_tutorial,rm_cavernas,rm_cavernas_2,rm_demo_end,rm_tutorial];
room_goto(targets[0]);
