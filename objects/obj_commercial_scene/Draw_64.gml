if(!instance_exists(obj_capitalist_ally))exit;
var _ally=instance_find(obj_capitalist_ally,0);
if(!_ally.dialogue_active)
{
    draw_set_font(fnt_ui);draw_set_halign(fa_center);draw_set_valign(fa_top);draw_set_color(c_white);
    draw_text(display_get_gui_width()/2,14,"PORTO COMERCIAL");
    draw_set_halign(fa_left);
}
