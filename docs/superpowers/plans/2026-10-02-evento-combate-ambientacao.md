# Paradoxo de Wilson — controles, combate e ambientação Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Entregar a demo existente com WASD e setas, combate estratégico compreensível e efeitos ambientais leves, mantendo o fluxo e a matemática.

**Architecture:** Adaptar o input e as funções atuais de batalha, com configuração centralizada e intenção determinística. Adicionar apenas um objeto ambiental não persistente, configurado pela sala, com pontos de emissão guardados na entrada e partículas limitadas em arrays. Os testes usam as funções e eventos reais em uma cópia temporária do projeto.

**Tech Stack:** GML, GameMaker LTS runtime 2026.0.0.23, PowerShell e Python 3.11 para executar verificações; sem novas dependências de produto.

**Spec:** `docs/superpowers/specs/2026-10-02-evento-combate-ambientacao-design.md` — aprovada pelo usuário.

## Global Constraints

- Preservar o jogo, sua identidade visual, composição dos mapas, colisões, matemática e progressão.
- Não adicionar assets externos, dependências de produto, novos mapas ou uma arquitetura de batalha substituta.
- A pasta não é um repositório Git; usar cópia de segurança dos arquivos modificados antes de implementar, sem inicializar Git ou fazer commits nesta tarefa.
- Limite total: 40 partículas ambientais simultâneas por sala, incluindo folhas, poeira, brilhos de água e brasas.
- Usar Draw no mundo, nunca Draw GUI.
- Nenhum efeito escreve em tiles, colisores ou posições de personagens.
- Meta: 60 FPS, a ser medida no jogo, não presumida por inspeção.
- Distinguir compilação, testes automatizados, inspeção visual e testes jogáveis: não declarar uma etapa testada se somente outra foi executada.

## Review Focus

- Teclas de fontes diferentes e direções opostas: o resultado continua booleano e mantém a normalização; testar na tarefa 1.
- Cura com HP cheio, cura parcial e erro na conta: somente uma cura executada inicia espera; testar na tarefa 2.
- Erro no turno forte, vitória no golpe final e reinício depois do treino: não mudar intenção durante a conta, não retaliar após vitória e não carregar estado antigo; testar na tarefa 2.
- Pontes, margens e pedras dentro das camadas de água: emissão somente em pontos realmente aquáticos, sem alterar dados de tiles; testar na tarefa 4.
- Reentrada nas salas, diálogo e GUI 640×380: nenhum controlador duplicado, partículas sobre a interface ou área clicável desalinhada; testar nas tarefas 3, 4 e 5.

---

## Mapa de arquivos

| Responsabilidade | Arquivos |
| --- | --- |
| Input e instruções do menu | `objects/obj_player/Step_0.gml`, `objects/obj_main_menu/Draw_64.gml` |
| Configuração, intenção e origem | `scripts/battle_system/battle_system.gml` |
| Ações, matemática, espera e reinício | `objects/obj_battle_controller/Create_0.gml` |
| Intenção e feedback visual | `objects/obj_battle_controller/Draw_64.gml`; `Step_0.gml` somente se necessário para compatibilidade do feedback |
| HP do chefe e explicações do treino | `objects/obj_cavern_isleide/Create_0.gml`, `objects/obj_newton_npc/Create_0.gml` |
| Efeitos ambientais | `objects/obj_ambient_controller/obj_ambient_controller.yy`, `Create_0.gml`, `Step_0.gml`, `Draw_0.gml` |
| Registro e instâncias | `ParadoxoDeWilson.yyp`, as `.yy` de `rm_tutorial`, `rm_cavernas` e `rm_cavernas_2` |
| Verificação dos recursos | `tools/validate_evento.py` |
| Testes GML executáveis | `tools/run_evento_tests.ps1`, `tests/evento/Input_Create.gml`, `Battle_Create.gml`, `Ambient_Create.gml`, `Integration_Create.gml` |
| Evidência e relatório | `docs/RELATORIO_EVENTO.md` |

## Tarefa 1: Controles compatíveis e preservação da base

**Files:** criar o executor e `tests/evento/Input_Create.gml`; modificar somente o Step normal do jogador e a tabela de controles no menu.

**Interfaces:**
- Consome: `obj_player` com `movimento_liberado`, `velh`, `velv`, `vel`, `facing_sign`, `estado_idle` e `estado_walk` já existentes.
- Produz: as mesmas quatro variáveis booleanas `up`, `down`, `left`, `right`, agora combinando os dois esquemas; nenhuma interface nova no jogador.
- Executor: `tools/run_evento_tests.ps1 -Suite Input|Battle|Ambient|Integration|All`, usando a pasta atual como projeto, copiando recursos para `%TEMP%`, registrando somente na cópia o objeto/sala de teste e compilando com o runtime local e `--prefabs=C:/ProgramData/GameMakerStudio2-LTS2026/Prefabs`. Lançar somente o Runner da cópia, com limite de 60 segundos por suíte; encerrar apenas o processo iniciado pelo executor se exceder esse limite.
- Testes em GML devem chamar os eventos ou métodos reais e imprimir marcadores `EVENTO_TEST_PASS`/`EVENTO_TEST_FAIL`; o executor retorna código diferente de zero em falha de teste, compilação, erro de execução ou timeout. Não implementar uma segunda cópia das regras de movimento/combate em Python.

- [x] **1. Guardar a base.** Criar uma cópia datada dos arquivos originais em `%LOCALAPPDATA%/CodexBackups/ParadoxoDeWilson/`, com hashes e estrutura relativa, antes da primeira modificação em código. Registrar o caminho no relatório. Excluir documentos de planejamento e testes dessa lista de recursos originais.
- [x] **2. Criar o teste de input real.** Usar pressão/liberação de teclas e os eventos Step e End Step de uma instância real de `obj_player`. Verificar cada direção WASD/setas, W+direita, W+cima, W+baixo, A+direita e movimento bloqueado. Após dois Steps com W+direita, verificar:

```gml
check(abs(point_distance(0, 0, p.velh, p.velv) - p.vel) < 0.001, "diagonal normalizada");
check(p.velh > 0 && p.velv < 0, "input misto");
```

Também usar `obj_colisor` real e End Step para verificar que o jogador não atravessa uma barreira com nenhum dos esquemas. Ao bloquear movimento, as velocidades devem zerar e a posição permanecer estável.
- [x] **3. Executar na base.** `powershell -NoProfile -File tools/run_evento_tests.ps1 -Suite Input`. Esperado: falha nas setas, confirmando o teste antes da alteração.
- [x] **4. Adaptar as quatro leituras.** Aplicar OR entre `keyboard_check(ord(...))` e a seta correspondente, dentro do bloco atual de `movimento_liberado`. Preservar Create, Draw, End Step e `state_machine` byte a byte. Atualizar a tabela do menu para indicar que WASD e setas movimentam.
- [x] **5. Reexecutar Input.** Esperado: todas as verificações passam; sem mudanças em velocidade, máscara ou sistema de estados.

## Tarefa 2: Combate estratégico, tutorial e reinício

**Files:** `scripts/battle_system/battle_system.gml`, `objects/obj_battle_controller/Create_0.gml`, `objects/obj_cavern_isleide/Create_0.gml`; criar `tests/evento/Battle_Create.gml`.

**Interfaces:**
- `batalha_configuracao() -> struct`: campos `player_hp_max=100`, `enemy_hp_default=100`, `boss_hp=150`, `attack_min=16`, `attack_max=20`, `normal_min=10`, `normal_max=12`, `strong_min=34`, `strong_max=36`, `defense_normal=0.50`, `defense_strong=0.75`, `dodge_normal=0.60`, `dodge_strong=0.75`, `heal_amount=28`, `heal_cooldown_turns=2`, `vulnerable_multiplier=1.5`, `tutorial_normal_min=4`, `tutorial_normal_max=6`, `tutorial_strong_min=12`, `tutorial_strong_max=14`.
- `batalha_intencao(_turno: integer, _tutorial_step: integer = -1) -> string`: retorna `normal`, `strong` ou `vulnerable`. Fora do treino, índices 0,1,2,3 repetem normal, normal, strong, vulnerable. Durante o treino, somente etapa 2 é strong; etapas 0,1,3 são normal.
- `batalha_ambiente(_room: room asset) -> string`: grasslands, cavern, cavern_camp ou neutral, conforme a especificação.
- Controlador: `battle_config` (struct), `battle_turn=0`, `enemy_intent` (string), `heal_cooldown=0`, `battle_origin_room` (room asset), `battle_environment` (string). Métodos `update_enemy_intent()` e `advance_turn(_heal_used: bool = false)` calculam aviso e contagem, sem desenhar GUI.
- Preservar as assinaturas atuais de `request_action`, `verify_answer`, `enemy_attack`, `execute_attack`, `execute_heal`, `execute_defense`, `execute_dodge`, `restart_battle` e `leave_after_victory`.

- [x] **1. Escrever os testes.** Instanciar o controlador real. Verificar ciclo, conta vazia, acerto, erro, HP máximo, bloqueios de cura, duas outras ações até liberar cura, defesa normal/forte e esquiva. Para cura cheia:

```gml
b.player_hp = b.player_hp_max;
b.request_action("heal");
check(b.battle_screen == "actions" && b.pending_action == "", "cura cheia não inicia desafio");
check(b.battle_turn == 0 && b.heal_cooldown == 0, "cura cheia não gasta turno");
```

Após curar com HP=50 e uma conta correta, esperar cura limitada a 28 e retaliação anunciada, cooldown=2; consumir outra ação correta e uma errada e esperar cooldown 1 e 0. Em um turno forte, uma conta errada recebe 34–36 de dano, preserva a etapa guiada se estiver em tutorial e não ganha defesa. Em turno vulnerável, erro não causa dano nem muda HP do inimigo.

Verificar que matar o inimigo não causa retaliação. Testar HP=99 curando (recuperação efetiva de 1), valores nunca acima do máximo, defesa normal de 5–6 e forte de 8–9 após arredondamento. Em 10.000 esquivas por intenção, a proporção observada deve ficar a até 4 pontos percentuais de 60%/75%; falha nunca duplica dano.

Verificar as quatro etapas guiadas, bloqueio da ação incorreta, demonstração garantida de esquiva na quarta etapa, conclusão sem restaurar HP, reinício da batalha já liberada restaurando o treino e limpando `guided_tutorial_completed`. Gerar desafios reais de todas as 16 fases e validar suas respostas; preservar o corpo de `batalha_gerar_desafio` com hash da base.
- [x] **2. Executar Battle antes da implementação.** Esperado: falha pela ausência do novo comportamento; guardar a evidência de falha.
- [x] **3. Adicionar as três funções.** Definir configuração, intenção e ambiente em `battle_system` sem alterar geração matemática. Fazer `batalha_iniciar` registrar a origem, carregar os dados atuais do inimigo e atualizar a intenção depois de configurar tutorial. Usar `boss_hp` no Create do chefe e manter `battle_math_phase_max=1`.
- [x] **4. Adaptar o controlador.** Usar a configuração nas funções existentes, eliminar críticos aleatórios, aplicar vulnerabilidade, defesa e chances de esquiva. Consumir turno somente após resposta não vazia; erro também consome. Não consumir turno em escolha bloqueada. Cura executada define cooldown=2; demais turnos consumidos o reduzem até zero.
- [x] **5. Preservar o tutorial e o encerramento.** Atualizar a intenção antes da escolha, manter etapa em erro e avançá-la em acerto. Na conclusão guiada, zerar apenas o índice do ciclo livre. Reinício limpa cooldown, turno, flags de conclusão e entrada matemática. Preservar callbacks de Newton, portal e transição do chefe.
- [x] **6. Reexecutar Battle e simular estratégias reais.** Usar `random_set_seed(20261002)` para repetir evidências. Em 2.000 combates contra 150 HP com contas corretas, comparar ataque repetido com defesa no forte, ataque na vulnerabilidade e cura disponível quando HP≤60 em turno normal. Esperado: estratégia segura vence todas; ataque repetido vence menos de 10%. Simular esquiva como alternativa e registrar sucesso, duração e risco, sem exigir que ela vença todas as tentativas.

## Tarefa 3: Avisos, feedback e contexto visual da batalha

**Files:** `objects/obj_battle_controller/Draw_64.gml`, `objects/obj_newton_npc/Create_0.gml`; `Step_0.gml` apenas se o teste demonstrar que o feedback precisa bloquear um novo popup enquanto a mensagem anterior é visível.

**Interfaces:** consome os campos da tarefa 2 e as funções atuais `rx`, `ry`, `draw_ui_box`, `draw_ui_text`, `draw_ui_button` e `update_ui_transform`. Não mudar os retângulos de clique dos quatro botões nem do OK e dos botões finais.

- [x] **1. Registrar os critérios de inspeção.** Comparar a interface atual com a nova em GUI 960×540 e 640×380. Em 640×380, esperar `ui_scale=2/3`, offset X=0 e offset Y=10. Confirmar que converter coordenadas com essa escala preserva as áreas clicáveis.
- [x] **2. Desenhar o aviso.** Usar um painel no espaço de referência `(285,96,260,64)`, abaixo do painel guiado e à esquerda do sprite inimigo. Desenhar título curto, indicação do ambiente e recomendação curta. Para strong, mostrar `ATAQUE FORTE!` e `DEFENDA OU ESQUIVE`, com triângulo de atenção desenhado geometricamente. Para vulnerable, mostrar `INIMIGO VULNERÁVEL!` e `APROVEITE PARA ATACAR`. O popup matemático deve encobrir esse painel normalmente.
- [x] **3. Mostrar disponibilidade e resultado.** No botão existente de cura, desenhar segunda linha PRONTA, 1 TURNO ou 2 TURNOS. Mensagens devem indicar ganho/perda real de HP, defesa, esquiva e acerto/erro, sem texto fora do painel de log. Manter transformações, paleta e sprites. A tonalidade do fundo depende do ambiente e mantém a sala real visível.
- [x] **4. Atualizar as explicações de Newton.** Manter os arrays e número de páginas. Ajustar somente as frases das ações e incluir observar o aviso inimigo antes de escolher.
- [ ] **5. Testar visualmente e por input.** Executar o jogo, acionar os quatro botões por teclado e mouse, abrir/resolver contas e verificar mensagens de cura cheia, espera, defesa e esquiva. Conferir janela e tela cheia. Reexecutar Input e Battle se houve alteração de lógica.

## Tarefa 4: Água, folhas, poeira e fogueira

**Files:** criar os quatro arquivos de `obj_ambient_controller`, `tests/evento/Ambient_Create.gml` e `tools/validate_evento.py`; modificar `.yyp` e as três salas de jogo.

**Interfaces:**
- Consome: sala atual, layers existentes, tiles de 16×16 e `batalha_ambiente(room)` da tarefa 2.
- Produz: uma instância não persistente por sala; `ambient_environment` (string), `water_points`, `leaf_points`, `fire_points` (arrays de structs `{x,y}`), `particles` (array limitado a 40 structs com tipo, posição, velocidade, fase e tempo de vida), `particle_limit=40`. Flags booleanas `water_enabled`, `leaves_enabled`, `dust_enabled`, `fire_enabled` e `embers_enabled` seguem a tabela da especificação; desligá-las impede nova emissão para testar expiração.
- Métodos locais `ambient_spawn(_kind: string, _x: real, _y: real) -> bool` e `ambient_update(_dt: real) -> void`: spawn retorna false se lotado; `_dt` é tempo em segundos, calculado no Step a partir de `delta_time`; update remove expirados e mantém coordenadas dentro dos limites, sem instanciar objetos de partículas.
- Validador: `python tools/validate_evento.py --baseline <pasta-da-copia>`; verificar referências reais, eventos, registros e instâncias, e comparar os tiles/colisores/resources protegidos semanticamente com a base. Não tratar paths virtuais de folders/texturegroups como arquivos ausentes.

- [x] **1. Criar os testes.** Validador deve falhar antes de existir o registro ambiental. Em teste GML, percorrer as salas reais e verificar exatamente uma instância, ausência nas salas finais/menu, limite de 40, expiração após tempo de vida e nova instância limpa ao trocar de sala. Testar layer ausente em uma sala de teste: nenhuma emissão correspondente e nenhum erro.
- [x] **2. Identificar emissores nos tiles atuais.** Fazer uma única varredura no Create. Tutorial usa a árvore realmente presente em `props_sob`; cavernas usam `Tiles_Arvores`. Para água, usar `Tiles_Agua` e `Tiles_Lagoa`, com seleção de índices e pontos interiores validada nas imagens originais. Para fogo, reconhecer os tiles da fogueira presente em `Tiles_Acampamento`. Registrar os índices selecionados com comentário curto para impedir emissão sobre pedra, margem ou ponte. Não editar tilesets ou imagens.
- [x] **3. Implementar Create e Step.** Inicializar todos os arrays, flags, temporizadores e limites no Create. Atualizar apenas partículas ativas; não percorrer o mapa no Step ou Draw. Gerar poucas folhas, poeira, reflexos e brasas em intervalos escalados pelo tempo de jogo. A ausência de uma origem não causa emissão substituta no chão.
- [x] **4. Implementar Draw.** Usar pixels/traços curtos, cor e alpha discretos; folhas oscilantes, poeira suspensa, reflexos/ondinhas e fogo com glow local pulsante e detalhe pequeno de chama. No tutorial, depth=50 permite que `props_sob` encubra partículas. Nas cavernas, depth=150 desenha sobre tiles e abaixo de personagens e GUI. Salvar/restaurar cor, alpha e blend. Nenhum Draw GUI, shader ou surface.
- [x] **5. Registrar recursos e instâncias.** Usar o schema dos objetos e salas atuais. Inserir somente a nova entrada no `.yyp` e uma instância ambiental por sala, com criação depois das existentes e depth próprio. Preservar os arrays de tiles, instâncias/posições dos colisores e câmeras.
- [x] **6. Executar Ambient e validador.** Esperado: todas as referências válidas; input/state machine/colisores/matemática protegidos; nenhuma mudança de tiles. Testar pelo menos 10.000 atualizações com tentativa de spawn excessiva: nunca mais de 40 partículas, nenhuma sobrevivente ao final do tempo de vida quando spawn fica desligado.
- [ ] **7. Inspecionar as três salas.** Conferir que água se move somente sobre água, folhas vêm da árvore/copa, fogo continua pixel art e partículas ficam abaixo de diálogos e batalha. Medir FPS e contagem de partículas ao percorrer as áreas; guardar evidência de execução e esclarecer o alcance da medição.

## Tarefa 5: Fluxo completo, compilação e relatório

**Files:** criar `tests/evento/Integration_Create.gml` e `docs/RELATORIO_EVENTO.md`; corrigir apenas arquivos diretamente responsáveis por falhas demonstradas.

**Interfaces:** consome todas as tarefas anteriores e os callbacks/transições originais. Nenhuma interface pública nova.

- [x] **1. Escrever verificações do fluxo.** Usar objetos/salas reais. Verificar uma instância de batalha após duas chamadas de `batalha_iniciar`, bloqueio do jogador, reinício sem outra instância, vitória do treino chamando `start_post_dialogue`, criação única do portal, chegada às cavernas com diálogo bloqueando movimento, saída direita, chefe e fim da demo. Verificar nova sessão sem dados de partículas/combate anteriores.
- [x] **2. Executar a bateria.** `powershell -NoProfile -File tools/run_evento_tests.ps1 -Suite All` e `python tools/validate_evento.py --baseline <pasta-da-copia>`. Esperado: códigos de saída zero e todos os marcadores PASS. Se houver falha, guardar o resultado anterior e repetir somente a suíte afetada após corrigir.
- [x] **3. Compilar o projeto real.** Usar Igor, Windows Compile, runtime VM, config Default, `--project=<caminho absoluto de ParadoxoDeWilson.yyp>`, runtime local e prefabs instalados. Cache, temporários, binário e log ficam em uma pasta de verificação fora do projeto. Esperado: `Igor complete.` e exit=0.
- [ ] **4. Jogar o fluxo completo.** Abrir o binário compilado e percorrer menu → Newton → quatro ações → vitória → diálogo → portal → cavernas → segunda sala → chefe → fim → menu. Verificar também derrota/reinício, input misto, colisão, erro/acerto, cura cheia/espera, defesa/esquiva, resolução da GUI e mudanças de sala. A automação de testes não substitui inspeção visual e input real.
- [ ] **5. Fazer a revisão final.** Rever inicialização de variáveis, ordem dos eventos, nomes de layers, contexto das funções GML, controle de estados finais, reinício e limites de partículas. Se execução nativa for escolhida, usar um revisor independente ao final conforme a habilidade de execução; não delegar implementações sem escolha do usuário. Corrigir achados demonstrados e repetir as verificações afetadas.
- [x] **6. Entregar o relatório.** Registrar os 18 tópicos solicitados, incluindo lista exata dos arquivos, configuração final, animação por overlays, testes efetivamente executados, logs, cópia de segurança e problemas encontrados. Distinguir claramente qualquer teste não executado; não chamar a entrega de plenamente jogável só por passar compilação.

## Autorrevisão do plano

- [x] Todas as nove seções funcionais da especificação têm tarefas correspondentes.
- [x] As assinaturas e campos usados em tarefas posteriores são definidos na tarefa proprietária.
- [x] Os cinco riscos de Review Focus possuem verificações nas tarefas indicadas.
- [x] Nenhuma etapa exige novos assets, refatoração geral, Git ou mudanças no fluxo.
- [x] O executor testa GML real; simulações e validação de referências não são apresentadas como inspeção visual.
- [x] Compilação, jogabilidade e FPS possuem etapas separadas e evidência exigida.

Estado: implementação aplicada e compilada; quatro suítes e validador passaram. Inspeção nativa parcial; percurso manual completo e parecer independente final não concluídos. Ver docs/RELATORIO_EVENTO.md.
