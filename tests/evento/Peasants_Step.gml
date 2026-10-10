tick++;
if(tick<10)exit;
check(instance_number(peasant)==0,"scene has no background peasant NPCs");
check(instance_number(population)==0,"scene has no resident population spawner");
check(instance_exists(obj_player),"scene preserves the player");
if(room==rm_bosque)check(instance_number(obj_colisor)==36,"forest includes repaired boundaries and existing route colliders");
if(room==rm_vila)check(instance_number(obj_colisor)==133,"village includes repaired buildings and river colliders");
if(room==rm_castelo)check(instance_exists(obj_castle_guard),"story guard preserved");
if(room==rm_throne_room)check(instance_exists(obj_isleide_king),"story king preserved");
visit++;tick=0;
if(visit>=array_length(rooms)){finish_tests();exit;}
room_goto(rooms[visit]);
