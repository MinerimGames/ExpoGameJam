estado_idle = new estado();
estado_walk = new estado();

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
    // Calcula primeiro a velocidade usando as teclas pressionadas
    velv = (down - up) * vel;
    velh = (right - left) * vel;

    // Se nenhuma direção estiver pressionada, volta para idle
    if (velh == 0 && velv == 0)
    {
        troca_estado(estado_idle);
        exit;
    }

    // Impede que o personagem ande mais rápido na diagonal
    var _tamanho = point_distance(0, 0, velh, velv);

    velh = (velh / _tamanho) * vel;
    velv = (velv / _tamanho) * vel;

    // Define a direção somente depois de calcular a velocidade
    dir = point_direction(0, 0, velh, velv) div 90;

    // Espelha o sprite lateral ao andar para a esquerda
    if (velh != 0)
    {
        image_xscale = sign(velh);
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