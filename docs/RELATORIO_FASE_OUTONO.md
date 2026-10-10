# Fase de outono após Isleide Rei

A vitória confirmada contra Isleide Rei inicia a fase de outono na ponte diante do portão. Atravessar o portão muda para as ruas internas; contornar o jardim da estátua e subir as escadas ao norte muda para a praça final. As duas transições acontecem ao caminhar. Não foram adicionados portais nem um novo chefe: o círculo central da praça está livre para o próximo encontro.

O rei permanece 20% menor, tanto na sala do trono quanto no combate. Sua animação, conversa, dificuldade e retratos foram preservados.

## Imagens e câmera

Os PNGs enviados foram copiados byte a byte para os sprites, incluindo suas imagens de camada:

- `Praça Cívica de Outono em Pixel Art.png` → `spr_autumn_city`, 1448×1086.
- `Praça Cívica Outonal em Pixel Art.png` → `spr_autumn_plaza`, 1672×941.

As duas primeiras salas apresentam regiões da mesma imagem da cidade, com escala uniforme de 800/1448. O trecho do portão usa deslocamento vertical de −336; as ruas usam a região superior. A praça usa escala uniforme de 960/1672. As imagens mantêm suas proporções.

Todas as câmeras têm área de visão 384×219, viewport 1280×720 e seguem o jogador, com a mesma aproximação das cavernas.

| Sala | Dimensões | Entrada | Colisores |
| --- | --- | --- | ---: |
| `rm_autumn_gate` | 800×264 | (416, 248) | 14 |
| `rm_autumn_streets` | 800×444 | (416, 388) | 21 |
| `rm_autumn_plaza` | 960×540 | (480, 516) | 17 |

Os colisores protegem água, parapeitos, construções, canteiros e bancos. O trajeto da ponte passa pelo portão; nas ruas, o jardim da estátua exige um pequeno desvio antes das escadas. O centro da praça em (480, 260) permanece navegável.

## Verificação

A suíte nova detectou inicialmente a ausência dos recursos. Um teste de pixels também reproduziu o fundo branco que encobria a imagem: o objeto de cenário e a camada branca estavam na mesma profundidade. A correção coloca o cenário na profundidade 199, acima da camada 200. As quatro capturas da entrada e do centro foram conferidas visualmente após a correção.

A suíte completa passou com nove grupos, 8.935 verificações e zero falhas:

| Grupo | Verificações |
| --- | ---: |
| Input | 18 |
| Battle | 8.187 |
| Ambient | 27 |
| Integration | 111 |
| Castle | 38 |
| Route | 48 |
| Guard | 197 |
| Royal | 283 |
| Autumn | 26 |

Route percorreu o caminho inteiro com movimento e colisões reais, desde as cavernas até o centro da praça. Autumn verificou a saída da vitória do rei, entradas livres, câmera, fundos visíveis, bloqueio da água e da estátua, duas transições e praça navegável. Integration preservou o teste do encerramento existente separadamente da nova rota e verificou o reinício.

O teste do botão de pular tutorial precisou aguardar o Newton processar a tecla P, com limite de 120 quadros e a mesma condição de aprovação. Nenhum comportamento do Newton foi alterado. Para reduzir duplicação de arquivos, a execução completa reutiliza sequencialmente um projeto e um cache, mantendo logs separados por grupo.

Logs completos: `C:/Users/jrhre/AppData/Local/Temp/paradoxo-evento-tests/All-38a7b5b5c0c94b3990021e92b1120e59`.

Os registros e a ordem anteriores do projeto foram preservados; foram acrescentados seis recursos e três salas à ordem. Todos os recursos resolvem, e os hashes dos fundos importados correspondem aos arquivos originais.

Revisão independente somente leitura: nenhum bug relevante ou regressão encontrado; rota, escalas do rei, câmera, referências, preservação do projeto e os nove logs foram conferidos.

Compilação Windows VM, GameMaker LTS runtime 2026.0.0.23: código zero e `Igor complete.`. Binário, log e capturas: `C:/Users/jrhre/AppData/Local/CodexBuilds/ParadoxoDeWilson/evento-20261006-135421`.

Backup dos arquivos alterados antes da nova rota: `C:/Users/jrhre/AppData/Local/CodexBackups/ParadoxoDeWilson/autumn-route-20261006-134403`.
