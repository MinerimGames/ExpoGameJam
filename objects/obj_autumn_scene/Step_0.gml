if (!instance_exists(obj_player) || instance_exists(obj_battle_controller)) exit;
var _p = instance_find(obj_player, 0);
if (!_p.movimento_liberado) exit;
var _destination = noone;
if (room == rm_autumn_gate
    && _p.x >= 366 && _p.x <= 466 && _p.y <= 64)
    _destination = rm_autumn_streets;
else if (room == rm_autumn_streets
    && _p.x >= 376 && _p.x <= 426 && _p.y <= 78)
    _destination = rm_autumn_plaza;
if (_destination != noone)
{
    _p.movimento_liberado = false;
    _p.velh = 0;
    _p.velv = 0;
    room_goto(_destination);
}
