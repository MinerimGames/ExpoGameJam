# Camponeses removidos dos cenários

Por pedido do usuário, foram removidas as instâncias de `obj_castle_population` do Bosque e da Vila e suas entradas na ordem de criação. Os cenários deixam de criar camponeses. A inspeção das 358 instâncias em todas as salas confirma ausência de camponeses e geradores de população.

O jogador, os encontros de história, as câmeras, os colisores e os demais dados das salas foram preservados. A comparação semântica dos arquivos com o backup confirma que somente o gerador de população e sua referência na ordem de criação foram retirados de cada uma das duas salas. Os sprites e códigos importados continuam disponíveis, sem instâncias no jogo.

## Verificação

Teste Peasants atualizado: dez visitas a Bosque, Vila, castelo, salão, trono e cenários outonais; ausência de camponeses e população, presença do jogador, colisores do Bosque e da Vila e encontros com guarda e rei preservados. Resultado: 36 verificações, zero falhas. Logs: `C:/Users/jrhre/AppData/Local/Temp/paradoxo-evento-tests/All-38a7b5b5c0c94b3990021e92b1120e59/run-20261006-153503/Peasants`.

Teste Route: 48 verificações, zero falhas, incluindo percurso natural e encontros com guarda e rei. Logs: `C:/Users/jrhre/AppData/Local/Temp/paradoxo-evento-tests/All-38a7b5b5c0c94b3990021e92b1120e59/run-20261006-153532/Route`.

Compilação Windows VM com runtime GameMaker LTS 2026.0.0.23: código zero, `Igor complete.`. Binário e log: `C:/Users/jrhre/AppData/Local/CodexBuilds/ParadoxoDeWilson/evento-20261006-153532`.

Backup das salas, dos testes e do relatório anterior: `C:/Users/jrhre/AppData/Local/CodexBackups/ParadoxoDeWilson/remove-residents-20261006-153423`.
