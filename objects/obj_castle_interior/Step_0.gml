if (room != rm_castle_hall || !instance_exists(obj_player)) exit;
var _p = instance_find(obj_player, 0);
if (!_p.movimento_liberado || instance_exists(obj_battle_controller)) exit;
if (_p.x >= 360 && _p.x <= 440 && _p.y <= 158)
{
    _p.movimento_liberado = false;
    _p.velh = 0;
    _p.velv = 0;
    room_goto(rm_throne_room);
}
