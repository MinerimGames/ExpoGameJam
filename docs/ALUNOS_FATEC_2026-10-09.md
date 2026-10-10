# Quatro personagens na chegada do professor

As quatro fotos enviadas foram transformadas em sprites individuais no estilo pixel art das variantes. Cabelos, óculos, roupas e o gesto de positivo da quarta foto distinguem os personagens. Dois ficam de cada lado do corredor na sala de aula da Fatec, voltados para o professor, com respiração e reação discretas à sua aproximação. O corredor e o tempo de passagem para os créditos permanecem livres.

Arte criada com o ImageGen integrado e importada sem alterar os PNGs. Recursos, referências e instruções de geração: [README dos sprites](../output/imagegen/classroom-students/README.md). As âncoras dos sprites usam os pés; a renderização elimina franjas de transparência sobre o piso claro.

## Verificação desta atualização

- Teste antes da implementação: o encerramento detectou a ausência dos quatro personagens.
- Encerramento atualizado: 1.654 verificações, zero falhas; inclui quatro sprites distintos, posição, direção, animação, despedida das variantes, chegada do professor e passagem aos créditos.
- Créditos: 52 verificações, zero falhas.
- Segurança dos mapas: 271 verificações, zero falhas.
- Testes Python: 34 aprovados.
- Revisão independente do código e das duas capturas da sala: sem achados acionáveis.
- Exportações Windows e HTML5 em FinalRelease concluídas. Pacotes e ZIPs conferidos: 105 arquivos entregues, sem divergências ou corrupção.
- Microsoft Edge: 13 verificações de abertura, interface, escala, tela cheia e áudio, sem erros ou requisições falhas. Este teste web não percorreu todo o encerramento; a sequência completa foi verificada no jogo nativo.
- Executável entregue iniciou normalmente; áudio presente em 78 de 78 observações da própria sessão do jogo.

Captura nova: [professor e quatro personagens](../output/revision-20261009/verification/epilogue-fatec-professor.png).

Entrega atualizada em `C:/Users/jrhre/OneDrive/Desktop/Paradoxo de Wilson - Final`, com Windows, Web, ZIPs e lançador local. A cópia anterior foi preservada em `C:/Users/jrhre/AppData/Local/CodexBackups/ParadoxoDeWilson/before-classroom-students-20261009-102042` e `release-before-final-20261009-102234`.

Logs e manifestos desta entrega em `output/revision-20261009/`; as três execuções nativas novas ficam em `run-20261009-101147`, `run-20261009-101810` e `run-20261009-101916` dentro de `C:/Users/jrhre/AppData/Local/Temp/paradoxo-evento-tests/Revision-20261009`.

## Ajuste de escala e encaixe solicitado depois da primeira entrega

A escala inicial de 48 unidades deixava os quatro pequenos diante das carteiras. A escala agora é de 76 unidades, compartilhada com o professor apenas nesta cena. As posições laterais foram aproximadas do corredor (445 e 515), preservando espaço entre a silhueta inteira, as carteiras e o percurso central. Os sprites originais e suas proporções foram preservados.

O teste geométrico anterior verificava principalmente os centros dos personagens. Ele agora confere também a largura da silhueta ao tamanho exibido. Antes da correção, detectou seis falhas de escala/encaixe; depois dela, o encerramento passou 1.655 verificações com zero falhas (`run-20261009-104324/Epilogue`). Uma captura adicional durante a caminhada mostra o professor passando entre os dois pares sem sobreposição. A revisão visual independente não encontrou invasão das carteiras ou problema de apoio dos pés.

[Captura durante a chegada](../output/revision-20261009/verification/epilogue-fatec-students-walk.png).

Os pacotes Windows e Web foram recompilados e substituídos na pasta final. A verificação dos 105 arquivos e dos dois ZIPs passou sem divergências; o executável entregue abriu normalmente e o teste web passou 13 verificações sem erros. Backup desta correção: `before-classroom-fit-release-20261009-104600` e `release-before-final-20261009-104849` em `C:/Users/jrhre/AppData/Local/CodexBackups/ParadoxoDeWilson`.

## Novo posicionamento e botão de testes

Por novo pedido do autor, os quatro agora ficam no lado esquerdo perto do quadro verde, em uma fileira diante das primeiras carteiras. Posições: (228,204), (286,204), (344,204) e (402,204), mantendo altura 76 e o corredor do professor livre.

O botão **Pular Batalha** foi reativado no perfil padrão e em FinalRelease para testes do autor, substituindo a decisão anterior de removê-lo. Usa a saída normal de vitória, com recompensas e portais; na primeira batalha final de Newton mantém a derrota prevista no roteiro e a recuperação dos aliados. O rótulo indica TESTE TEMPORÁRIO.

Verificações nativas na configuração entregue: Release 6, Skip 64 e Epilogue 1.659, todas sem falhas. A suíte Skip percorreu Newton, Cavernas, Guarda, Rei, Steampunk e Cidade, incluindo conta aberta e derrota, além de conferir portais e desbloqueios. Antes da implementação, os testes detectaram corretamente o botão desativado e o posicionamento antigo.

Windows e Web atualizados na pasta final, com verificação dos 105 arquivos e ZIPs aprovada e abertura do executável sem erro. No navegador, o clique no botão durante uma conta aberta encerrou o combate e mostrou o diálogo normal de Newton; captura em `output/revision-20261009/web-smoke/skip-battle.png`. O teste web concluiu 14 verificações/capturas, sem erros ou requisições falhas. Backup desta entrega: `before-left-classroom-test-skip-20261009-110754` e `release-before-final-20261009-111126`.
