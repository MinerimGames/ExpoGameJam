hall=asset_get_index("rm_castle_hall");
throne=asset_get_index("rm_throne_room");
king_object=asset_get_index("obj_isleide_king");
check(hall!=-1 && throne!=-1 && king_object!=-1,"castle interiors and king are available");
if(hall==-1 || throne==-1 || king_object==-1){finish_tests();exit;}
stage=0;tick=0;elapsed=0; pulse=false;questions=0;rising_seen=false;
room_goto(hall);
royal_solve=function(_b,_action,_correct=true)
{
    _b.request_action(_action);
    check(_b.battle_screen=="challenge","royal action presents a question");
    if(_b.battle_screen!="challenge")return;
    var _q=_b.challenge;
    if((questions mod 2)==0)
        check(_q.operacao=="+" && _q.x>=10 && _q.x<=48 && _q.y>=10 && _q.y<=28
            && _q.resposta==_q.x+_q.y,"royal sums follow guard difficulty");
    else
        check(_q.operacao=="x" && _q.x>=2 && _q.x<=6 && _q.y>=2 && _q.y<=6
            && _q.resposta==_q.x*_q.y,"royal multiplication follows a sum within simple tables");
    questions++;
    _b.answer_text=string(_q.resposta+(_correct?0:1));_b.verify_answer();
};
