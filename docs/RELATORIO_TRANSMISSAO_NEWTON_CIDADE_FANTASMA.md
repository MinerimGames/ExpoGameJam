# Transmissão de Newton na entrada da cidade fantasma

Texto e momento aprovados pelo usuário. Após a vitória contra Isleide Rei, a entrada `rm_autumn_gate` inicia a transmissão de Newton sobre a cidade fantasma. As seis falas explicam a ideologia de um único homem, seu discurso populista e sorriso, a consolidação de seu domínio e o medo que mantém os moradores em suas casas.

A instância `inst_NEWTON_GHOST_CITY_TRANSMISSION` foi adicionada à camada Player por último na ordem de criação, depois do jogador e do cenário. Reutiliza `obj_newton_cavern_dialogue`, com seleção de texto pelo nome da sala. As seis falas do Bosque e as quatro das cavernas permanecem iguais. Nenhum personagem físico foi adicionado.

Step e Draw GUI permanecem intactos. E ou Espaço avança uma página; a confirmação da última encerra a janela e libera o movimento. Durante a transmissão, Wilson permanece parado e as saídas não são ativadas. O mesmo início de fase é usado pela vitória normal e pelo botão temporário de pular batalha.

A comparação com o backup confirma que só a instância da transmissão e sua entrada na ordem de criação foram adicionadas à sala. Câmera, cenário, colisores, jogador e transições permanecem iguais. O projeto não recebeu novos registros de recursos.

## Falas aprovadas

1. Wilson, você chegou à chamada cidade fantasma. Suas ruas silenciosas revelam uma população que vive sob constante temor.

2. Esta realidade foi dominada pela ideologia de um único homem, que impôs sua visão de mundo e concentrou em si toda a autoridade.

3. Por meio de um discurso populista e de um sorriso sempre presente, conquistou a confiança do povo e consolidou seu domínio.

4. Sob sua influência, o perigo tornou-se parte da vida cotidiana. Os moradores receiam sair às ruas e permanecem recolhidos em suas casas.

5. O medo restringiu a convivência e enfraqueceu os vínculos desta cidade. Até os gestos mais simples passaram a exigir cautela.

6. Prossiga com prudência, Wilson. Precisamos compreender a origem dessa ameaça antes que ela comprometa também as demais realidades.

## Verificação

O teste Autumn falhou inicialmente por não encontrar a transmissão após a vitória do rei. Com a implementação, percorreu as seis páginas usando entradas reais alternadas de E e Espaço, verificou posição e movimento bloqueados durante cada página, confirmou a liberação na conclusão e seguiu pelas duas transições até a praça. Resultado inicial: 40 verificações, zero falhas.

Compilação Windows VM com runtime GameMaker LTS 2026.0.0.23: código zero, `Igor complete.`. Binário, log e seis capturas: `C:/Users/jrhre/AppData/Local/CodexBuilds/ParadoxoDeWilson/evento-20261006-161534`. Todas as páginas foram inspecionadas visualmente; texto e indicador E/Espaço cabem na janela.

Revisão independente somente leitura: aprovada, sem problemas concretos encontrados. Backup dos arquivos anteriores: `C:/Users/jrhre/AppData/Local/CodexBackups/ParadoxoDeWilson/newton-ghost-city-20261006-161028`.

A suíte completa final passou nos onze grupos, totalizando 9.067 verificações e zero falhas: Input 18, Battle 8187, Ambient 27, Integration 119, Castle 39, Route 77, Guard 197, Royal 285, Autumn 40, Skip 42, Peasants 36.

Logs: `C:/Users/jrhre/AppData/Local/Temp/paradoxo-evento-tests/All-38a7b5b5c0c94b3990021e92b1120e59/run-20261006-161420`. As fontes atuais da transmissão e da sala de entrada foram comparadas com as do projeto final testado e são idênticas.
