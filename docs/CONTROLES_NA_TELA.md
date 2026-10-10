# Movimento pelo teclado — 07/10/2026

As setas desenhadas no canto da tela foram removidas. Wilson continua andando com WASD e com as setas do teclado, usando a animação e a máscara de colisão existentes. Mouse e toque não movimentam o personagem durante a exploração.

Ao entrar em batalha, Wilson passa imediatamente à pose frontal parada, incluindo o personagem pequeno que permanece visível no mapa sob o painel de batalha. O retrato de batalha já usa a arte frontal original; as poses de ataque, defesa, cura e esquiva foram preservadas.

A suíte OnScreenControls mantém o nome para os comandos de validação existentes. Ela verifica que os antigos alvos de toque não causam movimento, que as oito teclas de direção continuam funcionando, e que diagonais, colisões, bloqueio e parada por soltura continuam corretos. Também inicia a batalha com Wilson de costas e exige a pose frontal imediatamente e nos passos seguintes.

Antes da mudança, a nova regressão executou 59 verificações e encontrou 18 falhas esperadas nos controles de tela e na orientação do personagem. A validação final passou: OnScreenControls 59 verificações, Input 18 e PlayerArt 63, todas sem falhas.

Backup anterior à mudança: C:/Users/jrhre/AppData/Local/CodexBackups/ParadoxoDeWilson/remove-controls-battle-front-20261007-114738.
