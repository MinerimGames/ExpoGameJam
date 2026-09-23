// Faz o portal aparecer gradualmente.
image_alpha = min(1, image_alpha + 0.04);

// Aguarda um pequeno tempo antes de ativar.
if (activation_delay > 0)
{
    activation_delay -= 1;
    exit;
}

// Só continua se o jogador existir.
if (!instance_exists(obj_player))
{
    exit;
}

var _player = instance_find(obj_player, 0);


// Verifica um ponto no centro do jogador dentro do núcleo do portal.
var _player_inside = point_in_rectangle(
    _player.x,
    _player.y - 8,
    x - 9,
    y - 34,
    x + 9,
    y - 8
);

// O jogador entrou na área do portal.
if (_player_inside && !portal_activated)
{
    portal_activated = true;

    _player.movimento_liberado = false;
    _player.velh = 0;
    _player.velv = 0;

    room_goto(portal_destination);
}
    room_goto(rm_demo_end);
}
