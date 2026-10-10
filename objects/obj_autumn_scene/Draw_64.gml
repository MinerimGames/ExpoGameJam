var _hint = "PRAÇA CÍVICA";
if (room == rm_autumn_gate) _hint = "ATRAVESSE O PORTÃO";
else if (room == rm_autumn_streets) _hint = "SUBA AS ESCADAS AO NORTE";
else if (room == rm_autumn_plaza && historia_newton_progresso().city_defeated)
    _hint = "PORTAL ABERTO - ATRAVESSE-O";
draw_set_font(fnt_ui);
draw_set_halign(fa_right);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_text_transformed(display_get_gui_width()-12, 12, _hint, 0.55, 0.55, 0);
draw_set_halign(fa_left);
