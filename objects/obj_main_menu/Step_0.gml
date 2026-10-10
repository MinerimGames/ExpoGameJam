var _full = os_browser == browser_not_a_browser ? window_get_fullscreen() : menu_browser_fullscreen;
menu_options[2] = _full ? "JANELA" : "TELA CHEIA";
menu_update_web_button();

if (show_controls)
{
    if (
        keyboard_check_pressed(vk_escape)
        || keyboard_check_pressed(vk_enter)
        || mouse_check_button_pressed(mb_left)
    )
    {
        show_controls = false;
    }

    exit;
}

var _option_count = array_length(menu_options);

if (
    keyboard_check_pressed(vk_up)
    || keyboard_check_pressed(ord("W"))
    || keyboard_check_pressed(vk_left)
    || keyboard_check_pressed(ord("A"))
)
{
    som_efeito("select");
    menu_selected--;

    if (menu_selected < 0)
    {
        menu_selected = _option_count - 1;
    }
}

if (
    keyboard_check_pressed(vk_down)
    || keyboard_check_pressed(ord("S"))
    || keyboard_check_pressed(vk_right)
    || keyboard_check_pressed(ord("D"))
)
{
    som_efeito("select");
    menu_selected++;

    if (menu_selected >= _option_count)
    {
        menu_selected = 0;
    }
}

var _mouse_x = ui_mouse_x_to_gui(0);
var _mouse_y = ui_mouse_y_to_gui(0);

var _mouse_moved=point_distance(_mouse_x,_mouse_y,menu_mouse_x,menu_mouse_y)>0.5;
menu_mouse_x=_mouse_x;menu_mouse_y=_mouse_y;
menu_hover(_mouse_x,_mouse_y,mouse_check_button_pressed(mb_left),_mouse_moved);

if (
    keyboard_check_pressed(vk_enter)
    || keyboard_check_pressed(vk_space)
)
{
    activate_option = true;
}

if (activate_option)
{
    som_efeito("select");
    activate_option = false;

    switch (menu_selected)
    {
        case 0:
            matematica_progresso(true);
            historia_newton_progresso(true);
            room_goto(rm_tutorial);
            break;

        case 1:
            show_controls = true;
            break;

        case 2:
            if (os_browser == browser_not_a_browser)
                window_set_fullscreen(!window_get_fullscreen());
            break;

        case 3:
            game_end();
            break;
    }
}
