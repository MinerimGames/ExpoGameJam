// The registered idle frame looks left; the four action frames look right.
// Check the real battle selection through challenge, result, and idle return.
stage=0;tick=0;elapsed=0;action_index=0;
actions=["attack","defense","heal","dodge"];
expected_sprites=[spr_wilson_attack,spr_wilson_defense,spr_wilson_heal,spr_wilson_dodge];
display_set_gui_size(960,540);
check_battle_pose=function(_sprite,_facing,_name)
{
    var _visual=b.player_visual();
    check(_visual.sprite==_sprite,_name+" selects the intended artwork");
    check(_visual.scale>0,_name+" preserves positive vertical size");
    check(abs(_visual.scale*(sprite_get_bbox_bottom(_sprite)-sprite_get_bbox_top(_sprite)+1)-232)<0.001,
        _name+" keeps the same visible portrait height");
    var _has_facing=variable_struct_exists(_visual,"facing");
    check(_has_facing,_name+" supplies the horizontal direction for battle drawing");
    if(_has_facing)check(_visual.facing==_facing,_name+" looks toward the enemy on the right");
};
room_goto(rm_castelo);
