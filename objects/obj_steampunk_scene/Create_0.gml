display_set_gui_size(640,380);
depth=200;
map_sprite=asset_get_index("spr_steampunk_foundry");
effect_time=0;
machine_activity=[0.15,0.15];
machine_centres=[[200,230],[760,230]];
steam_vents=[[154,116],[254,172],[780,132],[846,180]];
gear_centres=[[61,162,18],[190,165,19],[691,192,30],[742,131,23]];
machine_lights=[[189,218],[41,281],[782,270],[805,161]];
exit_gate=noone;

var _story=historia_newton_progresso();
var _defeated=variable_struct_exists(_story,"steampunk_defeated") && _story.steampunk_defeated;
if(!_defeated)
{
    exit_gate=instance_create_depth(360,84,0,obj_colisor);
    exit_gate.image_xscale=240/32;
    exit_gate.image_yscale=16/32;
}

// Only the entrance arch is redrawn at its foot depth. The central opening
// remains walkable and the original background bitmap stays intact.
if(map_sprite!=-1)
{
    var _arch=[[414,560,572],[440,551,563],[466,545,557],
        [493,546,558],[520,552,564],[547,560,572]];
    for(var _i=0;_i<array_length(_arch)-1;_i++)
    {
        var _a=_arch[_i];var _b=_arch[_i+1];
        var _front=instance_create_depth(0,0,mundo_profundidade(594),obj_world_foreground);
        _front.art=map_sprite;
        _front.source_world_width=960;_front.source_world_height=640;
        _front.points=[[_a[0],_a[1]],[_b[0],_b[1]],[_b[0],_b[2]],[_a[0],_a[2]]];
    }
}
