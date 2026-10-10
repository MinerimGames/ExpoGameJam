function peasant_home_areas(_room)
{
    if (_room == rm_bosque) return [[320,252,344,280]];
    if (_room == rm_vila) return [
        [92,340,124,356], [156,80,176,96], [100,388,124,408],
        [608,168,628,180], [372,432,416,456]
    ];
    return [];
}

function castle_peasant_land(_x, _y)
{
    var _areas = peasant_home_areas(room);
    for (var _i = 0; _i < array_length(_areas); _i++)
    {
        var _area = _areas[_i];
        if (_x >= _area[0] && _x <= _area[2] && _y >= _area[1] && _y <= _area[3]) return true;
    }
    return false;
}

function castle_peasant_can_stand(_x, _y)
{
    return castle_peasant_land(_x, _y)
        && collision_rectangle(_x-6, _y-3, _x+6, _y+3, obj_colisor, false, true) == noone;
}

function castle_peasant_can_move(_resident, _x, _y)
{
    if (_x < _resident.home_left || _x > _resident.home_right
        || _y < _resident.home_top || _y > _resident.home_bottom
        || !castle_peasant_can_stand(_x, _y)) return false;
    if (instance_exists(obj_player))
    {
        var _player = instance_find(obj_player, 0);
        if (point_distance(_x, _y, _player.x, _player.y) < 14) return false;
    }
    for (var _i = 0; _i < instance_number(obj_castle_peasant); _i++)
    {
        var _other = instance_find(obj_castle_peasant, _i);
        if (_other != _resident && point_distance(_x, _y, _other.x, _other.y) < 16) return false;
    }
    return true;
}
