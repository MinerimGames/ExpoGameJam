function historia_newton_progresso(_reiniciar=false)
{
    if (_reiniciar || !variable_global_exists("newton_story"))
        global.newton_story={steampunk_defeated:false,city_defeated:false,stage:"city",final_rewarded:false,finale_started:false,finale_transferred:false};
    return global.newton_story;
}

function historia_newton_bloquear(_bloquear)
{
    with(obj_player){movimento_liberado=!_bloquear;velh=0;velv=0;}
}

function historia_newton_retrato(_sprite,_x,_y,_altura,_alpha=1,_angulo=0)
{
    mundo_desenhar_personagem(_sprite,_x,_y,_altura,_alpha,_angulo,_altura);
}

function historia_newton_desenhar_dialogo(_pagina,_indice,_total)
{
    var _portrait=_pagina.portrait;var _speaker=_pagina.speaker;
    var _is_newton=variable_struct_exists(_pagina,"actor") && _pagina.actor=="newton";
    var _newton=instance_find(obj_newton_final,0);
    if(_is_newton && instance_exists(_newton))
    {
        _portrait=_newton.battle_sprite;
        if(_newton.evil_revealed)_speaker="EVIL NEWTON";
    }
    var _s=min(display_get_gui_width()/960,display_get_gui_height()/540);
    var _ox=(display_get_gui_width()-960*_s)/2;
    var _oy=(display_get_gui_height()-540*_s)/2;
    var _purple=make_color_rgb(64,17,110);
    draw_set_alpha(1);draw_set_font(fnt_ui);draw_set_halign(fa_left);draw_set_valign(fa_top);
    draw_set_color(_purple);draw_rectangle(_ox+70*_s,_oy+350*_s,_ox+890*_s,_oy+515*_s,false);
    draw_set_color(c_white);draw_rectangle(_ox+76*_s,_oy+356*_s,_ox+884*_s,_oy+509*_s,false);
    var _height=134*_s;var _angle=0;
    if(_is_newton)
    {
        if(instance_exists(_newton))
        {
            _height*=1+sin(_newton.idle_time*2.4)*0.010;
            _angle=sin(_newton.idle_time*1.6)*0.85;
        }
    }
    historia_newton_retrato(_portrait,_ox+152*_s,_oy+505*_s,_height,1,_angle);
    draw_set_color(_purple);
    draw_text_transformed(_ox+220*_s,_oy+367*_s,_speaker,_s,_s,0);
    var _words=string_split(_pagina.text," ");var _line="";var _out="";
    for(var i=0;i<array_length(_words);i++)
    {
        var _test=_line==""?_words[i]:_line+" "+_words[i];
        if(string_width(_test)*0.88>630){_out+=_line+chr(10);_line=_words[i];}
        else _line=_test;
    }
    _out+=_line;
    draw_text_transformed(_ox+220*_s,_oy+405*_s,_out,0.88*_s,0.88*_s,0);
    draw_set_halign(fa_right);
    var _transforming=instance_exists(obj_temporal_scene) && instance_find(obj_temporal_scene,0).transformation_active;
    var _advance_hint=_transforming?"TRANSFORMAÇÃO...":"E / ESPAÇO >>";
    draw_text_transformed(_ox+850*_s,_oy+487*_s,string(_indice+1)+"/"+string(_total)+"   "+_advance_hint,0.66*_s,0.66*_s,0);
    draw_set_halign(fa_left);draw_set_color(c_white);
}
// GENERATED DIALOGUES
function historia_newton_dialogo(_nome)
{
    switch(_nome)
    {
        case "revelation": return [
            {speaker:"ISLEIDE AGENTE",portrait:spr_capitalist_ally,text:"Antes de continuar, responda: quem lhe disse que derrotar os líderes dessas realidades resolveria as incursões?"},
            {speaker:"WILSON",portrait:spr_wilson_idle_front,text:"Newton. Ele me explicou que os mundos estavam entrando em colapso e que eu precisava estabilizá-los."},
            {speaker:"ISLEIDE AGENTE",portrait:spr_capitalist_ally,text:"As incursões existem. A mentira está na solução que ele lhe ofereceu. Ao derrotar os guardiões, você interrompeu as proteções que ligavam suas realidades ao restante do multiverso."},
            {speaker:"WILSON",portrait:spr_wilson_idle_front,text:"Eu vi o que acontecia nesses lugares. O rei escondia informações. A cidade estava vazia. Por que eu deveria confiar em você?"},
            {speaker:"ISLEIDE AGENTE",portrait:spr_capitalist_ally,text:"Eles tinham falhas, e alguns tomaram decisões terríveis. Ainda assim, eram âncoras entre os mundos. Newton transformou essas falhas em justificativas para enviar você contra todos eles."},
            {speaker:"ISLEIDE AGENTE",portrait:spr_capitalist_ally,text:"O inventor da Fundição prendeu sua cidade num ciclo para conter as incursões. Isso impedia o futuro, mas também sustentava sua proteção. Newton mandou você interrompê-la sem oferecer uma alternativa."},
            {speaker:"WILSON",portrait:spr_wilson_idle_front,text:"Então minhas vitórias estavam enfraquecendo as realidades?"},
            {speaker:"ISLEIDE AGENTE",portrait:spr_capitalist_ally,text:"Sim. Os guardiões sobreviveram, mas seus vínculos ficaram enfraquecidos. Newton quer aproveitar essa fragilidade para submeter todos os mundos à sua própria vontade."},
            {speaker:"WILSON",portrait:spr_wilson_idle_front,text:"Como você sabe disso?"},
            {speaker:"ISLEIDE AGENTE",portrait:spr_capitalist_ally,text:"Venho investigando essas rupturas. Compare os avisos dele com o que encontrou: a cada vitória, ele manda você partir sem verificar como o mundo ficou. Precisamos confrontá-lo antes que use essas brechas."},
            {speaker:"ISLEIDE AGENTE",portrait:spr_capitalist_ally,text:"Agora me diga: de qual mundo você veio? O que se lembra antes de encontrar Newton?"},
            {speaker:"WILSON",portrait:spr_wilson_idle_front,text:"Eu… não sei. Não lembro de uma viagem. Simplesmente apareci lá."},
            {speaker:"ISLEIDE AGENTE",portrait:spr_capitalist_ally,text:"Essa lacuna é parte do paradoxo: você está aqui, mas não lembra como chegou. Não sabemos ainda quem provocou isso. Precisamos voltar ao início e exigir que Newton explique o que sabe."},
            {speaker:"WILSON",portrait:spr_wilson_idle_front,text:"Ainda não tenho certeza de tudo que você está dizendo. Mas preciso descobrir o que aconteceu comigo."},
            {speaker:"ISLEIDE AGENTE",portrait:spr_capitalist_ally,text:"Então voltaremos ao momento em que ele começou a orientá-lo. Antes que você complete o caminho que ele preparou, precisamos corrigir esse paradoxo."},
            {speaker:"WILSON",portrait:spr_wilson_idle_front,text:"Eu vou com você. Desta vez, quero ouvir a verdade antes de lutar."}
        ];
        case "exposure": return [
            {actor:"newton",speaker:"NEWTON",portrait:spr_battle_newton,text:"A matemática será sua âncora. Siga minhas orientações e estabilize as realidades."},
            {speaker:"WILSON ATUAL",portrait:spr_wilson_idle_front,text:"Espere! Não aceite essa missão sem perguntar o que acontece com os mundos depois das batalhas."},
            {speaker:"WILSON DO PASSADO",portrait:spr_wilson_idle_front,text:"Quem é você? Por que tem o meu rosto?"},
            {speaker:"ISLEIDE AGENTE",portrait:spr_capitalist_ally,text:"Ele é o resultado do caminho que Newton está prestes a impor a você. Voltamos para interromper esse ciclo."},
            {actor:"newton",speaker:"NEWTON",portrait:spr_battle_newton,text:"Vocês confundem ordem com manipulação. Essas realidades precisam de uma inteligência capaz de conduzi-las."},
            {speaker:"ISLEIDE AGENTE",portrait:spr_capitalist_ally,text:"Você o enviou contra as âncoras dos mundos e chamou isso de salvação. Queria realidades enfraquecidas, dependentes das suas decisões."},
            {speaker:"WILSON ATUAL",portrait:spr_wilson_idle_front,text:"Eu não lembrava de onde vim. Você sabia disso desde o começo?"},
            {actor:"newton",speaker:"NEWTON",portrait:spr_battle_newton,text:"Sua origem era menos importante que sua função. Agora que trouxe essa interferência ao início, terei de corrigir o problema pessoalmente."},
            {speaker:"WILSON DO PASSADO",portrait:spr_wilson_idle_front,text:"Então eu não vou seguir essas ordens."},
            {speaker:"ISLEIDE AGENTE",portrait:spr_capitalist_ally,text:"Wilson, fique comigo. Vamos enfrentar isso juntos."}
        ];
        case "recovery": return [
            {actor:"newton",speaker:"NEWTON",portrait:spr_battle_newton,text:"Vocês não compreendem sequer a estrutura que tentam defender."},
            {speaker:"ISLEIDE DAS CAVERNAS",portrait:spr_isleide_cavernas,text:"Ele não precisa compreender tudo sozinho."},
            {speaker:"STEAMPUNK",portrait:asset_get_index("spr_steampunk_idle"),text:"Descobri que trancar o tempo destruía o futuro. Agora escolho o equilíbrio entre nossas realidades."},
            {speaker:"REI",portrait:spr_king_standing,text:"Conhecer uma ruptura não me deu o direito de controlar o destino. Também não dará esse direito a você, Newton."},
            {speaker:"LÍDER DA CIDADE",portrait:spr_city_peace,text:"Minha imagem foi distorcida. Não permitirei que use a mesma mentira para apagar todos nós."},
            {speaker:"WILSON",portrait:spr_wilson_idle_front,text:"Eu errei ao aceitar uma única versão. Se ainda puder corrigir isso, vou lutar com vocês."},
            {speaker:"ISLEIDE AGENTE",portrait:spr_capitalist_ally,text:"Cada realidade guarda parte da resposta. Juntas, elas tornam o impossível compreensível."},
            {speaker:"WILSON",portrait:spr_wilson_idle_front,text:"Agora eu entendo. Essas contas… estão ficando mais fáceis."}
        ];
        case "ending": return [
            {speaker:"WILSON",portrait:spr_wilson_idle_front,text:"O plano de Newton acabou aqui. Ninguém vai decidir sozinho quais realidades merecem existir."},
            {speaker:"ISLEIDE AGENTE",portrait:spr_capitalist_ally,text:"Sem o controle de Newton, esta realidade está se desfazendo. Agora todos devem voltar às próprias realidades. Vou abrir uma passagem para cada um."},
            {speaker:"ISLEIDE AGENTE",portrait:spr_capitalist_ally,text:"Seu passado voltou a ter uma escolha. Deixe este eco retornar ao início; sua passagem leva você de volta para casa."},
            {speaker:"WILSON",portrait:spr_wilson_idle_front,text:"Então chegou a hora de voltar para a minha realidade. Obrigado por me ajudarem a corrigir esse paradoxo."}
        ];
    }
    return [];
}
