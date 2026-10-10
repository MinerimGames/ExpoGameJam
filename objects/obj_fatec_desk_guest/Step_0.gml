idle_time+=min(delta_time/1000000,0.1);
var _teacher=instance_find(obj_fatec_ending,0);
if(instance_exists(_teacher))
{
    var _near=clamp(1-abs(_teacher.professor_y-y)/130,0,1);
    attention=lerp(attention,_near,0.08);
}
else attention=lerp(attention,0,0.08);
// Keep the chair and seated pose facing left beside the bin.
look_sign=-1;
depth=mundo_profundidade(y);
