/// Sistema de batalha portado do prototipo HTML/JS para GML.
/// Mantem as regras de battle.js e challenge.js, mas usa eventos do GameMaker.

function batalha_numero_aleatorio(_minimo, _maximo)
{
    return irandom_range(_minimo, _maximo);
}

function batalha_gerar_desafio(_fase)
{
    _fase = clamp(floor(_fase), 1, 16);

    var _x = 0;
    var _y = 0;
    var _resposta = 0;
    var _operacao = "";

    // Fases 1 a 3: soma de 1 algarismo.
    if (_fase >= 1 && _fase <= 3)
    {
        _x = irandom_range(1, 9);
        _y = irandom_range(1, 9);
        _resposta = _x + _y;
        _operacao = "+";
    }
    // Fases 4 a 6: preserva exatamente os intervalos usados no JS.
    else if (_fase >= 4 && _fase <= 6)
    {
        _x = irandom_range(10, 48);
        _y = irandom_range(10, 28);
        _resposta = _x + _y;
        _operacao = "+";
    }
    // Fases 7 a 9: subtracao de 1 algarismo, garantindo x > y.
    else if (_fase >= 7 && _fase <= 9)
    {
        _x = irandom_range(2, 9);
        _y = irandom_range(1, _x - 1);
        _resposta = _x - _y;
        _operacao = "-";
    }
    // Fases 10 a 12: preserva o comportamento do JS, inclusive x = y quando x = 10.
    else if (_fase >= 10 && _fase <= 12)
    {
        _x = irandom_range(10, 48);
        _y = floor(random(_x - 10)) + 10;
        _resposta = _x - _y;
        _operacao = "-";
    }
    // Fases 13 e 14: multiplicacao de 1 algarismo.
    else if (_fase >= 13 && _fase <= 14)
    {
        _x = irandom_range(1, 9);
        _y = irandom_range(1, 9);
        _resposta = _x * _y;
        _operacao = "x";
    }
    // Fases 15 e 16: preserva exatamente o intervalo 10..98 do JS.
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
_controlador.enemy_source = _inimigo;

// tutorial_mode poderá ser desativado depois dos quatro passos.
_controlador.tutorial_mode = _tutorial;

// Esta variável nunca muda durante a batalha.
_controlador.battle_started_as_tutorial = _tutorial;

_controlador.guided_tutorial_completed = false;

    if (_tutorial)
    {
        _controlador.player_name = "Isleide Wilson";
        _controlador.enemy_name = "Isleide Newton";
        _controlador.player_hp_max = 100;
        _controlador.player_hp = 100;
        _controlador.enemy_hp_max = 100;
        _controlador.enemy_hp = 100;
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

        if (variable_instance_exists(_inimigo, "battle_sprite"))
            _controlador.enemy_battle_sprite = _inimigo.battle_sprite;

        if (variable_instance_exists(_inimigo, "battle_blend"))
            _controlador.enemy_battle_blend = _inimigo.battle_blend;

        if (variable_instance_exists(_inimigo, "battle_scale"))
            _controlador.enemy_battle_scale = _inimigo.battle_scale;

        _controlador.battle_message = "Derrote a criatura e estabilize a incursão.";
    }

    return _controlador;
}
