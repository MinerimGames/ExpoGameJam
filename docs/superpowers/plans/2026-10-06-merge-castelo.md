# União da fase do castelo Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans para execução nesta pasta, com backup e revisão independente. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Unir os recursos novos do ZIP ao projeto atual sem perder as melhorias anteriores.

**Architecture:** Manter todos os arquivos existentes de produção, exceto a união dos registros no projeto. Copiar intactos somente os 54 arquivos novos e registrar suas 23 resources, pastas e salas. Não alterar o percurso de jogo.

**Tech Stack:** GameMaker LTS2026, GML, Python e PowerShell locais.

**Spec:** Pedido do usuário de unir as versões sem perder nada; resposta de 2026-10-06: importar as salas e manter o encerramento atual após as cavernas. Comparação completa e backup em `C:/Users/jrhre/AppData/Local/CodexMerges/ParadoxoDeWilson/castelo-20261006-043329`.

## Global Constraints

- Preservar WASD/setas, combate estratégico, matemática, ambientação, sprites, mapas e câmera anteriores.
- Não reintroduzir a cena pós-vitória removida.
- Importar rm_vila, rm_castelo e rm_bosque integralmente; manter o encerramento atual.
- Não sobrescrever código com a versão antiga do ZIP. Não criar Git ou substituir o projeto inteiro.
- Preservar original ZIP, extração e backup SHA-256 fora do projeto.

## Review Focus

- Recursos existentes e novos registrados exatamente uma vez, com caminhos válidos.
- Sala inicial, ordem anterior e encerramento mantidos.
- Nenhum tile, colisor, spawn ou pixel novo perdido na cópia.
- Imagens output_tileset divergentes compartilham os mesmos pixels; preservar a versão local.
- Salas novas têm viewport diferente, mas precisam carregar com player e colisores corretos.

## Tarefa 1: Inventário e preservação

**Files:** comparison.json, before-merge-manifest.json e backup externo; tools/validate_merge_castelo.py.

**Interfaces:** validador recebe --context comparison.json; compara source/workspace/backup.

- [x] Extrair ZIP com validação de caminhos; guardar os 213 arquivos existentes e manifesto.
- [x] Comparar arquivos, GML/base comum e rooms; obter escolha do usuário sobre acesso.
- [x] Criar validador e executá-lo antes do merge: falhou por 23 recursos/54 arquivos ausentes.

## Tarefa 2: União dos recursos

**Files:** ParadoxoDeWilson.yyp; novos rooms, sprites e tilesets do ZIP.

**Interfaces:** resources, Folders e RoomOrderNodes recebem apenas itens ausentes. Demais propriedades do projeto permanecem iguais.

- [x] Copiar 54 arquivos novos intactos, sem sobrescrever nenhum existente.
- [x] Unir 23 registros de recursos, duas pastas e três salas, mantendo a sala inicial atual.
- [x] Executar validador: 75 recursos, conteúdo novo íntegro e todos os recursos anteriores protegidos.

## Tarefa 3: Verificação e entrega

**Files:** tests/evento/Castle_{Create,Step}.gml; tools/evento_project.py e run_evento_tests.ps1; docs/RELATORIO_MERGE_CASTELO.md; diário.

- [x] Carregar as três rooms em fixture temporária, confirmar player/colisores/câmera, input antigo e troca de sala sem erro.
- [x] Executar Input, Battle, Ambient, Integration e Castle; compilar o projeto real.
- [x] Revisão final read-only do autor após falha de disponibilidade do revisor; nenhum defeito relevante demonstrado.
- [x] Relatório com arquivos preservados/importados, acesso escolhido, backup, testes e compilação.

Autorrevisão: integração limitada aos recursos já fornecidos, sem novo sistema ou mudanças de narrativa; todos os conflitos classificados; nenhum passo depende de uma conexão de salas não solicitada.
