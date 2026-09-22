ambient_time += 0.018;

for (var i = 0; i < particle_count; i++)
{
    particle_x[i] += particle_speed[i];
    particle_y[i] += sin(ambient_time * 2 + particle_phase[i]) * 0.035;

    if (particle_x[i] > room_width + 4)
    {
        particle_x[i] = -4;
        particle_y[i] = random_range(40, room_height - 25);
    }
}
