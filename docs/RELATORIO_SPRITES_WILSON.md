# Novo personagem e remoção do texto de demo

As duas imagens fornecidas foram importadas sem alterar seus pixels. Wilson agora usa esse visual em todos os mapas, com vistas de frente, costas e laterais; parado, tem uma leve respiração e, andando, alterna dois passos. A direção esquerda reflete a arte lateral da direita. Ataque, defesa, cura e esquiva possuem poses próprias nas batalhas.

A altura visual foi normalizada em 28 unidades do mapa, mantendo a escala própria dos cenários. As imagens são transparentes. A máscara original de colisão dos pés continua independente da aparência, preservando o movimento e as passagens pelas salas.

O título de entrada não mostra mais “DEMO”. O botão “FINALIZAR DEMO” da vitória nas cavernas agora diz “CONTINUAR”, com a mesma saída para o portal e o percurso medieval.

## Artes e prompts

Foram integrados 13 sprites: dois originais, uma vista lateral parada, seis passos e quatro ações. As 11 variantes foram criadas com a ferramenta integrada de imagens. [Lista dos arquivos finais e prompts utilizados](C:/Users/jrhre/OneDrive/Desktop/ExpoGameJam-demo/output/imagegen/wilson-prompts.md).

## Verificação

Os 14 grupos de testes passaram em 10.925 verificações, sem falhas. O novo grupo PlayerArt passou em 38 verificações, incluindo seleção real das quatro direções, alternância dos passos, parada, máscara, poses durante as ações e continuação após a vitória. Os testes existentes também verificaram colisões, transições, guardas, rei, cidade, tutorial, botão de pular, XP e Quebra de Paradoxo.

A primeira execução falhou pela ausência dos novos sprites. Durante a integração, o teste de colisão esperava 13×8, mas o GameMaker retorna 14×9 para a máscara original inclusiva; o diagnóstico confirmou o sprite de máscara antigo e escala 1×1. A expectativa do teste foi corrigida. As 13 imagens importadas foram comparadas com os arquivos fonte: os bytes são iguais. Os nomes dos recursos são únicos e as 54 fontes de produção coincidem com a cópia testada.

Compilação Windows VM no GameMaker LTS 2026.0.0.23 concluída com código zero e “Igor complete.”. Binário de 33.874.924 bytes e log em `C:/Users/jrhre/AppData/Local/CodexBuilds/ParadoxoDeWilson/evento-20261007-002834`.

Logs dos testes: `C:/Users/jrhre/AppData/Local/Temp/paradoxo-evento-tests/All-38a7b5b5c0c94b3990021e92b1120e59/run-20261007-002735`.

Revisão independente somente leitura concluída sem achados. Backup anterior em `C:/Users/jrhre/AppData/Local/CodexBackups/ParadoxoDeWilson/wilson-art-20261007-001307`.

## Capturas verificadas

![Wilson no mapa](C:/Users/jrhre/OneDrive/Desktop/ExpoGameJam-demo/output/verification/wilson/wilson-idle-down.png)

![Wilson atacando](C:/Users/jrhre/OneDrive/Desktop/ExpoGameJam-demo/output/verification/wilson/wilson-result-attack.png)

![Título atualizado](C:/Users/jrhre/OneDrive/Desktop/ExpoGameJam-demo/output/verification/wilson/wilson-menu-without-demo.png)

![Continuar após a vitória](C:/Users/jrhre/OneDrive/Desktop/ExpoGameJam-demo/output/verification/wilson/wilson-cavern-continue.png)
