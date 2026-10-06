 if (keyboard_check_pressed(vk_f11))
{
    window_set_fullscreen(!window_get_fullscreen());
}

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
)
{
    menu_selected--;

    if (menu_selected < 0)
    {
        menu_selected = _option_count - 1;
    }
}

if (
    keyboard_check_pressed(vk_down)
    || keyboard_check_pressed(ord("S"))
)
{
    menu_selected++;

    if (menu_selected >= _option_count)
    {
        menu_selected = 0;
    }
}

var _mouse_x = device_mouse_x_to_gui(0);
var _mouse_y = device_mouse_y_to_gui(0);

for (var i = 0; i < _option_count; i++)
{
    var _button_top = button_y + i * (button_height + button_gap);
    var _button_bottom = _button_top + button_height;

    if (
        point_in_rectangle(
            _mouse_x,
            _mouse_y,
            button_x,
            _button_top,
            button_x + button_width,
            _button_bottom
        )
    )
    {
        menu_selected = i;

        if (mouse_check_button_pressed(mb_left))
        {
            activate_option = true;
        }
    }
}

if (
    keyboard_check_pressed(vk_enter)
    || keyboard_check_pressed(vk_space)
)
{
    activate_option = true;
}

if (activate_option)
{
    activate_option = false;

    switch (menu_selected)
    {
        case 0:
            room_goto(rm_tutorial);
            break;

        case 1:
            show_controls = true;
            break;

        case 2:
            game_end();
            break;
    }
}