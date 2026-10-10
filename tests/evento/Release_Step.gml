tick++;
if(tick<12)exit;
if(stage==0)
{
    n=instance_find(obj_newton_npc,0);n.dialogue_active=false;
    b=batalha_iniciar(n,false);
    check(!b.battle_config.test_skip_enabled,"delivered game hides the battle skip button");
    var _enemy=b.enemy_hp;
    check(!b.handle_test_skip(650,40,true) && b.enemy_hp==_enemy && b.battle_screen=="actions"
        && matematica_progresso().xp_total==0,"clicking outside test button leaves ordinary battle unchanged");
    b.request_action("attack");
    check(b.battle_screen=="challenge" && !is_undefined(b.challenge),"release still opens ordinary mathematical challenges");
    b.answer_text=string(b.challenge.resposta);b.verify_answer();
    check(b.enemy_hp<_enemy && b.battle_screen=="actions","correct answer resolves normal combat in final release");
    stage=1;tick=0;exit;
}
screen_save("final-release-battle.png");
check(!b.handle_test_skip(800,40,true) && instance_exists(b) && b.enemy_hp>0,
    "delivered game ignores the removed battle skip button");
finish_tests();exit;
