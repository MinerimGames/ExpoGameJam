var _gw = display_get_gui_width();
var _scale = min(_gw / 960, display_get_gui_height() / 540);

draw_set_font(fnt_ui);
draw_set_halign(fa_right);
draw_set_valign(fa_top);
draw_set_color(c_white);
var _hint = "AVANCE  >>";
switch (room)
{
    case rm_bosque: _hint = "TRILHA - SIGA PARA O CASTELO"; break;
    case rm_vila: _hint = "VILA - SIGA PARA A TRILHA"; break;
    case rm_castelo:
        _hint = instance_exists(obj_castle_guard)
            ? "ATRAVESSE A PONTE E FALE COM O GUARDA"
            : "SIGA ATE A PORTA DO CASTELO";
        break;
}
draw_text_transformed(_gw - 18 * _scale, 18 * _scale, _hint, 0.8 * _scale, 0.8 * _scale, 0);
draw_set_halign(fa_left);
