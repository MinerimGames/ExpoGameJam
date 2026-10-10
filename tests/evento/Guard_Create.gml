stage=0; tick=0; elapsed=0; input_pulse=false;
guard_object=asset_get_index("obj_castle_guard");
room_goto(rm_castelo);

solve_guard=function(_b,_action,_correct=true)
{
    _b.request_action(_action);
    check(_b.battle_screen=="challenge","guard action requests a math challenge");
    if (_b.battle_screen!="challenge") return;
    var _c=_b.challenge;
    check(_c.operacao=="+" && _c.x>=10 && _c.x<=48 && _c.y>=10 && _c.y<=28,
        "guard uses bounded two-digit sums after single-digit cavern battle");
    check(_c.resposta==_c.x+_c.y,"guard sum has correct answer");
    _b.answer_text=string(_c.resposta+(_correct?0:1));
    _b.verify_answer();
};
