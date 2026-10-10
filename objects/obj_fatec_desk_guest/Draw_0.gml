var _filter=gpu_get_texfilter();
var _alpha=draw_get_alpha();var _colour=draw_get_color();
gpu_set_texfilter(false);
draw_set_alpha(1);draw_set_color(c_white);
var _scale=student_height/(sprite_get_bbox_bottom(sprite_index)-sprite_get_bbox_top(sprite_index)+1);
var _chair_scale=chair_height/(sprite_get_bbox_bottom(spr_fatec_desk_chair)-sprite_get_bbox_top(spr_fatec_desk_chair)+1);
// Keep the original generated pixels; discard translucent export fringes
// during rendering so the classroom floor stays clean around every sprite.
if(shader_is_compiled(shd_fatec_student))shader_set(shd_fatec_student);
// Mirror the complete seated composition together, beside the desk and bin.
draw_sprite_ext(spr_fatec_desk_chair,0,x-look_sign*4,y+8,look_sign*_chair_scale,_chair_scale,0,c_white,1);
draw_sprite_ext(sprite_index,0,x,y,look_sign*_scale,_scale,0,c_white,1);
shader_reset();
gpu_set_texfilter(_filter);draw_set_alpha(_alpha);draw_set_color(_colour);
