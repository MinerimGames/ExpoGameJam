estado_idle = new estado();
estado_walk = new estado();

visual_scale = 1;
facing_sign = 1;
ground_offset = 7;
image_alpha = 1;

if (room == rm_cavernas || room == rm_cavernas_2)
    depth = -20;

image_xscale = 1;
image_yscale = 1;

estado_idle.inicia = function(){
	var _sprite = define_sprite(dir, spr_player_idle_side, spr_player_idle_front, spr_player_idle_back);
	sprite_index = _sprite;
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
	sprite_index = define_sprite(dir, spr_player_walk_side, spr_player_walk_front, spr_player_walk_back);
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

    if (velh != 0)
    {
        facing_sign = sign(velh);
    }

    sprite_index = define_sprite(
        dir,
        spr_player_walk_side,
        spr_player_walk_front,
        spr_player_walk_back
    );
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