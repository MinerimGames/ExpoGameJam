city_object=asset_get_index("obj_isleide_city");
check(city_object!=-1,"final plaza has the approved city boss");
if(city_object==-1){finish_tests();exit;}
stage=0;tick=0;elapsed=0;input_pulse=false;
room_goto(rm_autumn_plaza);
