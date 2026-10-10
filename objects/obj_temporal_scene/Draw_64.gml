if(scene_mode=="arrival")
{
    draw_set_alpha(clamp(1-scene_time/0.6,0,1));draw_set_color(make_color_rgb(64,17,110));
    draw_rectangle(0,0,display_get_gui_width(),display_get_gui_height(),false);
    draw_set_alpha(1);draw_set_color(c_white);
}
if(transformation_active)
{
    var _newton=instance_find(obj_newton_final,0);
    if(instance_exists(_newton))
    {
        var _s=min(display_get_gui_width()/960,display_get_gui_height()/540);
        var _ox=(display_get_gui_width()-960*_s)/2;
        var _oy=(display_get_gui_height()-540*_s)/2;
        var _progress=clamp(transformation_time/transformation_duration,0,1);
        var _pulse=sin(_progress*pi);
        var _flash=max(0,1-abs(_progress-0.57)/0.13);
        draw_set_color(make_color_rgb(88,29,125));draw_set_alpha(_pulse*0.15);
        draw_rectangle(0,0,display_get_gui_width(),display_get_gui_height(),false);
        draw_set_color(make_color_rgb(244,230,162));draw_set_alpha(_flash*0.28);
        draw_rectangle(0,0,display_get_gui_width(),display_get_gui_height(),false);
        var _cx=_ox+480*_s;var _feet=_oy+340*_s;var _height=148*_s;
        draw_set_color(make_color_rgb(201,112,255));draw_set_alpha(_pulse*0.85);
        draw_circle(_cx,_oy+265*_s,(58+25*_progress)*_s,true);
        draw_circle(_cx,_oy+265*_s,(39+43*_progress)*_s,true);
        historia_newton_retrato(_newton.normal_sprite,_cx,_feet,_height,1-_progress);
        historia_newton_retrato(_newton.evil_sprite,_cx,_feet,_height,_progress);
        draw_set_alpha(1);draw_set_color(c_white);
    }
}
if(scene_mode=="ending")
{
    // The rupture starts while the Agent speaks; draw it below the dialogue box.
    var _w=display_get_gui_width();var _h=display_get_gui_height();
    var _pulse=0.5+0.5*sin(scene_time*5);
    draw_set_color(make_color_rgb(89,30,123));draw_set_alpha(0.035+0.035*_pulse);
    draw_rectangle(0,0,_w,_h,false);
    draw_set_color(make_color_rgb(218,177,255));draw_set_alpha(0.10+0.07*_pulse);
    draw_line_width(0,20,_w*0.17,_h*0.20,1);
    draw_line_width(_w*0.17,_h*0.20,_w*0.13,_h*0.32,1);
    draw_line_width(_w,35,_w*0.83,_h*0.18,1);
    draw_line_width(_w*0.83,_h*0.18,_w*0.87,_h*0.30,1);
    draw_set_alpha(1);draw_set_color(c_white);
}
if(dialogue_active)historia_newton_desenhar_dialogo(dialogue_pages[dialogue_page],dialogue_page,array_length(dialogue_pages));
if(scene_mode=="departures" || scene_mode=="fracture")
{
    var _fs=min(display_get_gui_width()/960,display_get_gui_height()/540);
    var _fox=(display_get_gui_width()-960*_fs)/2;var _foy=(display_get_gui_height()-540*_fs)/2;
    var _fracture=clamp(departures_time/6.05,0,1);
    var _light=0.5+0.5*sin(departures_time*9);
    draw_set_color(make_color_rgb(78,25,106));draw_set_alpha(0.07+_fracture*0.13);
    draw_rectangle(0,0,display_get_gui_width(),display_get_gui_height(),false);
    var _cracks=[[[65,35],[175,118],[140,171],[260,232]],[[878,42],[789,141],[827,206],[681,268]],
        [[34,438],[191,370],[154,315],[309,270]],[[910,476],[746,394],[792,339],[637,295]],
        [[405,0],[458,102],[421,154],[477,228]],[[519,540],[561,448],[526,393],[575,326]]];
    draw_set_color(make_color_rgb(210,173,255));draw_set_alpha(_fracture*(0.3+0.4*_light));
    for(var _ci=0;_ci<array_length(_cracks);_ci++)
    {
        var _crack=_cracks[_ci];
        for(var _pi=1;_pi<array_length(_crack);_pi++)
            draw_line_width(_fox+_crack[_pi-1][0]*_fs,_foy+_crack[_pi-1][1]*_fs,
                _fox+_crack[_pi][0]*_fs,_foy+_crack[_pi][1]*_fs,max(1,2*_fs));
    }
    draw_set_color(make_color_rgb(244,232,255));draw_set_alpha(_fracture*_light*0.10);
    draw_rectangle(0,0,display_get_gui_width(),display_get_gui_height(),false);
    // Draw the portal names above the scenery/cracks and below the final white fade.
    var _label_font=draw_get_font();var _labels=portal_label_layout();
    var _label_ui=min(display_get_gui_width()/640,display_get_gui_height()/380);
    var _label_opening=clamp(departures_time/depart_open_time,0,1);
    draw_set_font(fnt_ui);draw_set_halign(fa_center);draw_set_valign(fa_top);
    for(var _li=0;_li<array_length(_labels);_li++)
    {
        var _label=_labels[_li];var _portal=portals[_li];
        var _label_alpha=_label_opening*(_portal.departed?0.52:1);
        draw_set_color(make_color_rgb(16,11,25));draw_set_alpha(_label_alpha*0.86);
        draw_rectangle(_label.x,_label.y,_label.x+_label.width,_label.y+_label.height,false);
        draw_set_color(_portal.colour);draw_set_alpha(_label_alpha);
        draw_rectangle(_label.x,_label.y+_label.height-_label_ui,_label.x+_label.width,_label.y+_label.height,false);
        draw_set_color(c_white);
        draw_text_transformed(_label.centre_x,_label.y+3*_label_ui,_portal.name,_label.scale,_label.scale,0);
    }
    draw_set_font(_label_font);
    if(scene_mode=="fracture")
    {
        draw_set_color(c_white);draw_set_alpha(clamp(fracture_time/fracture_duration,0,1));
        draw_rectangle(0,0,display_get_gui_width(),display_get_gui_height(),false);
    }
    else
    {
        var _caption=depart_count<5?"TODOS VOLTAM ÀS PRÓPRIAS REALIDADES":"WILSON, É SUA VEZ DE VOLTAR.";
        draw_set_font(fnt_ui);draw_set_halign(fa_center);draw_set_valign(fa_top);
        draw_set_color(c_black);draw_set_alpha(0.38);
        draw_rectangle(_fox+120*_fs,_foy+487*_fs,_fox+840*_fs,_foy+529*_fs,false);
        draw_set_color(c_white);draw_set_alpha(1);
        draw_text_transformed(_fox+480*_fs,_foy+501*_fs,_caption,0.75*_label_ui,0.75*_label_ui,0);
    }
    draw_set_alpha(1);draw_set_color(c_white);draw_set_halign(fa_left);draw_set_valign(fa_top);
}
