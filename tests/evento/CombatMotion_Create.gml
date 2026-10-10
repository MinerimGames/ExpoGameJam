stage=0;tick=0;elapsed=0;case_index=0;
presentation_capture=function(_actor,_gui=false)
{
    var _width=_gui?display_get_gui_width():128;
    var _height=_gui?display_get_gui_height():160;
    var _surf=surface_create(_width,_height);
    var _view=matrix_get(matrix_view);var _projection=matrix_get(matrix_projection);
    var _world=matrix_get(matrix_world);
    var _camera=camera_create_view(0,0,_width,_height);
    var _filter=gpu_get_texfilter();
    var _old_x=_actor.x;var _old_y=_actor.y;
    _actor.x=64;_actor.y=128;
    surface_set_target(_surf);camera_apply(_camera);
    matrix_set(matrix_world,matrix_build_identity());
    draw_clear_alpha(c_black,0);gpu_set_texfilter(false);
    var _event=_gui?64:0;
    with(_actor)event_perform(ev_draw,_event);
    surface_reset_target();
    _actor.x=_old_x;_actor.y=_old_y;
    gpu_set_texfilter(_filter);
    matrix_set(matrix_view,_view);matrix_set(matrix_projection,_projection);
    matrix_set(matrix_world,_world);camera_destroy(_camera);
    var _size=_width*_height*4;
    var _pixels=buffer_create(_size,buffer_fixed,1);
    buffer_get_surface(_pixels,_surf,0);surface_free(_surf);
    var _top=_height;var _bottom=-1;var _count=0;
    for(var _py=0;_py<_height;_py++)
    for(var _px=0;_px<_width;_px++)
    {
        if(buffer_peek(_pixels,(_py*_width+_px)*4+3,buffer_u8)==0)continue;
        _top=min(_top,_py);_bottom=max(_bottom,_py);_count++;
    }
    return {pixels:_pixels,size:_size,top:_top,bottom:_bottom,height:_bottom-_top+1,count:_count};
};
presentation_changed=function(_before,_after)
{
    if(_before.size!=_after.size)return true;
    for(var _i=0;_i<_before.size;_i+=4)
        if(buffer_peek(_before.pixels,_i,buffer_u32)
            !=buffer_peek(_after.pixels,_i,buffer_u32))return true;
    return false;
};
sprites=[spr_isleide_cavernas,spr_castle_guard,spr_king_standing,spr_steampunk_idle,spr_city_peace,spr_battle_newton,spr_newton_evil];
portrait_changed=function(_before,_after,_x1,_y1,_x2,_y2)
{
    var _width=display_get_gui_width();
    for(var _y=_y1;_y<_y2;_y++)for(var _x=_x1;_x<_x2;_x++)
    {
        var _off=(_y*_width+_x)*4;
        if(buffer_peek(_before.pixels,_off,buffer_u32)!=buffer_peek(_after.pixels,_off,buffer_u32))return true;
    }
    return false;
};
room_goto(rm_tutorial);
