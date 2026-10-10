# Revelação de Newton — plano de implementação

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [x]`) syntax for tracking.

**Goal:** Integrar o aliado, seu distrito comercial, o retorno temporal e o confronto em duas etapas contra Newton.

**Architecture:** Reutilizar importação de recursos, movimento, colisões e controlador de combate existentes. Separar progresso e diálogos, cenário comercial, cena temporal e regras especiais da batalha em unidades próprias, com pontos de integração pequenos no sistema atual.

**Tech Stack:** GameMaker LTS 2026.0.0.23, GML, Python para registro e cópia de recursos, ferramenta integrada de imagens para arte. Sem novas dependências de produto.

**Spec:** `C:/Users/jrhre/OneDrive/Desktop/ExpoGameJam-demo/docs/superpowers/specs/2026-10-07-revelacao-newton-design.md`.

**Execução proposta:** o agente principal implementa nesta conversa; uma revisão independente somente leitura ao final. Plano e execução nesta conversa aprovados pelo usuário em 2026-10-07.

## Global Constraints

- Preservar as fases anteriores, movimento, colisões, XP, Quebra de Paradoxo e botão temporário de pular.
- Distrito 960×640, entrada (480,600), aliado (480,290), câmera 384×219.
- Importar `C:/Users/jrhre/Downloads/Capitalista0.png` sem alterar seus pixels; gerar o fundo em `output/imagegen/commercial-district.png`.
- Um único `obj_player` controlável; Wilson do passado é NPC. A volta temporal não adiciona portal ao percurso normal.
- Primeira etapa: Newton 420 HP, derrota após três respostas não vazias, sem recompensa; segunda: Newton 240 HP, dupla 140 HP, ataque 24–30 + 8 do aliado.
- Duas primeiras contas da segunda etapa são somas de 1–5; depois somas/subtrações pequenas e multiplicações de 2–5.
- Nova carga de Quebra de Paradoxo na segunda etapa e em seu reinício; vitória concede apenas os 100 XP normais uma vez.
- Usar a arte atual de Newton temporariamente, com referência dedicada substituível.
- Esta pasta não é um repositório Git. Fazer backup dos arquivos afetados em `%LOCALAPPDATA%/CodexBackups/ParadoxoDeWilson`; registrar etapas verificadas neste plano.

## Review Focus

1. Pular a primeira etapa enquanto existe uma questão aberta precisa limpar input e chegar à recuperação, sem conceder XP — tarefas 3 e 4.
2. Uma tecla E mantida durante a troca de sala não pode consumir duas falas nem criar duas batalhas — tarefa 2.
3. Perder na segunda etapa e reiniciar deve conservar o apoio e restaurar somente uma carga da habilidade — tarefa 4.
4. Expressões longas, mudança de resolução e Quebra de Paradoxo devem produzir questões legíveis e respostas válidas — tarefas 3 e 5.
5. Voltar ao menu e selecionar JOGAR após a revelação deve limpar a história, sem afetar o tutorial normal — tarefas 1 e 5.

---

### Task 1: Distrito, aliado e ligação com a cidade

**Files:**
- Create: `scripts/newton_story/newton_story.gml` e respectivo `.yy`.
- Create: `objects/obj_commercial_scene/{Create_0,Step_0,Draw_0,Draw_64}.gml` e `.yy`.
- Create: `objects/obj_capitalist_ally/{Create_0,Step_0,Draw_0,Draw_64}.gml` e `.yy`.
- Create: `tools/add_newton_story.py`, `sprites/spr_commercial_district/`, `sprites/spr_capitalist_ally/`, `rooms/rm_commercial_district/`.
- Modify: `objects/obj_autumn_scene/Step_0.gml`, `objects/obj_battle_controller/Create_0.gml`, `objects/obj_main_menu/Step_0.gml`, `ParadoxoDeWilson.yyp`.
- Test: `tests/evento/Newton_Create.gml`, `tests/evento/Newton_Step.gml`; adicionar Newton às opções de `tools/evento_project.py` e `tools/run_evento_tests.ps1`.

**Interfaces:**
- Consumes: `matematica_progresso()`, `add_royal_interiors.sprite/object_resource/make_room`, diálogo aprovado na especificação.
- Produces: `historia_newton_progresso(_reiniciar=false) -> struct {city_defeated:false, stage:"city", final_rewarded:false}`; `historia_newton_dialogo(_nome) -> array<struct {speaker,portrait,text}>`, nomes `revelation`, `exposure`, `recovery`, `ending`.
- `obj_capitalist_ally` oferece `dialogue_active`, `dialogue_page`, `dialogue_pages` e `advance_dialogue()`. O fim de `revelation` solicita a volta temporal da tarefa 2.

- [x] Escrever testes que inicialmente verificam via `asset_get_index` a ausência do cenário e aliado; executar `& tools/run_evento_tests.ps1 -Suite Newton -WorkspaceDirectory 'C:/Users/jrhre/AppData/Local/Temp/paradoxo-evento-tests/All-38a7b5b5c0c94b3990021e92b1120e59'`, esperando falha por recursos ausentes.
- [x] Fazer o backup e gerar o fundo usando a praça outonal como referência; solicitar corredor central livre e obstáculos laterais. Inspecionar a imagem, copiar para a pasta do projeto e registrar prompt e modo usados.
- [x] Registrar sala e sprites com o importador. Definir colisões a partir da imagem final, manter entrada e ponto de encontro livres, e importar o aliado byte a byte.
- [x] Implementar progresso, diálogo do distrito e saída norte da praça em x=440–520, y≤72 somente com `city_defeated`. A vitória real ou pulada da cidade marca essa flag; JOGAR reinicia as flags.
- [x] Ampliar testes: saída bloqueada antes da vitória, liberada depois; uma instância do aliado; 16 falas aprovadas, bloqueio durante conversa; máscara e caminhada no corredor; reinício pelo menu. Conferir captura do cenário e verificar bytes do sprite original.

### Task 2: Volta temporal e exposição de Newton

**Files:**
- Create: `objects/obj_temporal_scene/{Create_0,Step_0,Draw_0,Draw_64}.gml` e `.yy`.
- Create: `objects/obj_past_wilson/{Create_0,Draw_0}.gml` e `.yy`.
- Create: `objects/obj_newton_final/{Create_0,Draw_0}.gml` e `.yy`.
- Create: `rooms/rm_temporal_origin/`; ampliar `tools/add_newton_story.py`, `scripts/newton_story/newton_story.gml` e testes Newton.

**Interfaces:**
- Consumes: progresso e conjuntos de diálogo da tarefa 1.
- Produces: `obj_temporal_scene.start_recovery()`, `start_ending()` e `advance_dialogue()`, todos sem duplicação de execução.
- Cena possui `scene_mode` em `arrival`, `exposure`, `battle_first`, `recovery`, `battle_supported`, `ending`, `complete`; `dialogue_active`, `dialogue_page`, `dialogue_pages`.
- `obj_newton_final` expõe `battle_story="newton"`, `battle_stage=1`, sprite temporário atual `spr_battle_newton` e atributos de inimigo já aceitos por `batalha_iniciar`.

- [x] Ampliar os testes para falharem pela ausência de `rm_temporal_origin` e dos três atores novos.
- [x] Clonar o tutorial, preservando tiles e colisores. Substituir o Newton de treino por `obj_newton_final` em (560,272), adicionar Wilson passado (520,250), Wilson atual (470,300), aliado (430,300) e controlador de cena. Conferir posições no jogo e ajustar somente se houver sobreposição com a geometria.
- [x] Implementar chegada breve, dez falas de exposição e início de uma única batalha; zero velocidades enquanto a cena está ativa. O aliado aparece nesta sala como acompanhante, sem repetir a revelação comercial.
- [x] Testar a passagem pelo último diálogo com teclas reais, E mantido, uma instância controlável, ausência de portal e tutorial normal funcionando numa nova partida. Capturar a cena com os quatro participantes.

### Task 3: Expressões complexas e pontos de integração do combate

**Files:**
- Create: `scripts/newton_battle/newton_battle.gml` e `.yy`.
- Modify: `objects/obj_battle_controller/{Create_0,Draw_64}.gml`, `scripts/battle_system/battle_system.gml`; ampliar testes Newton.

**Interfaces:**
- Consumes: `batalha_iniciar`, controlador e perfil de história da tarefa 2.
- Produces: `newton_gerar_desafio(_etapa,_indice) -> desafio` compatível com `{x,y,operacao,resposta}`, com `expressao` opcional na etapa 1.
- Produces: `newton_batalha_configurar(_controlador,_etapa)`, `newton_batalha_apos_resposta(_controlador)`, `newton_batalha_queda(_controlador)` e `newton_batalha_pular(_controlador) -> bool`.
- Controlador recebe `story_battle=false`, `story_stage=0`, `story_answers=0`, `ally_bonus=0` por padrão. Newton habilita esses campos; demais inimigos conservam seu fluxo.

- [x] Testar 200 questões por modelo: `(a x b) + c^2 - d`, com a=12–24, b=6–12, c=7–15, d=2–9; e `(a*b / b) x (c + d)`, com a=12–24, b=2–9, c=7–15, d=2–9. Recalcular respostas independentemente; exigir valores inteiros positivos e denominador não zero.
- [x] Implementar geração em módulo próprio. Newton usa esse gerador sem perder o texto da expressão no redutor de compreensão; todos os outros perfis continuam passando por `matematica_facilitar`.
- [x] No popup, usar `expressao` quando presente e reduzir a fonte pelo espaço disponível; manter apresentação antiga caso contrário. Inserir a explicação de ordem das operações e conferir glifos `^`, `/`, `x` e parênteses no font existente.
- [x] Integrar contador após resposta válida; entrada vazia e cura recusada não contam. Após três respostas, chamar queda, limpar questão/input, iniciar recuperação e destruir apenas o controlador de combate. Impedir vitória na etapa 1 e derrota comum antes da terceira resposta.
- [x] Testar acertos, erros, defesa, cura, esquiva, HP baixo, habilidade preparada e habilidade em questão aberta. Pular a etapa 1 deve chamar queda diretamente, inclusive com resposta parcialmente digitada; verificar XP inalterado e ausência de vitória.

### Task 4: Apoio coletivo, segunda etapa e encerramento

**Files:**
- Modify: `scripts/newton_battle/newton_battle.gml`, `objects/obj_temporal_scene/{Create_0,Step_0,Draw_0,Draw_64}.gml`, `objects/obj_battle_controller/{Create_0,Draw_64}.gml`; ampliar testes Newton.

**Interfaces:**
- Consumes: `start_recovery`, `newton_batalha_configurar`, progresso e diálogos aprovados.
- Produces: cena de recuperação com oito falas e segunda etapa; `start_ending()` com três falas: plano de Newton impedido, ligação estabilizada e reconstrução das realidades. Após encerramento, libera movimento; E na saída sul volta ao menu.
- Configuração etapa 2 é local ao controlador: player_hp_max=140, enemy_hp_max=240, attack_min=24, attack_max=30, ally_bonus=8. Aplicar bônus antes do teste de vitória do ataque.

- [x] Testar recuperação única, quatro projeções (`spr_isleide_cavernas`, `spr_castle_guard`, `spr_king_standing`, `spr_city_peace`), mesmo XP antes/depois e transição para etapa 2.
- [x] Implementar Wilson caído e recuperação visual breve, aliado protegendo-o e projeções. Ao final das oito falas, marcar `battle_stage=2` e iniciar combate com vida restaurada e uma carga de Quebra de Paradoxo.
- [x] Gerar as duas primeiras questões como somas de 1–5. Depois alternar soma (2–12)+(2–12), subtração a=3–14,b=1–a-1 e multiplicação (2–5)x(2–5). Desenhar dupla com alturas normalizadas de 200 unidades, em x=220 e x=385, baseline y=415; mostrar apoio no painel.
- [x] Integrar reinício mantendo etapa 2, atributos locais e carga da habilidade. Vitória e botão de pular chamam encerramento e concedem 100 XP uma vez, com proteção tanto na instância de Newton como no progresso narrativo.
- [x] Testar bônus de ataque sem retaliação após golpe final, limites da cura, intenção forte/vulnerável, derrota e reinício, duas cargas em tentativas separadas, pular, recompensa duplicada e ausência de mudanças nos atributos de batalha dos inimigos anteriores.

### Task 5: Verificação final e entrega

**Files:**
- Complete: `tests/evento/Newton_{Create,Step}.gml`, `docs/RELATORIO_REVELACAO_NEWTON.md`, `output/imagegen/newton-story-prompts.md`, `output/verification/newton/`.
- Modify: adicionar Newton ao grupo All em `tools/run_evento_tests.ps1`; atualizar este plano com etapas realizadas.

- [x] Testar percurso completo cidade → distrito → revelação → origem → derrota → recuperação → segunda etapa → encerramento. Usar input real e guardar capturas das páginas de diálogo e das duas dificuldades.
- [x] Conferir visualmente enquadramento, obstáculos, texto, dupla, projeções e expressão longa em resoluções 640×380 e 960×540. Ajustes exigem repetir o teste específico afetado.
- [x] Executar `& tools/run_evento_tests.ps1 -Suite All -WorkspaceDirectory 'C:/Users/jrhre/AppData/Local/Temp/paradoxo-evento-tests/All-38a7b5b5c0c94b3990021e92b1120e59'`. Esperado: 15 grupos, zero falhas. Não iniciar dois Runners simultâneos.
- [x] Solicitar revisão independente somente leitura com especificação, backup, arquivos alterados e logs, sem permitir testes concorrentes. Corrigir achados concretos e verificar novamente o que a correção afetar.
- [x] Compilar o projeto de produção com o Igor da instalação GameMaker usada por `tools/run_evento_tests.ps1`, cache de produção `C:/Users/jrhre/AppData/Local/CodexBuilds/ParadoxoDeWilson/evento-20261006-135421/cache` e diretório de saída novo com data/hora em `%LOCALAPPDATA%/CodexBuilds/ParadoxoDeWilson`. Confirmar código zero, `Igor complete.` e arquivo `.win` existente.
- [x] Registrar resultado real, limites (Newton com arte temporária), backup e capturas no relatório. Conferir fontes copiadas nos testes iguais às de produção e recursos únicos antes de informar conclusão.

## Autorrevisão do plano

Cobertura conferida: cenário e ligação (1), diálogos e segundo Wilson (1–2), expressões e primeira derrota (3), apoio, habilidade, reinício e vitória (4), verificação visual e regressões (5). As cinco situações do Review Focus têm testes nas tarefas indicadas. Valores de vida, dano, XP, quantidade de falas e controles coincidem com a especificação aprovada. A arte futura de Newton altera somente a referência de sprite; sua ausência não impede implementar esta sequência com a arte atual.
