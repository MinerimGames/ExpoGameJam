var _gui_width = display_get_gui_width();
var _gui_height = display_get_gui_height();

draw_set_alpha(1);
draw_set_color(c_white);

// Reaproveita o fundo do menu.
draw_sprite(
    spr_menu_background,
    0,
    0,
    0
);

// Escurece o fundo.
draw_set_alpha(0.72);
draw_set_color(c_black);

draw_rectangle(
    0,
    0,
    _gui_width,
    _gui_height,
    false
);

draw_set_alpha(1);

// Painel
var _panel_left = 90;
var _panel_top = 75;
var _panel_right = 550;
var _panel_bottom = 305;

// Sombra amarela
draw_set_color(make_color_rgb(240, 221, 71));

draw_rectangle(
    _panel_left - 7,
    _panel_top - 7,
    _panel_right + 7,
    _panel_bottom + 7,
    false
);

// Fundo branco
draw_set_color(c_white);

draw_rectangle(
    _panel_left,
    _panel_top,
    _panel_right,
    _panel_bottom,
    false
);

// Contorno roxo
var _purple = make_color_rgb(64, 17, 110);

draw_set_color(_purple);

draw_rectangle(
    _panel_left,
    _panel_top,
    _panel_right,
    _panel_bottom,
    true
);

draw_rectangle(
    _panel_left + 3,
    _panel_top + 3,
    _panel_right - 3,
    _panel_bottom - 3,
    true
);

// Textos
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

draw_set_font(fnt_title);
draw_set_color(_purple);

draw_text(
    _gui_width * 0.5,
    125,
    "FIM DA DEMO"
);

draw_set_font(fnt_ui);

draw_text(
    _gui_width * 0.5,
    185,
    "OBRIGADO POR JOGAR PARADOXO DE WILSON!"
);

draw_text(
    _gui_width * 0.5,
    225,
    "A JORNADA CONTINUARÁ..."
);

draw_set_color(make_color_rgb(240, 221, 71));

draw_rectangle(
    175,
    255,
    465,
    290,
    false
);

draw_set_color(_purple);

draw_rectangle(
    175,
    255,
    465,
    290,
    true
);

draw_text(
    _gui_width * 0.5,
    273,
    "ENTER - VOLTAR AO MENU"
);

// Restaura as configurações
draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);