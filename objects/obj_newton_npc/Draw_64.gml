if (instance_exists(obj_battle_controller))
{
    exit;
}

npc_update_ui();

var _purple = make_color_rgb(64, 17, 110);
var _yellow = make_color_rgb(240, 221, 71);
var _white = c_white;

if (interaction_available && !dialogue_active)
{
    npc_draw_box(330, 472, 300, 46, _white, _purple, 4);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    npc_draw_text(480, 495, "E / ESPACO - FALAR COM NEWTON", 0.82, _purple);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

if (!dialogue_active)
{
    exit;
}

draw_set_alpha(0.18);
draw_set_color(c_black);
draw_rectangle(npc_rx(0), npc_ry(0), npc_rx(960), npc_ry(540), false);
draw_set_alpha(1);

npc_draw_box(70, 350, 820, 165, _white, _purple, 6);
draw_set_color(_purple);
draw_triangle(npc_rx(165), npc_ry(515), npc_rx(205), npc_ry(515), npc_rx(175), npc_ry(535), false);
draw_set_color(_white);
draw_triangle(npc_rx(171), npc_ry(509), npc_rx(198), npc_ry(509), npc_rx(176), npc_ry(526), false);

if (sprite_exists(spr_battle_newton))
{
    draw_sprite_ext(spr_battle_newton, 0, npc_rx(145), npc_ry(493), 0.17 * npc_ui_scale, 0.17 * npc_ui_scale, 0, c_white, 1);
}

npc_draw_text(205, 367, "ISLEIDE NEWTON", 1.05, _purple);
draw_set_color(_yellow);
draw_rectangle(npc_rx(205), npc_ry(391), npc_rx(850), npc_ry(395), false);

var _pages = npc_current_dialogue();
var _text = _pages[clamp(dialogue_page, 0, array_length(_pages) - 1)];

var _wrapped = string(_text);
var _max_chars = 60;
var _words = string_split(_wrapped, " ");
var _line = "";
var _output = "";
for (var i = 0; i < array_length(_words); i++)
{
    var _word = _words[i];
    var _test = (_line == "") ? _word : _line + " " + _word;
    if (string_length(_test) > _max_chars)
    {
        _output += _line + chr(10);
        _line = _word;
    }
    else
    {
        _line = _test;
    }
}
_output += _line;

npc_draw_text(205, 408, _output, 0.88, _purple);

draw_set_halign(fa_right);
npc_draw_text(850, 489, "E / ESPACO  >>", 0.72, _purple);
draw_set_halign(fa_left);

draw_set_alpha(1);
draw_set_color(c_white);
