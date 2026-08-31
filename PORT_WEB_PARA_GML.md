# Port do prototipo Web para GML

Arquivos adicionados:

- `scripts/battle_system/battle_system.gml`: geracao dos desafios matematicos e inicio da batalha.
- `objects/obj_battle_controller/Create_0.gml`: regras de batalha (HP, ataque, cura, defesa, esquiva, critico, erro/acerto, vitoria/derrota).
- `objects/obj_battle_controller/Step_0.gml`: botoes, mouse, teclado e resposta matematica.
- `objects/obj_battle_controller/Draw_64.gml`: interface que substitui o HTML/CSS usando Draw GUI.
- `objects/obj_slime/Step_0.gml`: chama `batalha_iniciar(id)` quando o slime alcanca o jogador.

Controles durante a batalha:

- Mouse nos botoes ou teclas `1`, `2`, `3`, `4`.
- Digite a resposta matematica e pressione `Enter` ou clique `OK`.
- Na vitoria, `Enter`/RETORNAR elimina o inimigo e devolve o controle ao jogador.
- Na derrota, `Enter`/TENTAR DE NOVO reinicia a batalha.

A logica matematica preserva os intervalos realmente usados em `challenge.js`, inclusive onde os comentarios do JS diziam 10..99 mas o codigo gerava intervalos menores.
