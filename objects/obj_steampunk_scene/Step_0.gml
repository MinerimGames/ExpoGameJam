var _story=historia_newton_progresso();
var _defeated=variable_struct_exists(_story,"steampunk_defeated") && _story.steampunk_defeated;
if(!_defeated || instance_exists(obj_battle_controller))exit;
if(instance_exists(exit_gate))instance_destroy(exit_gate);
exit_gate=noone;
