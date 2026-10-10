tick++;
if(tick==12)
{
    source=instance_find(enemies[stage],0);
    check(instance_exists(source),"skip test uses real enemy in "+room_get_name(room));
    source.dialogue_active=false;
    if(stage==4)
    {
        var _transmission=instance_find(obj_newton_cavern_dialogue,0);
        check(instance_exists(_transmission) && _transmission.dialogue_active
            && !instance_find(obj_player,0).movimento_liberado,
            "foundry arrival retains its intentional Newton transmission lock");
        // The walking suite covers confirmation of Newton's introduction.
        with(obj_newton_cavern_dialogue)dialogue_active=false;
        check(instance_exists(instance_find(obj_steampunk_scene,0).exit_gate),
            "industrial skip starts while the foundry exit is physically closed");
    }
    b=batalha_iniciar(source,stage==0);
    check(variable_instance_exists(b,"handle_test_skip"),"battle has skip click handler");
    if(!variable_instance_exists(b,"handle_test_skip")){finish_tests();exit;}
    b.battle_config.test_skip_enabled=false;
    check(!b.handle_test_skip(800,40,true) && instance_exists(b) && b.enemy_hp>0,
        "disabled skip keeps battle active");
    b.battle_config.test_skip_enabled=true;
    check(!b.handle_test_skip(800,40,false) && b.enemy_hp>0,"hover does not skip battle");
    check(!b.handle_test_skip(650,40,true) && b.enemy_hp>0,"click outside button does not skip battle");
    if(stage==1) {b.request_action("attack");keyboard_string="123";}
    if(stage==2) {b.player_hp=0;b.finish_check();}
    check(b.battle_screen==(stage==1?"challenge":(stage==2?"defeat":"actions")),
        "skip exercises actions, math popup and defeat");
    b.result_visible=true;
    exit;
}
if(tick==16)
{
    screen_save("battle-skip-"+string(stage)+".png");
    b.handle_test_skip(800,40,true);
    exit;
}
if(tick==20)
{
    check(!instance_exists(obj_battle_controller),"skip closes battle in one click");
    check(keyboard_string=="","skip clears pending math input");
    var _p=instance_find(obj_player,0);
    if(stage==0)
    {
        check(instance_exists(source) && source.tutorial_completed && source.dialogue_mode=="post"
            && source.dialogue_active,"Newton skip uses normal post-victory dialogue");
        check(!_p.movimento_liberado,"Newton post-dialogue retains intended player lock");
        source.dialogue_active=false;source.npc_lock_player(false);source.create_post_portal();
        check(instance_number(obj_portal)==1,"Newton post-victory portal still available");
    }
    else if(stage==1)
    {
        check(room==rm_cavernas_2 && !instance_exists(obj_cavern_isleide)
            && instance_number(obj_portal)==1 && _p.movimento_liberado,
            "cavern skip removes boss and creates single victory portal");
        check(instance_find(obj_portal,0).portal_destination==rm_vila,"cavern skip portal leads to medieval route");
        check(global.math_progress.xp_total==200 && global.math_progress.level==3
            && global.math_progress.paradox_unlocked,
            "cavern skip unlocks paradox after the tutorial and cavern XP rewards");
    }
    else if(stage==2)
        check(room==rm_castelo && !instance_exists(obj_castle_guard) && _p.movimento_liberado
            && instance_number(obj_portal)==0,"guard skip after defeat frees castle entrance without portal");
    else if(stage==3)
    {
        check(room==rm_throne_room && !instance_exists(obj_isleide_king)
            && _p.movimento_liberado && instance_number(obj_portal)==1,
            "king skip exposes a foundry portal and releases movement in the throne room");
        check(instance_find(obj_portal,0).portal_destination==rm_steampunk_foundry,
            "king skip portal keeps the foundry destination");
    }
    else if(stage==4)
    {
        var _scene=instance_find(obj_steampunk_scene,0);
        check(room==rm_steampunk_foundry && !instance_exists(obj_isleide_steampunk)
            && _p.movimento_liberado && instance_number(obj_portal)==1,
            "industrial skip stays in the foundry and exposes a portal with movement restored");
        check(instance_exists(_scene) && !instance_exists(_scene.exit_gate)
            && historia_newton_progresso().steampunk_defeated,
            "industrial skip records victory and opens the physical exit");
    }
    else
        check(room==rm_autumn_plaza && !instance_exists(obj_isleide_city)
            && _p.movimento_liberado && instance_number(obj_portal)==1,
            "city boss test skip restores plaza movement with its victory portal");
    stage++;tick=0;
    if(stage>=6)
    {
        check(global.math_progress.xp_total==600 && global.math_progress.level==7
            && global.math_progress.paradox_unlocked,"all six battle skips preserve victory rewards and cavern unlock");
        finish_tests();exit;
    }
    room_goto(rooms[stage]);
}
