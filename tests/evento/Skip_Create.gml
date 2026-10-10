// Catches a missing skip, disabled flag being ignored, or wrong victory exit.
stage=0;tick=0;
var _config=batalha_configuracao();
check(variable_struct_exists(_config,"test_skip_enabled"),"temporary battle skip can be disabled centrally");
if(!variable_struct_exists(_config,"test_skip_enabled")){finish_tests();exit;}
rooms=[rm_tutorial,rm_cavernas_2,rm_castelo,rm_throne_room,rm_steampunk_foundry,rm_autumn_plaza];
enemies=[obj_newton_npc,obj_cavern_isleide,obj_castle_guard,obj_isleide_king,obj_isleide_steampunk,obj_isleide_city];
room_goto(rooms[0]);
