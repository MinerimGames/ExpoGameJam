# Fundição do Tempo — expansão de 08/10/2026

## Percurso e história

Cavernas → Bosque → Vila → Castelo → Salão → Trono → Fundição do Tempo → Cidade fantasma → Agente → confronto com Newton → retorno à Fatec → créditos.

Após vencer o rei, Wilson chega à Fundição do Tempo. Newton apresenta o inventor Steampunk como alguém que aprisionou o futuro em um ciclo mecânico. O inventor admite que suspendeu os relógios para conter as incursões, mas argumenta que o mecanismo é uma âncora do equilíbrio entre mundos. Wilson teme pelos habitantes e o enfrenta para abrir o caminho. Essa primeira dúvida sobre as orientações de Newton prepara a revelação posterior do Agente: as figuras derrotadas também sustentavam suas realidades.

O novo adversário tem 205 HP. Sua dificuldade começa no nível matemático 6 e cresce até 8, alternando somas e multiplicações. As somas usam parcelas de 18..52 e 12..32 no primeiro nível; nos seguintes, cada teto cresce em 5. As multiplicações usam fatores de 2 até 7, chegando no máximo a 8. A Compreensão do jogador reduz esses números. A cidade seguinte começa no nível 8 e chega ao 10, mantendo uma progressão crescente.

## Cenário, câmera e movimento

Arte original de 1536×1024, apresentada em uma sala de 960×640 com câmera de 480×320 que acompanha Wilson. O caminho central é reto, com uma travessia horizontal livre entre as máquinas. Máquinas, suas partes altas, caixas e paredes têm colisões; as bordas da sala são fechadas. O arco de entrada recebe uma camada à frente do jogador para que Wilson passe por baixo.

Engrenagens, luzes e vapor se animam continuamente. A proximidade de Wilson aumenta suavemente a atividade das máquinas, sem modificar o sorteio das questões. Steampunk possui poses distintas de fala, ataque e defesa, além da pose original. As reações de batalha e a respiração usam o mesmo sistema dos demais personagens.

A saída ao norte permanece fisicamente fechada durante o encontro. Confirmar a vitória remove o adversário e o bloqueio, entrega 100 XP uma única vez e abre um portal visível no caminho central. Wilson precisa atravessá-lo para chegar à cidade. O botão temporário de pular batalha foi retirado do jogo normal e das duas versões finais.

## Quebra de Paradoxo

A habilidade é desbloqueada ao vencer Isleide das Cavernas. A tela de vitória explica:

- Pressione Q ou use o botão durante uma batalha.
- Se uma conta estiver aberta, ela é trocada imediatamente. Se não, a próxima ação válida recebe a conta fácil.
- A conta vira uma soma simples: 1+1, 2+2, até 5+5.
- Ainda é necessário digitar a resposta correta. A habilidade não causa dano sozinha.
- Pode ser usada uma vez por batalha. Outra batalha ou uma nova tentativa renova o uso.
- A Compreensão cresce com XP e reduz os números das contas normalmente, independentemente da habilidade.

O rei continua concedendo XP, mas não repete o desbloqueio nem repõe uma carga já usada na mesma batalha.

## Cidade, encerramento e créditos

Treze bandeiras da cidade receberam retratos novos do mesmo Isleide, em três poses: continência, discurso com mão aberta e braços cruzados. Os retratos se encaixam nos suportes existentes; o mapa e suas colisões foram preservados. As imagens fornecidas e os arquivos gerados são importados sem alteração dos pixels.

Na batalha de apoio e na despedida, Steampunk ocupa o lugar do soldado. Os seis destinos são Cavernas, Steampunk, Rei, Cidade, Agente e Wilson. O soldado permanece na fase medieval, pertencente à realidade do rei. Wilson retorna por último à Fatec. As animações de abertura, despedida, colapso e chegada foram preservadas.

Os créditos exibem Cabeludo, Adão, Akatsuki e Yandere. Os nomes e a sonoplastia de Guilherme Batistela permanecem conforme a solicitação anterior. A gravação enviada para a transformação de Newton continua incorporada ao jogo.

## Preservação

Backup anterior à expansão: C:/Users/jrhre/AppData/Local/CodexBackups/ParadoxoDeWilson/steampunk-expansion-20261008-020800.

Artes e referências: output/steampunk, output/city-flags e output/credits/Yandere0.png. Os recursos nativos usam nomes novos; os antigos continuam disponíveis sem serem consumidos pelos créditos. Os sprites, salas e objetos novos estão registrados em ParadoxoDeWilson.yyp.

## Verificação e entrega

Passaram 6.105 verificações nativas do GameMaker e 32 testes Python, sem falhas. Resultados e capturas estão em output/steampunk/verification. Foram exercitados percurso completo, bloqueios e saídas, diálogos, poses, oito estratégias de combate, derrota/nova tentativa, botão de teste, XP sem duplicação, habilidade, reset, créditos, áudio e despedidas.

| Suíte nativa | Verificações |
| --- | ---: |
| Steampunk | 436 |
| Progression | 1471 |
| Credits | 52 |
| Epilogue | 1590 |
| City | 338 |
| CityFlags | 9 |
| EvilNewton | 46 |
| Newton | 1354 |
| Audio | 55 |
| Royal | 285 |
| Skip | 64 |
| Route | 111 |
| Integration | 132 |
| CombatMotion | 26 |
| Scenery | 17 |
| MapSafety | 119 |

Pacote exportado pelo GameMaker: dist/ParadoxoDeWilson-Windows-steampunk-20261008. A cópia instalada está em C:/Users/jrhre/OneDrive/Desktop/Paradoxo de Wilson/ParadoxoDeWilson.exe. EXE, data.win, options.ini e ZIP foram conferidos por SHA-256; manifesto, export.log e logs de inicialização estão na pasta do pacote.

Backup dos quatro arquivos anteriores: C:/Users/jrhre/AppData/Local/CodexBackups/ParadoxoDeWilson/release-before-steampunk-20261008-024221.

O executável instalado iniciou e permaneceu no loop principal sem erro. A sessão de áudio do próprio jogo apresentou sinal em 73 de 73 observações do medidor Windows, sem mute. Não houve captura de áudio nem alteração de volume ou das configurações de outras aplicações.
