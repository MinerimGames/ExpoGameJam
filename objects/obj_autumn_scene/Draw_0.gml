draw_sprite_ext(map_sprite, 0, 0, -map_offset_y,
    map_scale, map_scale, 0, c_white, 1);
var _filter=gpu_get_texfilter();gpu_set_texfilter(false);
for(var _i=0;_i<array_length(flag_posts);_i++)
{
    var _f=flag_posts[_i];var _q=_f.points;var _s=map_scale;
    draw_primitive_begin_texture(pr_trianglefan,sprite_get_texture(_f.sprite,0));
    for(var _v=0;_v<array_length(_q);_v++)
    {
        var _uv=_f.texcoords[_v];
        // Native draw primitives normalise UVs inside the sprite's packed texture region.
        draw_vertex_texture_colour(_q[_v][0]*_s,_q[_v][1]*_s-map_offset_y,
            _uv[0],_uv[1],c_white,1);
    }
    draw_primitive_end();
}
gpu_set_texfilter(_filter);
