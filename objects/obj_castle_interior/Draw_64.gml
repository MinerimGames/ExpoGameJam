if (room != rm_castle_hall) exit;
draw_set_font(fnt_ui);
draw_set_color(c_white);
draw_set_halign(fa_right);
draw_set_valign(fa_top);
draw_text_transformed(display_get_gui_width()-12, 12,
    "SIGA O TAPETE ATÉ A SALA DO TRONO", 0.55, 0.55, 0);
draw_set_halign(fa_left);
