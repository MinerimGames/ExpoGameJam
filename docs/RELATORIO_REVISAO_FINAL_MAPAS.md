# Revisão final de mapas e caminhada — 07/10/2026

Corrigidas as colisões dos 13 mapas jogáveis, a profundidade dos personagens e o enquadramento da câmera. Wilson usa novas poses de exploração com braços relaxados e seis quadros por direção; esquerda espelha a lateral direita. O ciclo acompanha a distância efetivamente percorrida, mantém os pés alinhados e para quando Wilson está bloqueado. A máscara de colisão original dos pés e a velocidade de deslocamento foram preservadas.

No porto, água, bordas, telhados e margens da ponte receberam limites mais precisos. A passagem superior continua conectando a entrada ao aliado. O corrimão próximo é desenhado na frente de Wilson quando necessário, com recortes alinhados à imagem original.

O rei foi ajustado para 32 unidades sentado e 36 em pé, comparado a 33,6 de Wilson no interior do castelo. Guarda, Newton e os demais personagens de história usam os pés como referência de posicionamento e profundidade; retratos e poses de batalha foram conferidos.

## Verificação

As 16 suítes somam **12,419 verificações, sem falhas**. Também passaram 10 testes em Python: quatro de geometria dos mapas, cinco de conectividade/limites do porto e um de alinhamento visual do corrimão. As capturas nativas de caminhada, trono, batalha e ponte foram inspecionadas.

| Suíte | Verificações | Evidência |
|---|---:|---|
| Input | 18 | [Log](<C:/Users/jrhre/AppData/Local/Temp/paradoxo-evento-tests/WorldFinal-20261007/run-20261007-071130/Input/runner.log>) |
| Battle | 8187 | [Log](<C:/Users/jrhre/AppData/Local/Temp/paradoxo-evento-tests/WorldFinal-20261007/run-20261007-071130/Battle/runner.log>) |
| Ambient | 27 | [Log](<C:/Users/jrhre/AppData/Local/Temp/paradoxo-evento-tests/WorldFinal-20261007/run-20261007-071130/Ambient/runner.log>) |
| Integration | 120 | [Log](<C:/Users/jrhre/AppData/Local/Temp/paradoxo-evento-tests/WorldFinal-20261007/run-20261007-071130/Integration/runner.log>) |
| Castle | 39 | [Log](<C:/Users/jrhre/AppData/Local/Temp/paradoxo-evento-tests/WorldFinal-20261007/run-20261007-071130/Castle/runner.log>) |
| Route | 80 | [Log](<C:/Users/jrhre/AppData/Local/Temp/paradoxo-evento-tests/WorldFinal-20261007/run-20261007-071130/Route/runner.log>) |
| Guard | 197 | [Log](<C:/Users/jrhre/AppData/Local/Temp/paradoxo-evento-tests/WorldFinal-20261007/run-20261007-071130/Guard/runner.log>) |
| Royal | 285 | [Log](<C:/Users/jrhre/AppData/Local/Temp/paradoxo-evento-tests/WorldFinal-20261007/run-20261007-071130/Royal/runner.log>) |
| Autumn | 42 | [Log](<C:/Users/jrhre/AppData/Local/Temp/paradoxo-evento-tests/WorldFinal-20261007/run-20261007-071130/Autumn/runner.log>) |
| Skip | 52 | [Log](<C:/Users/jrhre/AppData/Local/Temp/paradoxo-evento-tests/WorldFinal-20261007/run-20261007-071130/Skip/runner.log>) |
| Peasants | 36 | [Log](<C:/Users/jrhre/AppData/Local/Temp/paradoxo-evento-tests/WorldFinal-20261007/run-20261007-071520/Peasants/runner.log>) |
| City | 338 | [Log](<C:/Users/jrhre/AppData/Local/Temp/paradoxo-evento-tests/WorldFinal-20261007/run-20261007-071532/City/runner.log>) |
| Progression | 1467 | [Log](<C:/Users/jrhre/AppData/Local/Temp/paradoxo-evento-tests/WorldFinal-20261007/run-20261007-071546/Progression/runner.log>) |
| PlayerArt | 63 | [Log](<C:/Users/jrhre/AppData/Local/Temp/paradoxo-evento-tests/WorldFinal-20261007/run-20261007-071601/PlayerArt/runner.log>) |
| Newton | 1349 | [Log](<C:/Users/jrhre/AppData/Local/Temp/paradoxo-evento-tests/WorldFinal-20261007/run-20261007-072044/Newton/runner.log>) |
| MapSafety | 119 | [Log](<C:/Users/jrhre/AppData/Local/Temp/paradoxo-evento-tests/WorldFinal-20261007/run-20261007-071958/MapSafety/runner.log>) |

Os testes automatizados usam teclas virtuais no projeto isolado para evitar que o Windows direcione entradas à janela em foco. O código real de movimento, colisão, diálogos e batalha é executado. Essas entradas não são incluídas no projeto principal. O comportamento de envio de teclas no Windows é descrito no [manual oficial do GameMaker](https://manual.gamemaker.io/lts/en/GameMaker_Language/GML_Reference/Game_Input/Keyboard_Input/keyboard_key_press.htm).

O teste visual compara duas capturas fixas da ponte, sem personagens, com e sem a camada do corrimão. Apenas 0,0975% dos pixels diferem acima da tolerância de amostragem; erro médio de 0,0286 por canal. A [API de primitivas](https://manual.gamemaker.io/lts/en/GameMaker_Language/GML_Reference/Drawing/Primitives/draw_vertex_texture_colour.htm) usa coordenadas normalizadas dentro da imagem do sprite.

## Mapas revisados

A quantidade de colisores é registrada para rastreabilidade. Os testes de geometria verificam pontos sólidos, bordas e caminhos, além dessa contagem.

| Mapa | Colisores antes | Colisores atuais |
|---|---:|---:|
| rm_autumn_gate | 14 | 17 |
| rm_autumn_plaza | 17 | 23 |
| rm_autumn_streets | 22 | 29 |
| rm_bosque | 31 | 36 |
| rm_castelo | 60 | 67 |
| rm_castle_hall | 18 | 22 |
| rm_cavernas | 13 | 19 |
| rm_cavernas_2 | 25 | 30 |
| rm_commercial_district | 153 | 310 |
| rm_temporal_origin | 6 | 5 |
| rm_throne_room | 13 | 17 |
| rm_tutorial | 6 | 5 |
| rm_vila | 109 | 133 |

## Arquivos e recuperação

- [Projeto GameMaker atualizado](<C:/Users/jrhre/OneDrive/Desktop/ExpoGameJam-demo/ParadoxoDeWilson.yyp>)
- [Compilação final para o Runner do GameMaker](<C:/Users/jrhre/AppData/Local/CodexBuilds/ParadoxoDeWilson/world-final-20261007-072110/ParadoxoDeWilson.win>)
- [Log da compilação final — Igor complete](<C:/Users/jrhre/AppData/Local/CodexBuilds/ParadoxoDeWilson/world-final-20261007-072110/compile.log>)
- Backup anterior: C:/Users/jrhre/AppData/Local/CodexBackups/ParadoxoDeWilson/world-fixes-20261007-063546
- Capturas preservadas: C:/Users/jrhre/OneDrive/Desktop/ExpoGameJam-demo/output/verification/world-fixes/screens
- [Atlas original de frente e costas](<C:/Users/jrhre/OneDrive/Desktop/ExpoGameJam-demo/output/imagegen/wilson-relaxed-walk-atlas.png>)
- [Atlas original de passos laterais](<C:/Users/jrhre/OneDrive/Desktop/ExpoGameJam-demo/output/imagegen/wilson-side-walk-strip.png>)
- [Prompt inicial de imagem](<C:/Users/jrhre/OneDrive/Desktop/ExpoGameJam-demo/output/imagegen/wilson-relaxed-walk-prompt.md>)
- [Prompts finais de imagem](<C:/Users/jrhre/OneDrive/Desktop/ExpoGameJam-demo/output/imagegen/wilson-walk-refinements.md>)

As novas imagens foram geradas com a ferramenta nativa de imagem e importadas sem modificar seus pixels. O jogo seleciona os quadros, alinha os pés e trata resíduos de transparência durante o desenho.
