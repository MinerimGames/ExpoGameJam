interaction_available = false;

if (instance_exists(obj_battle_controller))
{
    exit;
}

if (!instance_exists(obj_player))
{
    exit;
}

var _player = instance_find(obj_player, 0);
var _near = point_distance(x, y, _player.x, _player.y) <= interaction_distance;
var _advance = keyboard_check_pressed(ord("E"))
    || keyboard_check_pressed(vk_space);
var _mx = (ui_mouse_x_to_gui(0) - npc_ui_offset_x) / npc_ui_scale;
var _my = (ui_mouse_y_to_gui(0) - npc_ui_offset_y) / npc_ui_scale;
var _skip = keyboard_check_pressed(ord("P"))
    || (mouse_check_button_pressed(mb_left)
        && _mx >= 675 && _mx <= 875
        && _my >= 300 && _my <= 342);

if (dialogue_active)
{
    npc_lock_player(true);

    if (dialogue_mode == "intro" && _skip)
    {
        skip_tutorial();
        exit;
    }

    if (_advance)
    {
        var _pages = npc_current_dialogue();

        if (dialogue_page < array_length(_pages) - 1)
        {
            dialogue_page += 1;
        }
        else
        {
            dialogue_active = false;
            dialogue_page = 0;

            if (dialogue_mode == "intro" && !tutorial_started)
            {
                tutorial_started = true;
                batalha_iniciar(id, true);
            }
            else
            {
                npc_lock_player(false);

                if (dialogue_mode == "post")
                {
                    create_post_portal();
                }
            }
        }
    }

    exit;
}

interaction_available = _near;

if (_near && _advance)
{
    dialogue_mode = tutorial_completed ? "reminder" : "intro";
    dialogue_page = 0;
    dialogue_active = true;
    npc_lock_player(true);
}
