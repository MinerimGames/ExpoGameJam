// Real runner checks: menus, persistent fullscreen input, and SDF render output.
stage=0;tick=0;elapsed=0;
original_fullscreen=window_get_fullscreen();
ui_capture_text=function(_font,_scale,_outline,_filename)
{
    var _width=2560;var _height=240;
    var _surface=surface_create(_width,_height);
    var _view=matrix_get(matrix_view);var _projection=matrix_get(matrix_projection);
    var _world=matrix_get(matrix_world);var _font_before=draw_get_font();
    var _filter=gpu_get_texfilter();
    var _camera=camera_create_view(0,0,_width,_height);
    surface_set_target(_surface);camera_apply(_camera);
    matrix_set(matrix_world,matrix_build_identity());draw_clear_alpha(c_black,0);
    draw_set_font(_font);draw_set_halign(fa_left);draw_set_valign(fa_top);
    draw_set_color(c_white);draw_set_alpha(1);
    font_enable_effects(_font,_outline,{outlineEnable:true,outlineDistance:2,outlineColour:c_red});
    // Sprite interpolation remains disabled. SDF text supplies its own filtering.
    gpu_set_texfilter(false);
    draw_text_transformed(36,36,"AÇÃO: 12 × 3 + 4 - 2 = 38",_scale,_scale,0);
    surface_reset_target();surface_save(_surface,_filename);
    var _pixels=buffer_create(_width*_height*4,buffer_fixed,1);
    buffer_get_surface(_pixels,_surface,0);surface_free(_surface);
    var _visible=0;var _soft=0;
    for(var _i=3;_i<_width*_height*4;_i+=4)
    {
        var _alpha=buffer_peek(_pixels,_i,buffer_u8);
        if(_alpha>0)_visible++;
        if(_alpha>0 && _alpha<255)_soft++;
    }
    font_enable_effects(_font,false);draw_set_font(_font_before);
    gpu_set_texfilter(_filter);matrix_set(matrix_view,_view);
    matrix_set(matrix_projection,_projection);matrix_set(matrix_world,_world);
    camera_destroy(_camera);
    return {pixels:_pixels,size:_width*_height*4,visible:_visible,soft:_soft};
};
ui_changed=function(_a,_b)
{
    for(var _i=0;_i<_a.size;_i+=4)
        if(buffer_peek(_a.pixels,_i,buffer_u32)!=buffer_peek(_b.pixels,_i,buffer_u32))return true;
    return false;
};
room_goto(rm_menu);
