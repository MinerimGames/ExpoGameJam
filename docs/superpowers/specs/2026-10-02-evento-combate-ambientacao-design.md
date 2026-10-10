# Paradoxo de Wilson — controles, combate e ambientação para o evento

Data: 2026-10-02. Projeto: `ParadoxoDeWilson.yyp`, nesta pasta.

Estado: proposta e especificação escrita aprovadas pelo usuário na conversa. Implementação ainda não iniciada.

## Objetivo e limites

Preparar a demo existente para crianças: controles intuitivos, decisões de combate compreensíveis, feedback curto e cenários vivos. Preservar o jogo, sua identidade visual, composição dos mapas, colisões, matemática e progressão.

O fluxo continua sendo `rm_menu → rm_tutorial → treinamento com Newton → portal → rm_cavernas → rm_cavernas_2 → Isleide das Cavernas → rm_demo_end → rm_menu`. Alterações nos diálogos se limitam às explicações das ações e da intenção inimiga. Não adicionar assets externos, dependências de produto, novos mapas ou uma arquitetura de batalha substituta.

## Análise da base existente

- `obj_player` lê WASD no Step, calcula movimento na máquina de estados do Create, normaliza a diagonal e chama `move_and_collide` no End Step. `movimento_liberado` bloqueia input; diálogos e batalhas também zeram `velh` e `velv`. Preservar essa divisão, `facing_sign`, sprites e máscara de colisão.
- `battle_system` gera desafios em 16 fases e cria uma única instância de `obj_battle_controller`, bloqueando o jogador. Também transfere nome, HP, fase matemática e apresentação do inimigo para o controlador.
- `obj_battle_controller` concentra ações, verificação das respostas, reinício, vitória e derrota no Create; recebe mouse/teclado no Step e desenha a interface no Draw GUI. Referência da interface: 960×540, com escala e margens calculadas para a resolução real.
- O treinamento exige Ataque, Cura, Defesa e Esquiva, nessa ordem. Ao concluir as quatro ações, libera as escolhas até derrotar Newton. A vitória chama seu diálogo final e cria o portal. Manter esse fluxo.
- O chefe possui atualmente 75 HP, fase matemática inicial e máxima iguais a 1 e um sprite próprio. A vitória leva ao fim da demo. A saída de `rm_cavernas` leva a `rm_cavernas_2` pela borda direita.
- As três salas de jogo e todos os objetos atuais são não persistentes. Os efeitos ambientais também serão não persistentes.
- `rm_tutorial` tem layers `props_sob` (depth 0), `player` (100), `enemies` (200), `colisores` (300), `props_sub` (400), `Tileset` (500) e fundo (600). O mapa atual não contém água: efeitos de água não serão desenhados sobre o chão nem será adicionado um lago.
- `rm_cavernas` possui layers de detalhes, árvores, pedras, pontes, margem, água, vegetação e chão, com depths de 200 a 900. Sua água usa `tl_cavernas01`. Há 13 colisores.
- `rm_cavernas_2` possui layers de árvores, pedras, acampamento, detalhes, trilha, vegetação, lagoa e chão, com depths de 200 a 900. Sua lagoa usa `tl_cavernas07` e sua fogueira usa `tl_acampamento`. Há 25 colisores.
- Os tilesets analisados usam tiles de 16×16 e não têm animações configuradas. As imagens de acampamento contêm variantes de fogueiras, mas não uma sequência de frames já configurada para a fogueira do mapa. Preferir luz, pequenos detalhes de chama e brasas sobre a fogueira existente.
- Os sprites de batalha existentes serão reutilizados. Não substituir os sprites do jogador, Newton ou chefe.
- A documentação antiga menciona recursos que não existem nesta cópia, como `spr_newton_npc` animado e `obj_slime`. Os arquivos atuais, e não essas descrições antigas, definem a implementação.

## 1. Controles

Adaptar somente as quatro leituras de input em `objects/obj_player/Step_0.gml`: W ou cima, S ou baixo, A ou esquerda, D ou direita. Os sinais permanecem booleanos, evitando velocidade extra quando ambas as teclas da mesma direção são pressionadas.

Preservar o tratamento de direções opostas e combinações mistas, como W + direita. Nenhum segundo sistema de movimentação. Atualizar a explicação dos controles no menu para informar WASD e setas.

## 2. Turnos e intenção inimiga

Centralizar configurações de combate em `scripts/battle_system/battle_system.gml`, mantendo as funções matemáticas existentes. O controlador consome essa configuração e mantém suas funções de ação.

Fora das quatro etapas guiadas, repetir um ciclo determinístico:

| Ação do jogador no ciclo | Intenção visível antes da escolha | Resposta do inimigo |
| --- | --- | --- |
| 1 | ATAQUE NORMAL | Ataque normal |
| 2 | ATAQUE NORMAL | Ataque normal |
| 3 | ATAQUE FORTE! DEFENDA OU ESQUIVE | Ataque forte |
| 4 | INIMIGO VULNERÁVEL! | Recupera-se, sem causar dano |

Uma escolha só consome turno após verificar uma resposta matemática não vazia. Acerto executa a ação e a resposta inimiga correspondente. Erro cancela a ação e aplica a resposta inimiga anunciada, sem defesa ou esquiva. Em um turno vulnerável, o erro perde a oportunidade de agir, sem criar um ataque surpresa.

A intenção fica estável enquanto o jogador resolve a conta. Escolhas bloqueadas, input vazio e seleção de uma ação incorreta no tutorial não consomem turno. O ataque que derrota o inimigo encerra o combate sem retaliação.

Remover críticos aleatórios do inimigo. Remover também a duplicação aleatória do dano do jogador; sua oportunidade de dano maior passa a ser a vulnerabilidade visível. A pequena variação de dano continua dentro dos intervalos abaixo.

## 3. Balanceamento inicial

| Parâmetro | Valor |
| --- | --- |
| HP máximo e inicial do jogador | 100 |
| HP do Isleide das Cavernas | 150 |
| Ataque do jogador | 16–20 HP |
| Multiplicador contra inimigo vulnerável | 1,5×, resultado inteiro |
| Ataque normal do inimigo | 10–12 HP |
| Ataque forte do inimigo | 34–36 HP |
| Redução de defesa contra ataque normal | 50% |
| Redução de defesa contra ataque forte | 75% |
| Chance de esquiva contra ataque normal | 60% |
| Chance de esquiva contra ataque forte | 75% |
| Cura | 28 HP, limitada ao máximo |
| Espera após curar | 2 outros turnos consumidos |

Arredondar o dano final da defesa para o inteiro mais próximo. Esquiva bem-sucedida evita todo o dano; falha recebe o dano anunciado, sem penalidade adicional.

Não obrigar artificialmente as quatro ações em toda luta real. Defesa e esquiva são alternativas: a primeira previsível, a segunda com maior recompensa e risco. A criança deve poder vencer com escolhas estratégicas sem depender de sorte. Ataque repetido deve apresentar risco real; acertos matemáticos e decisões defensivas devem oferecer uma rota acessível à vitória.

Os números acima são a configuração inicial aprovada. Validar com simulações e com o jogo; ajustes pequenos para cumprir esses objetivos devem ser registrados no relatório final.

## 4. Cura, defesa e esquiva

Ao selecionar cura com HP cheio, mostrar `SUA VIDA JÁ ESTÁ CHEIA!` e manter a escolha de ações. Não gerar desafio ou consumir turno. Ao selecionar durante a espera, mostrar quantos turnos faltam, sem consumir ação. Cura só entra em espera após uma resposta correta que a execute.

Contagem explícita: curar deixa 2 turnos restantes; a primeira outra ação consumida reduz para 1; a segunda reduz para 0. Erro de conta de outra ação também consome turno e reduz a espera. Mostrar `CURA / PRONTA`, `CURA / 2 TURNOS` ou `CURA / 1 TURNO` no botão atual.

Defesa e esquiva afetam somente a resposta inimiga do turno em que a conta é acertada. Não acumulam bônus. Mostrar feedback curto: `DEFESA!`, `DEFESA PERFEITA!`, `ESQUIVOU!`, `A ESQUIVA FALHOU!`, `+28 HP` ou o valor efetivamente curado, e o dano efetivamente recebido.

Manter `ACERTOU!` e `ERROU!` e evitar que textos longos escondam o resultado no painel.

## 5. Tutorial e matemática

Preservar `batalha_gerar_desafio()`, `math_phase`, `math_phase_max`, `answer_text`, `verify_answer()`, os intervalos de geração e a progressão por acerto. O chefe conserva a fase matemática inicial/máxima 1 definida na base. Não aumentar sua dificuldade matemática nesta tarefa.

Preservar Ataque → Cura → Defesa → Esquiva. Nas etapas guiadas, usar ataques fracos e configurar a intenção para demonstrar defesa contra ataque forte na terceira etapa e esquiva contra um ataque real na quarta; a quarta não será um turno sem ataque. A esquiva do treino pode ser garantida, com indicação de que é uma demonstração. Fora do treino, usar as chances reais da tabela.

Após a quarta etapa, liberar as ações e começar o ciclo normal no primeiro turno, sem restaurar HP do inimigo ou do jogador. A matemática continua no ponto já alcançado. Ajustar apenas as explicações de Newton necessárias para ensinar o aviso inimigo, sem aumentar o número de páginas.

Reinício restaura HP, turno inicial, intenção, espera da cura, resposta vazia e etapa guiada, conforme o tipo de batalha. Não criar outra instância do controlador. Manter a movimentação bloqueada durante toda a batalha, inclusive nas telas finais.

## 6. Cenário de batalha e interface

Registrar a sala de origem e `battle_environment` ao iniciar a batalha: `grasslands` em `rm_tutorial`, `cavern` em `rm_cavernas` e `cavern_camp` em `rm_cavernas_2`. Para outras salas, usar um ambiente neutro com o fundo real da sala.

Preservar a sala visível atrás da camada escura, os sprites atuais e a interface roxa, amarela, branca e verde. Permitir apenas uma tonalidade discreta e uma identificação curta do ambiente. Não criar fundos que cubram o mapa inteiro com novas imagens.

Adicionar o aviso de intenção em posição que não conflite com status, instruções do treino, personagens, painel de log ou popup matemático. Manter os botões 2×2, os atalhos 1–4, mouse e Enter, além das funções de escala para 960×540. Desenhar um pequeno ícone geométrico de atenção: a fonte atual não contém o glifo ⚠.

## 7. Ambientação

Criar apenas `obj_ambient_controller`, não persistente, com uma instância em cada uma das três salas de jogo. Configurar efeitos pela sala. Não instanciar no menu ou no fim da demo. Evitar controladores duplicados.

| Sala | Efeitos |
| --- | --- |
| `rm_tutorial` | Folhas ocasionais junto à árvore e pequenas partículas de vegetação |
| `rm_cavernas` | Ondas/reflexos no rio, folhas próximas das árvores e poeira discreta |
| `rm_cavernas_2` | Ondas/reflexos na lagoa, folhas, poeira, brilho da fogueira, pequenas oscilações visuais da chama e brasas ascendentes |

No Create, identificar e guardar pontos válidos de água, folhas e fogo a partir dos tiles existentes. A varredura dos tilemaps ocorre apenas ao entrar na sala. Não tratar pedras, margem, ponte ou vegetação como água só porque usam uma camada relacionada ao rio ou lagoa.

Usar uma quantidade limitada de partículas em arrays, sem criar um objeto por folha. Limite total: 40 partículas ambientais simultâneas por sala, incluindo folhas, poeira, brilhos de água e brasas. Desenhos pequenos, alinhados ao pixel; baixa opacidade e sem shaders ou superfícies grandes. Atualizar apenas os pontos selecionados e as partículas ativas.

Folhas caem lentamente, oscilam lateralmente e desaparecem por tempo de vida ou ao sair dos limites. Brasas sobem perto da fogueira e desaparecem. Água recebe traços curtos e pequenas ondas nos pontos interiores válidos; margens e tiles originais continuam nas mesmas posições. A fogueira continua usando seu tile original, com brilho pulsante e detalhes locais leves; não animar o conjunto inteiro de pedras ou deslocar o chão.

Usar Draw no mundo, nunca Draw GUI. Definir depth à frente dos tiles relevantes e atrás de toda a interface; respeitar o encobrimento de folhas por copas quando aplicável. Restaurar cor, alpha e blend após desenhar. Nenhum efeito escreve em tiles, colisores ou posições de personagens. Nenhuma alteração física nas copas.

Destruição ao trocar de sala elimina todos os dados locais. Nenhum acúmulo após voltar ao menu ou reiniciar a demo. Meta: 60 FPS, a ser medida no jogo, não presumida por inspeção.

## 8. Arquivos previstos

Modificar `objects/obj_player/Step_0.gml`, `objects/obj_main_menu/Draw_64.gml`, `scripts/battle_system/battle_system.gml`, os eventos necessários de `obj_battle_controller`, `objects/obj_cavern_isleide/Create_0.gml` e as explicações de treino em `objects/obj_newton_npc/Create_0.gml`.

Registrar `obj_ambient_controller` e seus eventos no `.yyp`; adicionar uma instância nas salas `rm_tutorial`, `rm_cavernas` e `rm_cavernas_2`, preservando todas as instâncias, dados de tiles e colisores existentes. Não modificar `obj_portal`, `obj_cavern_exit_right`, `obj_newton_cavern_dialogue` ou `rm_demo_end` sem um problema diretamente relacionado à tarefa e demonstrado pelos testes.

Adicionar verificações de comportamento e de integridade dos recursos, além do relatório final solicitado. A pasta não é um repositório Git; usar cópia de segurança dos arquivos modificados antes de implementar, sem inicializar Git ou fazer commits nesta tarefa.

## 9. Validação e entrega

Compilação de referência já executada com sucesso no runtime local `2026.0.0.23`, usando a biblioteca de prefabs instalada em `C:/ProgramData/GameMakerStudio2-LTS2026/Prefabs`. A primeira tentativa sem esse caminho falhou ao localizar `io.gamemaker.sdfshaders-1.0.0`; apontar para a instalação existente resolveu, sem alterar o projeto. Log de referência: `%TEMP%/paradoxo-wilson-baseline-20261002/compile.log`.

Validar recursos existentes e novos: arquivos do `.yyp`, eventos registrados, ordem de criação de instâncias, layers usados, nomes de sprites e variáveis inicializadas. Comparar tiles, colisores e transições com a base anterior.

Testar no jogo WASD, setas, combinações mistas, teclas opostas, diagonal e colisões; bloqueio durante diálogos e batalha; introdução de Newton; quatro etapas guiadas; combate livre; acertos e erros de conta; todas as ações; cura cheia e em espera; sequência de intenções; vitória, derrota e reinício; diálogo final e portal; as duas cavernas e sua transição; chefe; fim da demo; retorno ao menu e início de uma nova sessão.

Comparar ataque repetido com estratégia de defesa/cura e com esquiva por meio de simulações de vários resultados de dano e chance. Garantir que defesa ofereça uma rota de vitória sem depender de esquiva bem-sucedida. Medir limite de partículas, ausência de controladores duplicados e FPS no jogo. Conferir a interface em janela, tela cheia e resolução de GUI usada pelo menu.

Compilar após a implementação, corrigir erros introduzidos e registrar o resultado. Distinguir compilação, testes automatizados, inspeção visual e testes jogáveis: não declarar uma etapa testada se somente outra foi executada.

Entregar relatório com os 18 tópicos pedidos: arquivos alterados e criados; alterações no jogador, `battle_system` e controlador de batalha; números finais; ataque forte; defesa; esquiva; cura; efeitos das três salas; água; fogo; folhas/partículas; compilação; problemas encontrados e limitações de validação.
