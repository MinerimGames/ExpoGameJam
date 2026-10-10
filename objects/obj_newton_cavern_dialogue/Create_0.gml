dialogue_page = 0;
dialogue_active = true;
if (room == rm_vila)
{
    dialogue_pages = [
        "Wilson, você alcançou um reino outrora próspero. Hoje, porém, suas aldeias sofrem as consequências das decisões de seu soberano.",
        "Os camponeses desapareceram em consequência das escolhas imprudentes do rei. Sua soberba o fez ignorar o destino daqueles que deveria proteger.",
        "O rei já conhecia a existência das incursões. Contudo, em vez de combatê-las, passou a enxergá-las como instrumentos de poder.",
        "Seu propósito era usar essas rupturas para interferir em acontecimentos que deveriam permanecer inalterados, submetendo o curso da realidade à sua vontade.",
        "Você desbloqueou a Quebra de Paradoxo ao vencer nas cavernas. Use Q ou o botão uma vez por batalha: a conta atual, ou a próxima, vira uma soma simples, como 1 + 1. Ainda precisa acertar a resposta.",
        "Procure o rei, Wilson. Precisamos impedir que sua ambição transforme este reino em uma ameaça para mundos que sequer conhecem seu nome."
    ];
}
else if (room == asset_get_index("rm_steampunk_foundry"))
{
    dialogue_pages = [
        "Wilson, além do reino medieval existe a Fundição do Tempo. Aqui, caldeiras e engrenagens regulam o ritmo desta realidade.",
        "Seu inventor, Isleide Steampunk, construiu um relógio central para conter as incursões. Contudo, passou a impor o mesmo ciclo a toda a cidade.",
        "Os relógios retornam à mesma hora, as máquinas repetem as mesmas tarefas e nenhum habitante consegue construir um futuro diferente.",
        "Steampunk afirma que esse mecanismo é uma âncora necessária ao equilíbrio dos mundos. Tome cuidado: uma prisão também pode receber o nome de proteção.",
        "Aproxime-se da fundição e questione o inventor. Se ele insistir em manter o ciclo, você terá de enfrentá-lo para abrir o caminho adiante.",
        "Sua compreensão cresceu desde as cavernas. Use a Quebra de Paradoxo com Q ou pelo botão quando precisar simplificar uma conta, mas lembre-se de responder corretamente."
    ];
}
else if (room == rm_autumn_gate)
{
    dialogue_pages = [
        "Wilson, você chegou à chamada cidade fantasma. Suas ruas silenciosas revelam uma população que vive sob constante temor.",
        "Esta realidade foi dominada pela ideologia de um único homem, que impôs sua visão de mundo e concentrou em si toda a autoridade.",
        "Por meio de um discurso populista e de um sorriso sempre presente, conquistou a confiança do povo e consolidou seu domínio.",
        "Sob sua influência, o perigo tornou-se parte da vida cotidiana. Os moradores receiam sair às ruas e permanecem recolhidos em suas casas.",
        "O medo restringiu a convivência e enfraqueceu os vínculos desta cidade. Até os gestos mais simples passaram a exigir cautela.",
        "Prossiga com prudência, Wilson. Precisamos compreender a origem dessa ameaça antes que ela comprometa também as demais realidades."
    ];
}
else
{
    dialogue_pages = [
        "Você atravessou a primeira dobra. Esta região pertence à realidade quebrada das cavernas.",
        "Quando duas realidades ocupam o mesmo espaço, criaturas, memórias e leis naturais começam a se misturar.",
        "Mais adiante está o Isleide das Cavernas. Derrote-o para enfraquecer este ponto de instabilidade.",
        "Ele ainda não evoluiu intelectualmente, então não deve ser um adversário muito difícil."
    ];
}

with (obj_player)
{
    movimento_liberado = false;
    velh = 0;
    velv = 0;
}
