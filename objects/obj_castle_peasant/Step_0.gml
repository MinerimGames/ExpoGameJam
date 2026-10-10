// Residents pause while the encounter has the player's attention.
if (instance_exists(obj_battle_controller)) exit;
if (instance_exists(obj_player) && !instance_find(obj_player, 0).movimento_liberado) exit;
var _dt = 1 / game_get_speed(gamespeed_fps);
if (!walking && current_speed == 0)
{
    state_time -= _dt;
    if (state_time <= 0)
    {
        // Pick a clear path before turning, excluding back-facing walking.
        var _directions = [0, 2, 3];
        var _first = irandom(2);
        for (var _i = 0; _i < 3; _i++)
        {
            var _direction = _directions[(_first+_i) mod 3];
            var _dx = _direction == 2 ? -1 : (_direction == 3 ? 1 : 0);
            var _dy = _direction == 0 ? 1 : 0;
            var _distance = 0;
            var _limit = walk_speed * random_range(0.8, 2.4);
            for (var _step = 1; _step <= _limit; _step++)
            {
                if (!castle_peasant_can_move(id, x+_dx*_step, y+_dy*_step)) break;
                _distance = _step;
            }
            if (_distance < 4) continue;
            _distance = random_range(4, _distance);
            walk_target_x = x + _dx * _distance;
            walk_target_y = y + _dy * _distance;
            walk_direction = _direction;
            walking = true;
            animation_time = 0;
            break;
        }
        if (!walking) state_time = random_range(0.6, 1.8);
    }
}
var _remaining = point_distance(x, y, walk_target_x, walk_target_y);
if (walking && _remaining <= 0.05)
{
    walking = false;
    state_time = random_range(0.6, 1.8);
}
// Ease into walking and reduce the speed as the destination approaches.
var _desired = walking ? min(walk_speed, _remaining * 4) : 0;
if (current_speed < _desired) current_speed = min(_desired, current_speed+walk_acceleration*_dt);
else current_speed = max(_desired, current_speed-walk_acceleration*_dt);
if (current_speed > 0)
{
    var _dx = walk_direction == 2 ? -1 : (walk_direction == 3 ? 1 : 0);
    var _dy = walk_direction == 0 ? 1 : 0;
    var _distance = min(_remaining, current_speed * _dt);
    var _nx = x + _dx * _distance;
    var _ny = y + _dy * _distance;
    if (castle_peasant_can_move(id, _nx, _ny)) { x = _nx; y = _ny; }
    else
    {
        // A newly arrived player or obstacle takes priority over easing.
        walking = false;
        current_speed = 0;
    }
    if (!walking && current_speed == 0) state_time = random_range(0.6, 1.8);
}
if (current_speed > 0.2)
{
    animation_time = (animation_time + 8 * (current_speed / walk_speed) * _dt) mod 5;
    image_index = (walk_direction+1)*5 + floor(animation_time);
}
else if (walk_direction == 0)
{
    animation_time = (animation_time + 4*_dt) mod 5;
    image_index = floor(animation_time);
}
else image_index = (walk_direction+1)*5;
