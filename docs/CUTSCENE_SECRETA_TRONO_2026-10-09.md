# Cutscene secreta do trono

Registro histórico. O encerramento e a entrega atuais estão documentados em [Cutscene final de 96 quadros](CUTSCENE_FINAL_96_QUADROS_2026-10-09.md).

## Integração

GameMaker 2026.0.0.23, GML nativo. A sequência amplia `obj_fatec_ending`, que já era iniciado na sala da Fatec após a vitória final sobre Evil Newton e a despedida das variantes. Nenhum controlador de campanha ou cenário foi substituído. A chegada do professor continua intacta; após a sala desaparecer, começa a sequência secreta. Derrotas e novas partidas não a iniciam.

O mesmo controlador impede duplicatas, utiliza o relógio real (`delta_time`) e processa a entrada a cada quadro, sem esperas síncronas. Ao finalizar ou pular, limpa seus efeitos sonoros, devolve o áudio ao encerramento e abre os créditos existentes. Para pular, solte as teclas da despedida e segure Enter, E, Espaço ou Esc por um segundo. Soltar antes cancela o progresso. A tecla segurada não fecha os créditos.

## Configuração editável

Abra `scripts/secret_throne/secret_throne.gml`, função `segredo_trono_config()`.

- `quote` e `author`: citação e autor. Foi preservada a citação de Isaac Newton escolhida anteriormente, sem inventar outra.
- `characters_per_second`: velocidade de digitação; atualmente 24.
- `scenes`: ordem, duração, imagem, entrada e saída de cada estado. Edite `duration`, `fade_in` e `fade_out` em segundos.
- `skip_seconds`: tempo de confirmação para pular.
- `destination`: `credits` mantém os créditos atuais; `menu` retorna diretamente ao menu.
- `music`, `ambience`, `glitch_sound`, `typing_sound`, `reveal_sound` e os ganhos de cada quadro: pontos de integração de áudio existente. As trilhas de Undertale não foram utilizadas.

A duração da citação aumenta automaticamente se um texto maior precisar de mais tempo para terminar a digitação e permanecer legível. A citação atual leva cinco segundos.

| Estado | Duração | Apresentação |
|---|---:|---|
| FINAL_SCREEN | 3 s | FIM imóvel no centro; encerramento musical diminui |
| GLITCH_SEQUENCE | 4 s | Deslocamentos curtos, interferência moderada e erros verdes ficcionais |
| BLACKOUT | 1 s | Preto e silêncio |
| QUOTE_REVEAL | 5 s | Digitação da citação, autor e desaparecimento suave |
| SCENE_01 | 4 s | Início da trilha |
| SCENE_02 | 3 s | Primeira aproximação |
| SCENE_03 | 3 s | Aproximação intermediária |
| SCENE_04 | 4 s | Escadaria, música reduzida e ambiente grave |
| SCENE_05 | 6 s | Personagem imóvel, efeito grave e desaparecimento para preto |
| ENDING_TRANSITION | 2 s | Preto e silêncio antes dos créditos |

## Imagens preservadas

Os cinco PNGs do ZIP estão em `datafiles/secret_throne/`, registrados como `spr_secret_throne_01` até `spr_secret_throne_05`. Os arquivos dos sprites são cópias exatas, confirmadas byte a byte com o ZIP. A renderização utiliza escala uniforme e margens pretas para preservar o quadro completo, inclusive as fotos das fissuras e a máscara na última cena. Não existem movimentos internos, cortes, substituições de imagem ou animação artificial do personagem.

## Arquivos

Criados: script e recurso `secret_throne`, cinco recursos de sprite, cópias dos cinco PNGs, evento Cleanup do controlador e ferramentas de importação/verificação HTML5 da cutscene.

Modificados: Create, Step, Draw GUI e recurso de `obj_fatec_ending`; `game_audio` para a seleção e o volume locais desta sequência; registro de recursos em `ParadoxoDeWilson.yyp`; testes Credits/Epilogue; limite de tempo do teste completo; preparação dos pacotes e instruções de entrega.

## Verificação

- Teste inicial falhou pela ausência do controlador configurável da nova sequência, antes de implementar.
- Epilogue: 2.502 verificações, zero falhas. Exercita derrota, repetição da notificação de vitória, seis portais, sala de aula, todos os dez estados, cinco capturas ordenadas, limpeza de áudio, créditos, menu e nova partida.
- Credits: 83 verificações, zero falhas. Confere ordem e tempos, recursos, citação, autor, singleton, digitação real, confirmação herdada, salto curto cancelado, salto intencional de um segundo, restauração e créditos.
- Audio: 55 verificações, zero falhas. Revalida o sistema de áudio existente.
- Capturas nativas das cinco telas inspecionadas, sem distorção, corte ou interface de exploração visível.
- HTML5: dez estados em ordem, término natural nos créditos, confirmação curta cancelada e salto intencional confirmados em navegador isolado. Contexto de áudio ativo, zero erros, requisições falhadas ou respostas HTTP de erro (`web-secret-throne/report.json`).
- Revisão independente concluída sem pendências após ajustar o tempo real em máquinas abaixo de 10 FPS e evitar atualizar ganho de sons já encerrados.
- Exportações finais Windows e HTML5 concluídas. O executável entregue iniciou sem erros. A versão web final passou 14 verificações de menu, tela cheia, áudio e controles, com zero erros.
- ZIPs e pastas de entrega conferidos: 4 arquivos Windows, 96 arquivos web, 950 arquivos de fontes do projeto e 105 arquivos de entrega, sem divergências (`package-verification.json`).

Não restaram pendências. Entrega atualizada em `C:/Users/jrhre/OneDrive/Desktop/Paradoxo de Wilson - Final/`, incluindo os dois ZIPs, o executável e a versão web.

Evidências e recibos de exportação ficam em `output/revision-20261009/`. Os arquivos anteriores à alteração estão preservados no backup indicado por `secret-throne-backup.txt`.
