var _gui_width = display_get_gui_width();
var _gui_height = display_get_gui_height();

draw_set_alpha(1);
draw_set_color(c_white);

draw_sprite(
    spr_menu_background,
    0,
    0,
    0
);

draw_set_font(fnt_ui);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

draw_set_font(fnt_title);

draw_set_color(color_text);

draw_text(
    _gui_width * 0.5 - 2,
    62,
    "PARADOXO DE WILSON"
);

draw_text(
    _gui_width * 0.5 + 2,
    62,
    "PARADOXO DE WILSON"
);

draw_text(
    _gui_width * 0.5,
    60,
    "PARADOXO DE WILSON"
);

draw_text(
    _gui_width * 0.5,
    64,
    "PARADOXO DE WILSON"
);

draw_set_color(color_yellow);

draw_text(
    _gui_width * 0.5,
    62,
    "PARADOXO DE WILSON"
);

draw_set_font(fnt_ui);

draw_set_color(color_white);

draw_text(
    _gui_width * 0.5,
    96,
    "A LINHA DO TEMPO PRECISA DE VOCÊ"
);

draw_set_font(fnt_ui);
draw_set_color(color_white);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

draw_text(
    _gui_width * 0.5,
    116,
    "(DEMO)"
);

for (var i = 0; i < array_length(menu_options); i++)
{
    var _button_top =
        button_y + i * (button_height + button_gap);

    var _button_bottom =
        _button_top + button_height;

    draw_set_color(color_yellow);
    draw_rectangle(
        button_x + 5,
        _button_top + 5,
        button_x + button_width + 5,
        _button_bottom + 5,
        false
    );

    if (i == menu_selected)
    {
        draw_set_color(color_yellow);
    }
    else
    {
        draw_set_color(color_white);
    }

    draw_rectangle(
        button_x,
        _button_top,
        button_x + button_width,
        _button_bottom,
        false
    );

    draw_set_color(color_text);
    draw_rectangle(
        button_x,
        _button_top,
        button_x + button_width,
        _button_bottom,
        true
    );

    draw_rectangle(
        button_x + 2,
        _button_top + 2,
        button_x + button_width - 2,
        _button_bottom - 2,
        true
    );

    draw_set_color(color_text);
    draw_text(
        button_x + button_width * 0.5,
        _button_top + button_height * 0.5,
        menu_options[i]
    );
}

draw_set_color(color_white);
draw_text(
    _gui_width * 0.5,
    _gui_height - 16,
    "W/S OU SETAS PARA NAVEGAR --- ENTER PARA CONFIRMAR"
);

if (show_controls)
{
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

    var _panel_left = 115;
    var _panel_top = 80;
    var _panel_right = 525;
    var _panel_bottom = 300;

    draw_set_color(color_yellow);
    draw_rectangle(
        _panel_left - 7,
        _panel_top - 7,
        _panel_right + 7,
        _panel_bottom + 7,
        false
    );

    draw_set_color(color_white);
    draw_rectangle(
        _panel_left,
        _panel_top,
        _panel_right,
        _panel_bottom,
        false
    );

    draw_set_color(color_text);
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

draw_set_font(fnt_ui);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

draw_set_color(color_text);

draw_text(
    _gui_width * 0.5,
    110,
    "CONTROLES"
);

var _control_keys = [
    "WASD",
    "SETAS",
    "ENTER / ESPAÇO",
    "ESC"
];

var _control_actions = [
    "MOVIMENTAR",
    "NAVEGAR NO MENU",
    "CONFIRMAR",
    "VOLTAR"
];

var _row_left = 135;
var _row_divider = 300;
var _row_right = 505;

var _row_top = 135;
var _row_height = 30;
var _row_gap = 8;

for (var i = 0; i < array_length(_control_keys); i++)
{
    var _current_top =
        _row_top + i * (_row_height + _row_gap);

    var _current_bottom =
        _current_top + _row_height;

    draw_set_color(color_yellow);

    draw_rectangle(
        _row_left,
        _current_top,
        _row_divider,
        _current_bottom,
        false
    );

    draw_set_color(color_white);

    draw_rectangle(
        _row_divider,
        _current_top,
        _row_right,
        _current_bottom,
        false
    );

    draw_set_color(color_text);

    draw_rectangle(
        _row_left,
        _current_top,
        _row_right,
        _current_bottom,
        true
    );

    draw_line(
        _row_divider,
        _current_top,
        _row_divider,
        _current_bottom
    );

    draw_text(
        (_row_left + _row_divider) * 0.5,
        (_current_top + _current_bottom) * 0.5,
        _control_keys[i]
    );

    draw_text(
        (_row_divider + _row_right) * 0.5,
        (_current_top + _current_bottom) * 0.5,
        _control_actions[i]
    );
}
}

draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);