# Menu, movimento de combate e áudio — plano de implementação

> Execução nativa nesta sessão, preservando o projeto atual e o executável anterior.

**Objetivo:** usar o cartaz fornecido como fundo completo do menu, animar todos os participantes de combate e corrigir a falha de som relatada pelo jogador.

**Arquitetura:** conservar sprites e regras de combate; centralizar apenas o movimento visual no controlador de batalha. Importar o PNG do usuário sem alterar pixels e desenhar a arte com proporção preservada. Diagnosticar o mixer do GameMaker e a saída Windows antes de escolher a correção de áudio.

**Tecnologias:** GML e GameMaker LTS2026; testes isolados no Runner, imagens nativas renderizadas e medição de áudio sem usar microfone.

**Restrições:** não mudar matemática, XP, colisão, progressão, escala básica, orientação dos sprites nem sequência narrativa; nenhuma alteração nas artes existentes; animação visual com delta_time e sem consumir aleatoriedade de combate.

## 1. Áudio
- [x] Comparar arquivo, recurso nativo, ganho do mixer e saída do Windows; identificar causa com evidência.
- [x] Acrescentar verificação de ganho/sinal, que o teste anterior de audio_is_playing não cobria.
- [x] Corrigir apenas a causa encontrada e verificar música, efeitos e passos.

## 2. Menu
- [x] Teste nativo observa sprite escolhido, proporção do cartaz, posições dos três botões, mouse e teclado.
- [x] Registrar spr_menu_poster a partir do PNG fornecido, sem editar pixels.
- [x] Modificar obj_main_menu Create, Draw GUI e Step: imagem inteira, sem título duplicado; botões em uma linha no rodapé.
- [x] Conferir captura de menu e início do tutorial.

## 3. Todos os combatentes
- [x] Teste nativo observa pixels do Draw GUI de Wilson e todos os inimigos em dois tempos diferentes; inclui Agente e apoiadores.
- [x] Acrescentar relógio e reações visuais no obj_battle_controller: respiração/balanço, avanço de ataque, recuo de dano, proteção, esquiva e brilho de cura.
- [x] Renderizar todos os retratos pela mesma transformação visual; manter facing e tamanho base.
- [x] Validar reações, limite de movimento, retornos a repouso, acertos/erros, vitórias/reinício e batalha final.

## 4. Entrega
- [x] Rodar regressões de combate, orientação, apresentação, sequência Newton, áudio, integração, progressão e menu.
- [x] Revisão independente do resultado; exportação Windows; abertura do EXE e conferência de áudio real.
- [x] Atualizar pasta de jogo na Área de Trabalho com backup e hashes.

## Focos de revisão
- Entrada rápida não pula transformação nem repete batalha.
- Nenhum som de passos ao empurrar colisor ou ficar em diálogo.
- Animação não muda máscara de colisão, RNG, HP ou ordem dos turnos.
- Cartaz inteiro e título legível; botões não cobrem rosto/título.
- Final musical não fica reiniciando nem vaza reprodução anterior entre salas.
