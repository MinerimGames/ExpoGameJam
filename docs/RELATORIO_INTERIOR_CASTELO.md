# Interior do Castelo e Isleide Rei

Após vencer o guarda e atravessar a porta do Castelo, Wilson entra no salão iluminado por velas. Caminhar pelo tapete central até a porta superior leva à sala do trono, sem um novo portal. Ao entrar, o jogador vê o rei sentado, com respiração discreta; ele se levanta antes de iniciar a conversa e a batalha. A vitória confirmada contra o rei agora leva à fase de outono, detalhada em [RELATORIO_FASE_OUTONO.md](RELATORIO_FASE_OUTONO.md).

## Salas e apresentação

- `rm_castle_hall`: 800×600, entrada em (400, 440), 18 colisores alinhados às paredes, móveis e colunas. O jogador aparece sobre o tapete, dentro da entrada. A câmera 640×360 acompanha Wilson e mantém a proporção do viewport 1280×720.
- `rm_throne_room`: 800×600, entrada em (400, 400), 13 colisores. Câmera 640×360 fixa em (80, 80), enquadrando rei e jogador durante a cena. O rei fica sobre o trono em (400, 198).
- Os dois fundos foram importados byte a byte dos PNGs enviados, sem alterações de pixels. São apresentados com proporção 4:3 preservada dentro das salas; a câmera mostra uma região de proporção 16:9.
- Os 60 colisores e a câmera do Castelo exterior, os mapas anteriores, o botão de pular o tutorial e o único portal pós-vitória nas Cavernas foram preservados.

## Rei e conversa

Foram geradas poses transparentes a partir de `isleide rei.jpg`, usando a ferramenta integrada de geração de imagens:

- [Rei sentado](../output/imagegen/king-seated.png)
- [Rei em pé](../output/imagegen/king-standing.png)
- [Prompts completos](../output/imagegen/royal-prompts.md)

Os PNGs finais estão também incorporados nos sprites `spr_king_seated` e `spr_king_standing`. A referência original e os arquivos gerados originais foram preservados. A cena mantém o rei sentado por aproximadamente um segundo, aplica uma respiração leve e mistura as duas poses com deslocamento suave durante 0,65 segundo para representar o levantamento. As teclas não pulam essa apresentação. Em seguida, E ou Espaço avança as sete falas, alternando nome e retrato de Isleide Rei e Wilson.

O rei pergunta o que um plebeu faz ali, como passou pelos guardas e o motivo da visita. Wilson explica sua realidade alternativa e as incursões. O rei afirma que elas são segredo de Estado, proíbe interferir no destino, recusa permitir o fechamento da realidade e inicia a luta.

## Dificuldade da luta

O rei tem 180 HP, contra 150 HP do guarda. Mantém os mesmos danos, cura, defesa, esquiva e avisos de ataque. Seu perfil matemático alterna soma e multiplicação a cada pergunta apresentada:

1. Soma com operandos de 10–48 e 10–28, a mesma dificuldade de soma do guarda.
2. Multiplicação com ambos os operandos de 2–6.

A alternância continua depois de respostas erradas. Perguntas só são contadas quando uma ação válida gera um desafio. Tentar novamente após derrota restaura 100 HP do jogador, 180 HP do rei e reinicia pela soma. O perfil padrão mantém as contas anteriores das Cavernas e do guarda.

## Verificação

O teste novo falhou inicialmente pela ausência das salas e do rei. Depois da implementação, a suíte completa `tools/run_evento_tests.ps1 -Suite All` terminou com oito grupos aprovados, 8.890 verificações e zero falhas:

| Grupo | Verificações |
| --- | ---: |
| Input | 18 |
| Battle | 8.187 |
| Ambient | 27 |
| Integration | 107 |
| Castle | 38 |
| Route | 33 |
| Guard | 197 |
| Royal | 283 |

Route percorreu os caminhos com os controles e colisões reais, enfrentou o guarda, atravessou o salão e venceu o rei até o encerramento. Royal verificou entrada livre, transição animada, diálogo completo, alternância inclusive após erro, derrota/retry, oito vitórias estratégicas e reinício limpo em uma nova visita.

Os dois fundos têm hashes idênticos aos arquivos fornecidos; referências de recursos, eventos, imagens e salas foram conferidas. Revisão independente: sem problemas encontrados. As capturas do salão, das poses, das sete falas, da batalha e da vitória foram conferidas visualmente.

Compilação real Windows VM no GameMaker LTS 2026.0.0.23: `Igor complete.`, código zero. Binário, log e capturas: `C:/Users/jrhre/AppData/Local/CodexBuilds/ParadoxoDeWilson/evento-20261006-114358`.

Backup dos arquivos anteriores à mudança: `C:/Users/jrhre/AppData/Local/CodexBackups/ParadoxoDeWilson/royal-interior-20261006-113405`.

## Ajuste posterior do tamanho do rei

O rei foi reduzido em 20% no cenário e na batalha: 43,2 pixels sentado, 62,4 em pé e 232 de altura no combate. Retratos de diálogo mantêm seu enquadramento original. A apresentação animada, os 180 HP, os danos e as contas continuam os mesmos. A fixture Royal passou com 283 verificações e zero falhas; a captura da batalha foi conferida visualmente. A compilação Windows VM concluiu com `Igor complete.` em `C:/Users/jrhre/AppData/Local/CodexBuilds/ParadoxoDeWilson/evento-20261006-133852`.

Backup anterior ao ajuste de tamanho: `C:/Users/jrhre/AppData/Local/CodexBackups/ParadoxoDeWilson/king-size-20261006-133815`.
