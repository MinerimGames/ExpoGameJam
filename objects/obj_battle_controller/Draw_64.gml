update_ui_transform();

draw_set_font(fnt_ui);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

var _sx = ui_scale;
var _ox = ui_offset_x;
var _oy = ui_offset_y;

draw_set_alpha(0.25);
draw_set_color(c_black);
draw_rectangle(_ox, _oy, _ox + 960 * _sx, _oy + 540 * _sx, false);
draw_set_alpha(1);

draw_set_color(col_purple);
draw_rectangle(_ox, _oy, _ox + 960 * _sx, _oy + 540 * _sx, true);

// Status inimigo.
draw_ui_box(0, 0, 260, 112, col_white, col_yellow, 5);
draw_ui_text(12, 10, enemy_name, 1.05, col_purple);
draw_ui_text(12, 31, "NÍVEL MAT. " + string(math_phase), 0.8, col_purple);

// Barra inimigo.
draw_ui_box(12, 55, 236, 22, col_purple, col_yellow, 3);
var _enemy_ratio = enemy_hp / enemy_hp_max;
draw_set_color(col_green);
draw_rectangle(rx(18), ry(61), rx(18 + 224 * _enemy_ratio), ry(71), false);
draw_ui_text(12, 84, "HP: " + string(enemy_hp) + "/" + string(enemy_hp_max), 0.72, col_purple);

// Status jogador.
draw_ui_box(0, 428, 260, 112, col_white, col_yellow, 5);
draw_ui_text(12, 438, player_name, 1.05, col_purple);
draw_ui_text(12, 459, "NÍVEL 1", 0.8, col_purple);
draw_ui_box(12, 483, 236, 22, col_purple, col_yellow, 3);
var _player_ratio = player_hp / player_hp_max;
draw_set_color(col_green);
draw_rectangle(rx(18), ry(489), rx(18 + 224 * _player_ratio), ry(499), false);
draw_ui_text(12, 512, "HP: " + string(player_hp) + "/" + string(player_hp_max), 0.72, col_purple);

if (sprite_exists(spr_battle_isleide))
{
    draw_sprite_ext(spr_battle_isleide, 0, rx(300), ry(415), 0.40 * _sx, 0.40 * _sx, 0, c_white, 1);
}

if (sprite_exists(enemy_battle_sprite))
{
    draw_sprite_ext(
        enemy_battle_sprite,
        0,
        rx(705),
        ry(305),
        enemy_battle_scale * _sx,
        enemy_battle_scale * _sx,
        0,
        enemy_battle_blend,
        1
    );
}

if (tutorial_mode && battle_screen != "victory" && battle_screen != "defeat")
{
    draw_ui_box(285, 16, 360, 72, col_white, col_yellow, 5);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_ui_text(465, 40, "TREINO DE INCURSÃO", 0.92, col_purple);
    draw_ui_text(465, 66, tutorial_hint(), 0.78, col_purple);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

// Log de batalha.
draw_set_alpha(0.88);
draw_ui_box(275, 420, 355, 105, col_white, col_purple, 4);
draw_set_alpha(1);
draw_ui_text(
    288,
    438,
    wrap_battle_message(battle_message, 40),
    0.70,
    col_purple
);

// Menu 2x2.
draw_ui_box(650, 315, 310, 225, col_yellow, col_yellow, 1);
draw_ui_button(660, 325, 140, 90, "1 ATAQUE");
draw_ui_button(810, 325, 140, 90, "2 CURA");
draw_ui_button(660, 425, 140, 90, "3 DEFESA");
draw_ui_button(810, 425, 140, 90, "4 ESQUIVA");

// Popup matematico.
if (battle_screen == "challenge")
{
    draw_set_alpha(0.55);
    draw_set_color(c_black);
    draw_rectangle(_ox, _oy, _ox + 960 * _sx, _oy + 540 * _sx, false);
    draw_set_alpha(1);

    draw_ui_box(230, 120, 500, 290, col_yellow, col_purple, 6);
    draw_ui_box(242, 132, 476, 80, col_white, col_purple, 4);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_ui_text(480, 172, "RESOLVA A CONTA!", 1.05, col_purple);

    draw_ui_box(242, 222, 476, 90, col_white, col_purple, 4);
    draw_ui_text(
        480,
        267,
        string(challenge.x) + "   " + challenge.operacao + "   " + string(challenge.y),
        1.75,
        col_purple
    );

// Campo de resposta
draw_ui_box(
    242,
    322,
    330,
    66,
    col_white,
    col_purple,
    4
);

draw_set_halign(fa_center);
draw_set_valign(fa_middle);

draw_ui_text(
    407,
    355,
    answer_text == "" ? "RESPOSTA" : answer_text,
    1.0,
    col_purple
);

draw_ui_button(
    582,
    322,
    136,
    66,
    "OK"
);

draw_set_halign(fa_left);
draw_set_valign(fa_top);
}

if (result_visible)
{
    draw_set_alpha(0.12);
    draw_set_color(c_black);
    draw_rectangle(_ox, _oy, _ox + 960 * _sx, _oy + 540 * _sx, false);
    draw_set_alpha(1);

    draw_ui_box(350, 220, 260, 95, col_white, col_purple, 6);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_ui_text(480, 267, result_text, 1.35, col_purple);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

// Telas finais.
if (battle_screen == "victory" || battle_screen == "defeat")
{
    draw_set_alpha(0.72);
    draw_set_color(c_black);
    draw_rectangle(_ox, _oy, _ox + 960 * _sx, _oy + 540 * _sx, false);
    draw_set_alpha(1);

    draw_ui_box(220, 150, 520, 255, col_yellow, col_purple, 6);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    if (battle_screen == "victory")
    {
       if (battle_started_as_tutorial)
{
    draw_ui_text(
        480,
        210,
        "VOCÊ VENCEU!",
        1.45,
        col_purple
    );

    draw_ui_text(
        480,
        270,
        "Você concluiu o treinamento e derrotou Newton.",
        0.78,
        col_purple
    );

    draw_ui_button(
        350,
        335,
        260,
        60,
        "FALAR COM NEWTON"
    );
}
        else
        {
            var _encerra_demo = false;

if (instance_exists(enemy_source))
{
    _encerra_demo =
        (enemy_source.object_index == obj_cavern_isleide);
}

draw_ui_text(
    480, 210,
    "VOCÊ VENCEU!",
    1.45, col_purple
);

if (_encerra_demo)
{
    draw_ui_text(
        480, 270,
        "Você derrotou o Isleide das Cavernas!",
        0.78, col_purple
    );

    draw_ui_button(
        350, 335, 260, 60,
        "FINALIZAR DEMO"
    );
}
else
{
    draw_ui_text(
        480, 270,
        "A batalha acabou por enquanto.",
        0.78, col_purple
    );

    draw_ui_button(
        350, 335, 260, 60,
        "RETORNAR"
    );
}
        }
    }
    else
    {
        draw_ui_text(480, 210, "VOCÊ PERDEU!", 1.45, col_purple);
        draw_ui_text(480, 270, "Tenta de novo que agora vai.", 0.78, col_purple);
        draw_ui_button(350, 335, 260, 60, "TENTAR DE NOVO");
    }

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

draw_set_alpha(1);
draw_set_color(c_white);
