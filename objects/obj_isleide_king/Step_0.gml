if (instance_exists(obj_battle_controller)) exit;
var _fps = game_get_speed(gamespeed_fps);
idle_time += 1 / _fps;
state_ticks += 1;
if (encounter_state == "seated")
{
    if (state_ticks >= round(_fps))
    {
        encounter_state = "rising";
        state_ticks = 0;
    }
    exit;
}
if (encounter_state == "rising")
{
    var _t = clamp(state_ticks / max(1, round(_fps * 0.65)), 0, 1);
    pose_mix = _t * _t * (3 - 2 * _t);
    if (_t >= 1)
    {
        encounter_state = "dialogue";
        dialogue_active = true;
        state_ticks = 0;
    }
    exit;
}
if (dialogue_active
    && (keyboard_check_pressed(ord("E")) || keyboard_check_pressed(vk_space)))
{
    if (dialogue_page < array_length(dialogue_pages)-1) dialogue_page += 1;
    else
    {
        dialogue_active = false;
        encounter_state = "battle";
        batalha_iniciar(id, false);
    }
}
