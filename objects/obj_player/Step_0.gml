if (movimento_liberado)
{
	up = keyboard_check(ord("W"))
	down = keyboard_check(ord("S"))
	left = keyboard_check(ord("A"))
	right = keyboard_check(ord("D"))
}
else
{
	up = false;
	down = false;
	left = false;
	right = false;
}

roda_estado();