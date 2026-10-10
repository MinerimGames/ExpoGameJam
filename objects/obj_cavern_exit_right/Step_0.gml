if (!instance_exists(obj_player))
    exit;

var _player = instance_find(obj_player, 0);
var _destination = noone;
var _at_exit = false;

if (!_player.movimento_liberado || instance_exists(obj_battle_controller))
    exit;

switch (room)
{
    case rm_cavernas:
        _destination = rm_cavernas_2;
        _at_exit = _player.x >= room_width - 24;
        break;
    case rm_bosque:
        _destination = rm_castelo;
        _at_exit = _player.y <= 24 && _player.x >= 248 && _player.x <= 320;
        break;
    case rm_vila:
        _destination = rm_bosque;
        _at_exit = _player.x <= 24 && _player.y >= 128 && _player.y <= 192;
        break;
    case rm_castelo:
        if (instance_exists(obj_castle_guard))
            exit;
        _destination = rm_castle_hall;
        _at_exit = _player.y >= 512 && _player.y <= 532 && _player.x >= 392 && _player.x <= 440;
        break;
}

if (_destination == noone)
    exit;

if (_at_exit)
{
    _player.movimento_liberado = false;
    _player.velh = 0;
    _player.velv = 0;
    room_goto(_destination);
}
