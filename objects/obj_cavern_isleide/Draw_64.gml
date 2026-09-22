/// Fala incompreensível antes da luta.

if (!dialogue_active || instance_exists(obj_battle_controller))
    exit;

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();
var _scale = min(_gw / 960, _gh / 540);
var _ox = (_gw - 960 * _scale) * 0.5;
var _oy = (_gh - 540 * _scale) * 0.5;
var _purple = make_color_rgb(64, 17, 110);
var _yellow = make_color_rgb(240, 221, 71);

draw_set_alpha(0.20);
draw_set_color(c_black);
draw_rectangle(_ox, _oy, _ox + 960 * _scale, _oy + 540 * _scale, false);
draw_set_alpha(1);

draw_set_color(_purple);
draw_rectangle(_ox + 70 * _scale, _oy + 350 * _scale, _ox + 890 * _scale, _oy + 515 * _scale, false);
draw_set_color(c_white);
draw_rectangle(_ox + 76 * _scale, _oy + 356 * _scale, _ox + 884 * _scale, _oy + 509 * _scale, false);

draw_sprite_ext(
    spr_isleide_cavernas,
    0,
    _ox + 152 * _scale,
    _oy + 505 * _scale,
    0.22 * _scale,
    0.22 * _scale,
    0,
    c_white,
    1
);

draw_set_font(fnt_ui);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(_purple);
draw_text_transformed(_ox + 220 * _scale, _oy + 370 * _scale, "ISLEIDE DAS CAVERNAS", 1.0 * _scale, 1.0 * _scale, 0);
draw_set_color(_yellow);
draw_rectangle(_ox + 220 * _scale, _oy + 397 * _scale, _ox + 850 * _scale, _oy + 401 * _scale, false);

var _text = dialogue_pages[clamp(dialogue_page, 0, array_length(dialogue_pages) - 1)];
draw_set_color(_purple);
draw_text_transformed(_ox + 220 * _scale, _oy + 420 * _scale, _text, 0.88 * _scale, 0.88 * _scale, 0);

draw_set_halign(fa_right);
draw_text_transformed(_ox + 850 * _scale, _oy + 482 * _scale, "E / ESPAÇO  >>", 0.72 * _scale, 0.72 * _scale, 0);
draw_set_halign(fa_left);
draw_set_color(c_white);
