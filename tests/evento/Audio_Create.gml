stage=0;tick=0;elapsed=0;
check(asset_get_index("game_audio")!=-1,"game has an audio runtime");
if(asset_get_index("game_audio")==-1){finish_tests();exit;}
game_set_speed(60,gamespeed_fps);
room_goto(rm_tutorial);
