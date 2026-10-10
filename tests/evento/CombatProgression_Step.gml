tick++;elapsed++;
if(elapsed>900){check(false,"combat progression timeout");finish_tests();exit;}
if(tick<12)exit;
switch(stage)
{
case 0:
    n=instance_find(obj_cavern_isleide,0);n.dialogue_active=false;
    b=batalha_iniciar(n,false);
    b.player_hp=0;b.finish_check();b.restart_battle();
    check(b.player_hp_max==100,"losing and retrying gives no permanent HP");
    b.enemy_hp=0;b.finish_check();b.finish_check();b.reward_victory();
    check(b.player_hp_max==130,"first actual boss grants exactly thirty permanent HP");
    b.leave_after_victory();
    var _portal=instance_find(obj_portal,0);
    check(instance_exists(_portal) && _portal.portal_destination==rm_vila,"cavern victory portal enters village");
    stage=1;tick=0;break;
case 1:
    b=batalha_iniciar(noone,false);
    check(b.player_hp_max==130 && b.player_hp==130,"next battle retains boss HP increase");
    check_backdrop();
    if(!variable_instance_exists(b,"dodge_cooldown")){check(false,"dodge cooldown exists");finish_tests();exit;}
    for(var _i=0;_i<100;_i++)
    {
        b.restart_battle();b.battle_turn=2;b.update_enemy_intent();
        check(solve("dodge") && b.player_hp==130,"correct dodge reliably avoids strong attack");
    }
    check(b.dodge_cooldown==2,"successful dodge starts two other turn cooldown");
    var _turn=b.battle_turn;var _count=b.math_question_count;
    check(b.activate_paradox(),"Q can arm the next challenge");
    b.request_action("dodge");
    check(b.battle_screen=="actions" && b.battle_turn==_turn && b.math_question_count==_count
        && b.paradox_pending,"unavailable dodge spends no turn question or pending Q");
    solve("defense");
    check(b.dodge_cooldown==1 && b.player_hp==130,"vulnerable turn advances dodge recharge without damage");
    solve("attack",false);
    check(b.dodge_cooldown==0 && b.player_hp>=118 && b.player_hp<=120,"wrong answer also advances dodge recharge");
    b.restart_battle();
    solve("dodge",false);
    check(b.player_hp>=118 && b.player_hp<=120 && b.dodge_cooldown==0,"wrong dodge answer takes announced damage without successful-use cooldown");
    b.request_action("dodge");var _enemy=b.enemy_hp;
    check(b.activate_paradox() && b.battle_screen=="challenge" && b.pending_action=="dodge"
        && b.challenge.operacao=="+" && b.challenge.x==b.challenge.y
        && b.challenge.x>=1 && b.challenge.x<=5 && b.enemy_hp==_enemy,"Q simplifies current dodge without answering it");
    b.answer_text=string(b.challenge.resposta);var _hp=b.player_hp;b.verify_answer();
    check(b.player_hp==_hp && b.dodge_cooldown==2 && !b.activate_paradox(),"Q still requires answer and stays once per battle");
    with(b)instance_destroy();room_goto(rm_castelo);stage=2;tick=0;break;
case 2:
    n=instance_find(obj_castle_guard,0);n.dialogue_active=false;
    b=batalha_iniciar(n,false);b.enemy_hp=0;b.finish_check();b.reward_victory();
    check(b.player_hp_max==130,"guard victory grants no world boss HP bonus");
    b.leave_after_victory();room_goto(rm_throne_room);stage=3;tick=0;break;
case 3:
    n=instance_find(obj_isleide_king,0);n.dialogue_active=false;
    b=batalha_iniciar(n,false);b.enemy_hp=0;b.finish_check();b.finish_check();
    check(b.player_hp_max==160,"second actual boss cumulatively grants thirty HP");
    b.leave_after_victory();room_goto(rm_steampunk_foundry);stage=31;tick=0;break;
case 31:
    n=instance_find(obj_isleide_steampunk,0);n.dialogue_active=false;
    b=batalha_iniciar(n,false);b.enemy_hp=0;b.finish_check();b.reward_victory();
    check(b.player_hp_max==190,"industrial boss grants its own permanent thirty HP");
    b.leave_after_victory();room_goto(rm_autumn_plaza);stage=32;tick=0;break;
case 32:
    n=instance_find(obj_isleide_city,0);n.dialogue_active=false;
    b=batalha_iniciar(n,false);b.enemy_hp=0;b.finish_check();b.reward_victory();
    check(b.player_hp_max==220,"city boss grants its own permanent thirty HP");
    b.leave_after_victory();
    historia_newton_progresso().city_defeated=false;room_goto(rm_autumn_plaza);stage=33;tick=0;break;
case 33:
    n=instance_find(obj_isleide_city,0);n.dialogue_active=false;
    b=batalha_iniciar(n,false);b.enemy_hp=0;b.finish_check();
    check(b.player_hp_max==220,"recreated world boss cannot grant another permanent bonus");
    b.leave_after_victory();room_goto(rm_temporal_origin);stage=4;tick=0;break;
case 4:
    n=instance_find(obj_newton_final,0);n.battle_stage=1;
    b=batalha_iniciar(n,false);
    check(b.player_hp_max==220,"first Newton stage preserves accumulated max HP");
    b.reward_victory();
    check(b.player_hp_max==220 && !historia_newton_progresso().final_rewarded,"forced first Newton defeat cannot grant reward even directly");
    newton_batalha_queda(b);
    n.battle_stage=2;b=batalha_iniciar(n,false);
    check(b.player_hp_max==260 && b.player_hp==260,"supported Newton adds forty HP to accumulated total");
    b.player_hp=0;b.finish_check();b.restart_battle();
    check(b.player_hp_max==260 && b.player_hp==260,"supported retry preserves additive recovery bonus");
    b.enemy_hp=0;b.finish_check();b.finish_check();b.reward_victory();
    check(b.player_hp_max==290,"final actual boss grants thirty HP once with support preserved");
    with(b)instance_destroy();
    b=batalha_iniciar(n,false);b.enemy_hp=0;b.finish_check();
    check(b.player_hp_max==290,"recreated final controller cannot duplicate permanent reward");
    with(b)instance_destroy();room_goto(rm_tutorial);stage=5;tick=0;break;
case 5:
    n=instance_find(obj_newton_npc,0);n.dialogue_active=false;
    b=batalha_iniciar(n,true);b.enemy_hp=0;b.finish_check();b.reward_victory();
    with(b)instance_destroy();b=batalha_iniciar(noone,false);
    check(b.player_hp_max==250,"tutorial rewards never increase permanent max HP");
    matematica_progresso(true);with(b)instance_destroy();b=batalha_iniciar(noone,false);
    check(b.player_hp_max==100,"new game reset clears permanent boss HP");
    finish_tests();exit;
}
