# Botão temporário para testar as fases

Todas as batalhas usam o botão amarelo **PULAR BATALHA / TESTE TEMPORÁRIO**, no canto superior direito. Ele funciona no menu de ações, durante uma conta e após uma derrota. Um clique encerra a luta e usa a mesma continuação de uma vitória normal, sem exigir confirmação adicional. Na tela de vitória o botão fica oculto, pois a luta já terminou.

- Newton mantém sua conversa pós-vitória; depois dela, seu portal libera a primeira fase.
- Isleide das Cavernas é removido e libera o único portal para o Bosque.
- O guarda é removido e libera a entrada do castelo.
- Isleide Rei leva diretamente à entrada da fase de outono.

A implementação fica no controlador compartilhado das batalhas. Assim, futuros oponentes que utilizem esse controlador também recebem o botão. Respostas e ações pendentes são limpas; clicar no botão durante uma conta não executa a ação que estava aguardando resposta.

## Desativar depois dos testes

Em `scripts/battle_system/battle_system.gml`, no início de `batalha_configuracao()`, mudar `test_skip_enabled: true` para `test_skip_enabled: false`. Essa opção desativa tanto a exibição quanto o funcionamento do botão nas próximas batalhas.

## Verificação

A fixture Skip falhou primeiro pela ausência da configuração de salto. Depois da implementação, passou com 40 verificações e zero falhas. Usou os inimigos e o controlador reais, cobrindo as quatro continuações, salto durante conta e após derrota, desativação da opção, ausência de salto ao apenas passar o mouse ou clicar fora do botão e limpeza da resposta pendente.

O teste chama diretamente o mesmo handler usado pelo clique. A transformação de coordenadas do mouse e a interrupção do evento após o salto foram conferidas na revisão das fontes; não houve automação de clique nativo. As quatro capturas foram conferidas visualmente. Revisão independente: nenhum problema relevante encontrado.

A suíte completa passou: dez grupos, 8.975 verificações, zero falhas. Totais: Input 18, Battle 8.187, Ambient 27, Integration 111, Castle 38, Route 48, Guard 197, Royal 283, Autumn 26 e Skip 40. Logs separados por grupo em `C:/Users/jrhre/AppData/Local/Temp/paradoxo-evento-tests/All-38a7b5b5c0c94b3990021e92b1120e59/run-20261006-140039`. A opção `-WorkspaceDirectory` permite reaproveitar o projeto/cache dos testes sem substituir os logs anteriores.

Compilação Windows VM, GameMaker LTS runtime 2026.0.0.23: `Igor complete.`, código zero. Binário, log e capturas: `C:/Users/jrhre/AppData/Local/CodexBuilds/ParadoxoDeWilson/evento-20261006-140146`. O cache da compilação anterior foi reutilizado para poupar espaço; o binário anterior foi preservado.

Backup dos quatro arquivos de produção alterados: `C:/Users/jrhre/AppData/Local/CodexBackups/ParadoxoDeWilson/battle-skip-20261006-140010`.
