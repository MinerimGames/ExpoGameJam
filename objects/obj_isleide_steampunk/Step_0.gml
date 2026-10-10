breathing=0;depth=mundo_profundidade(y+7);
if(!assets_ready || instance_exists(obj_battle_controller) || !instance_exists(obj_player))exit;
var _player=instance_find(obj_player,0);
var _advance=keyboard_check_pressed(ord("E")) || keyboard_check_pressed(vk_space);
if(!encounter_started && _player.movimento_liberado
    && point_distance(x,y,_player.x,_player.y)<=encounter_distance)
{
    encounter_started=true;dialogue_active=true;
    _player.movimento_liberado=false;_player.velh=0;_player.velv=0;
    exit;
}
if(!dialogue_active)exit;
_player.movimento_liberado=false;_player.velh=0;_player.velv=0;
if(_advance)
{
    som_efeito("select");
    if(dialogue_page<array_length(dialogue_pages)-1)dialogue_page++;
    else{dialogue_active=false;batalha_iniciar(id,false);}
}
