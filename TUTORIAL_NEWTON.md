# Tutorial do Isleide Newton

- O antigo slime da Room1 foi substituido por `obj_newton_npc`.
- Aproxime-se e pressione **E** ou **Espaco** para conversar.
- O dialogo explica as incursões multiversais e a matematica como mecanica central.
- Ao terminar a introducao, inicia uma luta de tutorial contra Isleide Newton.
- O tutorial guia, nesta ordem: Ataque -> Cura -> Defesa -> Esquiva.
- Cada acao exige resolver uma conta, igual ao sistema portado do prototipo web.
- Na batalha, o jogador usa `spr_battle_isleide` e Newton usa `spr_battle_newton`, ambos criados a partir das imagens fornecidas.
- Ao concluir o treino, Newton permanece no mapa e fecha a introducao com um ultimo dialogo.


## Animacao do Newton no mapa
O `spr_newton_npc` agora usa os 24 quadros do GIF fornecido, em aproximadamente 20 FPS, mantendo o personagem com cerca de 24 px de altura visual para ficar na mesma escala do Isleide normal. O sprite grande da batalha permanece separado.
