/// Interacao do NPC.

interaction_available = false;

// Durante a batalha a interface do NPC fica silenciosa.
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
var _advance = keyboard_check_pressed(ord("E")) || keyboard_check_pressed(vk_space);

if (dialogue_active)
{
    npc_lock_player(true);

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

    // Depois do diálogo pós-batalha, cria o portal.
    if (dialogue_mode == "post" && !portal_created)
    {
        portal_created = true;

        var _portal = instance_create_layer(
            x + 36,
            y +12,
            "enemies",
            obj_portal
        );

        _portal.depth = depth + 1;
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
