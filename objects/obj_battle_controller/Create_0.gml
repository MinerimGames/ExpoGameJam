/// Controle principal da batalha.
/// Equivalente ao estado global de battle.js + challenge.js.

player_hp = 100;
enemy_hp = 100;
player_hp_max = 100;
enemy_hp_max = 100;

pending_action = "";
math_phase = 1;
math_phase_max = 16;
challenge = undefined;
answer_text = "";

battle_screen = "actions"; // actions, challenge, victory, defeat
battle_message = "Escolha uma acao.";
result_visible = false;
result_text = "";
result_timer = 0;

enemy_source = noone;
player_name = "Isleide";
enemy_name = "Inimigo";
enemy_battle_sprite = spr_battle_newton;
enemy_battle_blend = c_white;
enemy_battle_scale = 0.40;

// Modo de tutorial iniciado pelo Isleide Newton.
tutorial_mode = false;
tutorial_step = 0;
tutorial_actions = ["attack", "heal", "defense", "dodge"];
tutorial_labels = ["ATAQUE", "CURA", "DEFESA", "ESQUIVA"];

// Referencia visual baseada na arena 960x540 do CSS original.
ui_reference_width = 960;
ui_reference_height = 540;
ui_scale = 1;
ui_offset_x = 0;
ui_offset_y = 0;

// Cores aproximadas do CSS original.
col_purple = make_color_rgb(64, 17, 110);
col_yellow = make_color_rgb(240, 221, 71);
col_green = make_color_rgb(57, 230, 57);
col_white = c_white;
col_dark = make_color_rgb(34, 34, 34);

keyboard_string = "";

update_ui_transform = function()
{
    var _gw = display_get_gui_width();
    var _gh = display_get_gui_height();

    ui_scale = min(_gw / ui_reference_width, _gh / ui_reference_height);
    ui_offset_x = (_gw - ui_reference_width * ui_scale) * 0.5;
    ui_offset_y = (_gh - ui_reference_height * ui_scale) * 0.5;
};

rx = function(_x)
{
    return ui_offset_x + _x * ui_scale;
};

ry = function(_y)
{
    return ui_offset_y + _y * ui_scale;
};

// Helpers de desenho precisam ser metodos da instancia.
// Funcoes anonimas locais no Draw GUI nao devem depender de variaveis locais
// como ui_scale/_sx, pois o escopo muda quando elas sao executadas.
draw_ui_box = function(_x, _y, _w, _h, _fill, _border, _border_size)
{
    draw_set_color(_border);
    draw_rectangle(rx(_x), ry(_y), rx(_x + _w), ry(_y + _h), false);

    draw_set_color(_fill);
    draw_rectangle(
        rx(_x + _border_size),
        ry(_y + _border_size),
        rx(_x + _w - _border_size),
        ry(_y + _h - _border_size),
        false
    );
};

draw_ui_text = function(_x, _y, _value, _size, _color)
{
    draw_set_color(_color);
    draw_text_transformed(
        rx(_x),
        ry(_y),
        _value,
        ui_scale * _size,
        ui_scale * _size,
        0
    );
};

draw_ui_button = function(_x, _y, _w, _h, _label)
{
    draw_ui_box(_x, _y, _w, _h, col_white, col_purple, 4);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_ui_text(_x + _w * 0.5, _y + _h * 0.5, _label, 1.05, col_purple);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
};

inside_ref_rect = function(_mx, _my, _x, _y, _w, _h)
{
    return _mx >= _x && _mx <= _x + _w && _my >= _y && _my <= _y + _h;
};

tutorial_expected_action = function()
{
    if (!tutorial_mode || tutorial_step >= array_length(tutorial_actions)) return "";
    return tutorial_actions[tutorial_step];
};

tutorial_expected_label = function()
{
    if (!tutorial_mode || tutorial_step >= array_length(tutorial_labels)) return "";
    return tutorial_labels[tutorial_step];
};

tutorial_hint = function()
{
    if (!tutorial_mode) return "";
    if (tutorial_step >= 4) return "Treino concluido.";
    return "PASSO " + string(tutorial_step + 1) + "/4 - Use " + tutorial_expected_label() + ".";
};

limit_hp = function()
{
    player_hp = clamp(player_hp, 0, player_hp_max);
    enemy_hp = clamp(enemy_hp, 0, enemy_hp_max);
};

show_result = function(_text)
{
    result_text = _text;
    result_visible = true;
    result_timer = max(1, round(room_speed * 0.9));
};

finish_check = function()
{
    if (player_hp <= 0)
    {
        battle_message = "Voce perdeu.";
        pending_action = "";
        battle_screen = "defeat";
        keyboard_string = "";
        return true;
    }

    if (enemy_hp <= 0)
    {
        battle_message = "Voce venceu.";
        pending_action = "";
        battle_screen = "victory";
        keyboard_string = "";
        return true;
    }

    return false;
};

enemy_attack = function(_defending = false, _dodging = false)
{
    var _damage = tutorial_mode ? batalha_numero_aleatorio(4, 8) : batalha_numero_aleatorio(8, 18);
    var _message = "O inimigo atacou e deu " + string(_damage) + " de dano.";

    if (!tutorial_mode && random(1) < 0.15)
    {
        _damage *= 2;
        _message = "O inimigo acertou critico de " + string(_damage) + " de dano.";
    }

    if (_defending)
    {
        _damage = floor(_damage / 2);
        _message = "Voce defendeu e recebeu " + string(_damage) + " de dano.";
    }

    if (_dodging)
    {
        if (random(1) < 0.5)
        {
            _damage = 0;
            _message = "Voce esquivou do ataque inimigo.";
        }
        else
        {
            _message = "A esquiva falhou e voce recebeu " + string(_damage) + " de dano.";
        }
    }

    player_hp -= _damage;
    limit_hp();

    if (player_hp <= 0)
    {
        return _message + " Voce perdeu.";
    }

    return _message;
};

execute_attack = function()
{
    var _damage = batalha_numero_aleatorio(12, 22);
    var _message = "Voce atacou e deu " + string(_damage) + " de dano.";

    if (random(1) < 0.20)
    {
        _damage *= 2;
        _message = "Voce acertou critico de " + string(_damage) + " de dano.";
    }

    enemy_hp -= _damage;
    limit_hp();

    if (enemy_hp <= 0)
    {
        battle_message = _message + " Voce venceu.";
        finish_check();
        return;
    }

    battle_message = _message + " " + enemy_attack(false, false);
    finish_check();
};

execute_defense = function()
{
    battle_message = "Voce defendeu. " + enemy_attack(true, false);
    finish_check();
};

execute_heal = function()
{
    var _before = player_hp;
    player_hp += 20;
    limit_hp();

    var _healed = player_hp - _before;
    battle_message = "Voce curou " + string(_healed) + " de vida. " + enemy_attack(false, false);
    finish_check();
};

execute_dodge = function()
{
    battle_message = "Voce tentou esquivar. " + enemy_attack(false, true);
    finish_check();
};

execute_pending_action = function()
{
    var _action = pending_action;
    pending_action = "";

    switch (_action)
    {
        case "attack": execute_attack(); break;
        case "defense": execute_defense(); break;
        case "heal": execute_heal(); break;
        case "dodge": execute_dodge(); break;
    }

    // No tutorial, cada acao correta ensina uma parte do sistema.
    if (tutorial_mode && battle_screen != "defeat")
    {
        tutorial_step += 1;

        if (tutorial_step >= array_length(tutorial_actions))
        {
            battle_screen = "victory";
            battle_message = "Treino concluido! Voce executou as quatro acoes e estabilizou os calculos.";
            keyboard_string = "";
            answer_text = "";
        }
        else
        {
            battle_message += " Proximo passo: " + tutorial_expected_label() + ".";
        }
    }
};

request_action = function(_action)
{
    if (finish_check()) return;

    if (tutorial_mode && _action != tutorial_expected_action())
    {
        battle_message = "Tutorial: agora escolha " + tutorial_expected_label() + ".";
        return;
    }

    pending_action = _action;
    challenge = batalha_gerar_desafio(math_phase);
    answer_text = "";
    keyboard_string = "";
    battle_screen = "challenge";
};

apply_wrong_answer = function()
{
    var _message = enemy_attack(false, false);
    pending_action = "";
    battle_screen = "actions";
    answer_text = "";
    keyboard_string = "";
    show_result("ERROU!");
    battle_message = "Voce errou a conta. " + _message;
    finish_check();
};

verify_answer = function()
{
    if (battle_screen != "challenge") return;
    if (string_length(answer_text) <= 0) return;

    var _answer = real(answer_text);
    var _correct = (_answer == challenge.resposta);

    answer_text = "";
    keyboard_string = "";

    if (_correct)
    {
        battle_screen = "actions";
        show_result("ACERTOU!");

        if (math_phase < math_phase_max)
        {
            math_phase += 1;
        }

        execute_pending_action();
    }
    else
    {
        apply_wrong_answer();
    }
};

restart_battle = function()
{
    player_hp = tutorial_mode ? 70 : player_hp_max;
    enemy_hp = tutorial_mode ? 200 : enemy_hp_max;
    player_hp_max = 100;
    enemy_hp_max = tutorial_mode ? 200 : enemy_hp_max;
    pending_action = "";
    math_phase = 1;
    tutorial_step = 0;
    answer_text = "";
    keyboard_string = "";
    result_visible = false;
    result_timer = 0;
    battle_screen = "actions";
    battle_message = tutorial_mode ? "Tutorial: comece usando ATAQUE." : "Batalha reiniciada.";
};

leave_after_victory = function()
{
    if (tutorial_mode)
    {
        if (instance_exists(enemy_source))
        {
            with (enemy_source)
            {
                start_post_dialogue();
            }
        }
        else
        {
            with (obj_player)
            {
                movimento_liberado = true;
                velh = 0;
                velv = 0;
            }
        }

        instance_destroy();
        return;
    }

    if (instance_exists(enemy_source))
    {
        with (enemy_source)
        {
            instance_destroy();
        }
    }

    with (obj_player)
    {
        movimento_liberado = true;
        velh = 0;
        velv = 0;
    }

    instance_destroy();
};

update_ui_transform();
