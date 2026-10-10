matematica_progresso();
estado_idle = new estado();
estado_walk = new estado();

visual_scale = 1;
facing_sign = 1;
ground_offset = 7;
world_height = 28;
walk_cycle = 0;
walk_distance = 0;
walk_travel = 0;
world_frame = 0;
idle_clock = 0;
image_speed = 0;
image_alpha = 1;

if (room == rm_cavernas || room == rm_cavernas_2)
    depth = -20;

image_xscale = 1;
image_yscale = 1;

update_player_art = function(_walking)
{
    facing_sign = dir == 2 ? -1 : 1;
    if (!_walking)
        sprite_index = define_sprite(dir, spr_wilson_idle_side, spr_wilson_idle_front, spr_wilson_idle_back);
    else
    {
        var _second = (floor(walk_cycle) mod 2) == 1;
        sprite_index = _second
            ? define_sprite(dir, spr_wilson_walk_side_b, spr_wilson_walk_front_b, spr_wilson_walk_back_b)
            : define_sprite(dir, spr_wilson_walk_side_a, spr_wilson_walk_front_a, spr_wilson_walk_back_a);
    }
    image_index = 0;
};

estado_idle.inicia = function(){
    update_player_art(false);
}
estado_idle.roda = function()
{
    if ((up xor down) || (left xor right))
    {
        troca_estado(estado_walk);
    }
}

estado_walk.inicia = function(){
	dir = (point_direction(0, 0, right - left, down - up) div 90);
    walk_cycle = 0;
    update_player_art(true);
	image_index = 0;
}	

estado_walk.roda = function()
{
    velv = (down - up) * vel;
    velh = (right - left) * vel;

    if (velh == 0 && velv == 0)
    {
        troca_estado(estado_idle);
        exit;
    }

    var _tamanho = point_distance(0, 0, velh, velv);

    velh = (velh / _tamanho) * vel;
    velv = (velv / _tamanho) * vel;

    dir = point_direction(0, 0, velh, velv) div 90;

    update_player_art(true);
}


up = noone;
down = noone;
left = noone;
right = noone;

velh = 0;
velv = 0;
vel = 2;

dir = 3;

inicia_estado(estado_idle);

movimento_liberado = true;
som_garantir();
