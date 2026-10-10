function newton_gerar_desafio(_etapa,_indice)
{
    if(_etapa==2)
    {
        var _x,_y,_op,_r;
        if(_indice<2){_x=irandom_range(1,5);_y=irandom_range(1,5);_op="+";_r=_x+_y;}
        else switch((_indice-2) mod 3)
        {
            case 0:_x=irandom_range(2,12);_y=irandom_range(2,12);_op="+";_r=_x+_y;break;
            case 1:_x=irandom_range(3,14);_y=irandom_range(1,_x-1);_op="-";_r=_x-_y;break;
            default:_x=irandom_range(2,5);_y=irandom_range(2,5);_op="x";_r=_x*_y;break;
        }
        return {x:_x,y:_y,operacao:_op,resposta:_r};
    }
    var _a=irandom_range(12,24);var _c=irandom_range(7,15);var _d=irandom_range(2,9);
    var _b,_expression,_answer;
    if(_indice mod 2==0)
    {
        _b=irandom_range(6,12);_answer=_a*_b+_c*_c-_d;
        _expression="("+string(_a)+" x "+string(_b)+") + "+string(_c)+"^2 - "+string(_d);
    }
    else
    {
        _b=irandom_range(2,9);_answer=_a*(_c+_d);
        _expression="("+string(_a*_b)+" / "+string(_b)+") x ("+string(_c)+" + "+string(_d)+")";
    }
    return {x:_a,y:_b,operacao:"x",resposta:_answer,expressao:_expression};
}

function newton_batalha_configurar(_controlador,_etapa)
{
    with(_controlador)
    {
        story_battle=true;story_stage=_etapa;story_answers=0;story_falling=false;
        math_profile=_etapa==1?"newton_complex":"newton_shared";
        player_name="Wilson e Agente";
        battle_config=batalha_configuracao();
        player_hp_max=battle_config.player_hp_max+matematica_progresso().boss_hp_bonus
            +(_etapa==2?battle_config.ally_hp_bonus:0);player_hp=player_hp_max;
        enemy_hp_max=_etapa==1?420:240;enemy_hp=enemy_hp_max;
        ally_bonus=_etapa==1?0:8;
        if(_etapa==2){battle_config.attack_min=24;battle_config.attack_max=30;}
        paradox_used=false;paradox_pending=false;
        battle_message=_etapa==1?"Newton domina cálculos que vocês ainda não compreendem. O aliado permanece ao seu lado.":"Apoio das realidades: vocês estão mais fortes. Resolva as contas juntos!";
    }
}

function newton_batalha_queda(_controlador)
{
    if(!instance_exists(_controlador) || _controlador.story_falling)return;
    som_efeito("defeat");
    _controlador.story_falling=true;
    _controlador.player_hp=0;_controlador.pending_action="";_controlador.challenge=undefined;
    _controlador.answer_text="";keyboard_string="";
    var _scene=instance_find(obj_temporal_scene,0);
    if(instance_exists(_scene))_scene.start_recovery();
    with(_controlador)instance_destroy();
}

function newton_batalha_apos_resposta(_controlador)
{
    if(!_controlador.story_battle || _controlador.story_stage!=1)return;
    _controlador.story_answers++;
    if(_controlador.story_answers>=3)newton_batalha_queda(_controlador);
}

function newton_batalha_pular(_controlador)
{
    if(!_controlador.story_battle || _controlador.story_stage!=1)return false;
    newton_batalha_queda(_controlador);return true;
}
