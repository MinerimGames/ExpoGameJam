som_atualizar();
// This persistent instance owns F11 in every room, including the main menu.
// Browsers handle F11 themselves and require a user gesture for game fullscreen.
if (os_browser == browser_not_a_browser && keyboard_check_pressed(vk_f11))
{
    window_set_fullscreen(!window_get_fullscreen());
}
