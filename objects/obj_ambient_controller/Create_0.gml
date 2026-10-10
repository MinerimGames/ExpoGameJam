if (instance_number(obj_ambient_controller) > 1)
{
    instance_destroy();
    exit;
}

ambient_environment = batalha_ambiente(room);
depth = room == rm_tutorial ? 50 : 150;
water_points = [];
leaf_points = [];
fire_points = [];
particles = [];
particle_limit = 40;
ambient_time = 0;
water_timer = 0.3;
leaf_timer = 1.2;
dust_timer = 0.5;
ember_timer = 0.2;

// Índices interiores conferidos nas imagens originais: sem margens, pedras ou ponte.
var _water_indices = room == rm_cavernas
    ? [587,588,635,636]
    : [975,976,977,978,980,981,982,983,984,986,987,988,990,
       1021,1022,1025,1027,1028,1029,1032,1034,1035,1036,1037,1038,
       1069,1070,1074,1075,1076,1079,1080,1082,1086,1117,1118,1119,
       1122,1123,1124,1167,1168,1169,1171,1173,1215,1216,1217,1221,
       1222,1263,1264,1265,1266,1269,1309,1310,1311,1314,1315,1316,
       1357,1358,1362,1363,1364,1365];
var _names = [room == rm_cavernas ? "Tiles_Agua" : "Tiles_Lagoa",
    room == rm_tutorial ? "props_sob" : "Tiles_Arvores", "Tiles_Acampamento"];
for (var _kind = 0; _kind < array_length(_names); _kind++)
{
    var _layer = layer_get_id(_names[_kind]);
    if (_layer == -1) continue;
    var _map = layer_tilemap_get_id(_layer);
    if (_map == -1) continue;
    for (var _cy = 0; _cy < tilemap_get_height(_map); _cy++)
    for (var _cx = 0; _cx < tilemap_get_width(_map); _cx++)
    {
        var _index = tile_get_index(tilemap_get(_map, _cx, _cy));
        if (_index == 0) continue;
        var _px = layer_get_x(_layer) + _cx * 16 + 8;
        var _py = layer_get_y(_layer) + _cy * 16 + 8;
        if (_px >= room_width || _py >= room_height) continue;
        if (_kind == 0 && array_contains(_water_indices, _index))
            array_push(water_points, { x: _px, y: _py });
        if (_kind == 1)
        {
            // 608 é o centro da copa existente no tutorial; as cavernas têm layer próprio.
            var _canopy = room == rm_tutorial ? _index == 608 : (_cx mod 4 == 0 && _cy mod 3 == 0);
            if (_canopy) array_push(leaf_points, { x: _px, y: _py });
        }
        // 147 identifica uma vez a chama da fogueira já colocada nesta sala.
        if (_kind == 2 && _index == 147)
            array_push(fire_points, { x: _px - 8, y: _py + 4 });
    }
}

water_enabled = array_length(water_points) > 0;
leaves_enabled = array_length(leaf_points) > 0;
dust_enabled = room == rm_cavernas || room == rm_cavernas_2;
fire_enabled = array_length(fire_points) > 0;
embers_enabled = fire_enabled;

ambient_spawn = function(_kind, _x, _y)
{
    if (array_length(particles) >= particle_limit) return false;
    if (_x < 0 || _y < 0 || _x >= room_width || _y >= room_height) return false;
    var _life = random_range(4, 6);
    var _vx = random_range(-2, 2);
    var _vy = -1;
    switch (_kind)
    {
        case "leaf": _vx = random_range(2, 5); _vy = random_range(7, 11); break;
        case "water": _vx = 0; _vy = 0; _life = random_range(1.4, 2.4); break;
        case "ember": _vx = random_range(-2, 2); _vy = random_range(-12, -7); _life = random_range(1.2, 2.2); break;
    }
    array_push(particles, { kind: _kind, x: _x, y: _y, vx: _vx, vy: _vy,
        age: 0, life: _life, phase: random(2 * pi) });
    return true;
};

ambient_update = function(_dt)
{
    ambient_time += _dt;
    for (var _i = array_length(particles) - 1; _i >= 0; _i--)
    {
        var _p = particles[_i];
        _p.age += _dt;
        _p.x += _p.vx * _dt;
        _p.y += _p.vy * _dt;
        if (_p.age >= _p.life || _p.x < 0 || _p.y < 0 || _p.x >= room_width || _p.y >= room_height)
            array_delete(particles, _i, 1);
    }
    water_timer -= _dt;
    leaf_timer -= _dt;
    dust_timer -= _dt;
    ember_timer -= _dt;
    if (water_enabled && water_timer <= 0 && array_length(water_points) > 0)
    {
        water_timer = random_range(0.22, 0.40);
        var _point = water_points[irandom(array_length(water_points) - 1)];
        ambient_spawn("water", _point.x, _point.y);
    }
    if (leaves_enabled && leaf_timer <= 0 && array_length(leaf_points) > 0)
    {
        leaf_timer = random_range(1.1, 2.2);
        var _point = leaf_points[irandom(array_length(leaf_points) - 1)];
        ambient_spawn("leaf", _point.x, _point.y);
    }
    if (dust_enabled && dust_timer <= 0)
    {
        dust_timer = random_range(0.4, 0.9);
        ambient_spawn("dust", random_range(8, room_width - 8), random_range(8, room_height - 8));
    }
    if (embers_enabled && ember_timer <= 0 && array_length(fire_points) > 0)
    {
        ember_timer = random_range(0.18, 0.36);
        var _point = fire_points[irandom(array_length(fire_points) - 1)];
        ambient_spawn("ember", _point.x + random_range(-3, 3), _point.y);
    }
};
