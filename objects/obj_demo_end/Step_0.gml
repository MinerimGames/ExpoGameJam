// Volta ao menu.
if (
    keyboard_check_pressed(vk_enter)
    || keyboard_check_pressed(vk_space)
)
{
    room_goto(rm_menu);
}

// Encerra o jogo.
if (keyboard_check_pressed(vk_escape))
{
    game_end();
}