update_ui_transform();

draw_set_font(fnt_ui);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

var _sx = ui_scale;
var _ox = ui_offset_x;
var _oy = ui_offset_y;

draw_set_alpha(1);
draw_set_color(battle_environment == "grasslands" ? make_color_rgb(18, 35, 26) : make_color_rgb(24, 20, 38));
// Hide exploration across the whole GUI, including the centered UI margins.
draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
draw_set_alpha(1);

draw_set_color(col_purple);
draw_rectangle(_ox, _oy, _ox + 960 * _sx, _oy + 540 * _sx, true);

// Status inimigo.
draw_ui_box(0, 0, 260, 112, col_white, col_yellow, 5);
draw_ui_text(12, 10, enemy_name, 1.05, col_purple);
var _math_label = math_profile == "royal_alternating"
    ? "SOMA / MULTIPLICAÇÃO"
    : "NÍVEL MAT. " + string(math_phase);
if(story_battle)_math_label=story_stage==1?"CÁLCULO UNIVERSAL":"CÁLCULOS COMPARTILHADOS";
draw_ui_text(12, 31, _math_label, 0.8, col_purple);

// Barra inimigo.
draw_ui_box(12, 55, 236, 22, col_purple, col_yellow, 3);
var _enemy_ratio = enemy_hp / enemy_hp_max;
draw_set_color(col_green);
draw_rectangle(rx(18), ry(61), rx(18 + 224 * _enemy_ratio), ry(71), false);
draw_ui_text(12, 84, "HP: " + string(enemy_hp) + "/" + string(enemy_hp_max), 0.72, col_purple);

// Status jogador.
draw_ui_box(0, 428, 260, 112, col_white, col_yellow, 5);
draw_ui_text(12, 438, player_name, 1.05, col_purple);
var _progress = matematica_progresso();
draw_ui_text(12, 459, "COMPREENSÃO " + string(_progress.level), 0.62, col_purple);
draw_set_halign(fa_right);
draw_ui_text(248, 459, "XP: " + string(_progress.xp_total), 0.62, col_purple);
draw_set_halign(fa_left);
draw_ui_box(12, 483, 236, 22, col_purple, col_yellow, 3);
var _player_ratio = player_hp / player_hp_max;
draw_set_color(col_green);
draw_rectangle(rx(18), ry(489), rx(18 + 224 * _player_ratio), ry(499), false);
draw_ui_text(12, 512, "HP: " + string(player_hp) + "/" + string(player_hp_max), 0.72, col_purple);

var _player_visual = player_visual();
if (sprite_exists(_player_visual.sprite))
{
    draw_motion(_player_visual.sprite,rx(story_battle?220:300),ry(415),
        _player_visual.scale*_sx*(story_battle?200/232:1),"player",_player_visual.facing);
}
if(story_battle)
{
    draw_motion(spr_capitalist_ally,rx(385),ry(415),200*_sx/(sprite_get_bbox_bottom(spr_capitalist_ally)-sprite_get_bbox_top(spr_capitalist_ally)+1),"ally");
    if(story_stage==2)
    {
        var _supports=[spr_isleide_cavernas,spr_steampunk_idle,spr_king_standing,spr_city_peace];
        for(var i=0;i<4;i++)draw_motion(_supports[i],rx(310+i*90),ry(215),45*_sx/(sprite_get_bbox_bottom(_supports[i])-sprite_get_bbox_top(_supports[i])+1),"support"+string(i),1,c_white,0.42);
    }
}

var _enemy_visual = enemy_visual();
if (sprite_exists(_enemy_visual.sprite))
{
    draw_motion(_enemy_visual.sprite,rx(705),ry(305),_enemy_visual.scale*_sx,
        "enemy",1,enemy_battle_blend);
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

// O aviso usa o espaço entre os status e os retratos, sem mudar os botões.
if (battle_screen != "victory" && battle_screen != "defeat")
{
    draw_ui_box(285, 96, 260, 64, col_white, enemy_intent == "strong" ? col_yellow : col_purple, 4);
    var _environment_label = "INCURSÃO";
    switch (battle_environment)
    {
        case "grasslands": _environment_label = "REGIÃO INICIAL"; break;
        case "cavern": _environment_label = "CAVERNAS"; break;
        case "cavern_camp": _environment_label = "ACAMPAMENTO DAS CAVERNAS"; break;
        case "medieval": _environment_label = "ENTRADA DO CASTELO"; break;
        case "throne": _environment_label = "TRONO REAL"; break;
        case "steampunk": _environment_label = "FUNDIÇÃO DO TEMPO"; break;
        case "ghost_city": _environment_label = "CIDADE FANTASMA"; break;
    }
    if(story_battle && story_stage==2)_environment_label="APOIO DAS REALIDADES";
    draw_set_halign(fa_center);
    draw_ui_text(415, 101, _environment_label, 0.52, col_purple);
    var _intent_title = "ATAQUE NORMAL";
    var _intent_hint = "ESCOLHA SUA AÇÃO";
    if (enemy_intent == "strong")
    {
        _intent_title = "ATAQUE FORTE!";
        _intent_hint = dodge_cooldown == 0 ? "DEFENDA OU ESQUIVE" : "DEFENDA! ESQUIVA RECARREGANDO";
        draw_set_color(col_yellow);
        draw_triangle(rx(297), ry(134), rx(303), ry(119), rx(309), ry(134), false);
        draw_set_color(col_purple);
        draw_line(rx(303), ry(124), rx(303), ry(129));
        draw_point(rx(303), ry(132));
    }
    else if (enemy_intent == "vulnerable")
    {
        _intent_title = "INIMIGO VULNERÁVEL!";
        _intent_hint = "APROVEITE PARA ATACAR";
    }
    draw_ui_text(415, 115, _intent_title, 0.78, col_purple);
    draw_ui_text(415, 139, _intent_hint, 0.58, col_purple);
    draw_set_halign(fa_left);
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
var _heal_label = "2 CURA" + chr(10) + (heal_cooldown == 0 ? "PRONTA" : string(heal_cooldown) + (heal_cooldown == 1 ? " TURNO" : " TURNOS"));
draw_ui_button(810, 325, 140, 90, _heal_label);
draw_ui_button(660, 425, 140, 90, "3 DEFESA");
var _dodge_label = "4 ESQUIVA" + chr(10) + (dodge_cooldown == 0 ? "PRONTA"
    : string(dodge_cooldown) + (dodge_cooldown == 1 ? " TURNO" : " TURNOS"));
draw_ui_button(810, 425, 140, 90, _dodge_label);

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
    draw_ui_text(480, story_battle && story_stage==1?156:172,
        pending_action == "dodge" ? "ACERTE PARA ESQUIVAR SEM DANO!" : "RESOLVA A CONTA!",
        pending_action == "dodge" ? 0.85 : 1.05, col_purple);
    if(story_battle && story_stage==1)
    {
        draw_ui_text(480,183,"Parênteses primeiro; depois potências,",0.60,col_purple);
        draw_ui_text(480,201,"multiplicações e divisões.",0.60,col_purple);
    }

    draw_ui_box(242, 222, 476, 90, col_white, col_purple, 4);
    var _expression=variable_struct_exists(challenge,"expressao")?challenge.expressao
        :string(challenge.x)+"   "+challenge.operacao+"   "+string(challenge.y);
    var _expression_size=min(1.75,440/max(1,string_width(_expression)));
    draw_ui_text(
        480,
        267,
        _expression,
        _expression_size,
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

    draw_ui_box(220, reward_paradox?118:150, 520, reward_paradox?287:255, col_yellow, col_purple, 6);

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
            var _cavern_victory = false;

if (instance_exists(enemy_source))
{
    _cavern_victory =
        (enemy_source.object_index == obj_cavern_isleide);
}

draw_ui_text(
    480, reward_paradox?155:210,
    "VOCÊ VENCEU!",
    1.45, col_purple
);

if (_cavern_victory)
{
    draw_ui_text(
        480, reward_paradox?211:270,
        "Você derrotou o Isleide das Cavernas!",
        0.78, col_purple
    );

    draw_ui_button(
        350, 335, 260, 60,
        "CONTINUAR"
    );
}
else
{
    var _royal_victory = math_profile == "royal_alternating";
    draw_ui_text(
        480, 270,
        _royal_victory ? "Você derrotou Isleide Rei!" : (math_profile=="steampunk_alternating"
            ?"Você derrotou Isleide Steampunk!":(math_profile == "city_alternating"
            ? "Você derrotou Isleide da Cidade!" : "A batalha acabou por enquanto.")),
        0.78, col_purple
    );

    draw_ui_button(
        350, 335, 260, 60,
        _royal_victory ? "CONTINUAR" : "RETORNAR"
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

    if (battle_screen == "victory" && reward_xp > 0)
    {
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_ui_text(480, reward_paradox?182:240, "+" + string(reward_xp) + " XP  |  COMPREENSÃO "
            + string(reward_level), 0.72, col_purple);
        if (reward_paradox)
        {
            draw_ui_text(480, 243, "QUEBRA DE PARADOXO DESBLOQUEADA!", 0.66, col_purple);
            draw_ui_text(480, 267, "Q ou botão: simplifica a conta atual ou a próxima ação.", 0.50, col_purple);
            draw_ui_text(480, 284, "Vira uma soma de 1+1 a 5+5. Você precisa responder.", 0.50, col_purple);
            draw_ui_text(480, 301, "Uma vez por batalha. Renova na próxima luta ou tentativa.", 0.47, col_purple);
            draw_ui_text(480, 318, "O XP aumenta a Compreensão e reduz os números aos poucos.", 0.46, col_purple);
        }
    }
    if (battle_screen == "victory" && reward_hp > 0)
        draw_ui_text(480, reward_paradox ? 230 : 300, "+" + string(reward_hp)
            + " VIDA MÁXIMA PERMANENTE", 0.62, col_purple);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

draw_set_alpha(1);
draw_set_color(c_white);
// Continua acessível durante o desafio, sem cobrir a conta ou o botão OK.
if (_progress.paradox_unlocked && (battle_screen == "actions" || battle_screen == "challenge"))
{
    draw_ui_box(paradox_button.x, paradox_button.y, paradox_button.w,
        paradox_button.h, paradox_used ? col_white : col_yellow, col_purple, 4);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_ui_text(115, 140, "QUEBRA DE PARADOXO", 0.62, col_purple);
    draw_ui_text(115, 158, paradox_pending ? "PRÓXIMA CONTA SERÁ FÁCIL"
        : (paradox_used ? "USADA NESTA BATALHA" : "Q - SIMPLIFICAR UMA CONTA"), 0.44, col_purple);
    draw_ui_text(115, 176, "SOMA DE 1+1 A 5+5; UMA VEZ", 0.43, col_purple);
    draw_ui_text(115, 191, "DIGITE A RESPOSTA E CONFIRME", 0.43, col_purple);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}
// Acima dos popups, inclusive durante uma conta ou após derrota.
if (battle_config.test_skip_enabled && battle_screen != "victory")
{
    draw_ui_box(test_skip_button.x, test_skip_button.y,
        test_skip_button.w, test_skip_button.h, col_yellow, col_purple, 4);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_ui_text(813, 33, "PULAR BATALHA", 0.85, col_purple);
    draw_ui_text(813, 51, "TESTE TEMPORÁRIO", 0.58, col_purple);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}
