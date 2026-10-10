# Cutscene final: trono vazio e futura revelação

Registro histórico. O encerramento e a entrega atuais estão documentados em [Cutscene final de 96 quadros](CUTSCENE_FINAL_96_QUADROS_2026-10-09.md).

Esta revisão substitui a cena final descrita em `CUTSCENE_SECRETA_TRONO_2026-10-09.md`. O encerramento mantém a chegada do professor, FIM, corrupção verde, tela preta, citação de Isaac Newton e as quatro imagens de aproximação até a escadaria.

## Quinta imagem

Foi utilizada a imagem anexada `Trono Gótico no Vazio Verde.png`, copiada integralmente para `datafiles/secret_throne/05_Trono_Vazio.png`. Não havia um novo ZIP entre os anexos desta revisão. As quatro primeiras imagens continuam as do ZIP anterior.

O recurso existente `spr_secret_throne_05` foi reaproveitado: nenhum personagem foi acrescentado e nenhum sprite novo foi gerado. A imagem mantém suas proporções, sem recorte, movimento de câmera ou alteração de seus pixels. Não foi aplicada pulsação, pois ela era opcional.

`SCENE_05` dura cinco segundos, com entrada suave de 0,6 segundo. A música diminui gradualmente; o ambiente grave permanece e desaparece antes de uma pausa de silêncio de aproximadamente 0,35 segundo. A imagem fica imóvel e não desaparece para preto ao terminar.

## Transição contínua

Ao terminar `SCENE_05`, o controlador entra em `REVEAL_SEQUENCE`, mantendo exatamente a mesma imagem, tamanho, posição e opacidade. Este estado aguarda sem limite de tempo e permanece silencioso. Não abre créditos nem retorna ao menu automaticamente.

A futura animação de 24 quadros não foi implementada. O sistema de animação dos personagens continua como antes. O comando manual já existente para pular a cutscene foi preservado: solte as teclas e depois segure Enter, E, Espaço ou Esc por um segundo para seguir aos créditos existentes.

## Como conectar os 24 quadros posteriormente

Os pontos de integração estão em `segredo_trono_config()`, no arquivo `scripts/secret_throne/secret_throne.gml`. Os três callbacks ficam `undefined` nesta versão:

- `on_reveal_enter(ending)`: chamado uma única vez ao entrar em `REVEAL_SEQUENCE`. Inicialize aqui o futuro recurso e seu relógio de reprodução.
- `on_reveal_step(ending, dt)`: chamado a cada atualização enquanto o estado aguarda; `dt` está em segundos. Atualize aqui o avanço dos 24 quadros e as entradas da futura sequência.
- `on_reveal_draw(ending, width, height)`: chamado no desenho da interface depois do trono vazio. Desenhe aqui a futura revelação sobre o enquadramento preservado, usando as dimensões recebidas.

Somente quando a futura sequência terminar, chame `segredo_trono_finalizar(ending)`. Essa função encerra a cutscene, limpa seus efeitos sonoros e libera os créditos já existentes. Não a chame ao entrar no estado: isso interromperia a continuidade desejada. A integração deve continuar usando o mesmo controlador `obj_fatec_ending`, sem criar outro encerramento concorrente.

## Verificação desta revisão

- Encerramento nativo: 2.480 verificações, zero falhas, incluindo a chegada à sala, toda a sequência e a espera em `REVEAL_SEQUENCE`.
- Créditos nativos: 89 verificações, zero falhas, incluindo entrada única no estado, silêncio, espera sem créditos automáticos, conclusão pelo callback e comando manual para pular.
- Os testes utilizam um callback temporário de conclusão apenas nas cópias de teste; esse callback não faz parte do jogo entregue.
- A execução HTML5 confirmou os dez estados, a espera sem avanço automático, a entrada de áudio habilitada e o comando manual para pular; nenhum erro de execução, requisição ou carregamento foi registrado. Relatório: `output/revision-20261009/web-secret-throne/report.json`.
- O executável Windows entregue iniciou e entrou no ciclo principal sem erro. Os arquivos e os ZIPs das duas versões passaram na verificação de integridade contra a exportação e os manifestos: `output/revision-20261009/package-verification.json`.
- A imagem anexada, o arquivo canônico e as duas cópias importadas do sprite possuem o mesmo SHA-256: `8bb4ede79cff14389db42d00f62d1914b8f9d81fb811c55d834d7699326127d5`.
