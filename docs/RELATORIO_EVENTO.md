# Paradoxo de Wilson — relatório da implementação

As alterações estão aplicadas na pasta original. O projeto real compilou sem erros introduzidos; as quatro suítes executadas no runtime GameMaker passaram em 8.255 verificações. Mapas, colisores, sprites, tilesets, fontes, opções, matemática e transições protegidas foram comparados com a cópia original e preservados.

A validação visual e de teclado foi parcial. O fluxo inteiro passou pela integração automatizada com os objetos e callbacks reais; não houve uma partida completa percorrida manualmente pelo mapa. A revisão independente começou, confirmou o conjunto de arquivos alterados, mas foi interrompida pelo limite de uso antes do parecer final. A revisão do autor foi concluída, sem novo problema funcional identificado; isso não equivale a um parecer independente.

## 1. Arquivos alterados

São exatamente 11 arquivos originais, identificados pela comparação de SHA-256 com o backup:

- `objects/obj_player/Step_0.gml`
- `objects/obj_main_menu/Draw_64.gml`
- `scripts/battle_system/battle_system.gml`
- `objects/obj_battle_controller/Create_0.gml`
- `objects/obj_battle_controller/Draw_64.gml`
- `objects/obj_cavern_isleide/Create_0.gml`
- `objects/obj_newton_npc/Create_0.gml`
- `rooms/rm_tutorial/rm_tutorial.yy`
- `rooms/rm_cavernas/rm_cavernas.yy`
- `rooms/rm_cavernas_2/rm_cavernas_2.yy`
- `ParadoxoDeWilson.yyp`

## 2. Arquivos criados

Produção: `objects/obj_ambient_controller/obj_ambient_controller.yy`, `Create_0.gml`, `Step_0.gml` e `Draw_0.gml`.

Verificação: `tools/evento_project.py`, `tools/run_evento_tests.ps1`, `tools/validate_evento.py`, `tools/build_evento.ps1`; `tests/evento/Common.gml`, `Input_Create.gml`, `Input_Step.gml`, `Battle_Create.gml`, `Ambient_Create.gml`, `Ambient_Step.gml`, `Integration_Create.gml`, `Integration_Step.gml`, `Visual_Create.gml` e `Visual_Step.gml`.

Documentação: este relatório; `docs/superpowers/specs/2026-10-02-evento-combate-ambientacao-design.md`, `docs/superpowers/plans/2026-10-02-evento-combate-ambientacao.md` e `docs/superpowers/progress-evento.md`.

Os objetos e atalhos dos testes são registrados apenas nas cópias temporárias. Não entram no projeto de produção. Nenhum asset externo foi adicionado.

## 3. Mudanças no obj_player

As quatro leituras de direção combinam WASD com as setas, usando operações booleanas. Velocidade, normalização diagonal, direção visual, máquina de estados, colisões e bloqueio de movimento continuam nos eventos originais. Teclas iguais de dois esquemas não duplicam velocidade; direções opostas se cancelam. O menu agora informa “WASD / SETAS”.

## 4. Mudanças no battle_system

Adicionadas `batalha_configuracao`, `batalha_intencao` e `batalha_ambiente`. A configuração centraliza o balanceamento. O início registra sala e ambiente e atualiza a intenção após configurar o tutorial. A proteção contra controlador duplicado foi mantida.

O corpo de `batalha_gerar_desafio` foi preservado, incluindo todas as 16 fases. O chefe continua com fase matemática inicial e máxima 1.

## 5. Mudanças no obj_battle_controller

As ações existentes passaram a consumir a configuração e a intenção anunciada. Adicionados índice de turno e espera da cura. Acerto realiza a ação; erro realiza a resposta anunciada do inimigo e consome turno. Entrada vazia e escolhas bloqueadas não consomem turno. O golpe que vence a batalha não recebe retaliação.

O treino conserva as quatro ações em ordem. A quarta demonstra esquiva garantida, identificada como treino. Depois das quatro ações, a luta livre começa no primeiro turno do ciclo sem restaurar HP. Reiniciar restaura HP, matemática, treino, intenção, espera e campos de entrada, sem criar outra batalha.

A GUI exibe ambiente, intenção e disponibilidade de cura, conservando os retângulos de clique e a transformação responsiva. O aviso de ataque forte usa um triângulo desenhado, pois a fonte existente não contém o símbolo de alerta. Duas frases de Newton explicam as ações e os avisos; páginas e narrativa restantes foram preservadas.

## 6. Balanceamento final

| Parâmetro | Valor |
| --- | --- |
| HP do jogador | 100 |
| HP padrão / Newton | 100 |
| HP do chefe | 150, anteriormente 75 |
| Ataque do jogador | 16–20 |
| Ataque em vulnerabilidade | 24–30 |
| Ataque normal inimigo | 10–12 |
| Ataque forte inimigo | 34–36 |
| Dano normal / forte durante treino guiado | 4–6 / 12–14 |
| Redução da defesa normal / forte | 50% / 75% |
| Chance de esquiva normal / forte | 60% / 75% |
| Cura | Até 28 HP |
| Espera da cura | Duas outras ações consumidas |

Não há críticos aleatórios nas novas ações. Em 2.000 batalhas por estratégia, usando contas corretas e semente repetível: ataque repetido venceu 0; defesa no forte, ataque na vulnerabilidade e cura disponível com HP≤60 venceu 2.000, média de 12,21 ações; esquiva substituindo defesa venceu 1.884, média de 11,91 ações. A esquiva oferece risco; defesa fornece a rota consistente nas simulações. Esses resultados medem as regras, não a experiência de crianças em um evento.

## 7. Sistema de ataque forte

O ciclo livre repete normal → normal → forte → vulnerável. A intenção permanece fixa durante a conta. O painel mostra “ATAQUE FORTE!” e “DEFENDA OU ESQUIVE” antes da escolha. No turno vulnerável, o inimigo não causa dano e recebe ataque aumentado em 50%.

## 8. Defesa

Uma resposta correta reduz o ataque daquele turno: 50% no normal e 75% no forte, com arredondamento. Fora do treino, isso resulta em 5–6 e 9 HP, respectivamente. Uma conta errada não concede proteção. A mensagem mostra o dano aplicado.

## 9. Esquiva

Resposta correta tenta evitar todo o dano: 60% contra normal e 75% contra forte. Falha recebe uma vez o dano anunciado. No quarto passo guiado, a demonstração é garantida e identificada como treino; na luta livre vale a chance real. As probabilidades foram verificadas com 10.000 tentativas por intenção.

## 10. Cura

Recupera até 28 HP, limitada ao máximo, antes da resposta inimiga. O texto informa o ganho efetivo. Vida cheia ou espera ativa bloqueiam a escolha antes de gerar conta. Só uma cura executada inicia espera de duas outras ações. Erro de conta consome turno e recebe resposta inimiga, sem executar cura nem iniciar sua espera. O botão informa PRONTA, 1 TURNO ou 2 TURNOS.

## 11. Efeitos em rm_tutorial

Folhas discretas emitidas na copa da árvore existente. Uma origem de emissão foi encontrada. Não foi criada água: esta sala não tem um rio ou lagoa no projeto atual. Depth 50 mantém os efeitos atrás de `props_sob`.

## 12. Efeitos em rm_cavernas

Reflexos e pequenas ondas nos pontos interiores do rio, folhas perto das árvores e poeira discreta. O cache encontrou 35 pontos de água e 8 de folhas. Não há fogo nesta sala.

## 13. Efeitos em rm_cavernas_2

Reflexos e pequenas ondas na lagoa, folhas, poeira, brilho pulsante e detalhe de chama na fogueira existente, com brasas ascendentes. O cache encontrou 61 pontos de água, 17 de folhas e uma fogueira.

## 14. Animação da água

Os tiles originais são estáticos e não foram alterados. No Create, uma seleção de índices interiores identifica pontos realmente aquáticos. Pequenos traços claros oscilam e desaparecem sobre esses pontos, sem mover o mapa. Índices de pedras, margens e ponte são excluídos. A varredura não se repete no Step ou Draw.

## 15. Animação do fogo

A fogueira conserva seu tile. Duas elipses locais de baixa opacidade pulsam, um detalhe pequeno da chama oscila e brasas sobem e desaparecem. Não foram adicionados shaders, surfaces ou imagens.

## 16. Folhas e partículas

Uma instância não persistente por sala mantém structs em um array limitado a 40 partículas, somando todos os tipos. Folhas caem com oscilação lateral, poeira deriva lentamente e brasas sobem. Tempo de vida e limites da sala eliminam partículas. A atualização usa `delta_time` em segundos, limitado a 0,05 por frame.

Os efeitos usam Draw no mundo e restauram cor e alpha; não modificam blend. Não desenham na GUI nem escrevem em tiles ou colisões. Trocar de sala descarta todos os dados locais. O teste de 10.000 atualizações, expiração, sala sem layers, duplicação e reentrada passou.

Em amostras da inspeção nesta máquina, as três salas registraram 60 FPS. Na integração houve uma amostra inicial de 32 FPS durante carregamento/transição. Isso não garante 60 FPS em todo hardware ou durante toda troca de sala.

## 17. Compilação e verificações

Compilação real: GameMaker LTS runtime 2026.0.0.23, Windows VM, configuração Default; saída `Igor complete.`, código zero. Binário: `C:/Users/jrhre/AppData/Local/CodexBuilds/ParadoxoDeWilson/evento-20261002-010351/ParadoxoDeWilson.win`. Log na mesma pasta: `compile.log`. Esse arquivo `.win` é executado pelo Runner do GameMaker; não é um instalador Windows.

Última bateria completa:

| Suíte | Verificações | Falhas | Pasta de log em `%TEMP%/paradoxo-evento-tests/` |
| --- | ---: | ---: | --- |
| Input | 18 | 0 | `Input-3878960730894c448a91a71ed3fde7d2` |
| Battle | 8.187 | 0 | `Battle-6ce7c6b963604b5f9b4cf1054aa136e8` |
| Ambient | 27 | 0 | `Ambient-fbd859dd36d943e0a7576cbd376e7270` |
| Integration | 23 | 0 | `Integration-c63a227c3d3d42a088fabcbb99d34886` |

Validador: 52 recursos registrados, referências e eventos válidos. Comparação com a base confirmou preservação dos recursos protegidos e dos mapas após retirar somente a nova instância ambiental. As contas das 16 fases também foram exercitadas.

Integração: menu → introdução Newton → quatro ações → vitória → diálogo → portal → cavernas → saída direita → chefe → derrota/reinício → vitória → fim → menu → nova sessão. Usa as funções, instâncias e salas reais em uma cópia de teste.

Inspeção nativa: aviso forte e vulnerabilidade, conta por teclado `2 + 9 = 11` com resultado ACERTOU e dano, mensagem de vida cheia, apresentação em janela e tela cheia, rio/lagoa abaixo da interface. O menu do binário final foi aberto, a tabela “WASD / SETAS” conferida por clique e o retorno por Escape verificado. O percurso inteiro e todos os quatro botões por ambos os métodos não foram repetidos manualmente; suas regras passaram nos testes GML. Log visual: `%TEMP%/paradoxo-evento-tests/Visual-e085fc5dbccb44539d23835fe0afa1df/runner.log`.

Para repetir: `pwsh -NoProfile -File tools/run_evento_tests.ps1 -Suite All`; `python tools/validate_evento.py --baseline C:/Users/jrhre/AppData/Local/CodexBackups/ParadoxoDeWilson/20261002-004122`; `pwsh -NoProfile -File tools/build_evento.ps1`.

## 18. Problemas encontrados, decisões e limites

- A compilação inicial precisava do caminho da biblioteca de prefabs instalada. O parâmetro foi corrigido; nenhuma biblioteca do projeto foi substituída.
- A simulação de teclado no Create não era processada imediatamente. O teste passou a esperar frames reais; custo: alguns segundos adicionais por execução.
- As salas usam formatação compacta diferente da pressuposta pelo primeiro inseridor. A inserção foi ajustada e os mapas comparados estruturalmente com o original.
- O hover do mouse existente no menu interferia na simulação de Enter. A integração usa o callback real com a área de hover afastada somente na fixture. O menu de produção não foi modificado; clique e Escape foram inspecionados nativamente. A navegação exclusivamente por teclado com o cursor sobre uma opção continua sujeita ao comportamento original de hover.
- A fonte não contém o símbolo de atenção. O aviso usa geometria, sem mudar a fonte.
- O revisor independente verificou os 185 hashes e encontrou somente os 11 arquivos esperados alterados, mas atingiu o limite de uso antes de concluir o parecer. Não há aprovação independente final nem lista final de achados menores. Foi feita revisão do autor de inicialização, estados, reinício, registro, layers, duplicação e limites, sem falha funcional nova encontrada.
- A inspeção Visual usa atalhos somente na cópia temporária para acessar salas e situações. Isso não substitui uma partida inteira manual. Essa verificação manual completa permanece pendente e não foi declarada realizada.
- Não foi criado Git, branch ou PR: trabalho em pasta, conforme a especificação aprovada. Custo: eventual reversão usa a cópia de segurança. O diário e a documentação foram mantidos para conservar o registro, pois não existe histórico Git.

Cópia de segurança: `C:/Users/jrhre/AppData/Local/CodexBackups/ParadoxoDeWilson/20261002-004122`, 185 arquivos originais com `manifest.json` e SHA-256. Nenhum original foi excluído. Não há recomendação menor independente adiada, pois o parecer não foi concluído.
