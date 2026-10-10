show_debug_message("EPILOGUE_CREATE_ENTER");
stage=0;tick=0;elapsed=0;last_depart_count=0;finale_elapsed=0;
professor_captured=false;home_seen=false;fade_seen=false;
// Drive actual story actors, scene updates and room transitions.
#macro device_mouse_x_to_gui global.evento_epilogue_pointer_x
#macro device_mouse_y_to_gui global.evento_epilogue_pointer_y
#macro mouse_check_button_pressed global.evento_epilogue_pointer_pressed
global.evento_epilogue_pointer_x=function(_device){return -100;};
global.evento_epilogue_pointer_y=function(_device){return -100;};
global.evento_epilogue_pointer_pressed=function(_button){return false;};
show_debug_message("EPILOGUE_CREATE_BEFORE_ROOM_GOTO");
room_goto(rm_temporal_origin);
show_debug_message("EPILOGUE_CREATE_AFTER_ROOM_GOTO");
