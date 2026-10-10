if (room != rm_bosque && room != rm_vila) { instance_destroy(); exit; }
var _variants = room == rm_bosque ? [spr_castle_peasant_2]
    : [spr_castle_peasant_1, spr_castle_peasant_3, spr_castle_peasant_4, spr_castle_peasant_5, spr_castle_peasant_6];
var _areas = peasant_home_areas(room);
for (var _i = 0; _i < array_length(_variants); _i++)
{
    var _home = _areas[_i];
    for (var _attempt = 0; _attempt < 200; _attempt++)
    {
        var _x = random_range(_home[0], _home[2]);
        var _y = random_range(_home[1], _home[3]);
        if (!castle_peasant_can_stand(_x, _y)) continue;
        if (instance_exists(obj_player))
        {
            var _p = instance_find(obj_player, 0);
            if (point_distance(_x, _y, _p.x, _p.y) < 28) continue;
        }
        var _resident = instance_create_depth(_x, _y, room == rm_vila ? 410 : 210, obj_castle_peasant);
        _resident.sprite_index = _variants[_i];
        _resident.visual_scale = 30 / sprite_get_height(_resident.sprite_index);
        _resident.home_left = _home[0];
        _resident.home_top = _home[1];
        _resident.home_right = _home[2];
        _resident.home_bottom = _home[3];
        break;
    }
}
instance_destroy();
