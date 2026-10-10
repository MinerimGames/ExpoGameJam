function segredo_trono_delta(_phase,_dt)
{
    // Protect entry as well as playback: a stall in an earlier phase must
    // not jump across the blackout and into the middle of the animation.
    if(_phase=="NEWTON_QUOTE" || _phase=="FINAL_FADEOUT" || _phase=="CREDITS" || _phase=="COMPLETE")
        return _dt;
    return min(_dt,0.1);
}

function segredo_trono_config()
{
    var _config={
        quote:"O que sabemos é uma gota, o que ignoramos é um oceano",author:"Isaac Newton",
        characters_per_second:24,quote_hold:4,skip_seconds:1,destination:"black",
        music:"snd_final_cinematic_music",ambience:"",glitch_sound:"snd_wrong",
        errors:["ERROR: REALITY_UNSTABLE","TIMELINE_DESYNC","WORLD_INTEGRITY_FAILED","UNKNOWN_ENTITY_DETECTED"],
        scenes:[
            {key:"FINAL_SCREEN",duration:3,art:-1,fade_in:0,fade_out:0,music:"snd_music_ending",gain:0.32,ambient:0},
            {key:"GLITCH_SEQUENCE",duration:4.5,art:-1,fade_in:0,fade_out:0,music:"",gain:0,ambient:0},
            {key:"BLACKOUT",duration:0.45,art:-1,fade_in:0,fade_out:0,music:"",gain:0,ambient:0},
            {key:"CINEMATIC_01",duration:4.5,art:0,count:5,frame_seconds:0.9,fade_in:0.45,fade_out:0.12,music:"snd_music_newton",gain:0.14,ambient:0.07},
            {key:"CINEMATIC_02",duration:7.65,art:5,count:9,frame_seconds:0.85,fade_in:0.18,fade_out:0.12,music:"snd_music_newton",gain:0.14,ambient:0.07},
            {key:"CINEMATIC_03",duration:3.5,art:14,count:5,frame_seconds:0.7,fade_in:0.18,fade_out:0,music:"snd_music_newton",gain:0.14,ambient:0.07},
            {key:"REVEAL_HOLD",duration:2,art:18,count:1,frame_seconds:2,fade_in:0,fade_out:0.5,music:"snd_music_newton",gain:0.14,ambient:0.07},
            {key:"QUOTE_BLACKOUT",duration:0.6,art:-1,fade_in:0,fade_out:0,music:"",gain:0,ambient:0},
            {key:"NEWTON_QUOTE",duration:6.208333333,art:-1,fade_in:0,fade_out:0,music:"",gain:0,ambient:0},
            {key:"FINAL_FADEOUT",duration:1,art:-1,fade_in:0,fade_out:0,music:"",gain:0,ambient:0},
            {key:"CREDITS",duration:20,art:-1,fade_in:0.5,fade_out:0.5,music:"",gain:0,ambient:0},
            {key:"COMPLETE",duration:0.35,art:-1,fade_in:0,fade_out:0,music:"",gain:0,ambient:0}
        ]
    };
    // One mixer-owned track spans FIM, corruption, cinema, quote and credits.
    // It loops because the complete supplied recording is shorter than this ending.
    for(var _part=0;_part<array_length(_config.scenes)-1;_part++)
    {
        _config.scenes[_part].music=_config.music;
        _config.scenes[_part].gain=0.26;
        _config.scenes[_part].ambient=0;
    }
    segredo_trono_paineis(_config);return segredo_trono_tempos(_config);
}

function segredo_trono_tempos(_config)
{
    _config.characters_per_second=max(1,_config.characters_per_second);
    for(var _i=0;_i<array_length(_config.scenes);_i++)
    {
        var _scene=_config.scenes[_i];
        if(_scene.key=="NEWTON_QUOTE")_scene.duration=string_length(_config.quote)/_config.characters_per_second+_config.quote_hold;
    }
    return _config;
}

function segredo_trono_som(_ending,_name,_gain,_pitch=1)
{
    var _asset=asset_get_index(_name);if(_asset==-1 || _gain<=0)return -1;
    var _handle=audio_play_sound(_asset,20,false,_gain,0,_pitch);
    array_push(_ending.secret_sound_ids,_handle);return _handle;
}

function segredo_trono_limpar(_ending)
{
    for(var _i=0;_i<array_length(_ending.secret_sound_ids);_i++)
        if(audio_is_playing(_ending.secret_sound_ids[_i]))audio_stop_sound(_ending.secret_sound_ids[_i]);
    _ending.secret_sound_ids=[];
}

function segredo_trono_silencio()
{
    var _mix=som_estado();
    if(_mix.music_id!=-1)audio_stop_sound(_mix.music_id);
    if(_mix.ambience_id!=-1)audio_stop_sound(_mix.ambience_id);
    for(var _r=0;_r<array_length(_mix.retiring);_r++)audio_stop_sound(_mix.retiring[_r].id);
    _mix.retiring=[];
}

function segredo_trono_finalizar(_ending,_skipped=false)
{
    if(_ending.secret_complete)return;
    segredo_trono_limpar(_ending);segredo_trono_silencio();
    _ending.secret_complete=true;_ending.secret_skipped=_skipped;
    _ending.secret_active=true;_ending.secret_index=array_length(_ending.secret_config.scenes)-1;
    _ending.phase="COMPLETE";_ending.secret_skip_hold=0;_ending.secret_return_armed=false;
    _ending.secret_music_gain=0;_ending.secret_ambient_gain=0;
    historia_newton_progresso().stage="ending_complete";som_atualizar();
}

function segredo_trono_atualizar(_ending,_dt)
{
    var _config=_ending.secret_config;var _age=_ending.elapsed-_ending.blackout_time;
    if(_age<0 || _ending.secret_complete)return;
    var _index=0;
    while(_index<array_length(_config.scenes) && _age>=_config.scenes[_index].duration)
    {_age-=_config.scenes[_index].duration;_index++;}
    if(_index>=array_length(_config.scenes)){segredo_trono_finalizar(_ending);return;}
    var _scene=_config.scenes[_index];_ending.secret_active=true;_ending.secret_time=_age;_ending.phase=_scene.key;
    if(_ending.secret_index!=_index)
    {
        segredo_trono_limpar(_ending);_ending.secret_index=_index;_ending.secret_cue=-1;
        array_push(_ending.secret_history,_scene.key);
        if(_scene.key=="QUOTE_BLACKOUT" && surface_exists(_ending.secret_surface))
        {surface_free(_ending.secret_surface);_ending.secret_surface=-1;}
    }
    _ending.secret_music_gain=_scene.gain;_ending.secret_ambient_gain=_scene.ambient;
    if(_scene.key=="CREDITS")_ending.secret_music_gain*=clamp((_scene.duration-_age)/2,0,1);
    if(_scene.art>=0)
    {
        var _sample=segredo_trono_amostra(_scene,_age);
        _ending.secret_frame=_sample.current;_ending.secret_next_frame=_sample.next;
        _ending.secret_frame_blend=_sample.blend;
        if(_scene.key=="REVEAL_HOLD")
        {
            var _fade=1-clamp(_age/_scene.duration,0,1);
            _ending.secret_ambient_gain*=_fade;
        }
    }
    else if(_scene.key=="GLITCH_SEQUENCE")
    {
        _ending.terminal_visible=clamp(floor((_age-2)/0.35)+1,0,array_length(_config.errors));
        var _cue=floor(_age/0.9);
        if(_cue!=_ending.secret_cue && _age>0.15)
        {_ending.secret_cue=_cue;segredo_trono_som(_ending,_config.glitch_sound,0.06,0.7);}
    }
    else if(_scene.key=="NEWTON_QUOTE")_ending.secret_quote_chars=min(string_length(_ending.ending_quote),floor(_age*_config.characters_per_second));
    else if(_scene.key=="FINAL_FADEOUT")_ending.secret_quote_chars=string_length(_ending.ending_quote);
    som_atualizar();
}

function segredo_trono_amostra(_scene,_age)
{
    var _position=clamp(_age/_scene.frame_seconds,0,_scene.count-1);
    // Decimal frame durations can land just below an exact boundary.
    // Keep the selected frame and dissolve aligned at that boundary.
    var _boundary=round(_position);
    if(abs(_position-_boundary)<=0.00000001)_position=_boundary;
    var _frame=floor(_position);var _fraction=_position-_frame;
    var _blend=_fraction*_fraction*(3-2*_fraction);
    return {current:_scene.art+_frame,next:_scene.art+min(_frame+1,_scene.count-1),blend:_blend};
}

function segredo_trono_cinema(_ending,_scene,_w,_h)
{
    var _sw=1280;var _sh=760;
    if(!surface_exists(_ending.secret_surface))_ending.secret_surface=surface_create(_sw,_sh);
    var _filter=gpu_get_texfilter();gpu_set_texfilter(true);
    var _sample=segredo_trono_amostra(_scene,_ending.secret_time);
    if(surface_exists(_ending.secret_surface))
    {
        surface_set_target(_ending.secret_surface);draw_clear_alpha(c_black,1);
        segredo_trono_painel(spr_final_cinematic,_sample.current,_ending.secret_config.cinematic_sizes,_sw,_sh,1);
        if(_sample.next!=_sample.current)
            segredo_trono_painel(spr_final_cinematic,_sample.next,_ending.secret_config.cinematic_sizes,_sw,_sh,_sample.blend);
        surface_reset_target();
        if(shader_is_compiled(shd_final_camera))
        {
            shader_set(shd_final_camera);
            shader_set_uniform_f(shader_get_uniform(shd_final_camera,"u_time"),_ending.elapsed);
            shader_set_uniform_f(shader_get_uniform(shd_final_camera,"u_texel"),1/_sw,1/_sh);
        }
        draw_set_color(c_white);draw_set_alpha(1);
        draw_surface_stretched(_ending.secret_surface,0,0,_w,_h);shader_reset();
    }
    else
    {
        // A lost graphics context must still show the scene until recreation.
        segredo_trono_painel(spr_final_cinematic,_sample.current,_ending.secret_config.cinematic_sizes,_w,_h,1);
        segredo_trono_painel(spr_final_cinematic,_sample.next,_ending.secret_config.cinematic_sizes,_w,_h,_sample.blend);
    }
    gpu_set_texfilter(_filter);
    var _fade=1;
    if(_scene.fade_in>0)_fade=min(_fade,clamp(_ending.secret_time/_scene.fade_in,0,1));
    if(_scene.fade_out>0)_fade=min(_fade,clamp((_scene.duration-_ending.secret_time)/_scene.fade_out,0,1));
    draw_set_color(c_black);draw_set_alpha(1-_fade);draw_rectangle(0,0,_w,_h,false);draw_set_alpha(1);
}

function segredo_trono_painel(_sprite,_frame,_sizes,_w,_h,_alpha)
{
    var _size=_sizes[_frame];var _scale=min(_w/_size[0],_h/_size[1]);
    // Clip transparent storage to the original panel; only GUI letterboxing remains.
    draw_sprite_part_ext(_sprite,_frame,0,0,_size[0],_size[1],
        (_w-_size[0]*_scale)/2,(_h-_size[1]*_scale)/2,_scale,_scale,c_white,_alpha);
}

function segredo_trono_desenhar(_ending,_w,_h)
{
    draw_set_alpha(1);draw_set_color(c_black);draw_rectangle(0,0,_w,_h,false);
    var _state=_ending.phase;var _age=_ending.secret_time;
    var _config=_ending.secret_config;var _scene=_config.scenes[_ending.secret_index];
    var _filter=gpu_get_texfilter();gpu_set_texfilter(false);
    draw_set_font(fnt_ui);draw_set_halign(fa_center);draw_set_valign(fa_middle);
    if(_scene.art>=0)segredo_trono_cinema(_ending,_scene,_w,_h);
    else if(_state=="FINAL_SCREEN" || _state=="GLITCH_SEQUENCE")
    {
        var _shift=0;var _visible=true;
        if(_state=="GLITCH_SEQUENCE")
        {
            var _pulse=_age mod 0.9<0.085;
            if(_pulse)_shift=(_age<1?2:5)*sin(_age*31);
            _visible=_age<3.4;
            if(_age>=1 && _pulse)
            {
                draw_set_color(make_color_rgb(49,110,68));draw_set_alpha(0.12);
                var _y=(_age*67) mod _h;draw_rectangle(0,_y,_w,_y+3,false);draw_set_alpha(1);
                draw_set_color(make_color_rgb(85,185,115));draw_text_transformed(_w*0.72,_h*0.30,"#? 0x__",0.65,0.65,0);
            }
            draw_set_halign(fa_left);draw_set_color(make_color_rgb(85,185,115));
            for(var _i=0;_i<_ending.terminal_visible;_i++)
                draw_text_transformed(28+_shift,230+_i*23,_config.errors[_i],0.70,0.70,0);
            draw_set_halign(fa_center);
        }
        if(_visible){draw_set_color(c_white);draw_text_transformed(_w/2+_shift,_h/2,"FIM",2.2,2.2,0);}
    }
    else if(_state=="NEWTON_QUOTE" || _state=="FINAL_FADEOUT")
    {
        draw_set_font(fnt_ending_pixel);draw_set_color(c_white);
        var _text=string_copy(_ending.ending_quote,1,_ending.secret_quote_chars);
        var _quote=chr(34)+string_replace(_text,", ",","+chr(10));
        if(_ending.secret_quote_chars>=string_length(_ending.ending_quote))_quote+=chr(34);
        var _full=chr(34)+string_replace(_ending.ending_quote,", ",","+chr(10))+chr(34);
        var _scale=max(1,floor(min(2,(_w-60)/max(1,string_width(_full)))));
        draw_set_alpha(_state=="FINAL_FADEOUT"?1-clamp(_age/_scene.duration,0,1):1);
        draw_text_transformed(_w/2,_h*0.43,_quote,_scale,_scale,0);
        if(_ending.secret_quote_chars>=string_length(_ending.ending_quote))
            draw_text_transformed(_w/2,_h*0.66,_ending.ending_author,_scale,_scale,0);
    }
    else if(_state=="CREDITS" || _state=="COMPLETE")
    {
        draw_set_valign(fa_top);
        draw_set_color(make_color_rgb(38,23,61));draw_rectangle(143,70,497,354,false);
        draw_set_color(make_color_rgb(121,74,144));draw_line(155,68,485,68);
        draw_set_color(make_color_rgb(251,222,77));
        draw_text_transformed(_w/2,12,"O PARADOXO DE WILSON",0.82,0.82,0);
        draw_set_color(c_white);draw_text_transformed(_w/2,37,_ending.credits_heading,0.62,0.62,0);
        draw_set_color(make_color_rgb(189,170,211));draw_text_transformed(_w/2,56,"PARTICIPANTES",0.44,0.44,0);
        var _y=74;
        for(var _i=0;_i<array_length(_ending.credits);_i++)
        {
            var _credit=_ending.credits[_i];draw_set_color(make_color_rgb(243,203,96));
            draw_text_transformed(_w/2,_y,_credit.role,0.5,0.5,0);_y+=12;
            draw_set_color(c_white);
            for(var _j=0;_j<array_length(_credit.names);_j++)
            {draw_text_transformed(_w/2,_y,_credit.names[_j],0.62,0.62,0);_y+=14;}
            _y+=7;
        }
        var _filter_credits=gpu_get_texfilter();gpu_set_texfilter(false);
        for(var _k=0;_k<array_length(_ending.credit_variants);_k++)
        {
            var _variant=_ending.credit_variants[_k];if(_variant.sprite==-1)continue;
            draw_set_alpha(0.35);draw_set_color(make_color_rgb(105,72,132));
            draw_ellipse(_variant.x-34,_variant.feet-4,_variant.x+34,_variant.feet+4,false);
            draw_set_alpha(1);draw_set_color(c_white);
            mundo_desenhar_personagem(_variant.sprite,_variant.x,_variant.feet,
                _variant.height*(1+0.010*sin(_ending.elapsed*2.4+_k*1.7)),1,0,116);
        }
        gpu_set_texfilter(_filter_credits);draw_set_color(make_color_rgb(189,170,211));
        draw_text_transformed(_w/2,_h-18,"ENTER / E - VOLTAR AO MENU",0.5,0.5,0);
    }
    gpu_set_texfilter(_filter);draw_set_font(fnt_ui);draw_set_alpha(1);draw_set_color(c_white);
    draw_set_halign(fa_left);draw_set_valign(fa_top);
}

function segredo_trono_paineis(_config)
{
    _config.cinematic_sizes=array_create(19,[1672,941]);
    _config.cinematic_sizes[3]=[1671,941];
    _config.cinematic_sizes[5]=[1600,900];
    _config.path_sizes=[[227,213],[230,213],[221,213],[198,213],[185,213],[160,213],[227,209],[230,209],[221,209],[198,209],[185,209],[160,209],[227,192],[230,192],[221,192],[198,192],[185,192],[160,192],[227,187],[230,187],[221,187],[198,187],[185,187],[160,187],[227,191],[230,191],[221,191],[198,191],[185,191],[160,191],[227,230],[230,230],[221,230],[198,230],[185,230],[160,230]];
    _config.approach_sizes=[[227,213],[189,213],[206,213],[204,213],[196,213],[199,213],[229,209],[196,209],[197,209],[200,209],[202,209],[197,209],[222,192],[204,192],[196,192],[201,192],[202,192],[197,192],[221,187],[204,187],[198,187],[200,187],[201,187],[198,187],[221,191],[204,191],[198,191],[200,191],[201,191],[198,191],[221,230],[204,230],[198,230],[200,230],[200,230],[199,230]];
    _config.reveal_sizes=[[222,307],[203,307],[194,307],[198,307],[198,307],[203,307],[222,308],[203,308],[194,308],[198,308],[198,308],[203,308],[222,304],[203,304],[194,304],[198,304],[198,304],[203,304],[222,310],[203,310],[194,310],[198,310],[198,310],[203,310]];
}
