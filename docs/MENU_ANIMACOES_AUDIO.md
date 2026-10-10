# Menu, animações de batalha e áudio — 7 de outubro de 2026

## Resultado

O menu usa o cartaz enviado pelo usuário, preservado sem alterações nos pixels. O título e o subtítulo já presentes na imagem não são duplicados por texto do jogo. A arte inteira é encaixada com proporção preservada, e JOGAR, CONTROLES e SAIR ficam alinhados no rodapé. Setas/WASD, Enter e clique continuam funcionando. O cursor parado não anula uma seleção feita pelo teclado; mover ou clicar o mouse permite escolher outra opção.

Todas as figuras grandes de batalha usam respiração e balanço, incluindo Wilson, Isleide das Cavernas, Guarda, Rei, Líder da Cidade, Newton normal, Evil Newton e o Agente. Os quatro apoiadores do final também se movem. As ações acrescentam avanço de ataque, recuo e brilho de dano, postura de defesa, deslocamento de esquiva e brilho de cura. Os eventos expiram e a fila tem limite de 24; novas tentativas removem reações pendentes.

A animação usa apenas transformações visuais com delta_time, sem alterar HP, contas, XP, colisores, posições de exploração ou sorteios. A escala base e o espelhamento que faz Wilson olhar para o inimigo são preservados.

## Causa do áudio

Foi reproduzida a falha usando o Runner com o arquivo de produção data.win da pasta do jogo. A sessão do Runner estava silenciada no mixer de volume do Windows, apesar de o jogo emitir sinal: 79 de 79 medições tinham sinal; pico máximo 0,0947. O dispositivo padrão era Headphones (Fuxi-H3), com volume geral 100% e sem mute.

A correção removeu somente o mute da sessão do jogo identificado por PID. Volumes e demais aplicativos foram preservados. Após a correção, o jogo estava sem mute, com 79 de 79 medições positivas e pico 0,0778. Uma execução nova do Runner também conservou mute=false. Não foi necessário alterar as músicas ou os recursos de áudio do jogo.

A medição leu o indicador de nível exclusivo da sessão do jogo; não gravou amostras, não capturou áudio de outros aplicativos e não usou microfone. O teste anterior audio_is_playing verificava início de reprodução; o novo diagnóstico verifica também sinal e mute na saída Windows.

## Arquivos e evidência

- Arte preservada: output/menu/poster-original.png; recurso nativo spr_menu_poster.
- Movimento compartilhado: scripts/battle_motion/battle_motion.gml e eventos do controlador de batalha.
- Evidência do problema: output/audio/game_session_before.json.
- Evidência da correção: output/audio/game_session_after.json.
- Verificação após reabrir: output/audio/runner_relaunch.json.
- Diagnóstico reproduzível: tools/diagnose_audio_output.py, consulta por sessão identificada.
- Captura nativa de menu: C:/Users/jrhre/AppData/Local/ParadoxoDeWilson/menu-poster.png.
- Backup anterior: C:/Users/jrhre/AppData/Local/CodexBackups/ParadoxoDeWilson/menu-motion-audio-20261007-145644.

## Validação

Os testes novos foram executados antes das mudanças: CombatMotion encontrou 11 falhas em 13 verificações; MenuPoster inicialmente encontrou as duas funções ausentes, e depois detectou a ausência da proteção contra cursor parado. Os testes após as correções verificam pixels reais do Draw GUI, reações e retorno ao repouso, participantes do final, limites da fila, botões, navegação, clique e início do tutorial.

A revisão independente encontrou o conflito entre teclado e hover contínuo e o recorte da dica inferior. Ambos foram corrigidos e conferidos novamente. A revisão não encontrou outros problemas concretos.

Testes Python de áudio, diagnóstico, colisores e renderização: 21, zero falhas. Resultado final dos testes no Runner e entrega Windows serão acrescentados abaixo após a execução.

### Testes finais do Runner

11 grupos de regressão, 11419 verificações, zero falhas.

| Grupo | Verificações | Log |
|---|---:|---|
| MenuPoster | 12 | C:/Users/jrhre/AppData/Local/Temp/paradoxo-evento-tests/WorldFinal-20261007/run-20261007-151035/MenuPoster/runner.log |
| Battle | 8187 | C:/Users/jrhre/AppData/Local/Temp/paradoxo-evento-tests/WorldFinal-20261007/run-20261007-151045/Battle/runner.log |
| BattleFacing | 105 | C:/Users/jrhre/AppData/Local/Temp/paradoxo-evento-tests/WorldFinal-20261007/run-20261007-151056/BattleFacing/runner.log |
| Progression | 1467 | C:/Users/jrhre/AppData/Local/Temp/paradoxo-evento-tests/WorldFinal-20261007/run-20261007-151111/Progression/runner.log |
| Integration | 120 | C:/Users/jrhre/AppData/Local/Temp/paradoxo-evento-tests/WorldFinal-20261007/run-20261007-151124/Integration/runner.log |
| Skip | 52 | C:/Users/jrhre/AppData/Local/Temp/paradoxo-evento-tests/WorldFinal-20261007/run-20261007-151152/Skip/runner.log |
| Presentation | 13 | C:/Users/jrhre/AppData/Local/Temp/paradoxo-evento-tests/WorldFinal-20261007/run-20261007-151205/Presentation/runner.log |
| Newton | 1349 | C:/Users/jrhre/AppData/Local/Temp/paradoxo-evento-tests/WorldFinal-20261007/run-20261007-151220/Newton/runner.log |
| EvilNewton | 39 | C:/Users/jrhre/AppData/Local/Temp/paradoxo-evento-tests/WorldFinal-20261007/run-20261007-151257/EvilNewton/runner.log |
| Audio | 51 | C:/Users/jrhre/AppData/Local/Temp/paradoxo-evento-tests/WorldFinal-20261007/run-20261007-151311/Audio/runner.log |
| CombatMotion | 24 | C:/Users/jrhre/AppData/Local/Temp/paradoxo-evento-tests/WorldFinal-20261007/run-20261007-151336/CombatMotion/runner.log |

## Entrega conferida

Exportação Windows concluída. O executável atualizado foi aberto na própria pasta da Área de Trabalho e permaneceu ativo sem erros fatais. A sessão de áudio estava sem mute; 80/80 medições tinham sinal sonoro; pico máximo 0.1628. Os quatro arquivos instalados foram conferidos por SHA256 contra o pacote exportado.

- [Abrir executável atualizado](<C:/Users/jrhre/OneDrive/Desktop/Paradoxo de Wilson/ParadoxoDeWilson.exe>)
- [Pacote ZIP](<C:/Users/jrhre/OneDrive/Desktop/Paradoxo de Wilson/ParadoxoDeWilson.zip>)
- [Diagnóstico do áudio do executável](<C:/Users/jrhre/OneDrive/Desktop/ExpoGameJam-demo/dist/ParadoxoDeWilson-Windows-menu-animacoes-audio-20261007/desktop_audio_output.json>)
- [Cartaz original preservado](<C:/Users/jrhre/OneDrive/Desktop/ExpoGameJam-demo/output/menu/poster-original.png>)
- [Captura do menu](<C:/Users/jrhre/AppData/Local/ParadoxoDeWilson/menu-poster.png>)

Backup do executável anterior: C:/Users/jrhre/AppData/Local/CodexBackups/ParadoxoDeWilson/release-before-menu-animacoes-audio-20261007-151603.
