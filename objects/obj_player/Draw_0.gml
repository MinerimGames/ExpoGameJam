/// Sombra de contato para firmar o personagem no chão.

// Estado explícito de desenho: efeitos de névoa e partículas não devem
// transferir transparência ou mistura de cores para o personagem.
var _previous_alpha = draw_get_alpha();
var _previous_color = draw_get_color();
gpu_set_blendmode(bm_normal);
draw_set_alpha(1);
draw_set_color(c_white);

if (room == rm_cavernas || room == rm_cavernas_2)
{
    draw_set_alpha(0.28);
    draw_set_color(make_color_rgb(28, 38, 24));
    draw_ellipse(
        x - 7 * visual_scale,
        y + ground_offset - 2,
        x + 7 * visual_scale,
        y + ground_offset + 2,
        false
    );
    draw_set_alpha(1);
    draw_set_color(c_white);
}

// A ampliação é ancorada nos pés, mantendo o contato no mesmo ponto
// da máscara física. O corpo cresce para cima, e não para dentro do chão.
draw_sprite_ext(
    sprite_index,
    image_index,
    x,
    y + ground_offset * (1 - visual_scale),
    facing_sign * visual_scale,
    visual_scale,
    image_angle,
    image_blend,
    1
);

draw_set_alpha(_previous_alpha);
draw_set_color(_previous_color);
