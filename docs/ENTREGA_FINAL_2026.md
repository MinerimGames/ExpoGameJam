# Entrega final — 08/10/2026

Registro histórico. O encerramento e a entrega atuais estão documentados em [Cutscene final de 96 quadros](CUTSCENE_FINAL_96_QUADROS_2026-10-09.md).

Pasta entregue: `C:/Users/jrhre/OneDrive/Desktop/Paradoxo de Wilson - Final`.

## Alterações finais

Os treze cartazes e bandeiras da cidade mantêm o tecido, a moldura, a haste e a perspectiva da imagem original. As três poses existentes do Isleide da Cidade agora são recortadas dentro desses contornos, com proporção preservada. Os dois estandartes pontudos também seguem o formato do tecido.

Confirmar a vitória abre um portal visível e libera Wilson para andar até ele. O jogo aguarda a entrada física no portal; não muda automaticamente de realidade. Isso vale para Cavernas → Bosque, Rei → Fundição do Tempo, Steampunk → Cidade Fantasma e Isleide da Cidade → cidade do Agente. Após a conversa do Agente, o retorno ao início também usa um portal visível. A derrota do guarda libera a entrada normal no castelo, pois ele pertence à mesma realidade do rei. O encerramento mantém os portais individuais das variantes e a volta de Wilson à Fatec.

O portal possui animação, surgimento gradual e uma breve espera de ativação. As posições foram verificadas contra os colisores reais. Quando surge sobre alguém, exige que o jogador saia antes de entrar; a recompensa é concedida apenas uma vez.

O botão **Pular Batalha** foi retirado do jogo normal e das exportações. O perfil padrão e `FinalRelease` desativam tanto a exibição quanto a ação do botão. Apenas o projeto descartável dos testes recebe `EventoTests`, para verificar regressões antigas; esse perfil não aparece no projeto principal. O botão de pular o tutorial de Newton permanece disponível.

## Arquivos para jogar e compartilhar

- `Windows/ParadoxoDeWilson.exe`, acompanhado de `data.win` e `options.ini`.
- `ParadoxoDeWilson-Windows.zip`: pacote oficial exportado pelo GameMaker.
- `Web/index.html`, `html5game/` e os arquivos necessários do navegador.
- `ParadoxoDeWilson-Web.zip`: `index.html` na raiz, pronto para uma plataforma que hospede jogos HTML5.
- `Iniciar Web.cmd`: servidor local com o Python já instalado, disponível em `http://localhost:8319/`.
- `LEIA-ME.txt`: controles e instruções de execução.

O cache de compilação permanece nas pastas de desenvolvimento e backup; não faz parte do pacote web entregue. Os arquivos da cópia anterior instalada na Área de Trabalho foram preservados em backup antes da atualização. O primeiro backup é `C:/Users/jrhre/AppData/Local/CodexBackups/ParadoxoDeWilson/release-before-final-20261008-033959`.

## Verificação

As duas versões foram exportadas pelo GameMaker LTS 2026, runtime `2026.0.0.23`, configuração `FinalRelease`. O módulo oficial HTML5 foi instalado em uma pasta de compilação separada. O navegador utiliza páginas de textura 4096×4096 para preservar o atlas de caminhada, sem a redução que ocorria com 2048×2048.

Foram concluídas 17 suítes nativas, com 6.332 verificações e nenhuma falha. Cobrem portais, cartazes, percurso, castelo, rei, Steampunk, cidade, progressão, revelação de Newton, epílogo, menu, áudio, profundidade, colisões, créditos e a remoção do botão temporário. A suíte `Release` foi executada na configuração de entrega: clicar na antiga posição do botão não vence a batalha nem concede XP, e responder corretamente a uma conta ainda resolve o ataque.

Os testes Python somam 33: 19 de recursos e diagnóstico, 6 de geometria dos mapas, 5 de colisão dos portais e 3 de sobreposição do arco e da ponte, todos aprovados.

A versão web entregue foi aberta em uma instância isolada do Microsoft Edge. Menu, caminhada lateral, conversa com Newton, entrada em batalha e apresentação da conta funcionaram sem exceções ou requisições com falha. O áudio iniciou com uma tecla comum, e a tela se ajustou a uma janela de 700×420 sem cortar o jogo. A captura da batalha confirma a ausência de Pular Batalha. Esse teste não percorre manualmente toda a história no navegador; o percurso completo e o encerramento foram cobertos pelas suítes nativas.

Uma cópia isolada adicional verificou a renderização HTML5 de dois enquadramentos da cidade, da Fundição do Tempo e da ponte do porto comercial, sem erros no navegador. As capturas confirmam que as bandeiras mantêm o enquadramento da versão Windows. Essa cópia contém apenas o objeto temporário de inspeção e não integra os pacotes entregues. O lançador local aguarda o servidor estar disponível antes de abrir o navegador, evitando a falha de conexão na primeira abertura.

O executável da pasta final iniciou sem erro e entrou no loop principal. O medidor da sessão Windows exclusiva desse processo registrou áudio em 79 de 79 observações, sem mute, sem gravar áudio e sem alterar o volume do computador.

Logs, capturas e manifestos SHA-256 estão em `output/final-release/`. `package-manifest.json` registra os arquivos entregues, `source-manifest.json` registra os recursos do projeto, `native-tests.json` reúne os resultados e `delivery.json` identifica a pasta final e o backup. Os registros de exportação ficam em `dist/ParadoxoDeWilson-Final-20261008/`.
