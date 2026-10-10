// Original score and material footsteps use their own mixer state, not combat RNG.
function som_estado()
{
    if(!variable_global_exists("game_audio_state"))
        global.game_audio_state={music_name:"",ambience_name:"",music_id:-1,ambience_id:-1,
            master_gain:0.78,music_gain:0.32,ambience_gain:0.16,effect_gain:0.36,step_gain:0.38,
            retiring:[],cooldowns:{},last_room:-1,step_travel:0,last_step_time:-10000,
            step_count:0,last_step_name:"",last_effect:"",effect_count:0};
    return global.game_audio_state;
}

function som_garantir()
{
    if(!instance_exists(obj_game_audio))instance_create_depth(0,0,100000,obj_game_audio);
}

function som_piso(_room,_x,_y)
{
    if(_room==rm_steampunk_foundry)return "snd_step_stone";
    if(_room==rm_bosque)return "snd_step_leaves";
    if(_room==rm_vila)return "snd_step_dirt";
    if(_room==rm_cavernas)return "snd_step_gravel";
    if(_room==rm_cavernas_2)return "snd_step_cave";
    if(_room==rm_castelo)return "snd_step_stone";
    if(_room==rm_castle_hall)return "snd_step_wood";
    if(_room==rm_fatec_classroom)return "snd_step_wood";
    if(_room==rm_throne_room)return "snd_step_marble";
    if(_room==rm_autumn_gate || _room==rm_autumn_streets || _room==rm_autumn_plaza)
        return "snd_step_cobbles";
    if(_room==rm_commercial_district)
        return _x>=428 && _x<=526 && _y>=150 && _y<=382?"snd_step_stone":"snd_step_cobbles";
    return "snd_step_grass";
}

function som_ambiente(_room)
{
    if(_room==rm_fatec_classroom)
    {
        var _ending=instance_find(obj_fatec_ending,0);
        if(instance_exists(_ending) && variable_instance_exists(_ending,"secret_active") && _ending.secret_active)
            return _ending.secret_ambient_gain>0?_ending.secret_config.ambience:"";
    }
    if(_room==rm_steampunk_foundry)return "snd_amb_cave";
    if(_room==rm_tutorial || _room==rm_temporal_origin || _room==rm_bosque || _room==rm_vila)
        return "snd_amb_forest";
    if(_room==rm_cavernas || _room==rm_cavernas_2)return "snd_amb_cave";
    if(_room==rm_castelo || _room==rm_castle_hall || _room==rm_throne_room)return "snd_amb_castle";
    if(_room==rm_autumn_gate || _room==rm_autumn_streets || _room==rm_autumn_plaza)
        return "snd_amb_ghostcity";
    if(_room==rm_commercial_district)return "snd_amb_port";
    return "";
}

function som_musica()
{
    if(room==rm_fatec_classroom)
    {
        var _ending=instance_find(obj_fatec_ending,0);
        if(instance_exists(_ending) && variable_instance_exists(_ending,"secret_active") && _ending.secret_active)
            return _ending.secret_config.scenes[_ending.secret_index].music;
        return "snd_music_ending";
    }
    var _scene=instance_find(obj_temporal_scene,0);
    if(instance_exists(_scene) && variable_instance_exists(_scene,"newton_recording_started")
        && _scene.newton_recording_started && !_scene.newton_recording_finished
        && (_scene.scene_mode=="exposure" || _scene.scene_mode=="battle_first"
            || _scene.scene_mode=="recovery" || _scene.scene_mode=="battle_supported"))
        return "snd_newton_recording";
    var _battle=instance_find(obj_battle_controller,0);
    if(instance_exists(_battle))
    {
        if(_battle.battle_screen=="victory")
            return _battle.story_battle?"snd_music_ending":"snd_music_exploration";
        if(_battle.story_battle && _battle.story_stage==1)return "snd_music_newton";
        return "snd_music_battle";
    }
    if(instance_exists(_scene) && variable_instance_exists(_scene,"scene_mode"))
    {
        if(_scene.scene_mode=="departures" || _scene.scene_mode=="fracture")return "snd_music_newton";
        if(_scene.scene_mode=="ending" || _scene.scene_mode=="complete")return "snd_music_ending";
        var _newton=instance_find(obj_newton_final,0);
        var _revealed=instance_exists(_newton) && variable_instance_exists(_newton,"evil_revealed") && _newton.evil_revealed;
        if((variable_instance_exists(_scene,"transformation_active") && _scene.transformation_active) || _scene.scene_mode=="battle_first"
            || (_scene.scene_mode=="exposure" && _revealed))return "snd_music_newton";
        if(_scene.scene_mode=="recovery" || _scene.scene_mode=="battle_supported")return "snd_music_battle";
    }
    return "snd_music_exploration";
}

function som_transicao(_previous,_name,_gain,_loop=true)
{
    var _s=som_estado();
    if(_previous!=-1 && audio_is_playing(_previous))
    {
        audio_sound_gain(_previous,0,350);
        array_push(_s.retiring,{id:_previous,until:current_time+380});
    }
    var _asset=asset_get_index(_name);
    if(_name=="" || _asset==-1)return -1;
    var _handle=audio_play_sound(_asset,100,_loop,0);
    audio_sound_gain(_handle,_gain,350);
    return _handle;
}

function som_atualizar()
{
    var _s=som_estado();
    // The engine master also covers direct cinematic cues and the supplied recording.
    audio_master_gain(_s.master_gain);
    for(var i=array_length(_s.retiring)-1;i>=0;i--)
    {
        var _old=_s.retiring[i];
        if(current_time>=_old.until)
        {
            audio_stop_sound(_old.id);array_delete(_s.retiring,i,1);
        }
    }
    if(_s.last_room!=room)
    {
        _s.last_room=room;_s.step_travel=0;_s.last_step_time=-10000;
    }
    var _music=som_musica();var _ambient=som_ambiente(room);
    // The supplied recording plays once; after its full duration restore the score.
    if(_music=="snd_newton_recording" && _s.music_name==_music
        && _s.music_id!=-1 && !audio_is_playing(_s.music_id))
    {
        var _scene=instance_find(obj_temporal_scene,0);
        if(instance_exists(_scene))_scene.newton_recording_finished=true;
        _music=som_musica();
    }
    var _once=_music=="snd_music_ending" || _music=="snd_newton_recording";
    if(_s.music_name!=_music || (!_once && _s.music_id!=-1 && !audio_is_playing(_s.music_id)))
    {
        _s.music_id=som_transicao(_s.music_id,_music,_s.music_gain,!_once);_s.music_name=_music;
    }
    if(_s.ambience_name!=_ambient || (_s.ambience_id!=-1 && !audio_is_playing(_s.ambience_id)))
    {
        _s.ambience_id=som_transicao(_s.ambience_id,_ambient,_s.ambience_gain);_s.ambience_name=_ambient;
    }
    // Cutscene volumes remain local; persistent mixer preferences never change.
    var _ending=instance_find(obj_fatec_ending,0);
    if(instance_exists(_ending) && variable_instance_exists(_ending,"secret_active") && _ending.secret_active)
    {
        if(_s.music_id!=-1 && audio_is_playing(_s.music_id))audio_sound_gain(_s.music_id,_ending.secret_music_gain,0);
        if(_s.ambience_id!=-1 && audio_is_playing(_s.ambience_id))audio_sound_gain(_s.ambience_id,_ending.secret_ambient_gain,0);
    }
}

function som_passo(_travel,_allowed,_x,_y)
{
    var _s=som_estado();
    if(!_allowed || _travel<=0.01 || instance_exists(obj_battle_controller))
    {
        _s.step_travel=0;return false;
    }
    _s.step_travel+=_travel;
    if(_s.step_travel<32 || current_time-_s.last_step_time<334)return false;
    var _name=som_piso(room,_x,_y);var _asset=asset_get_index(_name);
    if(_asset==-1)return false;
    _s.step_travel=0;_s.last_step_time=current_time;_s.step_count++;_s.last_step_name=_name;
    var _pitch=1; // Foley stays at its original speed and pitch.
    audio_play_sound(_asset,3,false,_s.step_gain,0,_pitch);
    return true;
}

function som_efeito(_key)
{
    var _name="";
    switch(_key)
    {
        case "select": _name="snd_ui_select";break;
        case "correct": _name="snd_correct";break;
        case "wrong": _name="snd_wrong";break;
        case "attack": _name="snd_attack";break;
        case "defense": _name="snd_defense";break;
        case "heal": _name="snd_heal";break;
        case "dodge": _name="snd_dodge";break;
        case "portal": _name="snd_portal";break;
        case "transform": _name="snd_transformation";break;
        case "level": _name="snd_levelup";break;
        case "victory": _name="snd_victory";break;
        case "defeat": _name="snd_defeat";break;
    }
    var _asset=asset_get_index(_name);if(_asset==-1)return false;
    var _s=som_estado();
    var _last=variable_struct_exists(_s.cooldowns,_key)?variable_struct_get(_s.cooldowns,_key):-10000;
    if(current_time-_last<65)return false;
    variable_struct_set(_s.cooldowns,_key,current_time);
    _s.effect_count++;_s.last_effect=_key;
    audio_play_sound(_asset,10,false,_s.effect_gain);
    return true;
}

function som_parar()
{
    var _s=som_estado();
    if(_s.music_id!=-1)audio_stop_sound(_s.music_id);
    if(_s.ambience_id!=-1)audio_stop_sound(_s.ambience_id);
    for(var i=0;i<array_length(_s.retiring);i++)audio_stop_sound(_s.retiring[i].id);
    _s.retiring=[];_s.music_id=-1;_s.ambience_id=-1;_s.music_name="";_s.ambience_name="";
}
