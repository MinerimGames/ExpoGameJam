# SDD ledger — plan: docs/superpowers/plans/2026-10-06-merge-castelo.md

Ruling: executar nesta pasta sem Git/worktree, preservando o método anterior — pedido explícito de união nesta versão e backup completo de 213 arquivos — custo se errado: restauração pela cópia externa.
Ruling: preservar todo o código local e as salas anteriores — GML incoming não contém função nova; layouts antigos são iguais à base e local adiciona ambientação — custo se errado: alterações da fase omitidas; comparação independente confirma inexistência delas.
Ruling: manter os quatro output_tileset locais — arquivos do ZIP têm pixels RGBA idênticos, só codificação diferente — custo se errado: diferença de metadados PNG; originais incoming preservados na extração.
Ruling: manter encerramento e importar salas sem ligação nova — escolha explícita do usuário — custo se errado: fase só acessível no editor/testes até futura conexão solicitada.
Preflight: Tarefa1 produz contexto e manifesto usados por Tarefa2; Tarefa2 produz registros/assets usados pela fixture e revisão da Tarefa3. Interfaces consistentes.
Backup e incoming: C:/Users/jrhre/AppData/Local/CodexMerges/ParadoxoDeWilson/castelo-20261006-043329.
Tarefa1 inventário: 54 arquivos novos, 23 recursos novos; divergências funcionais do código são apenas melhorias locais. Rooms antigas preservadas. Usuário confirmou fluxo anterior.
Tarefa1 RED: validate_merge_castelo falhou por registros/arquivos ausentes; validation-red.log. Fixture Castle falhou corretamente por rm_vila não registrada, log Castle-755a567be26545d9a209baa3cc76ae98.
Tarefa2 complete: 54 arquivos copiados intactos, 23 registros/2 folders/3 rooms adicionados; 75 recursos; validate_merge_castelo e validate_evento passaram. Todos os arquivos de produção existentes exceto .yyp mantidos byte a byte.
Tarefa3 carregamento GREEN: Castle32, zero falhas, log Castle-f72aeed6700f410fb2021640d8e01fa2. As três salas carregaram com player/colisores/câmera reais, WASD/setas e retorno ao menu.
Tarefa3 Integration RED→GREEN: falha intermitente na fixture por borda de E processada entre Steps; alternância release/press em Integration_Create/Step corrigiu a causa sem tocar produção. Integration23 passou; Input18/Battle8187/Ambient27/Castle32 também passaram em execuções finais individuais.
Compilação final: C:/Users/jrhre/AppData/Local/CodexBuilds/ParadoxoDeWilson/evento-20261006-044244 — Igor complete, exit0, produção com 75 recursos.
Final review: self-review read-only — validador merge passou, validador anterior passou, testes e compilação passaram; revisão subagente não ficou disponível por limite de uso. Nenhum Critical/Important encontrado. O pacote final está em docs/RELATORIO_MERGE_CASTELO.md.
