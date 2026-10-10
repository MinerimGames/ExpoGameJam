// Prepare Wilson para as poses da batalha.
with (obj_player)
{
    dir = 3;
    world_frame = 0;
    walk_cycle = 0;
    troca_estado(estado_idle);
}

battle_config = batalha_configuracao();
story_battle=false;story_stage=0;story_answers=0;story_falling=false;ally_bonus=0;
player_hp_max = battle_config.player_hp_max + matematica_progresso().boss_hp_bonus;
enemy_hp_max = battle_config.enemy_hp_default;
player_hp = player_hp_max;
enemy_hp = enemy_hp_max;
battle_origin_room = room;
battle_environment = batalha_ambiente(room);
battle_turn = 0;
enemy_intent = "normal";
heal_cooldown = 0;
dodge_cooldown = 0;

pending_action = "";
math_phase = 1;
math_phase_max = 16;
math_profile = "progressive";
math_question_count = 0;
comprehension_level = matematica_progresso().level;
paradox_used = false;
paradox_pending = false;
victory_rewarded = false;
reward_xp = 0;
reward_hp = 0;
reward_level = comprehension_level;
reward_paradox = false;
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
enemy_battle_poses = undefined;
player_pose_action = "";
player_pose_timer = 0;
player_visual = function()
{
    var _sprite = spr_wilson_idle_front;
    var _action = battle_screen == "challenge" ? pending_action
        : (player_pose_timer > 0 ? player_pose_action : "");
    switch (_action)
    {
        case "attack": _sprite = spr_wilson_attack; break;
        case "defense": _sprite = spr_wilson_defense; break;
        case "heal": _sprite = spr_wilson_heal; break;
        case "dodge": _sprite = spr_wilson_dodge; break;
    }
    // A pose parada olha para a esquerda; as ações já olham para o inimigo à direita.
    return {sprite: _sprite, facing: _sprite == spr_wilson_idle_front ? -1 : 1,
        scale: 232 / (sprite_get_bbox_bottom(_sprite)-sprite_get_bbox_top(_sprite)+1)};
};

// Inimigos sem poses adicionais continuam usando seu retrato original.
enemy_visual = function()
{
    if (is_undefined(enemy_battle_poses))
        return {sprite: enemy_battle_sprite, scale: enemy_battle_scale};
    var _sprite = enemy_battle_poses.peace;
    if (battle_screen == "challenge" && pending_action == "attack")
        _sprite = enemy_battle_poses.defense;
    else if (enemy_intent == "strong" && battle_screen != "victory")
        _sprite = enemy_battle_poses.attack;
    else if (enemy_intent == "normal" && battle_screen != "victory")
        _sprite = enemy_battle_poses.talk;
    return {sprite: _sprite, scale: 232 / (sprite_get_bbox_bottom(_sprite)-sprite_get_bbox_top(_sprite)+1)};
};

tutorial_mode = false;

battle_started_as_tutorial = false;

guided_tutorial_completed = false;

tutorial_step = 0;
tutorial_actions = ["attack", "heal", "defense", "dodge"];
tutorial_labels = ["ATAQUE", "CURA", "DEFESA", "ESQUIVA"];

ui_reference_width = 960;
ui_reference_height = 540;
ui_scale = 1;
ui_offset_x = 0;
ui_offset_y = 0;
test_skip_button = {x: 682, y: 16, w: 262, h: 48};
paradox_button = {x: 12, y: 124, w: 206, h: 80};

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

update_enemy_intent = function()
{
    enemy_intent = batalha_intencao(battle_turn, tutorial_mode ? tutorial_step : -1);
};

advance_turn = function(_heal_used = false, _dodge_used = false)
{
    heal_cooldown = _heal_used
        ? battle_config.heal_cooldown_turns
        : max(0, heal_cooldown - 1);
    dodge_cooldown = _dodge_used
        ? battle_config.dodge_cooldown_turns
        : max(0, dodge_cooldown - 1);
    battle_turn += 1;
    update_enemy_intent();
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

reward_victory = function()
{
    if (story_battle && story_stage != 2) return;
    if (victory_rewarded || !instance_exists(enemy_source)) return;
    victory_rewarded = true;
    if (variable_instance_exists(enemy_source, "battle_reward_claimed")
        && enemy_source.battle_reward_claimed) return;
    enemy_source.battle_reward_claimed = true;
    if(story_battle)
    {
        var _story=historia_newton_progresso();
        if(_story.final_rewarded)return;
        _story.final_rewarded=true;
    }
    var _progress = matematica_progresso();
    // Each actual boss has one permanent HP reward for the whole playthrough.
    var _boss_key = "";
    if (!battle_started_as_tutorial)
    {
        switch (enemy_source.object_index)
        {
            case obj_cavern_isleide: _boss_key = "cavern"; break;
            case obj_isleide_king: _boss_key = "king"; break;
            case obj_isleide_steampunk: _boss_key = "steampunk"; break;
            case obj_isleide_city: _boss_key = "city"; break;
            case obj_newton_final:
                if (story_battle && story_stage == 2) _boss_key = "newton";
                break;
        }
    }
    if (_boss_key != "" && !array_contains(_progress.hp_rewarded_bosses, _boss_key))
    {
        array_push(_progress.hp_rewarded_bosses, _boss_key);
        reward_hp = battle_config.boss_hp_reward;
        _progress.boss_hp_bonus += reward_hp;
        player_hp_max += reward_hp;
        player_hp += reward_hp;
        limit_hp();
    }
    reward_xp = 100;
    _progress.xp_total += reward_xp;
    _progress.level = 1 + floor(_progress.xp_total / 100);
    if(enemy_source.object_index==obj_isleide_king)historia_newton_progresso().royal_defeated=true;
    if(enemy_source.object_index==obj_isleide_city)historia_newton_progresso().city_defeated=true;
    if(enemy_source.object_index==asset_get_index("obj_isleide_steampunk"))historia_newton_progresso().steampunk_defeated=true;
    reward_level = _progress.level;
    som_efeito("level");
    if (enemy_source.object_index == obj_cavern_isleide && !_progress.paradox_unlocked)
    {
        _progress.paradox_unlocked = true;
        reward_paradox = true;
    }
};

activate_paradox = function()
{
    if (!matematica_progresso().paradox_unlocked || paradox_used
        || (battle_screen != "actions" && battle_screen != "challenge")) return false;
    paradox_used = true;
    som_efeito("portal");
    result_visible = false;
    if (battle_screen == "challenge")
    {
        challenge = matematica_conta_simples();
        answer_text = "";
        keyboard_string = "";
    }
    else paradox_pending = true;
    battle_message = paradox_pending
        ? "Quebra preparada: responda a soma fácil da próxima ação. Uma vez nesta batalha."
        : "Conta simplificada! Digite a resposta e confirme para executar sua ação.";
    return true;
};

handle_paradox_input = function(_mx, _my, _click, _key)
{
    if (!_key && !(_click && inside_ref_rect(_mx, _my,
        paradox_button.x, paradox_button.y, paradox_button.w, paradox_button.h))) return false;
    return activate_paradox();
};

finish_check = function()
{
    if(story_battle && story_stage==1)
    {
        player_hp=max(1,player_hp);enemy_hp=max(1,enemy_hp);return false;
    }
    if (player_hp <= 0)
    {
        battle_message = "Você perdeu.";
        pending_action = "";
        if(battle_screen != "defeat")som_efeito("defeat");
        battle_screen = "defeat";
        keyboard_string = "";
        return true;
    }

    if (enemy_hp <= 0)
    {
        battle_message = "Você venceu.";
        pending_action = "";
        if(battle_screen != "victory")som_efeito("victory");
        battle_screen = "victory";
        reward_victory();
        keyboard_string = "";
        return true;
    }

    return false;
};

enemy_attack = function(_defending = false, _dodging = false)
{
    if (enemy_intent == "vulnerable") return "O inimigo está se recuperando.";
    var _counter_delay=player_pose_action=="attack" && player_pose_timer>0?0.38:0.08;
    motion_emit("enemy","attack",0.34,_counter_delay);
    var _strong = enemy_intent == "strong";
    var _min = _strong ? battle_config.strong_min : battle_config.normal_min;
    var _max = _strong ? battle_config.strong_max : battle_config.normal_max;
    if (tutorial_mode)
    {
        _min = _strong ? battle_config.tutorial_strong_min : battle_config.tutorial_normal_min;
        _max = _strong ? battle_config.tutorial_strong_max : battle_config.tutorial_normal_max;
    }
    var _damage = batalha_numero_aleatorio(_min, _max);
    var _message = (_strong ? "ATAQUE FORTE! " : "") + "-" + string(_damage) + " HP.";

    if (_defending)
    {
        _damage = round(_damage * (1 - (_strong ? battle_config.defense_strong : battle_config.defense_normal)));
        _message = (_strong ? "DEFESA PERFEITA! " : "DEFESA! ") + "-" + string(_damage) + " HP.";
    }

    if (_dodging)
    {
        // Only a correctly answered dodge reaches this branch.
        _damage = 0;
        _message = "ESQUIVA! Sem dano. Recarga: 2 turnos.";
    }

    if(_damage>0 && !_defending && !_dodging)motion_emit("player","hurt",0.25,_counter_delay+0.14);
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
    som_efeito("attack");
    motion_emit("player","attack",0.36);
    motion_emit("enemy","hurt",0.26);
    if(story_battle)motion_emit("ally","attack",0.42,0.07);
    var _damage = batalha_numero_aleatorio(battle_config.attack_min, battle_config.attack_max);
    if (enemy_intent == "vulnerable") _damage = round(_damage * battle_config.vulnerable_multiplier);
    _damage+=ally_bonus;
    var _message = "ATAQUE! Inimigo -" + string(_damage) + " HP.";

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
    som_efeito("defense");
    motion_emit("player","defense",0.58);
    battle_message = enemy_attack(true, false);
    finish_check();
};

execute_heal = function()
{
    som_efeito("heal");
    motion_emit("player","heal",0.60);
    var _before = player_hp;
    player_hp += battle_config.heal_amount;
    limit_hp();

    var _healed = player_hp - _before;
    battle_message = "CURA! +" + string(_healed) + " HP. " + enemy_attack(false, false);
    finish_check();
};

execute_dodge = function()
{
    som_efeito("dodge");
    motion_emit("player","dodge",0.55);
    battle_message = enemy_attack(false, true);
    finish_check();
};

execute_pending_action = function()
{
    var _action = pending_action;
    player_pose_action = _action;
    player_pose_timer = max(1, round(game_get_speed(gamespeed_fps) * 0.9));
    pending_action = "";

    switch (_action)
    {
        case "attack": execute_attack(); break;
        case "defense": execute_defense(); break;
        case "heal": execute_heal(); break;
        case "dodge": execute_dodge(); break;
    }

    advance_turn(_action == "heal", _action == "dodge");

if (tutorial_mode && battle_screen == "actions")
{
    tutorial_step += 1;

    if (tutorial_step >= array_length(tutorial_actions))
    {
        tutorial_mode = false;
        guided_tutorial_completed = true;
        battle_turn = 0;

        battle_screen = "actions";
        pending_action = "";
        keyboard_string = "";
        answer_text = "";

        battle_message =
            "Treino concluído! Observe o aviso e derrote Newton.";

        show_result("LIBERADO!");
    }
}
    update_enemy_intent();
};

request_action = function(_action)
{
    if (battle_screen != "actions") return;
    if (finish_check()) return;

    if (tutorial_mode && _action != tutorial_expected_action())
    {
        battle_message = "Tutorial: agora escolha " + tutorial_expected_label() + ".";
        return;
    }

    if (_action == "dodge" && dodge_cooldown > 0)
    {
        battle_message = "ESQUIVA: aguarde " + string(dodge_cooldown)
            + (dodge_cooldown == 1 ? " turno. Use outra ação." : " turnos. Use outra ação.");
        return;
    }

    if (_action == "heal")
    {
        if (player_hp >= player_hp_max)
        {
            battle_message = "SUA VIDA JÁ ESTÁ CHEIA!";
            return;
        }
        if (heal_cooldown > 0)
        {
            battle_message = "CURA: aguarde " + string(heal_cooldown) + (heal_cooldown == 1 ? " turno." : " turnos.");
            return;
        }
    }

    som_efeito("select");
    pending_action = _action;
    if (paradox_pending)
    {
        challenge = matematica_conta_simples();
        paradox_pending = false;
    }
    else if(story_battle)challenge=newton_gerar_desafio(story_stage,math_question_count);
    else challenge = matematica_facilitar(
        batalha_gerar_desafio(math_phase, math_profile, math_question_count), comprehension_level);
    math_question_count += 1;
    answer_text = "";
    keyboard_string = "";
    battle_screen = "challenge";
};

apply_wrong_answer = function()
{
    som_efeito("wrong");
    player_pose_action = "";
    player_pose_timer = 0;
    var _message = enemy_attack(false, false);
    pending_action = "";
    battle_screen = "actions";
    answer_text = "";
    keyboard_string = "";
    show_result("ERROU!");
    battle_message = "Você errou a conta. " + _message;
    finish_check();
    advance_turn(false);
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
        som_efeito("correct");
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
    newton_batalha_apos_resposta(id);
};

restart_battle = function()
{
    motion_events=[];
    player_pose_action = "";
    player_pose_timer = 0;
    paradox_used = false;
    paradox_pending = false;
    player_hp = player_hp_max;
    enemy_hp = enemy_hp_max;

    pending_action = "";
    challenge = undefined;
    answer_text = "";
    keyboard_string = "";

    result_visible = false;
    result_text = "";
    result_timer = 0;

    tutorial_mode = battle_started_as_tutorial;
    tutorial_step = 0;
    guided_tutorial_completed = false;
    battle_turn = 0;
    heal_cooldown = 0;
    dodge_cooldown = 0;
    math_phase = 1;
    math_question_count = 0;

    if (tutorial_mode)
    {
        battle_message = "Siga as instruções do painel superior.";
    }
    else
    {
        if (instance_exists(enemy_source))
        {
            if (variable_instance_exists(enemy_source, "battle_math_phase"))
            {
                math_phase = enemy_source.battle_math_phase;
            }
        }

        battle_message = "Derrote a criatura e estabilize a incursão.";
        if (instance_exists(enemy_source)
            && variable_instance_exists(enemy_source, "battle_message"))
            battle_message = enemy_source.battle_message;
    }

    battle_screen = "actions";
    if(story_battle)newton_batalha_configurar(id,story_stage);
    update_enemy_intent();
};

leave_after_victory = function()
{
    if(story_battle && story_stage==2)
    {
        var _scene=instance_find(obj_temporal_scene,0);
        if(instance_exists(_scene))_scene.start_ending();
        instance_destroy();return;
    }
    var _victory_room = noone;
    if (instance_exists(enemy_source)
        && variable_instance_exists(enemy_source, "battle_victory_room"))
        _victory_room = enemy_source.battle_victory_room;

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

    var _portal_x = 0;
    var _portal_y = 0;
    if (instance_exists(enemy_source))
    {
        _portal_x = enemy_source.x + 40;
        _portal_y = enemy_source.y + 12;
        if (enemy_source.object_index == obj_cavern_isleide) _victory_room = rm_vila;
        if (variable_instance_exists(enemy_source, "battle_victory_portal_x"))
            _portal_x = enemy_source.battle_victory_portal_x;
        if (variable_instance_exists(enemy_source, "battle_victory_portal_y"))
            _portal_y = enemy_source.battle_victory_portal_y;
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

    if (_victory_room != noone)
    {
        var _portal = instance_create_depth(_portal_x, _portal_y, mundo_profundidade(_portal_y), obj_portal);
        _portal.portal_destination = _victory_room;
    }
    instance_destroy();
};

// Usado pelo botão temporário; compartilha todas as saídas da vitória normal.
handle_test_skip = function(_mx, _my, _click)
{
    if (!battle_config.test_skip_enabled || battle_screen == "victory" || !_click) return false;
    if (!inside_ref_rect(_mx, _my, test_skip_button.x, test_skip_button.y,
        test_skip_button.w, test_skip_button.h)) return false;
    if(newton_batalha_pular(id))return true;

    player_hp = max(1, player_hp);
    enemy_hp = 0;
    pending_action = "";
    challenge = undefined;
    answer_text = "";
    keyboard_string = "";
    result_visible = false;
    finish_check();
    leave_after_victory();
    return true;
};

update_ui_transform();

batalha_animacao_iniciar(id);
