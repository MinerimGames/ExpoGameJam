display_set_gui_size(640, 380);
// Render above the room's plain Background layer at depth 200.
depth = 199;
map_offset_y = room == rm_autumn_gate ? 336 : 0;
map_sprite = room == rm_autumn_plaza ? spr_autumn_plaza : spr_autumn_city;
map_scale = (room == rm_autumn_plaza ? 960 : 800) / sprite_get_width(map_sprite);
// Only the printed faces change; masonry, poles and the original map stay intact.
flags_animated=false;
flag_posts=room==rm_autumn_plaza?[]:outono_bandeiras();
with (obj_player)
{
    depth = -20;
    visual_scale = 1.2;
}
if(room!=rm_autumn_plaza)outono_criar_arco(map_sprite,map_offset_y);

// Ground footprints are deliberately smaller than lamp silhouettes. Redraw
// the head, stem and base separately: their empty surrounding floor stays
// visible and Wilson passes behind the pole at its actual foot depth.
var _lamps=room==rm_autumn_plaza?[
    [145,192,268],[811,192,268],[380,137,207],[580,137,207],
    [380,273,356],[580,273,356]
]:[
    [247,22,70],[552,22,70],[363,342,395],[466,342,395],
    [359,503,568],[469,503,568]
];
var _world_w=room==rm_autumn_plaza?960:800;
var _world_h=sprite_get_height(map_sprite)*map_scale;
for(var _i=0;_i<array_length(_lamps);_i++)
{
    var _lamp=_lamps[_i];var _x=_lamp[0];var _top=_lamp[1];var _feet=_lamp[2];
    if(_feet-map_offset_y<0 || _top-map_offset_y>room_height)continue;
    var _parts=[
        [[_x-3,_top],[_x+3,_top],[_x+10,_top+8],[_x+6,_top+21],
            [_x-6,_top+21],[_x-10,_top+8]],
        [[_x-3,_top+19],[_x+3,_top+19],[_x+3,_feet-12],[_x-3,_feet-12]],
        [[_x-4,_feet-15],[_x+4,_feet-15],[_x+9,_feet-4],[_x+8,_feet],
            [_x-8,_feet],[_x-9,_feet-4]]
    ];
    for(var _part=0;_part<array_length(_parts);_part++)
    {
        var _points=_parts[_part];
        for(var _v=0;_v<array_length(_points);_v++)_points[_v][1]-=map_offset_y;
        var _front=instance_create_depth(0,0,mundo_profundidade(_feet-map_offset_y),obj_world_foreground);
        _front.art=map_sprite;_front.points=_points;
        _front.source_world_width=_world_w;_front.source_world_height=_world_h;
        _front.source_offset_y=map_offset_y;
    }
}
// Bench bodies and freestanding flag poles use the same measured base depth.
var _props=room==rm_autumn_plaza?[
    [216,79,276,118],[686,79,744,118]
]:[
    [281,36,323,59],[480,36,520,59],
    [227,104,231,149],[350,100,354,146],[447,115,451,150],
    [473,105,477,146],[558,109,562,148]
];
for(var _i=0;_i<array_length(_props);_i++)
{
    var _prop=_props[_i];if(_prop[3]-map_offset_y<0)continue;
    var _front=instance_create_depth(0,0,mundo_profundidade(_prop[3]-map_offset_y),obj_world_foreground);
    _front.art=map_sprite;
    _front.points=[[_prop[0],_prop[1]-map_offset_y],[_prop[2],_prop[1]-map_offset_y],
        [_prop[2],_prop[3]-map_offset_y],[_prop[0],_prop[3]-map_offset_y]];
    _front.source_world_width=_world_w;_front.source_world_height=_world_h;
    _front.source_offset_y=map_offset_y;
}
if(room==rm_autumn_streets)
{
    var _stand_feet=[149,146,150,146,148];
    for(var _stand=0;_stand<array_length(_stand_feet);_stand++)
    {
        var _index=4+_stand;if(_index>=array_length(flag_posts))continue;
        var _front=instance_create_depth(0,0,mundo_profundidade(_stand_feet[_stand])-1,obj_world_foreground);
        _front.flag_post=flag_posts[_index];
        _front.map_scale=map_scale;_front.map_offset_y=map_offset_y;
    }
    // Low stands beside the houses also occlude actors at their ground bases.
    // Redraw the cloth/hem first, then its existing portrait at the same depth.
    var _lower_stands=[
        [[211,295],[235,291],[241,323],[211,327]],
        [[590,291],[625,297],[622,327],[589,321]]
    ];
    for(var _stand=0;_stand<2;_stand++)
    {
        var _front=instance_create_depth(0,0,mundo_profundidade(327),obj_world_foreground);
        _front.art=map_sprite;_front.points=_lower_stands[_stand];
        _front.source_world_width=_world_w;_front.source_world_height=_world_h;
        var _portrait=instance_create_depth(0,0,mundo_profundidade(327)-1,obj_world_foreground);
        _portrait.flag_post=flag_posts[11+_stand];
        _portrait.map_scale=map_scale;_portrait.map_offset_y=map_offset_y;
    }
}
