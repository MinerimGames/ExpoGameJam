var _gui_width=display_get_gui_width();
var _gui_height=display_get_gui_height();
draw_set_alpha(1);draw_set_color(c_black);
draw_rectangle(0,0,_gui_width,_gui_height,false);
var _poster_scale=min(_gui_width/sprite_get_width(spr_menu_poster),_gui_height/sprite_get_height(spr_menu_poster));
var _poster_x=(_gui_width-sprite_get_width(spr_menu_poster)*_poster_scale)*0.5;
var _poster_y=(_gui_height-sprite_get_height(spr_menu_poster)*_poster_scale)*0.5;
draw_sprite_ext(spr_menu_poster,0,_poster_x,_poster_y,_poster_scale,_poster_scale,0,c_white,1);
// The supplied poster already contains its title and subtitle.
draw_set_font(fnt_ui);draw_set_halign(fa_center);draw_set_valign(fa_middle);
for(var i=0;i<array_length(menu_options);i++)
{
    var _button=menu_button(i);
    draw_set_color(color_text);
    draw_rectangle(_button.x-3,_button.y-3,_button.x+_button.w+3,_button.y+_button.h+3,false);
    draw_set_color(i==menu_selected?color_yellow:color_white);
    draw_rectangle(_button.x,_button.y,_button.x+_button.w,_button.y+_button.h,false);
    draw_set_color(color_text);
    draw_text(_button.x+_button.w*0.5,_button.y+_button.h*0.5,menu_options[i]);
}
draw_set_color(color_white);
var _hint = os_browser == browser_not_a_browser
    ? "SETAS / WASD: NAVEGAR   ENTER: CONFIRMAR   F11: TELA CHEIA"
    : "SETAS / WASD: NAVEGAR   ENTER: CONFIRMAR   CLIQUE: TELA CHEIA";
draw_text_transformed(_gui_width*0.5,375,_hint,0.50,0.50,0);

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
    var _panel_bottom = 332;

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
    "WASD / SETAS",
    "SETAS",
    "ENTER / ESPAÇO",
    "ESC",
    os_browser == browser_not_a_browser ? "F11" : "BOTÃO DO MENU"
];

var _control_actions = [
    "MOVIMENTAR",
    "NAVEGAR NO MENU",
    "CONFIRMAR",
    "VOLTAR",
    "TELA CHEIA"
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
