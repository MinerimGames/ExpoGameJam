depth=-25;image_speed=0;
idle_time=0;
battle_story="newton";battle_stage=1;
battle_name="Newton";battle_hp=420;battle_math_phase=16;battle_math_phase_max=16;
normal_sprite=spr_battle_newton;
evil_sprite=asset_get_index("spr_newton_evil");
if(evil_sprite==-1)evil_sprite=normal_sprite;
evil_revealed=false;transformation_progress=0;
battle_sprite=normal_sprite;
update_appearance=function()
{
    battle_sprite=evil_revealed?evil_sprite:normal_sprite;
    sprite_index=battle_sprite;
    battle_name=evil_revealed?"Evil Newton":"Newton";
    battle_scale=232/max(1,sprite_get_bbox_bottom(battle_sprite)-sprite_get_bbox_top(battle_sprite)+1);
};
reveal_evil=function()
{
    evil_revealed=true;transformation_progress=1;
    update_appearance();
};
update_appearance();
battle_message="Newton conhece estruturas que vocês ainda não conseguem compreender.";
