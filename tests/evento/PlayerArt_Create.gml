idle_front=asset_get_index("spr_wilson_idle_front");
check(idle_front!=-1,"map uses the provided Wilson sprite set");
if(idle_front==-1){finish_tests();exit;}
check(shader_is_compiled(shd_wilson_walk),"native clean-palette shader compiles on Windows renderer");
idle_back=asset_get_index("spr_wilson_idle_back");
idle_side=asset_get_index("spr_wilson_idle_side");
art_names=["walk_front_a","walk_front_b","walk_back_a","walk_back_b","walk_side_a","walk_side_b",
    "attack","defense","heal","dodge"];
for(var i=0;i<array_length(art_names);i++)
    check(asset_get_index("spr_wilson_"+art_names[i])!=-1,"Wilson has new "+art_names[i]+" artwork");
stage=0;tick=0;elapsed=0;direction_index=0;
directions=[vk_down,vk_up,vk_left,vk_right];
direction_names=["down","up","left","right"];
room_goto(rm_cavernas);
