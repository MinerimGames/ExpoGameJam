/// Indica a continuação da área sem interromper a exploração.

var _gw = display_get_gui_width();
var _scale = min(_gw / 960, display_get_gui_height() / 540);

draw_set_font(fnt_ui);
draw_set_halign(fa_right);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_text_transformed(_gw - 18 * _scale, 18 * _scale, "AVANCE  >>", 0.8 * _scale, 0.8 * _scale, 0);
draw_set_halign(fa_left);
