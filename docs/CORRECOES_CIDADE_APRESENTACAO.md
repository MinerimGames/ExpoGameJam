# Correções de apresentação e cidade — 07/10/2026

O arco da cidade ganhou uma camada de ferro desenhada pelo próprio GameMaker. Wilson atravessa por baixo; as coordenadas de textura atendem ao recorte da entrada e ao mapa inteiro. A imagem original foi preservada.

O rei tem 60 unidades de altura sentado e 64 em pé, com os pés alinhados ao assento e ao piso diante do trono. Wilson tem 42 unidades no castelo e 33,6 na cidade e no porto; o aliado tem 34. As máscaras de colisão permanecem independentes da escala visual.

Newton ganhou respiração e balanço no mapa, nos retratos do tutorial e do encontro final e durante as batalhas. As animações conservam os pontos de apoio e não alteram as regras do combate.

A cidade portuária foi redesenhada com uma ponte vertical larga, dois cais e um caminho central livre. As colisões agora usam retângulos, sem a grade diagonal que causava travamentos. Água, muretas, casas e limites ficam bloqueados. Três faixas da ponte foram percorridas pelo objeto real do jogador, passando pelas duas entradas.

As setas na tela foram removidas; WASD e setas do teclado continuam funcionando. Wilson vira para a frente ao entrar em batalha, inclusive na figura pequena que permanece visível sob a interface.

## Verificação

As regressões foram executadas antes das correções e mostraram as falhas esperadas: arco sem camada frontal, controles de toque ativos, Wilson de costas na batalha, rei pequeno, Newton sem animação e muretas abertas. Presentation compara pixels dos eventos Draw e Draw GUI reais em superfícies nativas.

Os testes de geometria (9) e alinhamento/oclusão de imagem (3) passaram. Capturas nativas estão em output/verification/city-presentation/screens.

O cursor físico estava sobre SAIR ao pressionar Enter nos testes Progression e Newton. Esses dois testes passaram a usar um cursor simulado fora da interface. O jogo de produção não recebe as macros ou o estado dos testes.

A revisão independente também conferiu a persistência da arte no importador e os eventos End Step. O importador agora referencia o mesmo mapa usado pelos colisores e conserva os eventos de animação e profundidade.

## Arte

Modo: ferramenta nativa image_gen, edição do cenário existente. Arquivo incorporado ao projeto: output/imagegen/commercial-straight-bridge.png. Referência preservada: output/imagegen/commercial-canals.png.

Prompt final utilizado:

> Edit target: provided game harbor map. Redesign its geometry substantially for a playable 2D top-down RPG, keeping its detailed warm pixel art, turquoise water, tan stone paving, terracotta merchant buildings, teal awnings and harbor theme. FULL MAP landscape 3:2 canvas. Orthogonal overhead projection with no diagonal walkways. A single horizontal canal spans entire canvas between y=43% and y=60%. One broad straight VERTICAL stone bridge centered at x=50%, bridge floor spans x=42% to58%, perfectly connects lower quay to upper quay. Low thin railings ONLY along bridge left/right edges; entrances open, NO transverse railings/arches/steps on bridge or across the paths. The lower quay is open walkable paved area y60%-100%, with a very clear unobstructed central entry road from bottom center through the bridge. The upper quay is open paved area y15%-43%, with a broad central road from bridge to a quiet open court at top center y20%. Merchant buildings ONLY in four outer corners, visible footprint neatly aligned horizontally and vertically, all decorative barrels/crates/lamps/trees against outer walls and far away from center walkway. Boats inside canal well away from bridge. Keep central x38%-62% clear of obstacles throughout entire map. Wide sidewalks, no islands, no extra bridges, no diagonals, no small steps, no park, no civic statue, no autumn propaganda. No characters, no UI, no text, no symbols labeling collision. Preserve visual variety commercial maritime district distinct from previous autumn plaza. Camera orthographic overhead RPG slight frontwall visibility, NOT cinematic perspective. Entire scene fills canvas.

Imagem gerada: C:/Users/jrhre/.codex/generated_images/01a0faa6-48c6-76e2-99aa-fabcdcb85825/exec-3c5f3d5c-5059-4f6c-a443-08c24a8fee3a.png.

Backup completo anterior: C:/Users/jrhre/AppData/Local/CodexBackups/ParadoxoDeWilson/city-presentation-20261007-114722.

Pacote Windows desta revisão: dist/ParadoxoDeWilson-Windows-correcoes-cidade-20261007.


## Runtime results

19 suites, 12508 checks, 0 failures.

| Suite | Checks | Log |
|---|---:|---|
| Input | 18 | C:/Users/jrhre/AppData/Local/Temp/paradoxo-evento-tests/WorldFinal-20261007/run-20261007-115803/Input/runner.log |
| OnScreenControls | 59 | C:/Users/jrhre/AppData/Local/Temp/paradoxo-evento-tests/WorldFinal-20261007/run-20261007-115803/OnScreenControls/runner.log |
| Battle | 8187 | C:/Users/jrhre/AppData/Local/Temp/paradoxo-evento-tests/WorldFinal-20261007/run-20261007-115803/Battle/runner.log |
| Ambient | 27 | C:/Users/jrhre/AppData/Local/Temp/paradoxo-evento-tests/WorldFinal-20261007/run-20261007-115803/Ambient/runner.log |
| Integration | 120 | C:/Users/jrhre/AppData/Local/Temp/paradoxo-evento-tests/WorldFinal-20261007/run-20261007-115803/Integration/runner.log |
| Castle | 39 | C:/Users/jrhre/AppData/Local/Temp/paradoxo-evento-tests/WorldFinal-20261007/run-20261007-115803/Castle/runner.log |
| Route | 80 | C:/Users/jrhre/AppData/Local/Temp/paradoxo-evento-tests/WorldFinal-20261007/run-20261007-115803/Route/runner.log |
| Guard | 197 | C:/Users/jrhre/AppData/Local/Temp/paradoxo-evento-tests/WorldFinal-20261007/run-20261007-115803/Guard/runner.log |
| Royal | 285 | C:/Users/jrhre/AppData/Local/Temp/paradoxo-evento-tests/WorldFinal-20261007/run-20261007-115803/Royal/runner.log |
| Autumn | 42 | C:/Users/jrhre/AppData/Local/Temp/paradoxo-evento-tests/WorldFinal-20261007/run-20261007-115803/Autumn/runner.log |
| Skip | 52 | C:/Users/jrhre/AppData/Local/Temp/paradoxo-evento-tests/WorldFinal-20261007/run-20261007-115803/Skip/runner.log |
| Peasants | 36 | C:/Users/jrhre/AppData/Local/Temp/paradoxo-evento-tests/WorldFinal-20261007/run-20261007-115803/Peasants/runner.log |
| City | 338 | C:/Users/jrhre/AppData/Local/Temp/paradoxo-evento-tests/WorldFinal-20261007/run-20261007-115803/City/runner.log |
| Progression | 1467 | C:/Users/jrhre/AppData/Local/Temp/paradoxo-evento-tests/WorldFinal-20261007/run-20261007-120509/Progression/runner.log |
| PlayerArt | 63 | C:/Users/jrhre/AppData/Local/Temp/paradoxo-evento-tests/WorldFinal-20261007/run-20261007-120522/PlayerArt/runner.log |
| Newton | 1349 | C:/Users/jrhre/AppData/Local/Temp/paradoxo-evento-tests/WorldFinal-20261007/run-20261007-120724/Newton/runner.log |
| MapSafety | 119 | C:/Users/jrhre/AppData/Local/Temp/paradoxo-evento-tests/WorldFinal-20261007/run-20261007-120759/MapSafety/runner.log |
| Scenery | 17 | C:/Users/jrhre/AppData/Local/Temp/paradoxo-evento-tests/WorldFinal-20261007/run-20261007-120829/Scenery/runner.log |
| Presentation | 13 | C:/Users/jrhre/AppData/Local/Temp/paradoxo-evento-tests/WorldFinal-20261007/run-20261007-121026/Presentation/runner.log |

Exportacao e abertura do executavel confirmadas. Copia instalada em: C:/Users/jrhre/OneDrive/Desktop/Paradoxo de Wilson. Backup da versao executavel anterior: C:\Users\jrhre\AppData\Local\CodexBackups\ParadoxoDeWilson\release-before-city-fixes-20261007-121511.
