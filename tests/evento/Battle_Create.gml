b = batalha_iniciar(noone, false);
check(batalha_iniciar(noone,false) == b && instance_number(obj_battle_controller)==1, "single battle controller");
b.player_hp = 100; b.request_action("heal");
check(b.battle_screen=="actions" && b.pending_action=="", "full health cannot consume heal");
if (!variable_instance_exists(b,"battle_turn")) { check(false,"strategic turn system exists"); finish_tests(); exit; }
play = function(_action, _correct = true) {
    b.request_action(_action);
    if (b.battle_screen != "challenge") return false;
    b.answer_text = string(b.challenge.resposta + (_correct ? 0 : 1));
    b.verify_answer();
    return true;
};
b.restart_battle();
var _want = ["normal","normal","strong","vulnerable","normal"];
for (var _t=0; _t<5; _t++) { b.battle_turn=_t; b.update_enemy_intent(); check(b.enemy_intent==_want[_t], "intent cycle " + string(_t)); }
b.restart_battle(); b.request_action("attack"); b.verify_answer();
check(b.battle_turn==0 && b.battle_screen=="challenge", "empty answer consumes no turn");
b.answer_text=string(b.challenge.resposta); b.verify_answer();
check(b.battle_turn==1 && b.math_phase==2, "correct math progresses one turn");
b.restart_battle(); b.player_hp=50; play("heal");
check(b.player_hp>=66 && b.player_hp<=68 && b.heal_cooldown==2, "heal 28 and normal retaliation");
var _turn=b.battle_turn; b.request_action("heal");
check(b.battle_screen=="actions" && b.battle_turn==_turn, "cooldown cannot consume heal");
play("defense"); check(b.heal_cooldown==1,"cooldown first other turn");
play("attack",false); check(b.heal_cooldown==0,"wrong answer also reduces cooldown");
b.restart_battle(); b.player_hp=99; play("heal");
check(b.player_hp>=88 && b.player_hp<=90,"partial heal never exceeds maximum");
b.restart_battle(); play("defense"); check(b.player_hp>=94 && b.player_hp<=95,"normal defense halves damage");
b.restart_battle(); b.battle_turn=2; b.update_enemy_intent(); play("defense");
check(b.player_hp>=91 && b.player_hp<=92,"strong defense reduces 75 percent");
b.restart_battle(); b.battle_turn=2; b.update_enemy_intent(); b.request_action("defense");
check(b.enemy_intent=="strong","intent stable during challenge"); b.answer_text=string(b.challenge.resposta+1); b.verify_answer();
check(b.player_hp>=64 && b.player_hp<=66 && b.battle_turn==3,"wrong strong answer has announced damage");
b.restart_battle(); b.battle_turn=3; b.update_enemy_intent(); play("attack",false);
check(b.player_hp==100 && b.enemy_hp==100 && b.battle_turn==4,"wrong vulnerable answer loses opportunity only");
b.restart_battle(); b.enemy_hp=1; play("attack");
check(b.battle_screen=="victory" && b.player_hp==100,"lethal attack has no retaliation");
b.restart_battle(); b.battle_turn=3; b.update_enemy_intent(); play("attack");
check(b.enemy_hp>=70 && b.enemy_hp<=76 && b.player_hp==100,"vulnerable bonus and no damage");
random_set_seed(20261002);
for (var _type=0; _type<2; _type++) {
    for(var _j=0;_j<100;_j++) {
        b.restart_battle();b.battle_turn=_type==0 ? 0 : 2;b.update_enemy_intent();
        play("dodge");check(b.player_hp==100,"correct dodge always avoids announced attack "+string(_type));
    }
}
b.battle_started_as_tutorial=true; b.restart_battle();
b.request_action("dodge"); check(b.battle_screen=="actions" && b.tutorial_step==0,"tutorial action order enforced");
play("attack",false); check(b.tutorial_step==0 && b.enemy_intent=="normal","tutorial wrong answer keeps step");
play("attack"); play("heal"); check(b.enemy_intent=="strong","guided defense faces strong attack");
play("defense"); check(b.enemy_intent=="normal","guided dodge faces a real attack");
var _before=b.player_hp; play("dodge");
check(b.player_hp==_before && !b.tutorial_mode && b.guided_tutorial_completed && b.battle_turn==0,"guided dodge demonstration and free cycle");
check(b.enemy_hp<100 && b.player_hp<=100,"tutorial completion preserves health");
b.restart_battle(); check(b.tutorial_mode && b.tutorial_step==0 && !b.guided_tutorial_completed && b.heal_cooldown==0,"retry restores guided state");
b.battle_started_as_tutorial=false;
var _wins=[0,0,0]; var _duration=[0,0,0];
for(var _policy=0;_policy<3;_policy++) {
    for(var _trial=0;_trial<2000;_trial++) {
        b.enemy_hp_max=150; b.math_phase_max=1; b.restart_battle(); var _turns=0;
        while(b.battle_screen=="actions" && _turns<60) {
            var _a="attack";
            if(_policy>0) {
                if(b.enemy_intent=="strong") _a=_policy==1 ? "defense" : "dodge";
                else if(b.enemy_intent=="normal" && b.player_hp<=60 && b.heal_cooldown==0) _a="heal";
            }
            play(_a); _turns++;
        }
        if(b.battle_screen=="victory") _wins[_policy]++;
        _duration[_policy]+=_turns;
    }
    show_debug_message("STRATEGY_"+string(_policy)+": wins="+string(_wins[_policy])+"/2000 turns="+string(_duration[_policy]/2000));
}
check(_wins[0]<200,"attack spam not dominant"); check(_wins[1]==2000,"safe strategy wins without dodge luck");
check(_wins[2]==2000,"announced strong-attack dodge strategy wins reliably");
for(var _f=1;_f<=16;_f++) for(var _n=0;_n<100;_n++) {
    var _c=batalha_gerar_desafio(_f);
    check(_c.resposta==(_c.operacao=="+" ? _c.x+_c.y : (_c.operacao=="-" ? _c.x-_c.y : _c.x*_c.y)),"math phase "+string(_f));
}
finish_tests();
