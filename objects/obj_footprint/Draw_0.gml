var _fade = clamp(life / life_max, 0, 1);

draw_set_alpha(0.48 * _fade);
draw_set_color(make_color_rgb(36, 34, 24));
draw_ellipse(x - 3.5, y - 2, x + 3.5, y + 2, false);
draw_circle(x - foot_side * 1.5, y + 1.5, 1.5, false);

// Pequena poeira do contato do pé, visível somente no início da marca.
if (life > life_max - 14)
{
    var _dust = (life_max - life) * 0.12;
    draw_set_alpha(0.22 * (1 - _dust / 2));
    draw_circle(x + foot_side * 3, y - 2 - _dust, 1, false);
}

draw_set_alpha(1);
draw_set_color(c_white);
