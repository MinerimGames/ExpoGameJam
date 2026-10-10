# Revelação de Newton e união das realidades

Estado: continuação implementada. Cenário revisado como porto comercial assimétrico, conforme nova direção aprovada pelo usuário em 2026-10-07.

## Intenção e resultado esperado

Dar continuidade à história após Isleide da Cidade. O personagem de `C:/Users/jrhre/Downloads/Capitalista0.png` revela que Newton usa Wilson para enfraquecer as realidades, acompanha seu retorno ao início e participa do confronto. Wilson encontra seu próprio passado, perde a primeira etapa contra Newton e se recupera com a ajuda dos adversários anteriores. A compreensão coletiva torna os cálculos acessíveis e permite enfrentar Newton em condições diferentes.

As versões políticas dos personagens pertencem à ficção do jogo. O aliado apresenta evidências da manipulação; Wilson começa desconfiado e muda de posição gradualmente.

## Abordagens e escolha proposta

1. **Duas etapas jogáveis no combate existente — recomendada.** A primeira mostra a superioridade de Newton; a segunda usa a ajuda coletiva e contas mais fáceis. Mantém as quatro ações, XP, habilidade e controles atuais.
2. Primeira derrota inteiramente em cena: mais curta, mas o jogador não experimenta a diferença dos cálculos.
3. Sistema de equipe com turnos individuais: oferece mais comandos, porém muda bastante a interface e o balanceamento já usados nas fases anteriores.

Esta proposta usa a primeira abordagem. O aliado participa visualmente e ajuda nas ações de Wilson, compartilhando a barra de vida da dupla. Não requer administrar dois personagens separadamente.

## Novo cenário e ligação com a praça

Criar um porto comercial em pixel art com composição diferente da cidade outonal: canais, docas, barcos, ponte diagonal, armazéns de pedra clara, telhados de terracota, torre de relógio deslocada e tendas coloridas. A distribuição é assimétrica. Sem personagens incorporados à imagem, textos ou logotipos. Um percurso sinuoso liga o cais sudoeste ao mercado no nordeste, cruzando a ponte; o caminho permanece livre de obstáculos.

Sala: `rm_commercial_district`, 960×640 unidades. Entrada em (160,600); aliado em (800,95). Câmera segue Wilson com visão aproximada de 384×219. Colisões acompanham margens diagonais, prédios e limites; a água bloqueia o deslocamento. A arte anterior foi substituída após o usuário pedir um layout totalmente novo.

Após a vitória contra Isleide da Cidade, Wilson atravessa a saída norte da praça para chegar ao distrito. A saída fica bloqueada até essa vitória. O deslocamento é uma transição de mapa, preservando a regra de um único portal após as cavernas.

Importar a imagem original do novo personagem sem alterar seus pixels, com fundo transparente e escala próxima de Wilson. Identificação proposta: **Isleide Capitalista**, nome derivado do arquivo. Ele fica parado com uma leve respiração durante o encontro; a conversa começa ao se aproximar e avança por E ou Espaço.

## Diálogo no distrito

As seguintes falas fixam o sentido e o tom; podem ser divididas em páginas menores para caber na interface:

1. **Aliado:** “Antes de continuar, responda: quem lhe disse que derrotar os líderes dessas realidades resolveria as incursões?”
2. **Wilson:** “Newton. Ele me explicou que os mundos estavam entrando em colapso e que eu precisava estabilizá-los.”
3. **Aliado:** “As incursões existem. A mentira está na solução que ele lhe ofereceu. Você está removendo justamente aqueles que mantinham cada realidade em equilíbrio.”
4. **Wilson:** “Eu vi o que acontecia nesses lugares. O rei escondia informações. A cidade estava vazia. Por que eu deveria confiar em você?”
5. **Aliado:** “Eles tinham falhas, e alguns tomaram decisões terríveis. Ainda assim, eram âncoras entre os mundos. Newton transformou essas falhas em justificativas para enviar você contra todos eles.”
6. **Aliado:** “Você lembra do líder da cidade? Ele disse que as incursões haviam distorcido sua própria imagem. Newton já havia lhe contado outra versão antes que você pudesse ouvi-lo.”
7. **Wilson:** “Então minhas vitórias estavam enfraquecendo as realidades?”
8. **Aliado:** “Sim. Sem essas âncoras, ele poderá impor uma única ordem sobre todos os mundos. Não pretende impedir o colapso: pretende controlar o que vier depois.”
9. **Wilson:** “Como você sabe disso?”
10. **Aliado:** “Compare os avisos que recebeu com o que encontrou. Observe o padrão: você atravessa uma realidade, elimina sua figura central e recebe instruções para partir antes de entender as consequências.”
11. **Aliado:** “Agora me diga: de qual mundo você veio? O que se lembra antes de encontrar Newton?”
12. **Wilson:** “Eu… não sei. Não lembro de uma viagem. Simplesmente apareci lá.”
13. **Aliado:** “Esse é o paradoxo. Sua chegada não tem uma origem que você consiga reconhecer. Newton o colocou numa história cujo início foi escondido de você.”
14. **Wilson:** “Ainda não tenho certeza de tudo que você está dizendo. Mas preciso descobrir o que aconteceu comigo.”
15. **Aliado:** “Então voltaremos ao momento em que ele começou a orientá-lo. Antes que você complete o caminho que ele preparou, precisamos corrigir esse paradoxo.”
16. **Wilson:** “Eu vou com você. Desta vez, quero ouvir a verdade antes de lutar.”

## Retorno ao início e segundo Wilson

Usar uma sala separada, `rm_temporal_origin`, que reaproveita o mapa, enquadramento e colisões do tutorial. O tutorial normal continua disponível no início de uma nova partida. A volta é uma ruptura temporal narrada com uma breve transição visual, sem acrescentar objetos de portal ao percurso.

Wilson atual e o aliado chegam juntos. Um NPC com o sprite de Wilson representa seu passado e conversa com Newton. Existe apenas uma instância controlável de `obj_player`; o Wilson do passado tem identificação clara na cena e não recebe comandos do jogador.

1. **Newton, ao Wilson do passado:** “A matemática será sua âncora. Siga minhas orientações e estabilize as realidades.”
2. **Wilson atual:** “Espere! Não aceite essa missão sem perguntar o que acontece com os mundos depois das batalhas.”
3. **Wilson do passado:** “Quem é você? Por que tem o meu rosto?”
4. **Aliado:** “Ele é o resultado do caminho que Newton está prestes a impor a você. Voltamos para interromper esse ciclo.”
5. **Newton:** “Vocês confundem ordem com manipulação. Essas realidades precisam de uma inteligência capaz de conduzi-las.”
6. **Aliado:** “Você o enviou contra as âncoras dos mundos e chamou isso de salvação. Queria realidades enfraquecidas, dependentes das suas decisões.”
7. **Wilson atual:** “Eu não lembrava de onde vim. Você sabia disso desde o começo?”
8. **Newton:** “Sua origem era menos importante que sua função. Agora que trouxe essa interferência ao início, terei de corrigir o problema pessoalmente.”
9. **Wilson do passado:** “Então eu não vou seguir essas ordens.”
10. **Aliado:** “Wilson, fique comigo. Vamos enfrentar isso juntos.”

O Wilson do passado permanece fora do combate. A dupla enfrenta Newton no cenário inicial, reaproveitando a apresentação e os controles do sistema existente.

## Primeira etapa: superioridade de Newton

Newton tem 420 HP e usa um perfil matemático próprio, exibindo expressões com parênteses, multiplicação, divisão exata e potências simples, por exemplo `(18 x 7) + 12^2 - 9 = 261` e `(144 / 12) x (9 + 7) = 192`. As respostas são inteiras, sem divisão por zero, cálculos ambíguos ou entrada simbólica exigida. Mostrar o aviso “Resolva primeiro os parênteses; depois potências, multiplicações e divisões.”

A superioridade é narrativa: após três respostas enviadas, Newton derruba a dupla, mesmo que Wilson tenha acertado. Entrada vazia não conta; cura indisponível não consome turno. Newton não pode ser derrotado nessa etapa. A intenção da narrativa é mostrada pelo diálogo, e a derrota não abre um ciclo de reinício, não tira XP e não concede recompensa.

A Quebra de Paradoxo continua disponível: simplifica uma questão e permite a ação escolhida, mas não elimina a derrota prevista pelo roteiro. O botão temporário de pular batalha avança desta etapa para a cena de recuperação; não pula diretamente para a vitória final.

## Recuperação e apoio das realidades

Mostrar Wilson caído brevemente, Newton prestes a completar seu plano e o aliado tentando protegê-lo. Em seguida surgem as projeções dos quatro adversários do percurso: Isleide das Cavernas, guarda medieval, Isleide Rei e Isleide da Cidade. Reaproveitar seus sprites, respeitando a escala; Newton do treinamento não participa desse apoio.

1. **Newton:** “Vocês não compreendem sequer a estrutura que tentam defender.”
2. **Isleide das Cavernas:** “Ele não precisa compreender tudo sozinho.”
3. **Guarda:** “Você nos colocou uns contra os outros. Agora sabemos quem atravessava nossas fronteiras.”
4. **Rei:** “Conhecer uma ruptura não me deu o direito de controlar o destino. Também não dará esse direito a você, Newton.”
5. **Líder da Cidade:** “Minha imagem foi distorcida. Não permitirei que use a mesma mentira para apagar todos nós.”
6. **Wilson:** “Eu errei ao aceitar uma única versão. Se ainda puder corrigir isso, vou lutar com vocês.”
7. **Aliado:** “Cada realidade guarda parte da resposta. Juntas, elas tornam o impossível compreensível.”
8. **Wilson:** “Agora eu entendo. Essas contas… estão ficando mais fáceis.”

## Segunda etapa: compreensão compartilhada

Wilson se levanta; a dupla recupera a vida com máximo de 140 HP. Ataque de Wilson passa a 24–30 de dano e o aliado acrescenta 8 de dano quando o ataque é resolvido corretamente. Defesa, esquiva e cura mantêm suas regras, com a cura limitada ao novo máximo. Newton inicia a segunda etapa com 240 HP e conserva o ciclo anunciado de ataques normais, fortes e vulnerabilidade.

As contas passam a somas e subtrações pequenas e multiplicações de 2 a 5. As duas primeiras questões são somas entre 1 e 5 para tornar a mudança evidente. Depois, alternar operações simples. O auxílio funciona como um bônus exclusivo deste confronto; o XP acumulado continua sendo o mesmo. A interface mostra “APOIO DAS REALIDADES”. A Quebra de Paradoxo recebe uma nova carga para essa etapa e continua com uma ativação por tentativa.

Se o jogador perder nesta segunda etapa, poderá tentar novamente já com o apoio, sem repetir toda a revelação e sem retornar à derrota programada. A vitória final concede os 100 XP normais uma única vez. O botão de pular nessa etapa usa a mesma vitória e recompensa.

Encerramento proposto para esta sequência: Newton é impedido de assumir o controle, a ruptura é estabilizada e Wilson reconhece que precisa reconstruir a ligação entre as realidades. Não criar outra fase além desse encerramento neste pedido.

## Arte de Newton e organização

Usar temporariamente o sprite atual de Newton. Preparar uma referência de sprite dedicada para substituir sua aparência quando o usuário enviar a versão de vilão, sem reescrever o roteiro ou as duas etapas.

Separar cenário comercial, cena temporal e regras especiais de Newton em unidades próprias. O controlador de combate existente recebe apenas os pontos de integração necessários. O desafio pode oferecer um campo opcional de expressão textual; os desafios anteriores continuam usando os dois operandos e a operação atuais.

O progresso narrativo da sequência acompanha as mudanças de sala. Selecionar JOGAR no menu reinicia esse progresso junto com o XP. A passagem comercial e a volta temporal não podem iniciar duas conversas ou duas batalhas simultâneas. As fases anteriores, os sprites novos de Wilson e as transmissões existentes permanecem no percurso.

## Critérios de aceitação

- Cenário novo integrado, transparente nos sprites e consistente com as imagens anteriores; caminho, zoom e colisões conferidos dentro do jogo.
- Saída da praça liberada apenas após derrotar seu chefe; nenhuma adição de portal ao trajeto normal.
- Diálogo apresenta dúvida, evidências, origem desconhecida e retorno antes do plano de Newton terminar.
- Cena com duas versões de Wilson, aliado e Newton; somente uma versão controlável.
- Dupla visível na batalha; questões complexas legíveis e respostas matematicamente corretas.
- Primeira derrota inevitável após três respostas; recuperação acontece uma única vez e conserva XP.
- Apoio dos quatro adversários, aumento da força e simplificação real das contas.
- Reinício da segunda etapa e ambos os usos do botão de pular funcionam sem duplicar recompensa.
- Quebra de Paradoxo funciona nas duas etapas; jogos novos reiniciam o estado narrativo.
- Novos testes específicos, testes existentes completos, revisão e compilação Windows sem erros antes de declarar conclusão.
