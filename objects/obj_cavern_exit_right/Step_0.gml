if (!instance_exists(obj_player))
    exit;

var _player = instance_find(obj_player, 0);

if (_player.x >= room_width - 24)
{
    _player.movimento_liberado = false;
    _player.velh = 0;
    _player.velv = 0;
    room_goto(rm_cavernas_2);
}
