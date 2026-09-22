estado_idle = new estado();
estado_walk = new estado();

// Nos cenários amplos das cavernas, aumenta apenas a representação no mapa.
// O tutorial e a tela de batalha mantêm suas escalas originais.
visual_scale = (room == rm_cavernas || room == rm_cavernas_2) ? 2.0 : 1.0;
facing_sign = 1;
ground_offset = 7;
image_alpha = 1;

// Os recortes de cenário (depth 0) não podem cobrir o corpo com pixels
// esparsos. As colisões continuam delimitando os objetos sólidos.
if (room == rm_cavernas || room == rm_cavernas_2)
    depth = -20;

// A escala da instância fica fixa para que a máscara de colisão não cresça
// dentro de pedras e plantas. O tamanho visual é aplicado apenas no Draw.
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
vel = (room == rm_cavernas || room == rm_cavernas_2) ? 2 : 3;

dir = 3;

inicia_estado(estado_idle);

movimento_liberado = true;

// Controle das marcas de passos nos mapas das cavernas.
footstep_timer = 0;
footstep_side = -1;
