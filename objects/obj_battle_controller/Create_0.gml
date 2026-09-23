/// Controle principal da batalha.
/// Equivalente ao estado global de battle.js + challenge.js.

player_hp = 100;
enemy_hp = 100;
player_hp_max = 100;
enemy_hp_max = 100;

pending_action = "";
math_phase = 1;
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

// Indica se a fase guiada está acontecendo neste momento.
tutorial_mode = false;

// Permanece verdadeiro mesmo depois que a fase guiada termina.
// Isso permite que o jogo reconheça a batalha contra Newton.
battle_started_as_tutorial = false;

// Indica que os quatro passos obrigatórios já foram concluídos.
guided_tutorial_completed = false;

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
    if (tutorial_step >= 4) return "Treino concluído.";
    return "PASSO " + string(tutorial_step + 1) + "/4 - Use " + tutorial_expected_label() + ".";
};

wrap_battle_message = function(_text, _max_chars = 44)
{
    var _words = string_split(string(_text), " ");
    var _line = "";
    var _output = "";

    for (var i = 0; i < array_length(_words); i++)
    {
        var _word = _words[i];

        var _test = (_line == "")
            ? _word
            : _line + " " + _word;

        if (string_length(_test) > _max_chars)
        {
            if (_output != "")
            {
                _output += chr(10);
            }

            _output += _line;
            _line = _word;
        }
        else
        {
            _line = _test;
        }
    }

    if (_line != "")
    {
        if (_output != "")
        {
            _output += chr(10);
        }

        _output += _line;
    }

    return _output;
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
    result_timer = max(1, round(game_get_speed(gamespeed_fps) * 0.9));
};

finish_check = function()
{
    if (player_hp <= 0)
    {
        battle_message = "Você perdeu.";
        pending_action = "";
        battle_screen = "defeat";
        keyboard_string = "";
        return true;
    }

    if (enemy_hp <= 0)
    {
        battle_message = "Você venceu.";
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
        _message = "O inimigo acertou crítico de " + string(_damage) + " de dano.";
    }

    if (_defending)
    {
        _damage = floor(_damage / 2);
        _message = "Dano reduzido, recebeu " + string(_damage) + " de dano.";
    }

    if (_dodging)
    {
        if (random(1) < 0.5)
        {
            _damage = 0;
            _message = "Você esquivou do ataque inimigo.";
        }
        else
        {
            _message = "A esquiva falhou e você recebeu " + string(_damage) + " de dano.";
        }
    }

    player_hp -= _damage;
    limit_hp();

    if (player_hp <= 0)
    {
        return _message + " Você perdeu.";
    }

    return _message;
};

execute_attack = function()
{
    var _damage = batalha_numero_aleatorio(12, 22);
    var _message = "Você atacou e deu " + string(_damage) + " de dano.";

    if (random(1) < 0.20)
    {
        _damage *= 2;
        _message = "Você acertou crítico de " + string(_damage) + " de dano.";
    }

    enemy_hp -= _damage;
    limit_hp();

    if (enemy_hp <= 0)
    {
        battle_message = _message + " Você venceu.";
        finish_check();
        return;
    }

    battle_message = _message + " " + enemy_attack(false, false);
    finish_check();
};

execute_defense = function()
{
    battle_message = "Você defendeu. " + enemy_attack(true, false);
    finish_check();
};

execute_heal = function()
{
    var _before = player_hp;
    player_hp += 20;
    limit_hp();

    var _healed = player_hp - _before;
    battle_message = "Você curou " + string(_healed) + " de vida. " + enemy_attack(false, false);
    finish_check();
};

execute_dodge = function()
{
    battle_message = "Você tentou esquivar. " + enemy_attack(false, true);
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

// Durante a fase guiada, cada ação correta avança uma etapa.
if (tutorial_mode && battle_screen != "defeat")
{
    tutorial_step += 1;

    // Depois das quatro ações, libera a batalha normal.
    if (tutorial_step >= array_length(tutorial_actions))
    {
        tutorial_mode = false;
        guided_tutorial_completed = true;

        battle_screen = "actions";
        pending_action = "";
        keyboard_string = "";
        answer_text = "";

        battle_message =
            "Treinamento concluído! Agora use livremente "
            + "as quatro ações e derrote Newton.";

        show_result("LIBERADO!");
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
    battle_message = "Você errou a conta. " + _message;
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

        if (math_phase < 16)
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
    player_hp_max = 100;

    // Batalha que começou como tutorial de Newton.
    if (battle_started_as_tutorial)
    {
        enemy_hp_max = 100;

        player_hp = player_hp_max;
        enemy_hp = enemy_hp_max;

        // Se a parte guiada já havia sido concluída,
        // reinicia diretamente na batalha livre.
        if (guided_tutorial_completed)
        {
            tutorial_mode = false;
            tutorial_step = array_length(tutorial_actions);

            // As quatro primeiras contas já foram superadas.
            math_phase = 5;

            battle_message =
                "Batalha reiniciada. Use livremente "
                + "as quatro ações para derrotar Newton.";
        }
        else
        {
            // Se perdeu durante o tutorial,
            // reinicia os quatro passos obrigatórios.
            tutorial_mode = true;
            tutorial_step = 0;
            math_phase = 1;

            battle_message =
                "Siga as instruções do painel superior.";
        }
    }
    else
    {
        // Reinício de uma batalha comum.
        tutorial_mode = false;
        tutorial_step = 0;
        math_phase = 1;

        player_hp = player_hp_max;
        enemy_hp = enemy_hp_max;

        battle_message = "Batalha reiniciada.";
    }

    pending_action = "";
    answer_text = "";
    keyboard_string = "";

    result_visible = false;
    result_timer = 0;

    battle_screen = "actions";
};

leave_after_victory = function()
{
    if (battle_started_as_tutorial)
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
