# O aliado e a revelação de Newton

Continuação implementada conforme roteiro e plano aprovados em 2026-10-07.

Após derrotar Isleide da Cidade, atravesse a saída norte da praça. O novo porto comercial usa canais, docas, barcos, ponte diagonal, armazéns de pedra clara e tendas coloridas, distribuídos de forma assimétrica. Wilson entra no cais sudoeste e percorre o caminho até o aliado no mercado nordeste. A câmera acompanha Wilson; margens e prédios bloqueiam o deslocamento.

O Isleide Capitalista explica a manipulação de Newton em 16 falas. Wilson questiona a versão apresentada, reconhece que não sabe de onde veio e aceita voltar ao início com o aliado. A imagem original do personagem foi importada sem alterar seus pixels, mantendo a transparência. [Cenário final e prompt da ferramenta integrada de imagens](C:/Users/jrhre/OneDrive/Desktop/ExpoGameJam-demo/output/imagegen/newton-story-prompts.md).

No retorno temporal, o cenário original do tutorial foi reaproveitado em uma sala própria. O Wilson do passado é um NPC separado; apenas o Wilson atual recebe comandos. Dez falas expõem o plano de Newton antes do confronto. Não foi acrescentado outro portal ao percurso.

## Batalha e recuperação

A dupla compartilha a barra de vida e enfrenta Newton com 420 HP. Suas questões usam operações combinadas, parênteses, potências e divisões exatas. Após três respostas, a superioridade de Newton provoca a derrota prevista pela história; não há perda de XP nem recompensa nessa etapa. O botão temporário de pular leva à recuperação. A Quebra de Paradoxo simplifica uma pergunta normalmente.

Wilson cai brevemente. Isleide das Cavernas, o guarda, Isleide Rei e Isleide da Cidade aparecem como projeções, oferecendo sua compreensão. As oito falas de recuperação levam à segunda etapa: dupla com 140 HP, Newton com 240 HP e ataque de Wilson de 24–30, mais 8 de auxílio do aliado. A interface mostra APOIO DAS REALIDADES.

As primeiras duas questões são somas de 1–5. Depois alternam somas pequenas, subtrações positivas e multiplicações de 2–5. A dupla recebe outra carga da Quebra de Paradoxo. Perder nessa etapa permite tentar novamente com o apoio, sem repetir toda a revelação ou a derrota inicial.

A vitória concede 100 XP uma única vez e inicia o encerramento com três falas. A ligação entre as realidades é estabilizada. Após a conversa, Wilson pode andar; na saída ao sul, E volta ao menu. JOGAR inicia novamente o tutorial normal, com história e XP reiniciados.

**Arte temporária:** Newton usa seu sprite atual. A referência `battle_sprite` de `obj_newton_final` está separada do roteiro e da lógica das etapas, permitindo substituir a aparência quando o usuário enviar a versão de vilão.

## Revisão do cenário como porto comercial

Em 2026-10-07, o usuário pediu um layout completamente diferente da cidade anterior e aprovou a direção de porto assimétrico. A arte foi substituída por `commercial-canals.png`, gerada com a ferramenta nativa de imagens. [Prompt final](C:/Users/jrhre/OneDrive/Desktop/ExpoGameJam-demo/output/imagegen/commercial-canals-prompt.md).

Entrada reposicionada em (160,600), aliado em (800,95), câmera mantida em 384×219. As colisões acompanham os cais e a ponte diagonal, bloqueando a água e as construções. O grupo Newton passou novamente em **1.349 verificações, zero falhas**, incluindo o percurso com comandos reais de teclado. Capturas da entrada, ponte e encontro foram inspecionadas em `output/verification/port`.

Compilação de produção concluída com código zero e “Igor complete.”, binário de 37.391.084 bytes: `C:/Users/jrhre/AppData/Local/CodexBuilds/ParadoxoDeWilson/evento-20261007-021200`. Logs dos testes: `C:/Users/jrhre/AppData/Local/Temp/paradoxo-evento-tests/All-38a7b5b5c0c94b3990021e92b1120e59/run-20261007-020759/Newton`.

Os 130 recursos continuam únicos, o registro do projeto permanece igual ao backup e o fundo importado coincide byte a byte com a arte gerada. Backup desta revisão: `C:/Users/jrhre/AppData/Local/CodexBackups/ParadoxoDeWilson/port-redesign-20261007-020011`.

![Ponte no novo porto](C:/Users/jrhre/OneDrive/Desktop/ExpoGameJam-demo/output/verification/port/newton-port-bridge.png)

## Verificações iniciais da continuação, antes da revisão visual

Os 15 grupos de testes passaram em **12.272 verificações, sem falhas**. O grupo Newton passou em 1.347 verificações: 400 expressões complexas com avaliação independente, 300 questões simples, percurso com teclado real, passagem bloqueada antes da vitória, dois Wilsons, uma batalha por vez, Questão vazia, cura indisponível, três respostas, erro com vida baixa, habilidade por Q, resposta por Enter, reinício, ambos os saltos de teste, recompensa única e novo jogo pelo menu.

Capturas em 640×380 e 960×540 foram inspecionadas, incluindo a expressão longa, as falas e a dupla. Os glifos de potência e divisão são legíveis. As camadas de tiles do tutorial clonado são iguais às originais, os bytes do sprite do aliado coincidem com o arquivo fornecido, os recursos registrados são únicos e as 72 fontes de produção coincidem com a cópia usada nos testes.

Compilação Windows VM no GameMaker LTS 2026.0.0.23 concluída com código zero e “Igor complete.”. Binário de 37.140.204 bytes, log e capturas em `C:/Users/jrhre/AppData/Local/CodexBuilds/ParadoxoDeWilson/evento-20261007-013715`.

Logs dos testes: `C:/Users/jrhre/AppData/Local/Temp/paradoxo-evento-tests/All-38a7b5b5c0c94b3990021e92b1120e59/run-20261007-013556`.

Revisão independente somente leitura favorável, sem achados. O revisor deixou a execução da compilação, dos testes completos e a captura em resolução maior para a verificação do agente principal; essas três verificações foram concluídas e confirmadas depois.

Decisão de execução: esta pasta não possui Git. Foram usados backup das fontes e cópia separada para testes, preservando o projeto nesta pasta. O custo caso essa escolha fosse inadequada seria não ter reversão por histórico Git; o backup permite restaurar os arquivos anteriores. Backup: `C:/Users/jrhre/AppData/Local/CodexBackups/ParadoxoDeWilson/newton-story-20261007-011839`.

Durante o desenvolvimento, os testes falharam primeiro pela ausência dos recursos, depois pela ausência da sala temporal, das regras de Newton e das projeções. Cada etapa foi executada novamente após a implementação. A compilação detectou uma expressão condicional ambígua no rótulo matemático; ela foi substituída por uma condição separada. Nenhum ponto menor foi adiado.

## Capturas

![Porto comercial com layout novo](C:/Users/jrhre/OneDrive/Desktop/ExpoGameJam-demo/output/imagegen/commercial-canals.png)

![Revelação do aliado](C:/Users/jrhre/OneDrive/Desktop/ExpoGameJam-demo/output/verification/newton/newton-revelation-5.png)

![Encontro com o passado](C:/Users/jrhre/OneDrive/Desktop/ExpoGameJam-demo/output/verification/newton/newton-origin.png)

![Cálculo complexo de Newton](C:/Users/jrhre/OneDrive/Desktop/ExpoGameJam-demo/output/verification/newton/newton-complex-large.png)

![Apoio dos antigos adversários](C:/Users/jrhre/OneDrive/Desktop/ExpoGameJam-demo/output/verification/newton/newton-recovery-3.png)

![Wilson e o aliado](C:/Users/jrhre/OneDrive/Desktop/ExpoGameJam-demo/output/verification/newton/newton-duo.png)

![Contas simplificadas](C:/Users/jrhre/OneDrive/Desktop/ExpoGameJam-demo/output/verification/newton/newton-easy.png)
