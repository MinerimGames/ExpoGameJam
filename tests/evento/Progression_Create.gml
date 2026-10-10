stage=0;tick=0;elapsed=0;
// The desktop cursor must not select SAIR while this keyboard test presses Enter.
#macro device_mouse_x_to_gui global.evento_progression_pointer_x
#macro device_mouse_y_to_gui global.evento_progression_pointer_y
#macro mouse_check_button_pressed global.evento_progression_pointer_pressed
global.evento_progression_pointer_x=function(_device){return -100;};
global.evento_progression_pointer_y=function(_device){return -100;};
global.evento_progression_pointer_pressed=function(_button){return false;};
// Exercise every operation family, including later subtraction tiers.
for(var _phase=1;_phase<=16;_phase++)
for(var _i=0;_i<30;_i++)
{
    var _raw=batalha_gerar_desafio(_phase);
    var _original=matematica_facilitar(_raw,1);
    var _easy=matematica_facilitar(_raw,5);
    var _capped=matematica_facilitar(_raw,100);
    check(_original.x==_raw.x && _original.y==_raw.y && _original.resposta==_raw.resposta,
        "level one preserves original questions");
    check(_easy.operacao==_raw.operacao && _easy.x<=_raw.x && _easy.y<=_raw.y
        && _easy.x>=1 && _easy.y>=1 && _easy.resposta>0
        && _easy.resposta==(_easy.operacao=="+"?_easy.x+_easy.y:
            (_easy.operacao=="-"?_easy.x-_easy.y:_easy.x*_easy.y)),
        "comprehension lowers operands without invalid answers or changing operations");
    check(_capped.x==_easy.x && _capped.y==_easy.y,"very high levels respect reduction cap");
}
room_goto(rm_cavernas_2);
