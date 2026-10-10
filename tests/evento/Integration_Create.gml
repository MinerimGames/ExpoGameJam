stage=0; tick=0; input_pulse=false;
skip_probe_done=false;
skip_probe_ticks=0;
medieval_probe_done=false;
ghost_probe_done=false;
solve = function(_b, _action, _correct=true) {
    _b.request_action(_action);
    if(_b.battle_screen!="challenge") { check(false,"integration action available"); return; }
    _b.answer_text=string(_b.challenge.resposta+(_correct ? 0 : 1));
    _b.verify_answer();
};
win = function(_b) {
    for(var _i=0;_i<60 && _b.battle_screen=="actions";_i++) {
        var _action="attack";
        if(_b.enemy_intent=="strong") _action="defense";
        else if(_b.enemy_intent=="normal" && _b.player_hp<=60 && _b.heal_cooldown==0) _action="heal";
        solve(_b,_action);
    }
    check(_b.battle_screen=="victory","strategy wins integration battle");
};
room_goto(rm_menu);
