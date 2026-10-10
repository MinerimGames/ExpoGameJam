batalha_animacao_atualizar(id);
update_ui_transform();
player_pose_timer = max(0, player_pose_timer - 1);

if (result_visible)
{
    result_timer -= 1;
    if (result_timer <= 0)
    {
        result_visible = false;
    }
}

var _mx = (ui_mouse_x_to_gui(0) - ui_offset_x) / ui_scale;
var _my = (ui_mouse_y_to_gui(0) - ui_offset_y) / ui_scale;
var _click = mouse_check_button_pressed(mb_left);
if (handle_test_skip(_mx, _my, _click)) exit;
if (handle_paradox_input(_mx, _my, _click, keyboard_check_pressed(ord("Q")))) exit;

switch (battle_screen)
{
    case "actions":
    {

        if ((_click && inside_ref_rect(_mx, _my, 660, 325, 140, 90)) || keyboard_check_pressed(ord("1")))
        {
            request_action("attack");
        }
        else if ((_click && inside_ref_rect(_mx, _my, 810, 325, 140, 90)) || keyboard_check_pressed(ord("2")))
        {
            request_action("heal");
        }
        else if ((_click && inside_ref_rect(_mx, _my, 660, 425, 140, 90)) || keyboard_check_pressed(ord("3")))
        {
            request_action("defense");
        }
        else if ((_click && inside_ref_rect(_mx, _my, 810, 425, 140, 90)) || keyboard_check_pressed(ord("4")))
        {
            request_action("dodge");
        }
        break;
    }

    case "challenge":
    {

        answer_text = string_digits(keyboard_string);

        if (string_length(answer_text) > 5)
        {
            answer_text = string_copy(answer_text, 1, 5);
        }

        keyboard_string = answer_text;

        var _ok_mouse =
    _click
    && inside_ref_rect(
        _mx,
        _my,
        582,
        322,
        136,
        66
    );
        if (_ok_mouse || keyboard_check_pressed(vk_enter))
        {
            verify_answer();
        }
        break;
    }

    case "victory":
    {
        var _return_mouse = _click && inside_ref_rect(_mx, _my, 350, 335, 260, 60);
        if (_return_mouse || keyboard_check_pressed(vk_enter))
        {
            leave_after_victory();
        }
        break;
    }

    case "defeat":
    {
        var _retry_mouse = _click && inside_ref_rect(_mx, _my, 350, 335, 260, 60);
        if (_retry_mouse || keyboard_check_pressed(vk_enter))
        {
            restart_battle();
        }
        break;
    }
}
