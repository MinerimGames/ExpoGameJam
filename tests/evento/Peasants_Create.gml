// Background residents have been removed; story encounters must remain.
peasant=asset_get_index("obj_castle_peasant");
population=asset_get_index("obj_castle_population");
tick=0;visit=0;
rooms=[rm_bosque,rm_vila,rm_bosque,rm_vila,rm_castelo,rm_castle_hall,
    rm_throne_room,rm_autumn_gate,rm_autumn_streets,rm_autumn_plaza];
game_set_speed(240,gamespeed_fps);
room_goto(rooms[0]);
