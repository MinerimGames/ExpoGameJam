if(scene_mode=="recovery" || scene_mode=="battle_supported" || scene_mode=="ending")
{
    var _alpha=scene_mode=="recovery"?min(0.75,scene_time*0.65):0.42;
    for(var i=0;i<4;i++)historia_newton_retrato(support_sprites[i],support_positions[i][0],support_positions[i][1],28,_alpha);
}
if(scene_mode=="departures" || scene_mode=="fracture")
{
    var _old_alpha=draw_get_alpha();var _old_colour=draw_get_color();var _old_font=draw_get_font();
    var _opening=clamp(departures_time/depart_open_time,0,1);
    var _frame=floor(departures_time*12) mod max(1,sprite_get_number(spr_portal));
    for(var _i=0;_i<array_length(portals);_i++)
    {
        var _portal=portals[_i];var _pulse=0.7+0.3*sin(departures_time*7+_i);
        var _portal_alpha=_portal.departed?0.26:0.92;
        draw_set_color(_portal.colour);draw_set_alpha(_opening*_portal_alpha*0.14);
        draw_ellipse(_portal.x-20,_portal.y-55,_portal.x+20,_portal.y+5,false);
        draw_set_alpha(_opening*_portal_alpha*(0.55+0.35*_pulse));
        draw_ellipse(_portal.x-13*_opening,_portal.y-48*_opening,_portal.x+13*_opening,_portal.y,true);
        draw_sprite_ext(spr_portal,_frame,_portal.x,_portal.y,0.65*_opening,0.72*_opening,0,_portal.colour,_portal_alpha*_opening);
        if(_portal.departed)continue;
        var _progress=clamp((departures_time-depart_open_time-_i*depart_duration)/depart_duration,0,1);
        var _walk=clamp(_progress/0.65,0,1);_walk=_walk*_walk*(3-2*_walk);
        var _x=lerp(_portal.start_x,_portal.x,_walk);var _y=lerp(_portal.start_y,_portal.y-5,_walk);
        var _fade=1-clamp((_progress-0.65)/0.35,0,1);
        var _height=(_i==4?34:28)*(0.55+0.45*_fade);
        if(_i==5)
        {
            var _direction=_portal.direction;
            var _walk_frame=_progress>0?floor(departures_time*10) mod 6:0;
            if(!wilson_desenhar_mapa(_x,_y,_direction,_walk_frame,_height,_fade))
                historia_newton_retrato(_portal.sprite,_x,_y,_height,_fade);
        }
        else historia_newton_retrato(_portal.sprite,_x,_y,_height,_fade);
    }
    var _echo=1-clamp(departures_time/0.95,0,1);
    if(_echo>0)
    {
        historia_newton_retrato(spr_wilson_idle_front,echo_x,echo_y-12*(1-_echo),28,_echo*0.65);
        draw_set_color(make_color_rgb(164,235,255));draw_set_alpha(_echo*0.5);
        draw_circle(echo_x,echo_y-12,8+16*(1-_echo),true);
    }
    if(_opening<1)historia_newton_retrato(depart_enemy_sprite,depart_enemy_x,depart_enemy_y,30,0.4*(1-_opening));
    draw_set_alpha(_old_alpha);draw_set_color(_old_colour);draw_set_font(_old_font);
    draw_set_halign(fa_left);draw_set_valign(fa_top);
}
