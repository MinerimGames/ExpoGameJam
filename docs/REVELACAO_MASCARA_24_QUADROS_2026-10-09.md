# Revelação da máscara: integração final

Registro histórico. O encerramento e a entrega atuais estão documentados em [Cutscene final de 96 quadros](CUTSCENE_FINAL_96_QUADROS_2026-10-09.md).

Esta revisão conecta a sprite sheet fornecida ao controlador existente `obj_fatec_ending`. Ela substitui a espera indefinida preparada em `TRONO_VAZIO_REVEAL_SEQUENCE_2026-10-09.md`. A chegada à Fatec, FIM, erros verdes, tela preta, citação, quatro aproximações e o trono vazio de cinco segundos continuam com os mesmos recursos e tempos.

## Continuação implementada

| Estado | Duração | Apresentação |
|---|---:|---|
| REVEAL_SEQUENCE | 3 s | Mesmo trono vazio, estático e silencioso |
| REVEAL_TRANSITION | 1 s | Trono desaparece suavemente para preto |
| REVEAL_BLACKOUT | 1 s | Preto e silêncio antes da figura |
| REVEAL_ANIMATION | 1 s a 24 FPS | Poses 1–24, uma única vez, em fundo preto |
| REVEAL_HOLD | 3 s | Quadro 24 imóvel, efeitos interrompidos |
| REVEAL_FADEOUT | 1,5 s | Mesmo quadro desaparece lentamente para preto |
| REVEAL_COMPLETE | 0,35 s | Pausa preta final; em seguida, créditos configurados |

A continuação dura 10,85 segundos, incluindo a pausa adicional do trono. A sequência inteira, desde FIM até a liberação dos créditos, dura 42,85 segundos com a citação atual. O retorno à sala de aula ocorre antes desse intervalo.

## Sprite sheet e pixel art

O arquivo original mede 1536 × 1024 pixels, com 6 colunas e 4 linhas. A leitura é da esquerda para a direita e de cima para baixo. O capuz da quarta linha começa em y=760: cortar rigidamente em y=768 incluiria parte desse capuz na linha anterior e cortaria a última linha. Foram utilizados os espaços pretos entre as linhas, com limites y=0, 255, 507, 754 e 1024.

Cada pose foi copiada, sem redimensionamento nem redesenho, para um quadro nativo de 256 × 256 pixels. As posições dos pés foram alinhadas em x=128, y=252 para impedir saltos causados pelas margens da folha. O fundo preto foi mantido, incluindo os pixels escuros pertencentes à figura. O arquivo original permanece intacto e existe uma cópia integral em `datafiles/secret_throne/06_Remocao_da_Mascara.png`.

O recurso `spr_secret_mask_reveal` contém 24 quadros. O desenho usa proporção constante, origem comum e filtragem nearest-neighbor, sem interpolação, blur, loop ou interface de combate. A imagem separada `Cavaleiro Mago de Capuz Verde.png` serviu como referência visual; não substitui os quadros da folha e não foi redesenhada. Nenhum personagem foi inserido na imagem do trono.

## Configuração de velocidade e áudio

Em `scripts/secret_throne/secret_throne.gml`, função `segredo_trono_config()`, altere `reveal_fps:24` para `reveal_fps:12` se desejar uma retirada de máscara de dois segundos. `segredo_trono_tempos()` recalcula a duração da animação na inicialização; não é necessário editar a lista de durações. O avanço usa tempo real em segundos e escolhe um quadro inteiro, independentemente da taxa de atualização da engine. Em quedas de FPS, o relógio segue o tempo decorrido, sem alongar ou repetir a animação.

O efeito metálico reutiliza `snd_defense`, em volume baixo. Quando a máscara deixa o rosto, na pose 11, toca uma única vez `snd_transformation`, também em volume baixo e tom grave. `metal_sound`, `metal_gain`, `face_sound` e `face_gain` são os pontos editáveis para áudio futuro. A entrada no quadro final interrompe os efeitos; o rosto permanece silencioso durante os três segundos de pausa e o fade-out.

A textura da revelação é carregada antecipadamente com `sprite_prefetch` na entrada da pausa estática do trono. O teste real identificou que o primeiro carregamento durante a animação consumia quase todo o seu segundo; após essa correção, o registro nativo mostrou os índices 0–23 em ordem. O carregamento não insere o personagem no trono nem altera as telas anteriores. A API está documentada no [manual oficial do GameMaker](https://manual.gamemaker.io/monthly/en/GameMaker_Language/GML_Reference/Asset_Management/Sprites/Sprite_Manipulation/sprite_prefetch.htm).

Os callbacks existentes de `REVEAL_SEQUENCE` continuam disponíveis. A conclusão normal passa por `REVEAL_COMPLETE` e usa `segredo_trono_finalizar`, liberando os créditos existentes. O comando manual de pular foi preservado: solte as teclas e segure Enter, E, Espaço ou Esc por um segundo.

## Arquivos principais

- `scripts/secret_throne/secret_throne.gml`: estados, temporização, áudio e desenho da revelação.
- `objects/obj_fatec_ending/Create_0.gml`: inicialização do quadro e da marca de efeito único.
- `sprites/spr_secret_mask_reveal/`: recurso nativo e seus 24 quadros.
- `ParadoxoDeWilson.yyp`: registro do novo recurso nativo.
- `datafiles/secret_throne/06_Remocao_da_Mascara.png`: cópia intacta da folha fornecida.
- `tools/import_mask_reveal.py`: importação reproduzível sem alteração da folha.
- `tests/evento/Credits_Step.gml`, `tests/evento/Epilogue_Step.gml` e ferramentas de teste web: verificação do fluxo real, dos quadros, dos tempos e do encerramento.
- `tests/evento/Castle_Step.gml` e `Autumn_Create.gml` / `Autumn_Step.gml`: atualização de cenários de teste antigos para aguardar a transmissão da vila e chegar à cidade pelo portal steampunk já existente. Essas alterações não modificam a jogabilidade.
- `tools/run_evento_tests.ps1`: maior limite de tempo para testar a sequência completa; `tools/package_final_release.py`: instruções de uso atualizadas na entrega.

## Verificação

O teste de créditos passou com 150 verificações e zero falhas, incluindo os 24 quadros a 24 FPS, os 24 quadros a 12 FPS, três segundos de quadro final, efeitos sem repetição, fade e conclusão natural. A ausência da continuação foi detectada pelo teste antes de sua implementação.

O teste nativo `Epilogue` executou a chegada, toda a cutscene e a saída normal com 2.902 verificações e zero falhas. Seu relógio real registrou todos os 24 quadros, sem capturas de tela durante o segundo da animação, pois a leitura da tela pode atrasar a execução. A captura visual foi feita na pausa final. O teste de créditos verifica a pausa do trono em seu instante central explícito e pressiona a confirmação antes da conclusão, para distinguir uma tecla carregada de uma confirmação nova após os créditos.

`tests/verify_mask_reveal_assets.py` confirmou os 24 quadros em ordem, os pixels copiados idênticos aos da folha, a ausência de personagem vizinho ou corte, o capuz completo e a origem dos pés comum. SHA-256 da folha original: `9184c68fab009c4da320d365c7d88ea49ff58800556dea70b5bef2de627c1f49`.

A execução dos 32 conjuntos nativos passou com 10.696 verificações e zero falhas. O registro de cada conjunto e seu log estão em `output/revision-20261009/native-tests.json`. As cinco imagens originais da sequência anterior também foram comparadas ao backup e permaneceram byte a byte idênticas; os nove estados anteriores mantiveram seus recursos e tempos.

O teste HTML5 passou pelas 16 etapas, registrou os 24 quadros em ordem, confirmou o quadro 24 silencioso até o fim da pausa de três segundos e testou o comando de pular. O áudio estava ativo; não houve erros de execução, requisições falhas ou respostas HTTP de erro. As capturas em 1280 × 800, 700 × 420 e 900 × 1200 foram inspecionadas: personagem inteiro, proporcional e centralizado. Relatório: `output/revision-20261009/web-secret-throne/report.json`.

As entregas `FinalRelease` foram recompiladas e atualizadas em `../Paradoxo de Wilson - Final`, incluindo Windows, Web e os dois ZIPs. A cópia anterior foi preservada antes da substituição. O verificador confirmou igualdade dos arquivos exportados, entregues e arquivados, integridade dos ZIPs e 1.000 arquivos do manifesto de origem; zero divergências. Registro: `output/revision-20261009/package-verification.json`.

O executável entregue iniciou seu loop principal sem erros e permaneceu aberto no teste de inicialização. Registro: `output/revision-20261009/native-start-mask-reveal/report.json`. O teste da versão web final também passou, incluindo tela cheia, densidades de tela 1×/2×, janela pequena, menu e botão de pular batalha preservado para testes do autor; não houve erros de execução ou carregamento. Registro: `output/revision-20261009/web-smoke/report.json`.

Na primeira execução ampla, `Castle` falhou em três verificações por ignorar a pausa intencional da transmissão de chegada à vila. `Autumn` falhou em uma verificação porque ainda esperava o antigo caminho direto do rei à cidade. As cópias de teste foram atualizadas para o percurso real; a repetição passou com 39 e 43 verificações, respectivamente, sem falhas. Nenhum cenário, colisão, diálogo ou comportamento de jogo foi alterado para satisfazer esses testes.
