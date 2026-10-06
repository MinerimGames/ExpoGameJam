 display_set_gui_size(640, 380);
window_set_showborder(true);
window_set_size(960, 570);
window_center();

menu_options = [
    "JOGAR",
    "CONTROLES",
    "SAIR"
];

menu_selected = 0;

show_controls = false;

activate_option = false;

button_x = 190;
button_y = 185;
button_width = 260;
button_height = 42;
button_gap = 10;

color_background = make_color_rgb(57, 18, 91);
color_background_light = make_color_rgb(112, 49, 151);
color_yellow = make_color_rgb(245, 228, 50);
color_orange = make_color_rgb(255, 126, 0);
color_white = make_color_rgb(250, 249, 247);
color_green = make_color_rgb(31, 177, 74);
color_text = make_color_rgb(55, 8, 84);