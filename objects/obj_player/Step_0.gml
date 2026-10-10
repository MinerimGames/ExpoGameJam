idle_clock += min(delta_time / 1000000, 0.1) * 2.4;
if (movimento_liberado)
{
	up = keyboard_check(ord("W")) || keyboard_check(vk_up);
	down = keyboard_check(ord("S")) || keyboard_check(vk_down);
	left = keyboard_check(ord("A")) || keyboard_check(vk_left);
	right = keyboard_check(ord("D")) || keyboard_check(vk_right);
}
else
{
	up = false;
	down = false;
	left = false;
	right = false;
}

roda_estado();
