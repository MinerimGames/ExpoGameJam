# Relatório da união da fase do castelo

## Resultado

O projeto atual recebeu as salas e os assets de `ExpoGameJam-main new.zip` sem substituir as melhorias já presentes. Depois da vitória contra Isleide das Cavernas, o jogador encontra um único portal para o Bosque e segue os caminhos naturais: saída superior do Bosque, saída esquerda da Vila e ponte até a porta do Castelo. Um guarda intercepta o jogador antes da porta. Sua derrota libera o salão iluminado e a sala do trono, onde acontece o encontro com Isleide Rei. A vitória contra o rei agora leva à fase de outono: portão, ruas internas e praça final. A cena pós-vitória removida das Cavernas não foi reintroduzida. As integrações posteriores estão detalhadas em [RELATORIO_INTERIOR_CASTELO.md](RELATORIO_INTERIOR_CASTELO.md) e [RELATORIO_FASE_OUTONO.md](RELATORIO_FASE_OUTONO.md).

O ZIP original foi preservado em `C:/Users/jrhre/Downloads/ExpoGameJam-main new.zip`. A extração, comparação e cópia de segurança desta união estão em `C:/Users/jrhre/AppData/Local/CodexMerges/ParadoxoDeWilson/castelo-20261006-043329`.

## Conteúdo importado

Foram adicionados 54 arquivos novos, correspondentes a 23 recursos:

- Salas: `rm_vila` (640×640), `rm_castelo` (800×720) e `rm_bosque` (640×380).
- Sprites e backgrounds: `spr_medieval_background`, `spr_castelo_backgorund`, `spr_tiles_agua`, `spr_tiles_arvores`, `spr_tiles_arvore_editado`, `spr_tiles_casas`, `spr_tiles_chao`, `spr_tiles_desnivel`, `spr_tiles_estrada`, `spr_tiles_pedras` e `spr_tiles_props`.
- Tilesets: `tl_agua`, `tl_arvores`, `tl_casas`, `tl_chao`, `tl_desnivel`, `tl_estrada`, `tl_pedras`, `tl_props` e `tl_tree_emerald2`.

Os registros das 23 resources e das duas pastas de organização foram unidos ao `ParadoxoDeWilson.yyp`. A ordem original de rooms foi preservada; as três novas foram acrescentadas ao final.

As três salas carregam o `obj_player` real e seus colisores autorais:

| Sala | Colisores | Spawn |
| --- | ---: | --- |
| Vila | 109 | (576, 608) |
| Castelo | 60 | (416, 704) |
| Bosque | 31 | (608, 214) |

Nenhuma dessas salas tinha portal, NPC ou ligação de gameplay no ZIP. A ligação foi adicionada no projeto atual com saídas de borda nas três salas, mantendo os mapas e colisores importados.

## Conteúdo preservado

Todos os arquivos de produção existentes foram mantidos byte a byte na união; a única exceção daquela etapa foi o `ParadoxoDeWilson.yyp`, que recebeu os registros novos. A etapa posterior da rota alterou somente a saída da batalha de Isleide, a saída de borda compartilhada e as três salas novas para remover os portais estáticos e posicionar as entradas. Isso preserva os controles WASD/setas, o combate estratégico, a matemática, a ambientação de água/folhas/fogo/poeira/brasas, os mapas antigos, a câmera e o encerramento atual.

Os quatro PNGs compartilhados de tilesets que divergiam no ZIP tinham os mesmos pixels e apenas metadados de data diferentes; a cópia local foi mantida. O backup completo anterior à união tem 213 arquivos e manifesto SHA-256.

## Verificações

- `tools/validate_merge_castelo.py`: passou na etapa de união com 75 resources, 54 arquivos novos íntegros e todos os arquivos/settings anteriores preservados.
- `tools/validate_evento.py`: passou na etapa de união com referências, eventos, rooms antigas, colisores, sprites, tiles, máquina de input e matemática preservados. Após a rota, a única diferença adicional apontada é a alteração intencional de `objects/obj_portal/Create_0.gml`.
- Fixture `Castle`: 38 verificações, 0 falhas. Carregou as três salas, confirmou player único, contagem de colisores, câmera 384×219 dentro dos limites do mapa, entrada no caminho natural, controles WASD/setas e retorno ao menu.
- Input: 18 verificações, 0 falhas.
- Battle: 8.187 verificações, 0 falhas.
- Ambient: 27 verificações, 0 falhas.
- Integration: 34 verificações, 0 falhas; inclui o botão de pular o tutorial do Newton e o combate com o guarda antes do encerramento.
- Route: 26 verificações, 0 falhas; confirmou o único portal pós-vitória, a caminhada real pelo Bosque e pela Vila até a ponte do Castelo, o bloqueio ao tentar andar na água, a interceptação pelo guarda e a passagem pela porta após vencer. O jogador usa os controles e colisões reais; não é teleportado entre os pontos do caminho.
- Guard: 197 verificações, 0 falhas; tentativa de passar pela porta antes da vitória, diálogo completo pelo teclado, contas de dois dígitos, derrota, retry, cinco vitórias com ataque/defesa/cura e liberação da porta sem portal. Uma nova visita ao Castelo reinicia o encontro.
- Suíte completa `tools/run_evento_tests.ps1 -Suite All`: 8.527 verificações, 0 falhas.
- Compilação real: GameMaker LTS runtime 2026.0.0.23, Windows VM, Default; `Igor complete.` e código zero. Saída: `C:/Users/jrhre/AppData/Local/CodexBuilds/ParadoxoDeWilson/evento-20261006-112339`. Capturas das seis falas, batalha, desafio e vitória foram preservadas nessa pasta e conferidas visualmente.

A fixture de Integration precisou de uma correção de temporização nos testes: E agora alterna liberação e pressão até o NPC real processar a entrada. Nenhum arquivo de produção foi alterado por essa correção.

## Rota adicionada depois da união

O único portal da nova ligação é criado após a vitória em `rm_cavernas_2` e aponta para `rm_bosque`. No Bosque, a entrada fica na trilha leste e a passagem para a Vila está no topo da trilha. Na Vila, o jogador entra pelo caminho inferior e sai pelo caminho à esquerda. No Castelo, a entrada fica ao sul da ponte; após vencer o guarda, atravessar a porta conduz ao salão iluminado. Seu tapete central leva à sala do trono. Vencer Isleide Rei conduz a `rm_autumn_gate`; atravessar o portão leva às ruas e subir as escadas ao norte leva à praça final. As transições entre salas acontecem ao caminhar, sem novos portais. `rm_demo_end` permanece no projeto com sua interface de encerramento preservada.

A correção do enquadramento e das colisões removeu os pontos de entrada na lateral esquerda e as saídas genéricas pela direita que desviavam o jogador do terreno navegável. Todos os 200 colisores autorais das três salas e todas as camadas visuais foram preservados. Os pontos de entrada e as posições iniciais da câmera foram alinhados aos caminhos, com viewport 1280×720 como nas cavernas. Backup anterior à correção: `C:/Users/jrhre/AppData/Local/CodexBackups/ParadoxoDeWilson/map-path-20261006-104819`.

## Guarda na entrada do Castelo

`Medieval0.png` foi importado integralmente como `spr_castle_guard`, preservando transparência e pixels. `obj_castle_guard` fica em (416, 548), diante da porta. A aproximação inicia seis falas alternando retrato e identificação do guarda e de Isleide Wilson. O jogador explica que veio de uma realidade alternativa e precisa conversar com o rei para resolver as incursões; o guarda considera a história suspeita, nega passagem e inicia a batalha. E ou Espaço avança as falas.

A batalha anterior das Cavernas continua com somas de um dígito e fase matemática fixa em 1. O guarda usa o próximo grupo de desafios do sistema existente: fases 4 a 6, somando números de 10–48 e 10–28, com resultados de 20 a 76. Mantém 150 HP e os mesmos danos e ações estratégicas da luta anterior. Recomeçar após derrota restaura a fase 4, sem avançar para subtração ou multiplicação.

A porta verifica a presença do guarda e permanece bloqueada até confirmar a vitória. A vitória remove o guarda e devolve o controle para caminhar até a porta, sem criar portal. Os mapas, colisores, câmera, recursos anteriores e ordem de salas foram comparados com o backup; as únicas adições de recursos são o sprite e o objeto do guarda. Revisão independente da alteração: sem problemas encontrados. Backup anterior ao encontro: `C:/Users/jrhre/AppData/Local/CodexBackups/ParadoxoDeWilson/castle-guard-20261006-111915`.
