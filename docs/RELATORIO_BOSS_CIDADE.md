# Isleide da Cidade — encontro na praça final

Implementação do encontro aprovado pelo usuário. O líder aguarda em `(480,260)` em `rm_autumn_plaza`; a aproximação inicia oito falas formais antes do combate. Ele afirma ter buscado paz e liberdade, atribui às incursões a distorção de sua imagem e apresenta Wilson como invasor. E ou Espaço avança uma fala por vez, com movimento bloqueado até o combate.

O chefe tem 220 HP, acima dos 180 do rei. Alterna somas e multiplicações; os acertos aumentam o nível matemático de 7 a 9. As somas têm resultados máximos de 80, 90 e 100; as multiplicações usam fatores de 2 até 7, 8 e 9 respectivamente. Erros mantêm o nível e causam o ataque normal do inimigo. Reiniciar restaura vida, nível inicial e alternância. As regras de dano, defesa e cura permanecem as existentes.

A vitória confirmada remove o chefe e devolve o controle na mesma praça. O botão temporário PULAR BATALHA usa essa mesma saída. Nenhuma fase ou portal foi acrescentado.

## Arte

A pose de paz preserva `C:/Users/jrhre/Downloads/Comunista0.png`. Foram geradas três variantes com a ferramenta integrada `image_gen`, preservando identidade, uniforme e fundo transparente. PNGs copiados para o projeto, sem edição dos pixels:

- [Fala](../output/imagegen/city-talk.png)
- [Defesa](../output/imagegen/city-defense.png)
- [Ataque](../output/imagegen/city-attack.png)
- [Prompts completos](../output/imagegen/city-prompts.md)

As quatro poses aparecem nos retratos do diálogo e no mapa. Na batalha, a intenção normal mostra fala; ataque forte mostra ataque; recuperação mostra paz; o desafio de ataque do jogador mostra defesa. A escala se ajusta à altura de cada sprite para manter proporções semelhantes. O personagem no mapa tem altura de 32 pixels e uma respiração discreta.

## Verificação

O teste inicial falhou corretamente pela ausência do chefe. Depois da implementação, a suíte completa executou 9.418 verificações sem falhas: Input18, Battle8187, Ambient27, Integration119, Castle39, Route79, Guard197, Royal285, Autumn42, Skip51, Peasants36, City338.

City verificou aproximação, oito páginas antes da batalha, quatro poses distintas, progressão e limites matemáticos, derrota, reinício e vitória em 20 sementes diferentes usando ataque, defesa e cura. Route percorreu o caminho natural desde as cavernas, incluindo as transmissões, guarda, rei e novo chefe. Skip verificou as cinco batalhas, inclusive a nova saída da praça.

Logs: `C:/Users/jrhre/AppData/Local/Temp/paradoxo-evento-tests/All-38a7b5b5c0c94b3990021e92b1120e59/run-20261006-231813`.

Compilação Windows VM com GameMaker LTS2026.0.0.23 terminou com código zero e `Igor complete.`. Binário, log e capturas das oito falas, poses e vitória: `C:/Users/jrhre/AppData/Local/CodexBuilds/ParadoxoDeWilson/evento-20261006-232010`. Capturas revisadas visualmente, sem cortes no texto ou fundo branco nos sprites.

Revisão independente somente leitura aprovada, sem bugs concretos encontrados. Backup anterior: `C:/Users/jrhre/AppData/Local/CodexBackups/ParadoxoDeWilson/city-boss-20261006-231412`. Câmera, colisores, transições e diálogos anteriores foram preservados.
