/// Atmosfera compartilhada pelos dois cenários das cavernas.

ambient_time = random(1000);
particle_count = 24;
particle_x = array_create(particle_count, 0);
particle_y = array_create(particle_count, 0);
particle_speed = array_create(particle_count, 0);
particle_phase = array_create(particle_count, 0);

for (var i = 0; i < particle_count; i++)
{
    particle_x[i] = random(room_width);
    particle_y[i] = random_range(40, room_height - 25);
    particle_speed[i] = random_range(0.06, 0.18);
    particle_phase[i] = random(100);
}
