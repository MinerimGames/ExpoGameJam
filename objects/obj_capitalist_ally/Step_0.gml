breathing+=min(delta_time/1000000,0.1)*2;
if(room!=rm_commercial_district || instance_exists(obj_battle_controller))exit;
if(!instance_exists(obj_player))exit;
var _p=instance_find(obj_player,0);
if(!encounter_started && point_distance(x,y,_p.x,_p.y)<=38)
{
    encounter_started=true;dialogue_active=true;historia_newton_bloquear(true);exit;
}
if(dialogue_active && (keyboard_check_pressed(ord("E")) || keyboard_check_pressed(vk_space)))advance_dialogue();
