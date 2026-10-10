// Keep the suite name for existing runners; exploration now uses keyboard only.
// Pointer input is supplied at the former arrow targets to catch accidental
// movement if GUI controls are restored. Real movement/collision remain intact.
#macro device_mouse_check_button global.evento_pointer_held
#macro device_mouse_x_to_gui global.evento_pointer_x
#macro device_mouse_y_to_gui global.evento_pointer_y
global.evento_touch_down=array_create(5,false);
global.evento_touch_x=array_create(5,0);
global.evento_touch_y=array_create(5,0);
global.evento_pointer_held=function(_device,_button){return global.evento_touch_down[_device] && _button==mb_left;};
global.evento_pointer_x=function(_device){return global.evento_touch_x[_device];};
global.evento_pointer_y=function(_device){return global.evento_touch_y[_device];};
clear_pointers=function(){global.evento_touch_down=array_create(5,false);};
point_former_arrow=function(_index)
{
    var _x=[83,83,36,130];var _y=[250,344,297,297];
    global.evento_touch_x[0]=_x[_index];global.evento_touch_y[0]=_y[_index];
    global.evento_touch_down[0]=true;
};
keys=[ord("W"),ord("S"),ord("A"),ord("D"),vk_up,vk_down,vk_left,vk_right];
dx=[0,0,-1,1,0,0,-1,1];dy=[-1,1,0,0,-1,1,0,0];
stage=0;tick=0;elapsed=0;probe=0;
room_goto(rm_cavernas);
