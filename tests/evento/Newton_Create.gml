var _district=asset_get_index("rm_commercial_district");
check(_district!=-1,"commercial district available after city");
check(asset_get_index("spr_capitalist_ally")!=-1,"provided ally imported");
if(_district==-1){finish_tests();exit;}
stage=0;tick=0;elapsed=0;
// Keep this scripted keyboard playthrough independent of the desktop cursor.
#macro device_mouse_x_to_gui global.evento_newton_pointer_x
#macro device_mouse_y_to_gui global.evento_newton_pointer_y
#macro mouse_check_button_pressed global.evento_newton_pointer_pressed
global.evento_newton_pointer_x=function(_device){return -100;};
global.evento_newton_pointer_y=function(_device){return -100;};
global.evento_newton_pointer_pressed=function(_button){return false;};
room_goto(rm_autumn_plaza);
