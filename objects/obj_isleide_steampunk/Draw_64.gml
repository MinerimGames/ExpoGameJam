if(!assets_ready || !dialogue_active || instance_exists(obj_battle_controller))exit;
var _gw=display_get_gui_width();var _gh=display_get_gui_height();
var _scale=min(_gw/960,_gh/540);
var _ox=(_gw-960*_scale)*0.5;var _oy=(_gh-540*_scale)*0.5;
var _bronze=make_color_rgb(77,47,25);var _gold=make_color_rgb(229,177,73);
var _page=clamp(dialogue_page,0,array_length(dialogue_pages)-1);
var _old_colour=draw_get_color();var _old_alpha=draw_get_alpha();var _old_font=draw_get_font();
draw_set_alpha(0.18);draw_set_color(c_black);
draw_rectangle(_ox,_oy,_ox+960*_scale,_oy+540*_scale,false);
draw_set_alpha(1);draw_set_color(_bronze);
draw_rectangle(_ox+70*_scale,_oy+350*_scale,_ox+890*_scale,_oy+515*_scale,false);
draw_set_color(make_color_rgb(250,242,218));
draw_rectangle(_ox+76*_scale,_oy+356*_scale,_ox+884*_scale,_oy+509*_scale,false);
var _portrait=dialogue_portraits[_page];
var _portrait_scale=134/(sprite_get_bbox_bottom(_portrait)-sprite_get_bbox_top(_portrait)+1);
draw_sprite_ext(_portrait,0,_ox+152*_scale,_oy+505*_scale,
    _portrait_scale*_scale,_portrait_scale*_scale,0,c_white,1);
draw_set_font(fnt_ui);draw_set_halign(fa_left);draw_set_valign(fa_top);draw_set_color(_bronze);
draw_text_transformed(_ox+220*_scale,_oy+370*_scale,dialogue_speakers[_page],_scale,_scale,0);
draw_set_color(_gold);
draw_rectangle(_ox+220*_scale,_oy+397*_scale,_ox+850*_scale,_oy+401*_scale,false);
draw_set_color(_bronze);
var _words=string_split(dialogue_pages[_page]," ");var _line="";var _output="";
for(var _i=0;_i<array_length(_words);_i++)
{
    var _test=_line==""?_words[_i]:_line+" "+_words[_i];
    if(string_width(_test)*0.88>630){_output+=_line+chr(10);_line=_words[_i];}
    else _line=_test;
}
_output+=_line;
draw_text_transformed(_ox+220*_scale,_oy+414*_scale,_output,0.88*_scale,0.88*_scale,0);
draw_set_halign(fa_right);
draw_text_transformed(_ox+850*_scale,_oy+482*_scale,"E / ESPAÇO  >>",0.72*_scale,0.72*_scale,0);
draw_set_halign(fa_left);draw_set_valign(fa_top);
draw_set_font(_old_font);draw_set_alpha(_old_alpha);draw_set_color(_old_colour);
