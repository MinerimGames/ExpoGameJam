# Créditos — GameJam 2026

A tela surge após Wilson chegar à Fatec. Todos os nomes aparecem simultaneamente na coluna central; Cabeludo, Adão, Akatsuki e Yandere decoram as laterais, com leve respiração. Steampunk passou a ter sua própria fase depois do rei e deixou de ser decoração dos créditos. Enter/E com nova pressão retorna ao menu; a confirmação segurada desde a despedida não pula os créditos.

## Conteúdo atualizado conforme o autor

- Artes de personagens e design: Thiago Kodaira.
- Artes de background: Jahel Boaventura; Matheus Conceição da Silva.
- Sonoplastia geral: Guilherme Batistela.
- Desenvolvimento: Matheus Conceição da Silva; Jahel Boaventura.
- Gestão geral do projeto: Guilherme Batistela.
- Auxiliares do projeto: Guilherme Hashish.
- Menção honrosa: Professor Isleide Wilson.

Laura foi retirada dos auxiliares. Título: O PARADOXO DE WILSON. Identificação: JOGO PARA A GAMEJAM 2026.

## Recursos fornecidos

Os PNGs em output/credits foram importados sem alteração de pixels para sprites/spr_credit_*. O usuário reenviou Akatsuki, resolvendo a ausência do arquivo na versão anterior, e depois forneceu Yandere como substituição de Steampunk. Duas variantes aparecem em cada lateral, com altura de 116 pixels na interface de 640×380, preservando o espaço dos nomes e do controle de retorno.

Backup da implementação anterior: C:/Users/jrhre/AppData/Local/CodexBackups/ParadoxoDeWilson/credits-audio-newton-20261008-015251.

## Áudio na transformação final

O arquivo enviado foi preservado em output/audio/newton-transform-original.mpeg. A gravação completa tem 181,891 segundos, estéreo a 44,1 kHz. A conversão para PCM16 aplica ganho de 0,90 para evitar saturação. O recurso snd_newton_recording usa compressão incorporada ao pacote; não exige arquivo de áudio externo junto do executável.

O áudio começa em begin_transformation, quando a acusação do Agente inicia a transformação de Newton. Ele ocupa o canal de música e continua pelo diálogo, primeira batalha, recuperação e batalha com apoio, sem reiniciar por confirmações ou repetição da batalha. Na despedida, sai por fade e entra a trilha do encerramento. Caso o arquivo termine antes, a trilha original volta e a gravação não reinicia. O efeito original do colapso e as músicas das outras fases foram preservados.

A origem e o SHA-256 estão em output/audio/newton-recording.json. A gravação do usuário permanece separada do manifesto das 31 composições e efeitos originais CC0.

## Verificação da versão anterior

Os testes iniciais demonstraram as alterações pendentes: cinco falhas nos créditos antigos e cinco na reprodução do áudio ausente. Depois da implementação, Credits passou com 48 verificações, incluindo funções, nomes e acentos, quatro artes, espaçamento, teclas seguradas e retorno ao menu. A captura nativa está preservada em output/credits/credits-gamejam-2026.png.

EvilNewton passou com 45 verificações: início exato da gravação, mesmo handle durante confirmações e as duas lutas, repetição da batalha e fade após vitória real. Audio passou com 55 verificações, incluindo término simulado da gravação para testar a restauração da música sem esperar três minutos. Os 27 testes Python passaram, verificando também conteúdo completo, som não silencioso, margem contra saturação e importação das artes byte a byte.

As regressões Epilogue (1.580 verificações) e MenuPoster (12) também passaram sem falhas. A revisão visual da captura confirmou as quatro variantes e todos os nomes legíveis. Total: 1.740 verificações nativas e 27 testes Python, sem falhas.

## Versão anterior entregue

Pacote: dist/ParadoxoDeWilson-Windows-creditos-audio-newton-20261008. A cópia instalada fica em C:/Users/jrhre/OneDrive/Desktop/Paradoxo de Wilson/ParadoxoDeWilson.exe; EXE, data.win, options.ini e ZIP foram conferidos por SHA-256. Manifesto e logs estão na pasta do pacote.

Backup do pacote anterior: C:/Users/jrhre/AppData/Local/CodexBackups/ParadoxoDeWilson/release-before-creditos-audio-20261008-020251.

O executável instalado abriu e permaneceu no loop principal sem erro. O medidor da sessão Windows do próprio jogo teve sinal positivo nas 79 de 79 observações, sem mute. O volume principal, volume da sessão e configurações de outras aplicações não foram alterados; nenhuma captura de áudio foi realizada.

## Expansão atual

A expansão de 08/10/2026 substitui o quarto retrato dos créditos por Yandere e o soldado dos portais finais por Steampunk. Os testes atuais Credits (52), Epilogue (1.590) e EvilNewton (46) passaram sem falhas. A gravação fornecida permanece incorporada e conserva seu início na transformação de Newton. Consulte FASE_STEAMPUNK_2026.md para cenário, história, habilidade e pacote atualizado.
