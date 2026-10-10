image_alpha = min(1, image_alpha + 0.04);

if (activation_delay > 0)
{
    activation_delay -= 1;
    exit;
}

if (!instance_exists(obj_player))
{
    exit;
}

var _player = instance_find(obj_player, 0);
if (!_player.movimento_liberado || instance_exists(obj_battle_controller)) exit;

var _player_inside = point_in_rectangle(
    _player.x,
    _player.y - 8,
    x - 9,
    y - 34,
    x + 9,
    y - 8
);

// A portal appearing under Wilson must be left and approached again.
if (portal_requires_exit)
{
    if (!_player_inside) portal_requires_exit = false;
    exit;
}

if (_player_inside && !portal_activated)
{
    portal_activated = true;
    som_efeito("portal");

    _player.movimento_liberado = false;
    _player.velh = 0;
    _player.velv = 0;

    room_goto(portal_destination);
}
