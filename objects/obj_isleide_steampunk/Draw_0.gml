if(!assets_ready)exit;
var _sprite=dialogue_active && dialogue_speakers[dialogue_page]=="ISLEIDE STEAMPUNK"
    ?dialogue_portraits[dialogue_page]:battle_poses.peace;
mundo_desenhar_personagem(_sprite,x,y+7,world_height);
