# Guardião do trono: duas sequências no encerramento

Registro histórico. O encerramento e a entrega atuais estão documentados em [Cutscene final de 96 quadros](CUTSCENE_FINAL_96_QUADROS_2026-10-09.md).

Esta revisão substitui a quinta imagem pela arte fornecida `Gemini_Generated_Image_8utihd8utihd8uti.jpg` e insere a aproximação antes da retirada da máscara. O mesmo controlador `obj_fatec_ending` executa tudo; FIM, corrupção, citação e imagens 01–04 permanecem intactos.

## Ritmo e configuração

| Etapa nova após a imagem 05 | Duração |
|---|---:|
| Pausa no novo trono vazio | 3 s |
| Personagem sentado, quadro 1 | 1 s |
| Levanta e aproxima: quadros 1–36 | 3 s a 12 FPS |
| Quadro 36 imóvel | 0,45 s |
| Corte preto e silencioso | 0,3 s |
| Retirada da máscara: quadros 1–24 | 2 s a 12 FPS |
| Rosto revelado, quadro 24 imóvel | 3 s |
| Fade-out | 1,5 s |
| Preto final antes dos créditos existentes | 0,35 s |

São 14,6 segundos novos após a imagem 05 e 46,6 segundos desde FIM até os créditos. A chegada do professor antecede esse intervalo.

Em `scripts/secret_throne/secret_throne.gml`, `approach_fps` e `reveal_fps` controlam independentemente as velocidades. O padrão é 12 para ambos; 24 reduz as animações para 1,5 e 1 segundo. `segredo_trono_tempos()` calcula as durações na inicialização. As demais pausas são editáveis na lista `scenes`.

## Recursos e apresentação

A nova imagem original mede 2390 × 1792. Seu JPEG original é preservado em `datafiles/secret_throne/05_Trono_Refatorado.jpg`; o PNG do recurso nativo é uma decodificação sem perda adicional. O desenho mantém a proporção e cabe na tela sem esticar o trono.

A folha de aproximação mede 1254 × 1254, com 6 colunas e 6 linhas de tamanhos irregulares. As divisórias verticais também mudam de posição entre linhas; os recortes foram inspecionados e definidos individualmente por linha. Cada painel já inclui o cenário: a reprodução não acrescenta outro trono nem zoom. Os painéis são importados sem reamostragem, em ordem de leitura, dentro de quadros nativos de 256 × 256. As divisórias são excluídas pelo recorte; o pequeno canto impresso com a numeração é excluído da apresentação, sem redesenhar o personagem. A folha original permanece intacta em `datafiles/secret_throne/07_Guardiao_Aproximacao.png`.

O sprite da máscara já existente permanece intacto, incluindo barba, cicatriz, olho branco e máscara na mão. Ambas as sequências usam nearest-neighbor, relógio real e quadros inteiros. Não há loop, diálogo adicional, interface de combate ou menu entre elas. O quadro final da aproximação e o corte preto tornam intencional a diferença de enquadramento entre as duas folhas.

## Áudio

Os efeitos reutilizam `snd_defense`, `snd_step_stone` e `snd_transformation`. O metal toca uma vez ao levantar; os passos seguem seis contatos da caminhada. A tensão cresce discretamente na aproximação. O corte preto interrompe música, ambiente e efeitos; a retirada tem um efeito metálico e uma nota grave quando o rosto aparece. A pausa final fica silenciosa.

`step_frames`, `step_sound`, `step_gain`, `metal_sound`, `metal_gain`, `face_sound` e `face_gain` permitem ajustar as referências de áudio. Quedas de FPS consomem contatos atrasados sem disparar uma rajada de passos. As duas texturas são carregadas antecipadamente durante a pausa estática.

## Arquivos alterados

- `scripts/secret_throne/secret_throne.gml`: novos estados, velocidades, desenho e áudio.
- `objects/obj_fatec_ending/Create_0.gml`: estado da aproximação e marcas de áudio.
- `sprites/spr_secret_throne_05/`: nova quinta imagem.
- `sprites/spr_secret_guardian_approach/` e `ParadoxoDeWilson.yyp`: 36 quadros nativos registrados.
- `datafiles/secret_throne/`: originais fornecidos e PNG da quinta imagem.
- `tools/import_guardian_throne.py`: importação reproduzível.
- `tests/evento/Credits_Step.gml`, `Epilogue_Step.gml`, `tests/verify_guardian_throne_assets.py` e ferramentas de teste web: verificação da continuidade, quadros, recortes e encerramento.
- `tools/package_final_release.py`: instruções da entrega atualizadas.
- `tools/export_web.ps1` e `tools/verify_web_export_syntax.py`: verificação do JavaScript exportado e reparo restrito de um stub vazio, sem referências, gerado com sintaxe inválida pelo processamento HTML5 do GameMaker. Uma exportação válida permanece idêntica.

## Validação

Os testes nativos desta revisão passaram: Epilogue (2.920), Credits (230), Audio (55), Release (6) e UIScaling (83), totalizando 3.294 checagens e zero falhas. O encerramento executado pelo relógio real registrou todos os índices 0–35 da aproximação e 0–23 da máscara. A verificação determinística também confirmou a ordem, a alteração independente de FPS, os contatos sonoros, o corte silencioso e a pausa final de três segundos.

Os dois testes de integridade de recursos passaram: quinta imagem equivalente à decodificação do JPEG, originais preservados, 36 recortes em ordem sem reamostragem e 24 poses da máscara com os pixels do personagem intactos. A revisão visual dos 36 painéis e a revisão independente confirmaram que números e divisórias foram excluídos sem cortar o capuz.

A execução Web isolada passou pelos 18 estados, finalizou naturalmente, verificou o comando de pular e a pausa silenciosa, e apresentou a revelação nas resoluções 1280 × 800, 700 × 420 e 900 × 1200. O registro do navegador observou os 36 índices da aproximação e 20 índices da máscara durante as capturas; o avanço pelo relógio admite saltar um quadro de apresentação durante atrasos, sem reordenar ou reiniciar a sequência. O teste nativo e o teste determinístico cobriram todos os 24 índices.

A exportação Web final passou por 14 verificações de carregamento, áudio, tela cheia, controles e densidade de tela, sem erros de execução, requisições ou HTTP. O executável entregue abriu e entrou no ciclo principal sem erros. A conferência dos pacotes passou: hashes das cópias e arquivos, conteúdo e integridade dos dois ZIPs, 1.075 arquivos de recursos de origem e 105 arquivos de entrega.

Os relatórios estão em `output/revision-20261009/native-tests.json`, `web-secret-throne/report.json`, `web-smoke/report.json`, `native-start-guardian/report.json` e `package-verification.json`. Os logs nativos usados nesta entrega ficam em `C:/Users/jrhre/AppData/Local/Temp/paradoxo-evento-tests/Guardian-20261009/`.

## Entrega

A pasta `C:/Users/jrhre/OneDrive/Desktop/Paradoxo de Wilson - Final` contém `Windows/ParadoxoDeWilson.exe`, os arquivos necessários ao executável, `Web/`, o lançador local Web e os ZIPs Windows e Web atualizados. A cópia anterior da entrega foi preservada em `C:/Users/jrhre/AppData/Local/CodexBackups/ParadoxoDeWilson/release-before-final-20261009-163025`.

Durante a montagem, faltou espaço na unidade C:. Cópias temporárias de compilação foram transferidas para `E:/CodexBuildArchive/ParadoxoDeWilson/`, preservando o projeto e os backups. Isso não altera os recursos ou o comportamento do jogo. A nova exportação confirmou separadamente o problema de sintaxe do stub HTML5; ele foi corrigido antes da montagem final e sua sintaxe e execução foram verificadas.
