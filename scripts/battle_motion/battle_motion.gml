// Presentation only: no physics, HP, random calls or turn changes.
function batalha_animacao_iniciar(_battle)
{
    with(_battle)
    {
        motion_clock=0;motion_events=[];
        motion_emit=function(_role,_kind,_duration=0.45,_delay=0)
        {
            array_push(motion_events,{role:_role,kind:_kind,time:-_delay,duration:_duration});
            // Simulation tests can resolve many turns without a Step in between.
            if(array_length(motion_events)>24)array_delete(motion_events,0,1);
        };
        motion_visual=function(_role)
        {
            var _phase=_role=="player"?0.2:(_role=="enemy"?1.3:2.4);
            if(string_pos("support",_role)==1)_phase+=real(string_digits(_role))*1.7;
            var _v={kind:"idle",x:0,y:0,sx:1,sy:1+sin(motion_clock*2.4+_phase)*0.012,
                angle:sin(motion_clock*1.6+_phase)*0.85,blend:c_white};
            var _selected=undefined;
            for(var i=0;i<array_length(motion_events);i++)
            {
                var _e=motion_events[i];
                if(_e.role==_role && _e.time>=0 && _e.time<_e.duration)_selected=_e;
            }
            if(is_undefined(_selected))return _v;
            var _p=clamp(_selected.time/_selected.duration,0,1);
            var _pulse=sin(pi*_p);var _toward=_role=="enemy"?-1:1;
            _v.kind=_selected.kind;
            switch(_selected.kind)
            {
                case "attack":_v.x=_toward*20*_pulse;_v.y=-5*_pulse;_v.angle=_toward*4*_pulse;break;
                case "hurt":_v.x=-_toward*10*_pulse;_v.angle=-_toward*3*_pulse;
                    _v.blend=merge_color(c_white,c_red,0.55*_pulse);break;
                case "defense":_v.sx=1+0.025*_pulse;_v.sy=1-0.025*_pulse;
                    _v.blend=merge_color(c_white,make_color_rgb(130,195,255),0.35*_pulse);break;
                case "dodge":_v.x=-_toward*24*_pulse;_v.y=-4*_pulse;_v.angle=-_toward*6*_pulse;break;
                case "heal":_v.y=-4*_pulse;_v.sy+=0.02*_pulse;
                    _v.blend=merge_color(c_white,make_color_rgb(90,255,160),0.45*_pulse);break;
            }
            return _v;
        };
        draw_motion=function(_sprite,_x,_y,_scale,_role,_facing=1,_blend=c_white,_alpha=1)
        {
            // Steampunk keeps authored still poses, with no sway or action offsets.
            if(_sprite==spr_steampunk_idle || _sprite==spr_steampunk_talk
                || _sprite==spr_steampunk_attack || _sprite==spr_steampunk_defense)
            {draw_sprite_ext(_sprite,0,_x,_y,_scale*_facing,_scale,0,_blend,_alpha);return;}
            var _v=motion_visual(_role);
            var _color=_v.blend==c_white?_blend:_v.blend;
            draw_sprite_ext(_sprite,0,_x+_v.x*ui_scale,_y+_v.y*ui_scale,
                _scale*_facing*_v.sx,_scale*_v.sy,_v.angle,_color,_alpha);
        };
    }
}

function batalha_animacao_atualizar(_battle)
{
    with(_battle)
    {
        var _dt=min(delta_time/1000000,0.1);motion_clock+=_dt;
        for(var i=array_length(motion_events)-1;i>=0;i--)
        {
            var _e=motion_events[i];_e.time+=_dt;
            if(_e.time>=_e.duration)array_delete(motion_events,i,1);
        }
    }
}
