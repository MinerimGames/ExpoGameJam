var _previous_alpha = draw_get_alpha();
var _previous_color = draw_get_color();
gpu_set_blendmode(bm_normal);
draw_set_alpha(1);
draw_set_color(c_white);

if (image_angle==0)
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

if(image_angle==0 && wilson_desenhar_mapa(x,y+ground_offset,dir,world_frame,world_height*visual_scale))
{
    draw_set_alpha(_previous_alpha);draw_set_color(_previous_color);exit;
}
var _art_scale = world_height * visual_scale
    / (sprite_get_bbox_bottom(sprite_index)-sprite_get_bbox_top(sprite_index)+1);
var _breath = estado_atual == estado_idle ? 1 + 0.015 * sin(idle_clock) : 1;
draw_sprite_ext(
    sprite_index,
    image_index,
    x,
    y + ground_offset,
    facing_sign * _art_scale,
    _art_scale * _breath,
    image_angle,
    image_blend,
    1
);

draw_set_alpha(_previous_alpha);
draw_set_color(_previous_color);
