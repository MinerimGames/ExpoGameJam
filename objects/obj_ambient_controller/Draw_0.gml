var _old_alpha = draw_get_alpha();
var _old_color = draw_get_color();

if (fire_enabled)
{
    for (var _f = 0; _f < array_length(fire_points); _f++)
    {
        var _fire = fire_points[_f];
        var _pulse = 0.5 + 0.5 * sin(ambient_time * 6.7 + _f);
        draw_set_color(make_color_rgb(255, 172, 63));
        draw_set_alpha(0.06 + _pulse * 0.025);
        draw_ellipse(_fire.x - 23, _fire.y - 18, _fire.x + 23, _fire.y + 23, false);
        draw_set_alpha(0.10 + _pulse * 0.035);
        draw_ellipse(_fire.x - 12, _fire.y - 8, _fire.x + 12, _fire.y + 13, false);
        draw_set_alpha(0.35 + _pulse * 0.25);
        draw_set_color(make_color_rgb(255, 232, 130));
        var _flicker = round(sin(ambient_time * 9.1) * 2);
        draw_rectangle(_fire.x - 1, _fire.y - 1 + _flicker, _fire.x + 1, _fire.y + 3, false);
    }
}

for (var _i = 0; _i < array_length(particles); _i++)
{
    var _p = particles[_i];
    var _fade = min(1, _p.age * 2) * clamp((_p.life - _p.age) * 1.5, 0, 1);
    var _x = round(_p.x);
    var _y = round(_p.y);
    switch (_p.kind)
    {
        case "water":
            draw_set_color(make_color_rgb(174, 239, 242));
            draw_set_alpha(_fade * 0.38);
            var _wave = round(sin(_p.age * 3 + _p.phase));
            var _width = 2 + floor(_p.age);
            draw_line(_x - _width, _y + _wave, _x + _width, _y + _wave);
            draw_set_alpha(_fade * 0.17);
            draw_line(_x - 1, _y + _wave + 2, _x + 1, _y + _wave + 2);
            break;
        case "leaf":
            _x += round(sin(_p.age * 2.4 + _p.phase) * 2);
            draw_set_alpha(_fade * 0.65);
            draw_set_color(make_color_rgb(147, 166, 72));
            draw_rectangle(_x, _y, _x + 2, _y + 1, false);
            draw_set_color(make_color_rgb(88, 118, 56));
            draw_point(_x + 1, _y + 2);
            break;
        case "dust":
            draw_set_alpha(_fade * 0.20);
            draw_set_color(make_color_rgb(209, 200, 158));
            draw_point(_x, _y);
            break;
        case "ember":
            draw_set_alpha(_fade * 0.70);
            draw_set_color(make_color_rgb(255, 165, 60));
            draw_point(_x, _y);
            draw_set_alpha(_fade * 0.28);
            draw_point(_x, _y + 1);
            break;
    }
}

draw_set_alpha(_old_alpha);
draw_set_color(_old_color);
