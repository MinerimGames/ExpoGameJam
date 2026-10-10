if(!is_undefined(flag_post))
{
    // Reuse the exact printed-cloth geometry and source portrait UVs.
    // Its portable stand's feet determine when it covers a walking actor.
    var _filter=gpu_get_texfilter();gpu_set_texfilter(false);
    var _q=flag_post.points;
    draw_primitive_begin_texture(pr_trianglefan,sprite_get_texture(flag_post.sprite,0));
    for(var _v=0;_v<array_length(_q);_v++)
    {
        var _uv=flag_post.texcoords[_v];
        draw_vertex_texture_colour(_q[_v][0]*map_scale,_q[_v][1]*map_scale-map_offset_y,
            _uv[0],_uv[1],c_white,1);
    }
    draw_primitive_end();gpu_set_texfilter(_filter);
}
else if(art!=-1 && array_length(points)>=3)
    mundo_frente_desenhar(art,points,source_world_width,source_world_height,source_offset_y);
