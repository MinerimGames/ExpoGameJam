var _w=display_get_gui_width();var _h=display_get_gui_height();
draw_set_font(fnt_ui);draw_set_halign(fa_center);draw_set_valign(fa_top);
if(secret_active)
{
    segredo_trono_desenhar(id,_w,_h);
    exit;
}
if(phase=="showcase")fatec_apresentacao_desenhar(id,_w,_h);
else if(phase!="credits_ready")
{
    draw_set_alpha(0.80);draw_set_color(make_color_rgb(35,31,54));
    draw_rectangle(106,12,_w-106,49,false);draw_set_alpha(1);draw_set_color(c_white);
    draw_text_transformed(_w/2,20,"FATEC - SUA REALIDADE",0.7,0.7,0);
    if(phase=="home")
    {
        draw_set_alpha(0.85);draw_set_color(make_color_rgb(35,31,54));
        draw_rectangle(100,_h-53,_w-100,_h-15,false);draw_set_alpha(1);draw_set_color(c_white);
        draw_text_transformed(_w/2,_h-44,"O professor voltou para casa.",0.65,0.65,0);
    }
}
var _fade=elapsed<0.7?clamp(1-elapsed/0.7,0,1):clamp((elapsed-home_duration)/(blackout_time-home_duration),0,1);
draw_set_alpha(_fade);draw_set_color(phase=="credits_ready"?make_color_rgb(22,14,38):c_black);
draw_rectangle(0,0,_w,_h,false);draw_set_alpha(1);
if(phase=="credits_ready")
{
    draw_set_color(make_color_rgb(38,23,61));draw_rectangle(143,70,497,354,false);
    draw_set_color(make_color_rgb(121,74,144));draw_line(155,68,485,68);
    draw_set_color(make_color_rgb(251,222,77));
    draw_text_transformed(_w/2,12,"O PARADOXO DE WILSON",0.82,0.82,0);
    draw_set_color(c_white);draw_text_transformed(_w/2,37,credits_heading,0.62,0.62,0);
    draw_set_color(make_color_rgb(189,170,211));
    draw_text_transformed(_w/2,56,"PARTICIPANTES",0.44,0.44,0);
    var _y=74;
    for(var i=0;i<array_length(credits);i++)
    {
        var _credit=credits[i];
        draw_set_color(make_color_rgb(243,203,96));
        draw_text_transformed(_w/2,_y,_credit.role,0.5,0.5,0);_y+=12;
        draw_set_color(c_white);
        for(var j=0;j<array_length(_credit.names);j++)
        {
            draw_text_transformed(_w/2,_y,_credit.names[j],0.62,0.62,0);_y+=14;
        }
        _y+=7;
    }
    var _filter=gpu_get_texfilter();gpu_set_texfilter(false);
    for(var i=0;i<array_length(credit_variants);i++)
    {
        var _variant=credit_variants[i];
        if(_variant.sprite==-1)continue;
        draw_set_alpha(0.35);draw_set_color(make_color_rgb(105,72,132));
        draw_ellipse(_variant.x-34,_variant.feet-4,_variant.x+34,_variant.feet+4,false);
        draw_set_alpha(1);draw_set_color(c_white);
        mundo_desenhar_personagem(_variant.sprite,_variant.x,_variant.feet,
            _variant.height*(1+0.010*sin(elapsed*2.4+i*1.7)),1,0,116);
    }
    gpu_set_texfilter(_filter);
    draw_set_color(make_color_rgb(189,170,211));
    draw_text_transformed(_w/2,362,"ENTER / E - VOLTAR AO MENU",0.5,0.5,0);
}
draw_set_halign(fa_left);draw_set_valign(fa_top);draw_set_alpha(1);draw_set_color(c_white);
