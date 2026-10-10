// Keep actors inside each room's existing foreground/ground tile band.
function mundo_profundidade(_feet)
{
    var _base=190;var _span=180;
    if(room==rm_tutorial || room==rm_temporal_origin){_base=390;_span=380;}
    else if(room==rm_bosque){_base=290;_span=280;}
    else if(room==rm_vila){_base=490;_span=280;}
    return _base-floor(clamp(_feet/room_height,0,1)*_span);
}

function mundo_desenhar_personagem(_sprite,_x,_feet,_height,_alpha=1,_angle=0,_width=10000)
{
    var _l=sprite_get_bbox_left(_sprite);var _t=sprite_get_bbox_top(_sprite);
    var _w=sprite_get_bbox_right(_sprite)-_l+1;
    var _h=sprite_get_bbox_bottom(_sprite)-_t+1;
    var _scale=min(_height/_h,_width/_w);
    if(_angle==0)
        draw_sprite_part_ext(_sprite,0,_l,_t,_w,_h,
            _x-clamp(sprite_get_xoffset(_sprite)-_l,0,_w)*_scale,
            _feet-_h*_scale,_scale,_scale,c_white,_alpha);
    else
        draw_sprite_ext(_sprite,0,_x,_feet,_scale,_scale,_angle,c_white,_alpha);
}

function wilson_desenhar_mapa(_x,_feet,_direction,_frame,_height,_alpha=1)
{
    var _atlas=asset_get_index("spr_wilson_walk_atlas");
    var _data=wilson_quadros();
    if(_atlas==-1 || array_length(_data)!=18)return false;
    var _row=_direction==3?0:(_direction==1?1:2);
    var _cell=_data[_row*6+clamp(_frame,0,5)];
    var _scale=_height/_cell.height;var _sign=_direction==2?-1:1;
    if(shader_is_compiled(shd_wilson_walk))shader_set(shd_wilson_walk);
    var _filter=gpu_get_texfilter();gpu_set_texfilter(false);
    draw_sprite_part_ext(_cell.art,0,_cell.x,_cell.y,_cell.w,_cell.h,
        round(_x)-_sign*_cell.anchor*_scale,round(_feet)-_cell.h*_scale,
        _sign*_scale,_scale,c_white,_alpha);
    gpu_set_texfilter(_filter);shader_reset();
    return true;
}

// The native renderer redraws only authored scenery polygons at their foot
// depth. No background bitmap is cropped or modified on disk.
function mundo_frente_desenhar(_sprite,_polygon,_world_w,_world_h,_offset_y=0)
{
    draw_primitive_begin_texture(pr_trianglefan,sprite_get_texture(_sprite,0));
    for(var i=0;i<array_length(_polygon);i++)
    {
        var _point=_polygon[i];
        draw_vertex_texture_colour(_point[0],_point[1],
            // Primitive draw calls normalise within the sprite texture handle;
            // its packed-page UV offset is applied by the native renderer.
            _point[0]/_world_w,(_point[1]+_offset_y)/_world_h,c_white,1);
    }
    draw_primitive_end();
}

function porto_criar_frentes()
{
    // Short native redraws keep the straight parapets at their foot depth.
    for(var side=0;side<2;side++)
    {
        var _left=side==0?405:526;
        for(var _y=155;_y<380;_y+=10)
        {
            var _front=instance_create_depth(0,0,mundo_profundidade(_y+12),obj_world_foreground);
            _front.points=[[_left,_y],[_left+27,_y],[_left+27,_y+10],[_left,_y+10]];
            _front.art=spr_commercial_district;
        }
    }
}

function outono_bandeiras()
{
    // Convex portrait panels measured inside the revised 1448x1086 city cloth.
    // Stop above notches and foliage; preserve the gold hems, poles and pointed pennants.
    var _art=[spr_city_flag_salute,spr_city_flag_speech,spr_city_flag_resolve];
    var _focus=[0.58,0.60,0.48];
    var _quads=[
        [[90,94],[132,94],[132,184],[90,184]],
        [[1372,92],[1414,92],[1414,182],[1372,182]],
        [[12,649],[62,649],[62,752],[12,752]],
        [[1383,651],[1432,651],[1432,755],[1383,755]],
        [[430,194],[469,200],[466,235],[428,230]],
        [[626,194],[646,194],[646,220],[626,220]],
        [[806,213],[827,213],[827,239],[806,239]],
        [[856,194],[875,194],[875,219],[856,219]],
        [[1035,200],[1076,211],[1070,246],[1029,235]],
        [[629,370],[650,370],[650,421],[640,433],[629,421]],
        [[852,370],[872,370],[872,423],[862,433],[852,423]],
        [[389,544],[416,540],[419,570],[392,573]],
        [[1091,542],[1121,548],[1116,573],[1086,567]]
    ];
    var _out=[];
    for(var _i=0;_i<array_length(_quads);_i++)
    {
        var _q=_quads[_i];var _sprite=_art[_i mod 3];
        var _width=point_distance(_q[0][0],_q[0][1],_q[1][0],_q[1][1]);
        var _height;
        var _layout=[[0,0],[1,0],[1,1],[0,1]];
        if(array_length(_q)==5)
        {
            _height=point_distance((_q[0][0]+_q[1][0])/2,(_q[0][1]+_q[1][1])/2,_q[3][0],_q[3][1]);
            // Clip the lower portrait to the tapered hem instead of squeezing it to a rectangle.
            _layout=_i==9?[[0,0],[1,0],[1,0.81],[0.52,1],[0,0.81]]:
                [[0,0],[1,0],[1,0.84],[0.50,1],[0,0.84]];
        }
        else
            _height=(point_distance(_q[0][0],_q[0][1],_q[3][0],_q[3][1])+
                point_distance(_q[1][0],_q[1][1],_q[2][0],_q[2][1]))/2;

        // Cover the cloth with an aspect-preserving crop, keeping each pose's face in view.
        var _aspect=_width/_height;
        var _source_aspect=sprite_get_width(_sprite)/sprite_get_height(_sprite);
        var _u0=0;var _v0=0;var _uw=1;var _vh=1;
        if(_aspect>_source_aspect)
        {
            _vh=_source_aspect/_aspect;
            _v0=min(0.04,1-_vh);
        }
        else
        {
            _uw=_aspect/_source_aspect;
            _u0=clamp(_focus[_i mod 3]-_uw/2,0,1-_uw);
        }
        var _texcoords=[];
        for(var _v=0;_v<array_length(_layout);_v++)
            array_push(_texcoords,[_u0+_layout[_v][0]*_uw,_v0+_layout[_v][1]*_vh]);
        array_push(_out,{sprite:_sprite,points:_q,texcoords:_texcoords});
    }
    return _out;
}

function outono_criar_arco(_sprite,_offset)
{
    // Redraw only the iron band and crest, keeping the opening walkable.
    var _edge=[[351,416,428],[367,408,421],[385,403,416],
        [402,400,413],[415,399,412],[430,402,415],[448,408,421],[478,418,431]];
    for(var i=0;i<array_length(_edge)-1;i++)
    {
        var _a=_edge[i];var _b=_edge[i+1];
        var _front=instance_create_depth(0,0,mundo_profundidade(466-_offset),obj_world_foreground);
        _front.points=[[_a[0],_a[1]-_offset],[_b[0],_b[1]-_offset],
            [_b[0],_b[2]-_offset],[_a[0],_a[2]-_offset]];
        _front.art=_sprite;_front.source_world_width=800;
        _front.source_world_height=600;_front.source_offset_y=_offset;
    }
    var _crest=instance_create_depth(0,0,mundo_profundidade(466-_offset),obj_world_foreground);
    _crest.art=_sprite;_crest.source_world_width=800;_crest.source_world_height=600;
    _crest.source_offset_y=_offset;
    _crest.points=[[410,395-_offset],[422,395-_offset],[432,407-_offset],
        [431,419-_offset],[421,428-_offset],[409,426-_offset],[400,417-_offset],[400,405-_offset]];
}

// GENERATED WALKING METADATA (source atlases remain untouched)
function wilson_quadros(){static _frames=[
    {x:112,y:14,w:143,h:269,anchor:70.5,height:271.0,art:spr_wilson_walk_atlas},
    {x:395,y:14,w:144,h:272,anchor:71.5,height:271.0,art:spr_wilson_walk_atlas},
    {x:671,y:14,w:141,h:270,anchor:69.5,height:271.0,art:spr_wilson_walk_atlas},
    {x:954,y:14,w:145,h:271,anchor:72.0,height:271.0,art:spr_wilson_walk_atlas},
    {x:1233,y:14,w:145,h:271,anchor:72.5,height:271.0,art:spr_wilson_walk_atlas},
    {x:1519,y:14,w:143,h:272,anchor:71.0,height:271.0,art:spr_wilson_walk_atlas},
    {x:113,y:303,w:142,h:272,anchor:70.0,height:271.5,art:spr_wilson_walk_atlas},
    {x:393,y:303,w:146,h:271,anchor:72.5,height:271.5,art:spr_wilson_walk_atlas},
    {x:665,y:303,w:149,h:272,anchor:74.5,height:271.5,art:spr_wilson_walk_atlas},
    {x:951,y:303,w:149,h:268,anchor:74.0,height:271.5,art:spr_wilson_walk_atlas},
    {x:1231,y:303,w:148,h:272,anchor:74.0,height:271.5,art:spr_wilson_walk_atlas},
    {x:1517,y:303,w:146,h:270,anchor:73.5,height:271.5,art:spr_wilson_walk_atlas},
    {x:65,y:109,w:203,h:510,anchor:87.0,height:510.0,art:spr_wilson_side_walk},
    {x:367,y:109,w:322,h:510,anchor:142.0,height:510.0,art:spr_wilson_side_walk},
    {x:770,y:109,w:249,h:510,anchor:124.0,height:510.0,art:spr_wilson_side_walk},
    {x:1136,y:109,w:201,h:510,anchor:89.0,height:510.0,art:spr_wilson_side_walk},
    {x:1448,y:109,w:323,h:510,anchor:147.0,height:510.0,art:spr_wilson_side_walk},
    {x:1878,y:109,w:258,h:510,anchor:99.5,height:510.0,art:spr_wilson_side_walk}
];return _frames;}
