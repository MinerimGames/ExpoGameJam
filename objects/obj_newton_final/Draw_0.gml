var _scene=instance_find(obj_temporal_scene,0);
var _alpha=instance_exists(_scene) && (_scene.scene_mode=="ending" || _scene.scene_mode=="complete")?0.40:1;
var _breath=1+sin(idle_time*2.4)*0.035;
var _sway=sin(idle_time*1.6)*2.5;
if(instance_exists(_scene) && _scene.transformation_active)
{
    var _progress=clamp(transformation_progress,0,1);
    historia_newton_retrato(normal_sprite,x,y+7,30*_breath,_alpha*(1-_progress),_sway);
    historia_newton_retrato(evil_sprite,x,y+7,30*_breath,_alpha*_progress,_sway);
    var _old_alpha=draw_get_alpha();var _old_color=draw_get_color();
    draw_set_color(make_color_rgb(190,94,245));draw_set_alpha(sin(_progress*pi)*0.8);
    draw_circle(x,y-9,9+_progress*25,true);
    draw_circle(x,y-9,5+_progress*17,true);
    draw_set_alpha(_old_alpha);draw_set_color(_old_color);
}
else historia_newton_retrato(battle_sprite,x,y+7,30*_breath,_alpha,_sway);
