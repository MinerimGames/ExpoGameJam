if(pending_scene) {
    with(obj_newton_cavern_dialogue) dialogue_active=false;
    with(obj_player) movimento_liberado=true;
    pending_scene=false;
}
sample_timer++;
if(sample_timer==30) {
    var _boss=instance_find(obj_cavern_isleide,0);
    var _battle=batalha_iniciar(_boss,false);
    _battle.battle_turn=2; _battle.player_hp=62; _battle.heal_cooldown=2; _battle.update_enemy_intent();
}
if(sample_timer==6000 && instance_exists(obj_battle_controller)) with(obj_battle_controller) { battle_turn=3; heal_cooldown=0; update_enemy_intent(); }
if(sample_timer==12000) finish_tests();
if(sample_timer mod 120==0) show_debug_message("VISUAL_FPS: "+room_get_name(room)+" actual="+string(fps)+" capacity="+string(fps_real));
if(keyboard_check_pressed(vk_f1)) { room_goto(rm_tutorial); pending_scene=true; }
if(keyboard_check_pressed(vk_f2)) { room_goto(rm_cavernas); pending_scene=true; }
if(keyboard_check_pressed(vk_f3)) { room_goto(rm_cavernas_2); pending_scene=true; }
if(keyboard_check_pressed(vk_f4)) {
    var _enemy=instance_exists(obj_cavern_isleide) ? instance_find(obj_cavern_isleide,0) : instance_find(obj_newton_npc,0);
    var _b=batalha_iniciar(_enemy,false); _b.battle_turn=2; _b.player_hp=62; _b.heal_cooldown=2; _b.update_enemy_intent();
}
if(keyboard_check_pressed(vk_f5) && instance_exists(obj_battle_controller)) with(obj_battle_controller) { battle_turn=3; heal_cooldown=0; update_enemy_intent(); }
if(keyboard_check_pressed(vk_f6) && instance_exists(obj_battle_controller)) with(obj_battle_controller) { player_hp=player_hp_max; battle_turn=0; heal_cooldown=0; update_enemy_intent(); }
if(keyboard_check_pressed(vk_f7)) {
    with(obj_battle_controller) instance_destroy();
    if(instance_exists(obj_newton_npc)) with(obj_newton_npc) start_post_dialogue();
    if(instance_exists(obj_cavern_isleide)) with(obj_cavern_isleide) { dialogue_active=true; dialogue_page=2; }
}
if(keyboard_check_pressed(vk_f12)) finish_tests();
