# Evil Newton, Agente e áudio — 7 de outubro de 2026

Wilson passa a olhar para o inimigo à direita no retrato grande de batalha. A pose parada recebe espelhamento horizontal; ataque, defesa, cura e esquiva mantêm suas poses próprias. O movimento de exploração conserva as quatro direções.

O personagem verde agora aparece como ISLEIDE AGENTE nos diálogos, no retorno ao passado, na recuperação e no encerramento. Os nomes internos dos recursos antigos foram preservados para manter as referências do projeto.

Newton mantém sua aparência normal no tutorial e até a acusação do Agente. A acusação inicia uma transformação de 1,05 segundo, com transição de aparência, clarão e anéis. A confirmação fica bloqueada durante o efeito. A forma Evil Newton persiste no diálogo seguinte, nas duas batalhas e nas novas tentativas. A música de Newton acompanha a transformação e continua durante sua resposta.

## Sons e música

31 arquivos originais em WAV PCM16, 44,1 kHz, aproximadamente 24,87 MB. As quatro músicas usam composição própria com arpejos, melodias, baixo, pads e percussão. Exploração, combate e confronto com Newton têm temas diferentes; o encerramento toca uma vez. Cinco ambientes acompanham bosque, cavernas, castelo, cidade fantasma e porto. Há 12 efeitos para seleção, acerto, erro, ataque, defesa, cura, esquiva, portal, transformação, evolução, vitória e derrota.

O controlador de áudio persiste entre salas. As músicas e os ambientes fazem uma transição de volume de 350 ms; a reprodução anterior é encerrada depois da transição. Os passos dependem da distância realmente percorrida e têm intervalo mínimo de 334 ms. Não há passos quando o jogador está parado, bloqueado em diálogo, empurrando uma parede ou numa batalha. Uma pequena variação de tom, em ciclo, evita consumir o gerador aleatório usado pelas contas e combates.

| Cenário | Passos |
|---|---|
| Tutorial / origem temporal | Grama |
| Bosque | Folhas |
| Vila | Terra |
| Primeira caverna | Cascalho |
| Segunda caverna | Rocha com eco |
| Entrada do castelo | Pedra |
| Salão iluminado | Madeira |
| Sala do trono | Mármore |
| Cidade fantasma | Calçamento |
| Distrito comercial | Calçamento; pedra na ponte |

O recurso adicional de madeira de cais está disponível, mas a ponte atual usa pedra para combinar com a imagem. Os sons foram produzidos sem amostras de terceiros e dedicados a CC0-1.0. Fonte reproduzível: tools/generate_game_audio.py. Créditos, duração e níveis dos arquivos: output/audio/README.md e output/audio/manifest.json. O esquema de importação foi conferido no modelo nativo do GameMaker LTS2026, incluindo channelFormat.

## Arte gerada

Modo: ferramenta nativa image_gen, com transparência. Arquivo final integrado: output/imagegen/newton-evil.png; recurso: spr_newton_evil. O PNG foi incorporado sem alterações nos pixels e conserva o canal alfa. A imagem de Newton normal foi usada como referência. O prompt final e a configuração estão registrados em output/imagegen/newton-evil-generation.txt.

## Proteção e verificação

Backup anterior às mudanças: C:/Users/jrhre/AppData/Local/CodexBackups/ParadoxoDeWilson/evil-newton-audio-20261007-135001.

Os testes novos foram executados primeiro sem as correções: falhas esperadas de orientação, ausência da transformação e ausência do sistema de áudio. A integração de som usa o mixer real do Runner, silenciado somente no projeto de testes. Ela verifica deslocamento, colisão, bloqueios, efeitos de combate, temas, transição de salas e encerramento sem repetição. Os testes dos WAVs verificam formatos, canais, silêncio, saturação, continuidade das bordas e diferenças entre materiais.

Resultados finais e pacote Windows serão registrados abaixo após a execução.

## Resultados finais

Runner nativo: 22 grupos, 12703 verificações, zero falhas. Testes Python: 17, zero falhas. Revisão independente somente leitura: nenhum problema acionável restante.

| Grupo | Verificações | Log |
|---|---:|---|
| Ambient | 27 | C:/Users/jrhre/AppData/Local/Temp/paradoxo-evento-tests/WorldFinal-20261007/run-20261007-141327/Ambient/runner.log |
| Audio | 51 | C:/Users/jrhre/AppData/Local/Temp/paradoxo-evento-tests/WorldFinal-20261007/run-20261007-141327/Audio/runner.log |
| Autumn | 42 | C:/Users/jrhre/AppData/Local/Temp/paradoxo-evento-tests/WorldFinal-20261007/run-20261007-141327/Autumn/runner.log |
| Battle | 8187 | C:/Users/jrhre/AppData/Local/Temp/paradoxo-evento-tests/WorldFinal-20261007/run-20261007-141327/Battle/runner.log |
| BattleFacing | 105 | C:/Users/jrhre/AppData/Local/Temp/paradoxo-evento-tests/WorldFinal-20261007/run-20261007-141327/BattleFacing/runner.log |
| Castle | 39 | C:/Users/jrhre/AppData/Local/Temp/paradoxo-evento-tests/WorldFinal-20261007/run-20261007-141327/Castle/runner.log |
| City | 338 | C:/Users/jrhre/AppData/Local/Temp/paradoxo-evento-tests/WorldFinal-20261007/run-20261007-141327/City/runner.log |
| EvilNewton | 39 | C:/Users/jrhre/AppData/Local/Temp/paradoxo-evento-tests/WorldFinal-20261007/run-20261007-141327/EvilNewton/runner.log |
| Guard | 197 | C:/Users/jrhre/AppData/Local/Temp/paradoxo-evento-tests/WorldFinal-20261007/run-20261007-141327/Guard/runner.log |
| Input | 18 | C:/Users/jrhre/AppData/Local/Temp/paradoxo-evento-tests/WorldFinal-20261007/run-20261007-141327/Input/runner.log |
| Integration | 120 | C:/Users/jrhre/AppData/Local/Temp/paradoxo-evento-tests/WorldFinal-20261007/run-20261007-141327/Integration/runner.log |
| MapSafety | 119 | C:/Users/jrhre/AppData/Local/Temp/paradoxo-evento-tests/WorldFinal-20261007/run-20261007-141327/MapSafety/runner.log |
| Newton | 1349 | C:/Users/jrhre/AppData/Local/Temp/paradoxo-evento-tests/WorldFinal-20261007/run-20261007-141327/Newton/runner.log |
| OnScreenControls | 59 | C:/Users/jrhre/AppData/Local/Temp/paradoxo-evento-tests/WorldFinal-20261007/run-20261007-141327/OnScreenControls/runner.log |
| Peasants | 36 | C:/Users/jrhre/AppData/Local/Temp/paradoxo-evento-tests/WorldFinal-20261007/run-20261007-141327/Peasants/runner.log |
| PlayerArt | 63 | C:/Users/jrhre/AppData/Local/Temp/paradoxo-evento-tests/WorldFinal-20261007/run-20261007-141327/PlayerArt/runner.log |
| Presentation | 13 | C:/Users/jrhre/AppData/Local/Temp/paradoxo-evento-tests/WorldFinal-20261007/run-20261007-141327/Presentation/runner.log |
| Progression | 1467 | C:/Users/jrhre/AppData/Local/Temp/paradoxo-evento-tests/WorldFinal-20261007/run-20261007-141327/Progression/runner.log |
| Route | 80 | C:/Users/jrhre/AppData/Local/Temp/paradoxo-evento-tests/WorldFinal-20261007/run-20261007-141327/Route/runner.log |
| Royal | 285 | C:/Users/jrhre/AppData/Local/Temp/paradoxo-evento-tests/WorldFinal-20261007/run-20261007-141327/Royal/runner.log |
| Scenery | 17 | C:/Users/jrhre/AppData/Local/Temp/paradoxo-evento-tests/WorldFinal-20261007/run-20261007-141327/Scenery/runner.log |
| Skip | 52 | C:/Users/jrhre/AppData/Local/Temp/paradoxo-evento-tests/WorldFinal-20261007/run-20261007-141327/Skip/runner.log |

## Entrega Windows

Exportação nativa concluída. O executável foi aberto durante 8 segundos e permaneceu ativo, com entrada no loop principal e sem erros fatais. Os quatro arquivos da pasta de jogo na Área de Trabalho foram conferidos por SHA256 contra o pacote exportado.

- [Executável atualizado](<C:/Users/jrhre/OneDrive/Desktop/Paradoxo de Wilson/ParadoxoDeWilson.exe>)
- [Pacote ZIP](<C:/Users/jrhre/OneDrive/Desktop/Paradoxo de Wilson/ParadoxoDeWilson.zip>)
- [Logs e hashes da entrega](<C:/Users/jrhre/OneDrive/Desktop/ExpoGameJam-demo/dist/ParadoxoDeWilson-Windows-evil-newton-audio-20261007>)
- [PNG final do Evil Newton](<C:/Users/jrhre/OneDrive/Desktop/ExpoGameJam-demo/output/imagegen/newton-evil.png>)
- [Prompt final — ferramenta nativa image_gen](<C:/Users/jrhre/OneDrive/Desktop/ExpoGameJam-demo/output/imagegen/newton-evil-generation.txt>)

Backup do executável anterior: C:/Users/jrhre/AppData/Local/CodexBackups/ParadoxoDeWilson/release-before-evil-newton-audio-20261007.
