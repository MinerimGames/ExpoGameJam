# XP, compreensão matemática e Quebra de Paradoxo

Regras aprovadas pelo usuário e implementadas no sistema de batalha existente.

Cada vitória contra um adversário real dá 100 XP. A compreensão começa no nível 1 e sobe um nível a cada 100 XP. O total de XP e o nível aparecem no painel de Wilson; a tela de vitória mostra a recompensa. As informações permanecem ao mudar de sala e de fase durante a partida. Selecionar JOGAR no menu inicia outra partida com XP zero, nível 1 e habilidade bloqueada.

Cada nível acima do inicial reduz os números das contas em 10%, até o limite de 40%. A operação continua sendo a mesma e a resposta é recalculada. Somas, subtrações e multiplicações são preservadas; o nível inicial mantém exatamente a questão original. A dificuldade própria de cada inimigo continua alternando e crescendo normalmente. O nível de compreensão considerado é o do início da batalha.

## Quebra de Paradoxo

Vencer Isleide Rei desbloqueia a habilidade. A tela de vitória explica: “Quebra de Paradoxo desbloqueada! Use Q ou o botão: conta fácil, uma vez por batalha.”

Na batalha seguinte, o botão QUEBRA DE PARADOXO aparece abaixo do painel do inimigo. Clicar nele ou pressionar Q troca a conta aberta por uma soma de números iguais entre 1 e 5, como 1+1, 2+2 ou 5+5. Se não houver uma conta aberta, a habilidade fica preparada para a próxima ação válida. Ela não consome turno nem altera a ação escolhida. A resposta digitada antes da troca é apagada.

Uma cura recusada por vida cheia ou por recarga mantém a habilidade preparada. Depois da conta simplificada, as perguntas voltam ao padrão do inimigo. É preciso acertar a conta para executar a ação; errar continua provocando a reação normal do adversário. A carga só pode ser ativada uma vez em cada batalha ou tentativa. Reiniciar depois da derrota restaura a carga, sem conceder XP.

O botão temporário de pular batalha usa a mesma recompensa da vitória normal, inclusive o desbloqueio após o rei. Dois controles, no controlador e no adversário, impedem conceder a recompensa repetidamente para a mesma vitória. Batalhas de teste sem adversário real não concedem XP.

## Explicação direta no jogo

A primeira fala de Newton após o treinamento agora diz: “Cada vitória te dá 100 XP e aumenta sua compreensão matemática. Quanto mais você evolui, menores ficam os números das contas. O difícil começa a ficar fácil.” As outras falas e transmissões continuam iguais.

## Verificação

O primeiro teste falhou pela ausência da habilidade. O teste ampliado detectou que o nível inicial modificava uma subtração de resultado zero; o retorno de identidade no nível 1 corrigiu o problema sem alterar o gerador de questões original.

A suíte Progression passou em 1.467 verificações, cobrindo todas as operações e o limite de redução, XP sem duplicação, derrota, persistência entre salas, desbloqueio após o rei, entrada real por Q, botão, resposta antiga, habilidade preparada, cura inválida, retorno à alternância, reinício e novo jogo pelo menu. As capturas da explicação de Newton, vitória, desbloqueio e conta simplificada foram inspecionadas e estão legíveis.

Compilação final Windows VM com GameMaker LTS2026.0.0.23 terminou com código zero e `Igor complete.`. Binário e log: `C:/Users/jrhre/AppData/Local/CodexBuilds/ParadoxoDeWilson/evento-20261006-234254`.

Revisão independente somente leitura aprovada após a correção, sem outros problemas encontrados. Backup anterior: `C:/Users/jrhre/AppData/Local/CodexBackups/ParadoxoDeWilson/math-progression-20261006-233502`.

A rodada geral final passou nos treze grupos, com 10.887 verificações e zero falhas: Input18, Battle8187, Ambient27, Integration119, Castle39, Route80, Guard197, Royal285, Autumn42, Skip52, Peasants36, City338, Progression1467. Logs: `C:/Users/jrhre/AppData/Local/Temp/paradoxo-evento-tests/All-38a7b5b5c0c94b3990021e92b1120e59/run-20261006-234150`. Route confirmou 400 XP e nível 5 após quatro vitórias ao longo do percurso; Skip confirmou 500 XP e nível 6 após pular as cinco batalhas. Ambas confirmaram a habilidade desbloqueada.

As quatro capturas `progression-*.png` foram copiadas para a pasta da compilação final. As fontes do produto foram comparadas às usadas na última rodada de testes e são idênticas.
