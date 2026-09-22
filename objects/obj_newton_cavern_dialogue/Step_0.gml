if (!dialogue_active)
    exit;

if (keyboard_check_pressed(ord("E")) || keyboard_check_pressed(vk_space))
{
    if (dialogue_page < array_length(dialogue_pages) - 1)
    {
        dialogue_page += 1;
    }
    else
    {
        dialogue_active = false;
        with (obj_player)
        {
            movimento_liberado = true;
            velh = 0;
            velv = 0;
        }
    }
}
