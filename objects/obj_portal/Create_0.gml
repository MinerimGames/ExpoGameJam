sprite_index = spr_portal;
image_index = 0;
image_speed = 1;
image_alpha = 0;

image_xscale = 0.8;
image_yscale = 0.8;

activation_delay = round(game_get_speed(gamespeed_fps) * 0.5);

portal_activated = false;
portal_destination = rm_cavernas;

// Keep the animated portal in front of the floor in every reality.
depth = mundo_profundidade(y);
portal_requires_exit = false;
if (instance_exists(obj_player))
{
    var _player = instance_find(obj_player, 0);
    portal_requires_exit = point_in_rectangle(_player.x, _player.y - 8,
        x - 9, y - 34, x + 9, y - 8);
}
