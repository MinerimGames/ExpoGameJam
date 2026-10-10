# Cutscene final — 96 quadros

Esta revisão substitui os roteiros anteriores de trono vazio e retirada da máscara em corpo inteiro. Preserva os portais, a chegada do professor, os quatro alunos e a jogabilidade.

## Recursos e importação

- `sprites/spr_secret_path_approach`: 36 quadros do caminho, novo recurso nativo.
- `sprites/spr_secret_guardian_approach`: 36 quadros do guardião; reutiliza o recurso existente.
- `sprites/spr_secret_mask_reveal`: 24 quadros em close-up, números originais 37–60; substitui o conteúdo da revelação anterior.
- `fonts/fnt_ending_pixel`: fonte bitmap branca, com caracteres acentuados, exclusiva da citação.
- `ParadoxoDeWilson.yyp`: registro dos dois novos recursos.
- `scripts/secret_throne/secret_throne.gml`: sequência, relógio, áudio, recortes, desenho e encerramento.
- `objects/obj_fatec_ending/Create_0.gml` e `Step_0.gml`: integração com o controlador existente e estado preto definitivo.
- `tools/import_neon_cutscene.py`: importação repetível sem redimensionar ou redesenhar os quadros.

Os arquivos fornecidos permanecem intactos em Downloads. Cópias exatas estão em `datafiles/cutscene_final/{caminho,guardiao,revelacao}/original.png`. Os quadros individuais ficam em:

```text
cutscene_final/caminho/frame_01.png ... frame_36.png
cutscene_final/guardiao/frame_01.png ... frame_36.png
cutscene_final/revelacao/frame_37.png ... frame_60.png
```

A grade irregular foi inspecionada e recortada por coordenadas reais, sem presumir células de 209 pixels. Números e suas bordas são excluídos por transparência apenas no pequeno canto de edição; linhas divisórias ficam fora dos recortes. O RGB dos pixels retidos é idêntico ao original. Não há reconstrução do cenário coberto pela numeração. O armazenamento nativo tem preenchimento transparente para acomodar dimensões diferentes; o desenho usa apenas os limites reais de cada painel. As faixas pretas do enquadramento preservam a proporção e a filtragem é nearest-neighbor. A imagem 01 permanece intacta; as antigas 02–05 estão preservadas fisicamente e fora da apresentação.

## Ordem e duração

| Estado | Segundos |
|---|---:|
| FINAL_SCREEN | 3 |
| GLITCH_SEQUENCE | 4 |
| BLACKOUT | 1 |
| INTRO_STATIC_01 | 2 |
| PATH_ANIMATION, 36 quadros a 12 FPS | 3 |
| GUARDIAN_ANIMATION, 36 quadros a 12 FPS | 3 |
| MASK_TRANSITION, corte proposital | 0,12 |
| MASK_REMOVAL, 24 quadros a 12 FPS | 2 |
| REVEAL_HOLD, quadro 60 | 3 |
| REVEAL_FADEOUT | 1,5 |
| QUOTE_BLACKOUT, silêncio | 1 |
| NEWTON_QUOTE, escrita e leitura | 6,2083 |
| FINAL_FADEOUT | 1 |
| COMPLETE, estabelecimento do estado preto | 0,35 |

Total: **31,1783 segundos a partir de FIM**, ou **40,1783 segundos desde a entrada na sala de aula**. O preto final permanece indefinidamente. A fonte usa 24 caracteres por segundo; os quatro segundos de leitura começam depois da conclusão do texto. Não aparecem créditos ou mensagens posteriores. O menu só pode ser aberto por uma nova confirmação deliberada, após soltar as teclas.

## Citação

O texto existente foi movido para depois do quadro 60, sua pausa, o escurecimento e um segundo de silêncio:

> O que sabemos é uma gota, o que ignoramos é um oceano
>
> Isaac Newton

A citação começa em 32,62 segundos desde a entrada na sala, centralizada sobre preto, e o autor aparece abaixo quando a escrita termina.

## Ajustes futuros

`segredo_trono_config()` reúne FPS, pausas, ganhos, nomes dos sons e tempos de transição. Alterar `path_fps`, `approach_fps` ou `reveal_fps` e recalcular com `segredo_trono_tempos()` ajusta automaticamente as durações. O relógio usa tempo real, sem loops ou zoom por código. Os 14 estados pertencem ao controlador existente. A opção de pular exige soltar as teclas e depois manter a confirmação por um segundo; limpa áudio e encerra em preto.

## Verificação

- Importação: 96 painéis em ordem, originais com hashes idênticos, sem reamostragem, camadas nativas correspondentes, guias removidos.
- Controlador: 242 verificações, incluindo quadros a 12 e 24 FPS, citação, tempos, salto, áudio e confirmação posterior.
- Percurso completo nativo: 3.212 verificações. Registrou os 36 + 36 + 24 quadros naturalmente, sem forçar conclusão, e validou os portais, a sala, os alunos e o retorno voluntário ao menu.
- Áudio: 55 verificações; release: 6; escala da interface: 83. Total dessas cinco suítes: 3.598 verificações sem falhas.
- HTML5: todos os 96 quadros registrados em ordem; 14 estados, pausa de três segundos, opção de pular, áudio e três tamanhos de tela aprovados; sem erros do navegador ou arquivos ausentes.
- Exportações `FinalRelease`: Windows abriu com sucesso; Web passou em 14 verificações de carregamento, áudio, interface, tela cheia e redimensionamento, sem erros ou arquivos ausentes.
- Inspeção visual: pranchas dos 96 recortes e captura nativa da citação conferidas. Revisão independente sem problemas apontados.

Os testes estão em `tests/verify_neon_cutscene_assets.py`, `tests/evento/Credits_Step.gml` e `tests/evento/Epilogue_Step.gml`. Os verificadores anteriores de guardião e máscara delegam para o teste dos recursos atuais. A validação HTML5 e os pacotes atualizados são registrados em `output/revision-20261009`.

Limite dos arquivos fornecidos: os enquadramentos e dimensões das células variam; o corte de 0,12 segundo antes da retirada da máscara e as faixas do enquadramento preservam a arte sem distorção. Não foram criados novos quadros, cenário ou rosto.

## Pacotes atualizados

As versões Windows e Web ficam em `C:/Users/jrhre/OneDrive/Desktop/Paradoxo de Wilson - Final`, com seus ZIPs e instruções. A cópia anterior foi preservada em `E:/CodexBuildArchive/ParadoxoDeWilson/delivery-backups`. A exportação nova foi feita em uma pasta vazia; a entrega Web também recebe uma pasta nova para não conservar texturas de versões anteriores. Os helpers de exportação e empacotamento permitem selecionar pastas de trabalho e backup em outro disco, mantendo os padrões existentes.
