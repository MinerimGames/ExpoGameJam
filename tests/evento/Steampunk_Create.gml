steam_room=asset_get_index("rm_steampunk_foundry");
steam_scene=asset_get_index("obj_steampunk_scene");
steam_boss=asset_get_index("obj_isleide_steampunk");
steam_art=asset_get_index("spr_steampunk_foundry");
steam_idle=asset_get_index("spr_steampunk_idle");
steam_talk=asset_get_index("spr_steampunk_talk");
steam_attack=asset_get_index("spr_steampunk_attack");
steam_defense=asset_get_index("spr_steampunk_defense");
check(steam_room!=-1,"steampunk phase is registered between the king and city");
check(steam_scene!=-1 && steam_boss!=-1 && steam_art!=-1 && steam_idle!=-1
    && steam_talk!=-1 && steam_attack!=-1 && steam_defense!=-1,
    "steampunk phase has its scene, original boss, foundry and three combat poses");
if(steam_room==-1 || steam_scene==-1 || steam_boss==-1 || steam_art==-1
    || steam_idle==-1 || steam_talk==-1 || steam_attack==-1 || steam_defense==-1)
{finish_tests();exit;}
historia_newton_progresso(true);
stage=0;tick=0;elapsed=0;pulse=false;intro_page=0;walk_start_y=0;
room_goto(rm_throne_room);
