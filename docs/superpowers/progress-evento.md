# SDD ledger — plan: docs/superpowers/plans/2026-10-02-evento-combate-ambientacao.md

Execução nativa aprovada pelo usuário em 2026-10-02.

Ruling: trabalhar nesta pasta e manter backup completo, sem scripts Git de workspace/commits — a especificação aprovada proíbe inicializar Git e o projeto não é repositório — custo se errado: recuperação manual pelo backup.

Pre-flight: tarefa 2 produz configuração/intenção/ambiente consumidos pelas tarefas 3 e 4; campos e assinaturas consistentes.
Pre-flight: tarefa 1 mantém o contrato do jogador consumido pelas tarefas 2 e 5; nenhum renomeamento.
Pre-flight: tarefa 4 registra o objeto usado pela tarefa 5; testes ficam em projeto temporário, não no .yyp de produção.

- [ ] Task 1: controles e preservação da base.
- [ ] Task 2: combate, tutorial e reinício.
- [ ] Task 3: interface e contexto.
- [ ] Task 4: ambientação.
- [ ] Task 5: integração, revisão e entrega.

Backup: ver caminho em `%TEMP%/paradoxo-evento-backup-path.txt`; cópia dos 185 arquivos originais com manifest SHA-256.
Task 1: complete — Input RED: setas e combinações mistas falharam; GREEN: 18/18 verificações GML reais. WASD e colisões mantidos. Ruling: teste de teclado espera frames reais, pois simulação no Create não é processada imediatamente; custo: teste leva alguns segundos.
Task 2: complete — Battle RED: cura cheia consumia ação e não existia turno estratégico. GREEN: 8187 verificações, zero falhas. Simulações: ataque 0/2000; defesa/cura 2000/2000, 12.21 turnos; esquiva/cura 1884/2000, 11.91 turnos. Matemática original mantida.
Task 4: complete — Ambient RED: registro ausente. GREEN: 26 verificações, limite de 40 e expiração em 10000 atualizações, entradas/saídas e duplicação testadas. Cache: tutorial 1 origem de folhas; rio 35 pontos de água/8 folhas; lagoa 61 pontos/17 folhas/1 fogueira. Validador: 52 recursos, originais preservados. Ruling: helper de inspeção Visual fica apenas no projeto temporário, para observar os cenários e a UI sem inserir atalhos de debug na demo; custo: inspeção visual não representa percurso manual inteiro.
Task 5: Integration GREEN 23/23: menu, diálogos, treino, portal, salas, chefe, derrota/reinício, fim e nova sessão. Ruling: integração aciona callback real do menu com fixture que afasta área de hover; motivo: mouse externo mudava a opção ao simular Enter; custo: input de menu deve ser verificado na inspeção nativa.

Final verification: All GREEN Input18, Battle8187, Ambient27, Integration23 = 8255 checks, 0 failures. Validator GREEN52 resources. Real compile exit0 Igor complete, build C:/Users/jrhre/AppData/Local/CodexBuilds/ParadoxoDeWilson/evento-20261002-010351.
Task 3: implementação complete; inspeção nativa parcial: forte/vulnerável, conta teclado2+9=11, cura cheia, janela640x380 e fullscreen legíveis. Botões reais/regra verificados GML; inspeção nativa de todos por ambos inputs não concluída.
Task 4: testes finais27/27; amostras estáveis60FPS nas três salas, sem garantia universal. Percurso visual de todas áreas não concluído.
Task 5: automação e compilação complete; relatório com18tópicos criado. Percurso manual completo permanece não executado.
Final review: reviewer fresh-context gpt-6-astra começou, confirmou185 hashes/11arquivos alterados, interrompido por limite de uso antes de parecer. Revisão do autor realizada, sem novo achado funcional; não apresentada como revisão independente concluída.
Final: Ruling: preservar diário/documentos/backup e mudanças nesta pasta — especificação sem Git, não há histórico para substituir o diário; custo se errado: documentação adicional.
Final: Ruling: encerrar com escopo de validação explícito e revisão do autor — usuário pediu finalizar, revisor bloqueado por limite de uso; custo: permanece sem parecer independente e sem partida manual completa. Todos os passos não executados permanecem abertos no plano.
Final: minor (deferred): nenhuma lista final independente disponível; não confundir parecer interrompido com aprovação sem achados.
