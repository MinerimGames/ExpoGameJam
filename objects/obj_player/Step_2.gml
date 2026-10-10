var _old_x=x;var _old_y=y;
if(!movimento_liberado){velh=0;velv=0;}
move_and_collide(velh,velv,obj_colisor);
// Authored room transitions occur inside these foot-mask limits.
x=clamp(x,7,room_width-8);
y=clamp(y,1,room_height-9);
walk_travel=point_distance(_old_x,_old_y,x,y);
som_passo(walk_travel,movimento_liberado,x,y);
if(walk_travel>0.01 && movimento_liberado)
{
    walk_distance+=walk_travel;
    walk_cycle=(walk_cycle+walk_travel/8) mod 6;
    world_frame=floor(walk_cycle);
    update_player_art(true);
}
else
{
    world_frame=0;
    update_player_art(false);
}
depth=mundo_profundidade(y+ground_offset);
// Keep the camera's authored zoom while preventing blank map margins.
if(view_enabled && view_camera[0]!=-1)
{
    var _camera=view_camera[0];
    camera_set_view_pos(_camera,
        clamp(camera_get_view_x(_camera),0,max(0,room_width-camera_get_view_width(_camera))),
        clamp(camera_get_view_y(_camera),0,max(0,room_height-camera_get_view_height(_camera))));
}
