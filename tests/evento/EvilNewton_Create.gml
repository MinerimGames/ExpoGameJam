stage=0;tick=0;elapsed=0;transform_elapsed=0;
// Exercise the real scene and battles, independently of the desktop cursor.
#macro device_mouse_x_to_gui global.evento_evil_pointer_x
#macro device_mouse_y_to_gui global.evento_evil_pointer_y
#macro mouse_check_button_pressed global.evento_evil_pointer_pressed
global.evento_evil_pointer_x=function(_device){return -100;};
global.evento_evil_pointer_y=function(_device){return -100;};
global.evento_evil_pointer_pressed=function(_button){return false;};
room_goto(rm_tutorial);
