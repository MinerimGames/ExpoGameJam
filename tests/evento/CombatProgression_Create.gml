// Real controllers and opponents exercise rewards, retries and action answers.
matematica_progresso(true);
historia_newton_progresso(true);
stage=0;tick=0;elapsed=0;
solve=function(_action,_correct=true)
{
    b.request_action(_action);
    if(b.battle_screen!="challenge")return false;
    b.answer_text=string(b.challenge.resposta+(_correct?0:1));
    b.verify_answer();return true;
};
check_backdrop=function()
{
    display_set_gui_size(1024,768);
    var _surface=surface_create(1024,768);
    var _view=matrix_get(matrix_view);var _projection=matrix_get(matrix_projection);
    var _world=matrix_get(matrix_world);var _camera=camera_create_view(0,0,1024,768);
    surface_set_target(_surface);camera_apply(_camera);matrix_set(matrix_world,matrix_build_identity());
    draw_clear_alpha(c_fuchsia,0);
    with(b)event_perform(ev_draw,64);
    surface_reset_target();matrix_set(matrix_view,_view);matrix_set(matrix_projection,_projection);
    matrix_set(matrix_world,_world);camera_destroy(_camera);
    var _pixels=buffer_create(1024*768*4,buffer_fixed,1);buffer_get_surface(_pixels,_surface,0);
    // These empty corners lie outside the centered 960x540 interface.
    var _samples=[[0,0],[1023,0],[0,767],[1023,767],[550,190]];
    for(var _i=0;_i<array_length(_samples);_i++)
    {
        var _offset=(_samples[_i][1]*1024+_samples[_i][0])*4;
        check(buffer_peek(_pixels,_offset+3,buffer_u8)==255
            && buffer_peek(_pixels,_offset,buffer_u8)<64
            && buffer_peek(_pixels,_offset+1,buffer_u8)<64
            && buffer_peek(_pixels,_offset+2,buffer_u8)<64,"battle covers exploration and letterbox with opaque darkness");
    }
    buffer_delete(_pixels);surface_free(_surface);display_set_gui_size(960,540);b.update_ui_transform();
};
room_goto(rm_cavernas_2);
