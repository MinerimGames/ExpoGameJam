function matematica_progresso(_reiniciar = false)
{
    if (_reiniciar || !variable_global_exists("math_progress"))
        global.math_progress = {xp_total: 0, level: 1, paradox_unlocked: false,
            boss_hp_bonus: 0, hp_rewarded_bosses: []};
    // Preserve an existing session when adding permanent HP growth.
    if (!variable_struct_exists(global.math_progress, "boss_hp_bonus"))
        global.math_progress.boss_hp_bonus = 0;
    if (!variable_struct_exists(global.math_progress, "hp_rewarded_bosses"))
        global.math_progress.hp_rewarded_bosses = [];
    return global.math_progress;
}

function matematica_facilitar(_desafio, _nivel)
{
    if (_nivel <= 1)
        return {x: _desafio.x, y: _desafio.y, resposta: _desafio.resposta, operacao: _desafio.operacao};
    // A compreensão reduz os números, preservando a operação e a resposta correta.
    var _fator = max(0.60, 1 - 0.10 * max(0, _nivel - 1));
    var _x = max(1, floor(_desafio.x * _fator));
    var _y = max(1, floor(_desafio.y * _fator));
    var _resposta;
    switch (_desafio.operacao)
    {
        case "-":
            _x = max(2, _x); _y = min(_y, _x - 1);
            _resposta = _x - _y; break;
        case "x": _resposta = _x * _y; break;
        default: _resposta = _x + _y; break;
    }
    return {x: _x, y: _y, resposta: _resposta, operacao: _desafio.operacao};
}

function matematica_conta_simples()
{
    var _numero = irandom_range(1, 5);
    return {x: _numero, y: _numero, resposta: _numero * 2, operacao: "+"};
}

function batalha_configuracao()
{
    return {
        // Temporário: false remove o botão e desativa o salto de batalha.
        test_skip_enabled: TEST_SKIP_ENABLED,
        player_hp_max: 100, enemy_hp_default: 100, boss_hp: 150,
        attack_min: 16, attack_max: 20,
        normal_min: 10, normal_max: 12, strong_min: 34, strong_max: 36,
        defense_normal: 0.50, defense_strong: 0.75,
        dodge_cooldown_turns: 2, boss_hp_reward: 30, ally_hp_bonus: 40,
        heal_amount: 28, heal_cooldown_turns: 2, vulnerable_multiplier: 1.5,
        tutorial_normal_min: 4, tutorial_normal_max: 6,
        tutorial_strong_min: 12, tutorial_strong_max: 14
    };
}

function batalha_intencao(_turno, _tutorial_step = -1)
{
    if (_tutorial_step >= 0) return _tutorial_step == 2 ? "strong" : "normal";
    switch (_turno mod 4)
    {
        case 2: return "strong";
        case 3: return "vulnerable";
        default: return "normal";
    }
}

function batalha_ambiente(_room)
{
    if (_room == asset_get_index("rm_steampunk_foundry")) return "steampunk";
    if (_room == rm_tutorial || _room == rm_temporal_origin) return "grasslands";
    if (_room == rm_cavernas) return "cavern";
    if (_room == rm_cavernas_2) return "cavern_camp";
    if (_room == rm_castelo) return "medieval";
    if (_room == rm_throne_room) return "throne";
    if (_room == rm_autumn_plaza) return "ghost_city";
    return "neutral";
}

function batalha_numero_aleatorio(_minimo, _maximo)
{
    return irandom_range(_minimo, _maximo);
}

function batalha_gerar_desafio(_fase, _perfil = "progressive", _indice = 0)
{
    if(_perfil=="steampunk_alternating")
    {
        var _tier=clamp(floor(_fase),6,8);
        var _a,_b;
        if(_indice mod 2==1)
        {
            _a=irandom_range(2,min(8,7+(_tier-6)));_b=irandom_range(2,min(8,7+(_tier-6)));
            return {x:_a,y:_b,resposta:_a*_b,operacao:"x"};
        }
        _a=irandom_range(18,52+5*(_tier-6));_b=irandom_range(12,32+5*(_tier-6));
        return {x:_a,y:_b,resposta:_a+_b,operacao:"+"};
    }
    if (_perfil == "city_alternating")
    {
        var _tier = clamp(floor(_fase), 7, 10);
        if ((_indice mod 2) == 1)
        {
            var _a = irandom_range(2, _tier);
            var _b = irandom_range(2, _tier);
            return {x: _a, y: _b, resposta: _a * _b, operacao: "x"};
        }
        var _a = irandom_range(20, 50 + 5 * (_tier - 7));
        var _b = irandom_range(10, 30 + 5 * (_tier - 7));
        return {x: _a, y: _b, resposta: _a + _b, operacao: "+"};
    }
    if (_perfil == "royal_alternating")
    {
        if ((_indice mod 2) == 1)
        {
            var _a = irandom_range(2, 6);
            var _b = irandom_range(2, 6);
            return {x: _a, y: _b, resposta: _a * _b, operacao: "x"};
        }
        _fase = 4;
    }
    _fase = clamp(floor(_fase), 1, 16);

    var _x = 0;
    var _y = 0;
    var _resposta = 0;
    var _operacao = "";

    if (_fase >= 1 && _fase <= 3)
    {
        _x = irandom_range(1, 9);
        _y = irandom_range(1, 9);
        _resposta = _x + _y;
        _operacao = "+";
    }
    else if (_fase >= 4 && _fase <= 6)
    {
        _x = irandom_range(10, 48);
        _y = irandom_range(10, 28);
        _resposta = _x + _y;
        _operacao = "+";
    }
    else if (_fase >= 7 && _fase <= 9)
    {
        _x = irandom_range(2, 9);
        _y = irandom_range(1, _x - 1);
        _resposta = _x - _y;
        _operacao = "-";
    }
    else if (_fase >= 10 && _fase <= 12)
    {
        _x = irandom_range(10, 48);
        _y = floor(random(_x - 10)) + 10;
        _resposta = _x - _y;
        _operacao = "-";
    }
    else if (_fase >= 13 && _fase <= 14)
    {
        _x = irandom_range(1, 9);
        _y = irandom_range(1, 9);
        _resposta = _x * _y;
        _operacao = "x";
    }
    else
    {
        _x = irandom_range(10, 98);
        _y = irandom_range(10, 98);
        _resposta = _x * _y;
        _operacao = "x";
    }

    return {
        x: _x,
        y: _y,
        resposta: _resposta,
        operacao: _operacao
    };
}

function batalha_iniciar(_inimigo = noone, _tutorial = false)
{
    if (instance_exists(obj_battle_controller))
    {
        return instance_find(obj_battle_controller, 0);
    }

    with (obj_player)
    {
        movimento_liberado = false;
        velh = 0;
        velv = 0;
    }

    var _controlador = instance_create_depth(0, 0, -1000, obj_battle_controller);
    _controlador.battle_origin_room = room;
    _controlador.battle_environment = batalha_ambiente(room);
_controlador.enemy_source = _inimigo;

_controlador.tutorial_mode = _tutorial;

_controlador.battle_started_as_tutorial = _tutorial;

_controlador.guided_tutorial_completed = false;

    if (_tutorial)
    {
        _controlador.player_name = "Isleide Wilson";
        _controlador.enemy_name = "Isleide Newton";
        _controlador.player_hp_max = _controlador.battle_config.player_hp_max + matematica_progresso().boss_hp_bonus;
        _controlador.player_hp = _controlador.player_hp_max;
        _controlador.enemy_hp_max = _controlador.battle_config.enemy_hp_default;
        _controlador.enemy_hp = _controlador.enemy_hp_max;
        _controlador.tutorial_step = 0;
        _controlador.math_phase = 1;
		_controlador.battle_message =
    "Siga as instruções do painel superior.";
    }

    else if (instance_exists(_inimigo))
    {
        _controlador.player_name = "Isleide Wilson";

        if (variable_instance_exists(_inimigo, "battle_name"))
            _controlador.enemy_name = _inimigo.battle_name;

        if (variable_instance_exists(_inimigo, "battle_hp"))
        {
            _controlador.enemy_hp_max = _inimigo.battle_hp;
            _controlador.enemy_hp = _inimigo.battle_hp;
        }

        if (variable_instance_exists(_inimigo, "battle_math_phase"))
            _controlador.math_phase = _inimigo.battle_math_phase;

        if (variable_instance_exists(_inimigo, "battle_math_phase_max"))
            _controlador.math_phase_max = _inimigo.battle_math_phase_max;

        if (variable_instance_exists(_inimigo, "battle_math_profile"))
            _controlador.math_profile = _inimigo.battle_math_profile;

        if (variable_instance_exists(_inimigo, "battle_sprite"))
            _controlador.enemy_battle_sprite = _inimigo.battle_sprite;

        if (variable_instance_exists(_inimigo, "battle_blend"))
            _controlador.enemy_battle_blend = _inimigo.battle_blend;

        if (variable_instance_exists(_inimigo, "battle_scale"))
            _controlador.enemy_battle_scale = _inimigo.battle_scale;

        if (variable_instance_exists(_inimigo, "battle_poses"))
            _controlador.enemy_battle_poses = _inimigo.battle_poses;

        _controlador.battle_message = "Derrote a criatura e estabilize a incursão.";
        if (variable_instance_exists(_inimigo, "battle_message"))
            _controlador.battle_message = _inimigo.battle_message;
    }

    if(instance_exists(_inimigo) && variable_instance_exists(_inimigo,"battle_story") && _inimigo.battle_story=="newton")
        newton_batalha_configurar(_controlador,_inimigo.battle_stage);
    _controlador.update_enemy_intent();
    return _controlador;
}
// Battle skipping is available only when a test explicitly enables the field.
#macro TEST_SKIP_ENABLED false
#macro FinalRelease:TEST_SKIP_ENABLED false

#macro EventoTests:TEST_SKIP_ENABLED false
