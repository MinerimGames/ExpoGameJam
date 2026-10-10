# Novos contatos de colisão e textos da despedida

Pedido: corrigir os 13 novos prints e tornar nítidos os textos dos portais no encerramento.

Os prints foram registrados contra as imagens originais dos mapas, sem modificar a arte. Os contatos projetados e a quantidade de correspondências estão em `output/revision-20261009/collision-screenshots-2/measured-points.json`.

Correções:

- Salão do castelo: braços e hastes dos cinco candelabros apontados, caixa de madeira, face da parede sudoeste e superfície/vaso do móvel inferior direito.
- Fundição: hastes e braços das duas tochas inferiores e os dois apoios da entrada, unidos à parede traseira já fechada. A chegada continua em `(480,520)`, à frente da entrada.
- Cidade: o canteiro cercado e seu pilar no canto noroeste ficam sólidos.
- Despedida: nomes dos seis portais e mensagem inferior usam a fonte SDF da interface em tamanho legível. Os nomes são desenhados na interface, com fundo escuro e espaçamento para evitar sobreposição, mantendo a posição de cada portal. Ordem, destinos, diálogos e animações foram preservados.

Validação:

- A regressão dos contatos reproduziu as 13 falhas antes da alteração e passou após a correção.
- A regressão nativa dos textos reproduziu uma falha antes da alteração; o encerramento corrigido passou por 1.621 verificações, incluindo os seis rótulos, limites, legibilidade e ausência de sobreposição.
- Cinco baterias nativas: MapSafety (271), Epilogue (1.621), Steampunk (563), Route (112) e Scenery (17), total de 2.584 verificações sem falhas.
- 34 testes Python e seis testes adicionais de geometria passaram. A auditoria completa dos 15 mapas não encontrou saídas pelas bordas nem destinos obrigatórios inacessíveis.
- Revisão independente confirmou que as diferenças dos mapas são somente os colisores previstos; o salão e a fundição preservam o acesso ao piso livre, e a cidade fecha o acesso ao canteiro cercado.

O projeto, as versões Windows/Web e as capturas nativas são atualizados juntos. Os resultados de exportação e integridade ficam em `output/revision-20261009`.

Entrega verificada: as duas exportações FinalRelease terminaram sem erros; o executável da pasta final abriu e produziu áudio, e a versão HTML5 passou nos 13 testes de navegador sem erros nem requisições falhas. A conferência dos 104 arquivos entregues, dos ZIPs e dos hashes em relação à exportação não encontrou divergências. Pasta: `../Paradoxo de Wilson - Final`.
