# Entrada steampunk e colisões dos sete prints

O portal após a vitória contra o rei agora coloca Wilson no piso interno
da Fundição do Tempo, à frente do arco de entrada. A passagem atrás dele
foi fechada por um colisor contínuo ligado às duas paredes laterais.

Foram corrigidas as bases das máquinas e as colunas externas nos dois lados
da fundição. Na cidade, os ajustes cobrem as faces dos canteiros junto ao
portão, a lateral do telhado da casa oeste, os caixotes e as bases das duas
bandeiras baixas. Essas bandeiras também receberam a profundidade apropriada.

As imagens enviadas foram comparadas com a arte existente para localizar
os contatos. A arte dos mapas foi preservada nesta correção. Os espaços de
piso visivelmente livres ao lado dos objetos continuam acessíveis.

Verificação realizada na versão corrigida:

- 32 testes Python, mais seis testes de geometria do percurso, sem falhas.
- Seis suítes nativas: 1.123 verificações, sem falhas. Incluem tentativas
  reais de movimento contra os objetos, entrada pelo portal do rei, bloqueio
  da passagem de volta, caminhada até o chefe e saída para a próxima fase.
- Varredura dos 15 mapas: nenhuma abertura nas bordas ou destino obrigatório
  inacessível.
- Revisão independente da geometria, das imagens e da profundidade das bandeiras.
- Exportações Windows e HTML5 concluídas em `FinalRelease`; os dois ZIPs
  passaram na verificação de integridade e correspondem às pastas entregues.
- O executável entregue abriu sem erros. No navegador, 13 verificações
  de abertura, controles, tela cheia, áudio e redimensionamento passaram,
  sem erros ou arquivos faltando.

Os dados de comparação com os prints estão em
`output/revision-20261009/collision-screenshots/measured-points.json`.
As capturas de chegada e do bloqueio ficam em
`output/revision-20261009/verification/steampunk-arrival-front.png` e
`steampunk-entry-blocked.png`.

A entrega atualizada permanece em
`C:/Users/jrhre/OneDrive/Desktop/Paradoxo de Wilson - Final`.
As exportações e a pasta web anteriores estão preservadas em
`C:/Users/jrhre/AppData/Local/CodexBackups/ParadoxoDeWilson/before-print-fix-20261009-090034`.
