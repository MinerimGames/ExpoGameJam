# Transmissão de Newton na entrada da fase medieval

Pedido e diálogo aprovados pelo usuário. A transmissão aparece em `rm_bosque`, logo após o jogador vencer o Isleide das Cavernas e atravessar o portal da vitória. Reutiliza a janela, o título e os controles da transmissão existente: E ou Espaço avança uma página; a confirmação da última libera Wilson.

A instância `inst_NEWTON_MEDIEVAL_TRANSMISSION` é criada por último na camada Player, depois de Wilson. O evento Create escolhe as seis páginas medievais conforme a sala e bloqueia imediatamente o movimento, zerando a velocidade. Nas cavernas, conserva as quatro páginas anteriores. Step, Draw GUI, metadados do objeto e registros do projeto permanecem idênticos.

A comparação da sala com o backup confirma que apenas a instância da transmissão e sua entrada na ordem de criação foram adicionadas. Câmera, colisores, jogador e transição para a Vila foram preservados. Os camponeses continuam removidos.

## Falas aprovadas

1. Wilson, você alcançou um reino outrora próspero. Hoje, porém, suas aldeias sofrem as consequências das decisões de seu soberano.

2. Os camponeses desapareceram em consequência das escolhas imprudentes do rei. Sua soberba o fez ignorar o destino daqueles que deveria proteger.

3. O rei já conhecia a existência das incursões. Contudo, em vez de combatê-las, passou a enxergá-las como instrumentos de poder.

4. Seu propósito era usar essas rupturas para interferir em acontecimentos que deveriam permanecer inalterados, submetendo o curso da realidade à sua vontade.

5. Há limites que nem mesmo uma coroa tem o direito de ultrapassar. Alterar esses marcos pode ameaçar o equilíbrio entre todas as realidades.

6. Procure o rei, Wilson. Precisamos impedir que sua ambição transforme este reino em uma ameaça para mundos que sequer conhecem seu nome.

## Verificação

O teste de percurso falhou inicialmente porque não havia transmissão na chegada pelo portal. Após a implementação, a fixture percorreu as seis páginas com entradas reais alternando E e Espaço, tentou mover Wilson durante cada página e confirmou sua posição inalterada; a última confirmação liberou o movimento sem iniciar batalha ou criar outro portal. O percurso continuou até a praça final, incluindo os encontros com guarda e rei: 63 verificações, zero falhas.

O teste de integração confirmou a transmissão anterior nas cavernas, a nova mensagem após a vitória, a liberação para continuar à Vila e o restante da campanha: 115 verificações, zero falhas. O teste de controles das salas foi adaptado para concluir a mensagem antes de testar a caminhada: 39 verificações, zero falhas.

Compilação Windows VM com GameMaker LTS runtime 2026.0.0.23: código zero, `Igor complete.`. Binário, log e seis capturas do diálogo: `C:/Users/jrhre/AppData/Local/CodexBuilds/ParadoxoDeWilson/evento-20261006-155647`. Todas as páginas foram inspecionadas visualmente; o texto cabe na janela e mantém o indicador E/Espaço visível.

Revisão independente somente leitura: nenhum problema concreto encontrado. Backup dos arquivos anteriores: `C:/Users/jrhre/AppData/Local/CodexBackups/ParadoxoDeWilson/newton-medieval-20261006-155241`.

Os onze grupos tiveram suas execuções finais bem-sucedidas, totalizando 9.031 verificações e zero falhas. Os quatro primeiros grupos já haviam passado com as fontes atuais; após adaptar o teste de controles à transmissão, Castle e os demais grupos foram verificados separadamente, sem repetir os grupos já aprovados. As fontes da transmissão e a sala atual são idênticas ao projeto final testado.

| Grupo | Verificações | Execução |
| --- | --- | --- |
| Input | 18 | `run-20261006-155603/Input` |
| Battle | 8187 | `run-20261006-155603/Battle` |
| Ambient | 27 | `run-20261006-155603/Ambient` |
| Integration | 115 | `run-20261006-155603/Integration` |
| Castle | 39 | `run-20261006-155820/Castle` |
| Route | 63 | `run-20261006-155926/Route` |
| Guard | 197 | `run-20261006-155950/Guard` |
| Royal | 283 | `run-20261006-160000/Royal` |
| Autumn | 26 | `run-20261006-160016/Autumn` |
| Skip | 40 | `run-20261006-160030/Skip` |
| Peasants | 36 | `run-20261006-160041/Peasants` |

Raiz dos logs: `C:/Users/jrhre/AppData/Local/Temp/paradoxo-evento-tests/All-38a7b5b5c0c94b3990021e92b1120e59`.
