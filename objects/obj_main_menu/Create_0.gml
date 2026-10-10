display_set_gui_size(640, 380);
window_set_showborder(true);
if (os_browser != browser_not_a_browser && variable_global_exists("menu_browser_pixel_width"))
    window_set_size(global.menu_browser_pixel_width, global.menu_browser_pixel_height);
else window_set_size(960, 570);
window_center();

menu_options = [
    "JOGAR",
    "CONTROLES",
    "TELA CHEIA",
    "SAIR"
];

menu_selected = 0;

show_controls = false;

activate_option = false;

button_x = 28;
button_y = 341;
button_width = 140;
button_height = 24;
button_gap = 8;

// A browser tab is closed by the browser; ending its runner would leave an
// empty canvas. Keep play, controls and fullscreen centred for the web build.
if (os_browser != browser_not_a_browser)
{
    menu_options = ["JOGAR", "CONTROLES", "TELA CHEIA"];
    button_x = 60;
    button_width = 164;
    button_gap = 14;
}
menu_options[2] = window_get_fullscreen() ? "JANELA" : "TELA CHEIA";
menu_browser_fullscreen = false;
if (variable_global_exists("menu_browser_fullscreen")) menu_browser_fullscreen = global.menu_browser_fullscreen;
menu_browser_density = 1;
if (variable_global_exists("menu_browser_density")) menu_browser_density = global.menu_browser_density;
menu_web_clickable = -1;

color_background = make_color_rgb(57, 18, 91);
color_background_light = make_color_rgb(112, 49, 151);
color_yellow = make_color_rgb(245, 228, 50);
color_orange = make_color_rgb(255, 126, 0);
color_white = make_color_rgb(250, 249, 247);
color_green = make_color_rgb(31, 177, 74);
color_text = make_color_rgb(55, 8, 84);
som_garantir();

menu_button=function(_i){return {x:button_x+_i*(button_width+button_gap),y:button_y,w:button_width,h:button_height};};

menu_mouse_x=ui_mouse_x_to_gui(0);menu_mouse_y=ui_mouse_y_to_gui(0);
menu_hover=function(_mx,_my,_click,_moved)
{
    if(!_moved && !_click)return;
    for(var i=0;i<array_length(menu_options);i++)
    {
        var _r=menu_button(i);
        if(point_in_rectangle(_mx,_my,_r.x,_r.y,_r.x+_r.w,_r.y+_r.h))
        {
            menu_selected=i;
            if(_click)activate_option=true;
            return;
        }
    }
};

menu_update_web_button = function()
{
    if (os_browser == browser_not_a_browser) return;
    if (show_controls)
    {
        if (menu_web_clickable != -1) clickable_delete(menu_web_clickable);
        menu_web_clickable = -1;
        return;
    }
    var _button = menu_button(2);
    // HTML5 window width/height count physical canvas pixels, while the DOM
    // clickable position and size count CSS pixels. Its origin is already CSS.
    var _sx = window_get_width() / menu_browser_density / display_get_gui_width();
    var _sy = window_get_height() / menu_browser_density / display_get_gui_height();
    var _x = window_get_x() + _button.x * _sx;
    var _y = window_get_y() + _button.y * _sy;
    var _tpe = sprite_get_tpe(spr_menu_fullscreen_hitbox, 0);
    if (menu_web_clickable == -1)
    {
        // The DOM overlay receives a real trusted browser click. Its lifecycle
        // follows this menu instance; it does not listen for global coordinates.
        menu_web_clickable = clickable_add(_x, _y, _tpe, "gmcallback_menu_fullscreen", "", "");
    }
    clickable_change(menu_web_clickable, _tpe, _x, _y);
    var _style = ds_map_create();
    _style[? "width"] = string(_button.w * _sx) + "px";
    _style[? "height"] = string(_button.h * _sy) + "px";
    _style[? "opacity"] = "0";
    _style[? "cursor"] = "pointer";
    _style[? "padding"] = "0";
    _style[? "outline"] = "0";
    clickable_set_style(menu_web_clickable, _style);
    ds_map_destroy(_style);
};
