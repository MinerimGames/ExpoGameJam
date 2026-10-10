# Desfecho: colapso e retorno à Fatec

O pedido amplia o desfecho existente após a segunda batalha de Newton. A primeira derrota e a recuperação com os aliados continuam. A vitória final leva à despedida, seis portais diferentes devolvem Cavernas, Guarda, Rei, Líder da Cidade, Agente e Wilson às suas próprias realidades. O Wilson do passado é um eco do início corrigido e se dissolve, em vez de criar uma sétima versão sem origem. Wilson é o último a partir; as fraturas da sala culminam numa transição para sua realidade.

O retorno acontece numa sala de aula moderna da Fatec criada em pixel art, com carteiras laterais e corredor central. Wilson aparece como professor, aproxima-se da área do quadro e a história termina. A passagem para créditos fica pronta, com apenas o título FIM enquanto o usuário prepara as instruções dos créditos; nenhum nome de autoria é inventado.

Escopo autorizado pelo pedido e pelas instruções de continuidade: implementação, arte, verificação e atualização do executável local. Backup anterior: C:/Users/jrhre/AppData/Local/CodexBackups/ParadoxoDeWilson/fatec-epilogue-20261007-233216.

## Verificação planejada

- Teste nativo novo deve falhar antes de alterar o final antigo.
- Validar portais individuais, ordem de partida, bloqueio de movimento e de reentrada, XP uma vez, chegada à sala e passagem para o estado de créditos.
- Conferir capturas nativas dos portais e do professor; preservar proporções e corredor sem obstáculos.
- Revalidar batalhas finais, transformação, áudio, progressão, menu e animações.
- Exportar e abrir o executável novo, mantendo cópia do pacote anterior.

## Recursos visuais

Ferramenta image_gen nativa. Imagens copiadas integralmente para [fatec-classroom.png](C:/Users/jrhre/OneDrive/Desktop/ExpoGameJam-demo/output/imagegen/fatec-classroom.png) e [wilson-professor.png](C:/Users/jrhre/OneDrive/Desktop/ExpoGameJam-demo/output/imagegen/wilson-professor.png), com transparência preservada no professor. Prompts finais completos e referência em [fatec-generation.md](C:/Users/jrhre/OneDrive/Desktop/ExpoGameJam-demo/output/imagegen/fatec-generation.md).

## Evidências iniciais

- O primeiro teste nativo reproduziu uma falha de ordem de criação: obj_player criava o áudio antes de obj_temporal_scene inicializar scene_mode. A consulta musical agora verifica a inicialização da cena e de Evil Newton. O problema foi localizado no diagnóstico do próprio Runner, sem alterar o mixer de outros aplicativos.
- Após essa correção, o teste RED do final antigo produziu duas falhas esperadas em oito verificações: não havia despedida com movimento bloqueado nem seis portais.
- O primeiro GREEN do final novo passou 1.577 verificações sem falhas (run-20261008-000120/Epilogue). As capturas revelaram que o zoom anterior cortava a cabeça dos apoiadores; a câmera da despedida foi aberta para mostrar a sala inteira.
- Os 24 testes Python passaram, incluindo os novos recursos, preservação da transparência e corredor de chegada.

## Validação final — 8 de outubro de 2026

O enquadramento e a direção foram corrigidos e cobertos por teste antes da correção: três falhas esperadas em câmera, sinal sonoro inicial de colapso e direção da caminhada para a direita. O GREEN final passou 1.582 verificações do desfecho. As fraturas começam discretamente durante a fala do Agente, antes da caixa de diálogo; após a conversa os seis portais abrem, os apoiadores atravessam um a um, o Agente parte e Wilson sai por último. O cenário se rompe e a sala de aula surge. O professor atravessa o corredor e se acomoda antes da tela FIM.

As oito suítes nativas passaram 4.629 verificações com zero falhas: Epilogue 1.582, Newton 1.349, EvilNewton 39, Audio 51, Progression 1.467, MenuPoster 12, CombatMotion 24, BattleFacing 105. Os 24 testes Python também passaram novamente. Logs em C:/Users/jrhre/AppData/Local/Temp/paradoxo-evento-tests/FatecEpilogue-20261007, execuções run-20261008-004048 até run-20261008-004443.

Uma revisão independente conferiu a sala, renderização, portais, guardas de reentrada, XP único, áudio e reset. O único achado foi a caminhada frontal num percurso para a direita; foi corrigido e verificado novamente. A conferência final das capturas não encontrou outro problema concreto.

Capturas reais salvas em output/finale: epilogue-six-portals.png, epilogue-wilson-last.png, epilogue-fatec-arrival.png, epilogue-fatec-professor.png e epilogue-fatec-credits.png. A comparação com o backup preservou 880 arquivos, sem nenhum removido; alterações existentes se limitam à cena final, falas, áudio e suporte aos testes/importação. Os assets anteriores, mapas, combate e geradores matemáticos foram preservados.

## Créditos

A história chega ao estado credits_ready após nove segundos de chegada, pausa e fade. Até o autor enviar nomes, ordem e conteúdo, aparece FIM com o título do jogo. Enter/E com uma nova pressão retorna ao menu; segurar uma tecla da despedida não encerra a cena. Esse é o ponto de entrada para a próxima instrução de créditos.

## Executável atualizado

Pacote novo: C:/Users/jrhre/OneDrive/Desktop/ExpoGameJam-demo/dist/ParadoxoDeWilson-Windows-final-fatec-20261008. O instalável portátil foi copiado para C:/Users/jrhre/OneDrive/Desktop/Paradoxo de Wilson (executável, data.win, options.ini e ZIP), com SHA-256 dos quatro arquivos confirmado contra a exportação. A versão anterior está em C:/Users/jrhre/AppData/Local/CodexBackups/ParadoxoDeWilson/release-before-final-fatec-20261008-004606.

O executável instalado foi aberto por oito segundos, entrou no loop principal e permaneceu ativo sem erro. A saída Windows da própria sessão do jogo estava sem mute e apresentou sinal nas 56 de 56 medições, pico 0,162766814. Nenhum volume/mute precisou ser alterado e nenhum áudio de outros aplicativos foi capturado. Evidências: release-manifest.json, desktop-smoke.log e desktop_audio_output.json dentro do pacote.
