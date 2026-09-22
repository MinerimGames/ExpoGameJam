var _previous_x = x;
var _previous_y = y;
move_and_collide(velh, velv, obj_colisor);

var _in_caverns = (room == rm_cavernas || room == rm_cavernas_2);
var _walking = movimento_liberado
    && point_distance(x, y, _previous_x, _previous_y) > 0.1;

// Escala visual constante: evita oscilação de tamanho e amostragem
// fracionária da pixel art ao atravessar os dois mapas das cavernas.
visual_scale = _in_caverns ? 2.0 : 1.0;

if (_in_caverns && _walking)
{
    footstep_timer -= 1;

    if (footstep_timer <= 0)
    {
        footstep_side *= -1;

        var _step = instance_create_depth(
            x + footstep_side * 4,
            y + ground_offset,
            101,
            obj_footprint
        );

        _step.foot_side = footstep_side;
        footstep_timer = max(8, round(room_speed * 0.16));
    }
}
else
{
    footstep_timer = 0;
}
