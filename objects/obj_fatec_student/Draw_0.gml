var _filter=gpu_get_texfilter();
var _alpha=draw_get_alpha();var _colour=draw_get_color();
gpu_set_texfilter(false);
draw_set_alpha(0.18);draw_set_color(make_color_rgb(29,35,30));
draw_ellipse(x-7,y-2,x+7,y+2,false);
draw_set_alpha(1);draw_set_color(c_white);
var _height=student_height*(1+0.008*sin(idle_time*2+photo_index*1.7));
var _scale=_height/(sprite_get_bbox_bottom(sprite_index)-sprite_get_bbox_top(sprite_index)+1);
var _nod=look_sign*attention*1.1*sin(idle_time*2.4+photo_index);
// Keep the original generated pixels; discard translucent export fringes
// during rendering so the classroom floor stays clean around every sprite.
if(shader_is_compiled(shd_fatec_student))shader_set(shd_fatec_student);
draw_sprite_ext(sprite_index,0,x,y,look_sign*_scale,_scale,_nod,c_white,1);
shader_reset();
gpu_set_texfilter(_filter);draw_set_alpha(_alpha);draw_set_color(_colour);
