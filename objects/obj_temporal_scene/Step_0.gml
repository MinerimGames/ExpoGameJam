var _dt=min(delta_time/1000000,0.1);
scene_time+=_dt;
if(scene_mode=="departures" || scene_mode=="fracture")
{
    advance_finale(_dt);exit;
}
if(transformation_active)
{
    transformation_time=min(transformation_duration,transformation_time+_dt);
    var _newton=instance_find(obj_newton_final,0);
    if(instance_exists(_newton))
    {
        _newton.transformation_progress=transformation_time/transformation_duration;
        if(transformation_time>=transformation_duration)_newton.reveal_evil();
    }
    if(transformation_time>=transformation_duration)transformation_active=false;
    historia_newton_bloquear(true);
    // Consume the completion frame too, so its confirmation cannot skip the accusation.
    exit;
}
if(scene_mode=="arrival" && scene_time>=0.6)begin_dialogue("exposure","exposure");
if(scene_mode=="recovery" && scene_time>=1.3){with(obj_player)image_angle=0;}
if(dialogue_active)
{
    historia_newton_bloquear(true);
    if(scene_time>=0.6 && (keyboard_check_pressed(ord("E")) || keyboard_check_pressed(vk_space)))advance_dialogue();
    exit;
}
