display_set_gui_size(640,380);
depth=mundo_profundidade(210);scene_mode="arrival";scene_time=0;dialogue_active=false;dialogue_page=0;dialogue_pages=[];
transformation_active=false;transformation_time=0;transformation_duration=1.05;
newton_recording_started=false;newton_recording_finished=false;
portals=[];depart_count=0;departures_started=false;departures_time=0;
depart_open_time=0.65;depart_duration=0.9;fracture_time=0;fracture_duration=0.65;
echo_x=520;echo_y=257;depart_enemy_x=560;depart_enemy_y=279;depart_enemy_sprite=spr_battle_newton;
support_sprites=[spr_isleide_cavernas,asset_get_index("spr_steampunk_idle"),spr_king_standing,spr_city_peace];
support_positions=[[380,210],[425,190],[470,190],[515,210]];
portal_label_layout=function()
{
    // GUI text keeps its SDF edges at screen resolution, independent of world zoom.
    var _gui_w=display_get_gui_width();var _gui_h=display_get_gui_height();
    var _ui_scale=min(_gui_w/640,_gui_h/380);var _text_scale=0.75*_ui_scale;
    var _view_x=0;var _view_y=0;var _view_w=room_width;var _view_h=room_height;
    if(view_enabled && view_camera[0]!=-1)
    {
        var _camera=view_camera[0];
        _view_x=camera_get_view_x(_camera);_view_y=camera_get_view_y(_camera);
        _view_w=camera_get_view_width(_camera);_view_h=camera_get_view_height(_camera);
    }
    var _font=draw_get_font();draw_set_font(fnt_ui);
    var _labels=[];var _padding=4*_ui_scale;var _gap=3*_ui_scale;
    for(var _i=0;_i<array_length(portals);_i++)
    {
        var _portal=portals[_i];
        var _width=string_width(_portal.name)*_text_scale+2*_padding;
        var _height=string_height(_portal.name)*_text_scale+6*_ui_scale;
        var _centre=(_portal.x-_view_x)/_view_w*_gui_w;
        var _x=clamp(_centre-_width/2,_padding,_gui_w-_width-_padding);
        var _y=(_portal.y-55-_view_y)/_view_h*_gui_h-_height-_padding;
        // Keep each name centred on its portal; lift crowded neighbours into rows.
        for(var _previous=0;_previous<array_length(_labels);_previous++)
        {
            var _other=_labels[_previous];
            if(_x<_other.x+_other.width+_gap && _x+_width+_gap>_other.x
                && _y<_other.y+_other.height+_gap && _y+_height+_gap>_other.y)
            {
                _y=_other.y-_height-_gap;_previous=-1;
            }
        }
        array_push(_labels,{x:_x,y:_y,width:_width,height:_height,centre_x:_x+_width/2,scale:_text_scale});
    }
    draw_set_font(_font);
    return _labels;
};
historia_newton_bloquear(true);
begin_transformation=function()
{
    var _newton=instance_find(obj_newton_final,0);
    if(transformation_active || !instance_exists(_newton) || _newton.evil_revealed)return;
    transformation_active=true;transformation_time=0;
    _newton.transformation_progress=0;
    historia_newton_bloquear(true);
    newton_recording_started=true;
    if(asset_get_index("game_audio")!=-1)som_atualizar();
};
begin_dialogue=function(_mode,_name)
{
    scene_mode=_mode;scene_time=0;dialogue_page=0;
    dialogue_pages=historia_newton_dialogo(_name);dialogue_active=true;
    historia_newton_bloquear(true);
};
start_recovery=function()
{
    if(historia_newton_progresso().finale_started || scene_mode=="recovery" || scene_mode=="battle_supported")return;
    historia_newton_progresso().stage="recovery";
    begin_dialogue("recovery","recovery");
    with(obj_player)image_angle=90;
};
start_ending=function()
{
    var _story=historia_newton_progresso();
    if(_story.finale_started)return;
    _story.finale_started=true;_story.stage="ending";
    begin_dialogue("ending","ending");
    // Open the existing zoom before the farewell so no returning ally is cropped.
    if(view_enabled && view_camera[0]!=-1)
    {
        camera_set_view_size(view_camera[0],room_width,room_height);
        camera_set_view_pos(view_camera[0],0,0);
    }
    som_efeito("transform");
};
start_departures=function()
{
    if(departures_started || scene_mode!="ending" || dialogue_active)return;
    departures_started=true;scene_mode="departures";scene_time=0;
    departures_time=0;depart_count=0;fracture_time=0;
    historia_newton_progresso().stage="departures";
    var _agent=instance_find(obj_capitalist_ally,0);var _player=instance_find(obj_player,0);
    var _past=instance_find(obj_past_wilson,0);var _newton=instance_find(obj_newton_final,0);
    var _agent_x=instance_exists(_agent)?_agent.x:430;var _agent_y=instance_exists(_agent)?_agent.y+7:307;
    var _player_x=instance_exists(_player)?_player.x:470;var _player_y=instance_exists(_player)?_player.y+7:307;
    if(instance_exists(_past)){echo_x=_past.x;echo_y=_past.y+7;}
    if(instance_exists(_newton))
    {
        depart_enemy_sprite=_newton.battle_sprite;depart_enemy_x=_newton.x;depart_enemy_y=_newton.y+7;
    }
    var _keys=["cavern","steampunk","king","city","agent","wilson"];
    var _names=["CAVERNAS","STEAMPUNK","REI","CIDADE","AGENTE","WILSON"];
    var _targets=[[340,242],[390,230],[440,220],[490,220],[540,270],[580,318]];
    var _colours=[make_color_rgb(230,152,91),make_color_rgb(110,185,255),make_color_rgb(246,219,91),
        make_color_rgb(215,134,249),make_color_rgb(108,236,152),make_color_rgb(151,246,249)];
    var _sprites=[support_sprites[0],support_sprites[1],support_sprites[2],support_sprites[3],spr_capitalist_ally,spr_wilson_idle_front];
    var _starts=[support_positions[0],support_positions[1],support_positions[2],support_positions[3],[_agent_x,_agent_y],[_player_x,_player_y]];
    portals=[];
    for(var _i=0;_i<6;_i++)
    {
        var _direction=floor(((point_direction(_starts[_i][0],_starts[_i][1],_targets[_i][0],_targets[_i][1])+45) mod 360)/90);
        array_push(portals,{key:_keys[_i],name:_names[_i],x:_targets[_i][0],y:_targets[_i][1],
            colour:_colours[_i],sprite:_sprites[_i],start_x:_starts[_i][0],start_y:_starts[_i][1],direction:_direction,departed:false});
    }
    historia_newton_bloquear(true);
    with(obj_player){visible=false;image_angle=0;}
    with(obj_capitalist_ally)visible=false;
    with(obj_past_wilson)visible=false;
    with(obj_newton_final)visible=false;
    // The finale draws its moving travellers together above the fracturing scenery.
    depth=mundo_profundidade(room_height-1);
    som_efeito("portal");
};
advance_finale=function(_dt)
{
    historia_newton_bloquear(true);
    with(obj_battle_controller)instance_destroy();
    if(scene_mode=="departures")
    {
        departures_time+=_dt;
        var _completed=clamp(floor(max(0,departures_time-depart_open_time)/depart_duration),0,6);
        while(depart_count<_completed)
        {
            portals[depart_count].departed=true;depart_count++;
        }
        if(depart_count==6)
        {
            scene_mode="fracture";scene_time=0;fracture_time=0;
            historia_newton_progresso().stage="fracture";
        }
        return;
    }
    if(scene_mode=="fracture")
    {
        fracture_time+=_dt;
        if(fracture_time<fracture_duration)return;
        var _destination=asset_get_index("rm_fatec_classroom");
        var _story=historia_newton_progresso();
        if(_destination==-1 || _story.finale_transferred)return;
        _story.finale_transferred=true;_story.stage="classroom";
        room_goto(_destination);
    }
};
advance_dialogue=function()
{
    if(!dialogue_active || transformation_active)return;
    som_efeito("select");
    if(dialogue_page<array_length(dialogue_pages)-1)
    {
        dialogue_page++;
        if(scene_mode=="exposure" && dialogue_page==5)begin_transformation();
        return;
    }
    var _newton=instance_find(obj_newton_final,0);
    if(scene_mode=="exposure" || scene_mode=="recovery")
    {
        if(!instance_exists(_newton))return;
        if(scene_mode=="exposure" && !_newton.evil_revealed)
        {
            dialogue_page=5;begin_transformation();return;
        }
    }
    dialogue_active=false;scene_time=0;
    if(scene_mode=="exposure" || scene_mode=="recovery")
    {
        var _supported=scene_mode=="recovery";
        scene_mode=_supported?"battle_supported":"battle_first";
        historia_newton_progresso().stage=scene_mode;
        _newton.battle_stage=_supported?2:1;
        with(obj_player)image_angle=0;
        batalha_iniciar(_newton,false);
    }
    else if(scene_mode=="ending")
    {
        start_departures();
    }
};
