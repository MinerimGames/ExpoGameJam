/// Luz, poeira suspensa e névoa sutil sobre o cenário.

var _pulse = 0.5 + 0.5 * sin(ambient_time);

draw_set_alpha(0.035 + _pulse * 0.018);
draw_set_color(make_color_rgb(34, 78, 62));
draw_rectangle(0, 0, room_width, room_height, false);

// Feixes suaves atravessando a copa das árvores.
draw_set_alpha(0.022 + _pulse * 0.012);
draw_set_color(make_color_rgb(225, 238, 176));
draw_triangle(80, 0, 205, 0, 290, room_height, false);
draw_triangle(430, 0, 510, 0, 390, room_height, false);

// Poeira e pólen em movimento lento.
for (var i = 0; i < particle_count; i++)
{
    var _sparkle = 0.25 + 0.55 * abs(sin(ambient_time * 1.7 + particle_phase[i]));
    draw_set_alpha(0.16 * _sparkle);
    draw_set_color((i mod 3 == 0) ? make_color_rgb(244, 224, 135) : c_white);
    draw_circle(particle_x[i], particle_y[i], (i mod 4 == 0) ? 1.2 : 0.7, false);
}

// Névoa baixa acompanha o chão sem esconder os personagens.
draw_set_color(make_color_rgb(190, 215, 190));
draw_set_alpha(0.035);
var _mist_offset = sin(ambient_time * 0.55) * 18;
draw_ellipse(-90 + _mist_offset, 292, 310 + _mist_offset, 365, false);
draw_ellipse(330 - _mist_offset, 300, 750 - _mist_offset, 370, false);

draw_set_alpha(1);
draw_set_color(c_white);
