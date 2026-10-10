var _filter=gpu_get_texfilter();gpu_set_texfilter(false);
if(elapsed<1.6)
{
    var _alpha=clamp(1-elapsed/1.6,0,1);
    draw_set_color(make_color_rgb(138,92,215));draw_set_alpha(_alpha*0.28);
    draw_ellipse(445,497,515,574,false);
    draw_set_alpha(_alpha*0.85);draw_set_color(make_color_rgb(247,226,145));
    draw_ellipse(451,504,509,571,true);
}
draw_set_alpha(0.22);draw_set_color(make_color_rgb(29,35,30));
draw_ellipse(professor_x-12,professor_y+4,professor_x+12,professor_y+10,false);
draw_set_alpha(1);draw_set_color(c_white);
if(phase=="arrival")
{
    var _frame=elapsed<0.7?0:(floor(walk_travel/8) mod 6);
    wilson_desenhar_mapa(professor_x,professor_y+7,1,_frame,professor_height);
}
else
{
    historia_newton_retrato(spr_wilson_professor,professor_x,professor_y+7,
        professor_height*(1+0.009*sin(elapsed*2.4)));
}
gpu_set_texfilter(_filter);draw_set_alpha(1);draw_set_color(c_white);
