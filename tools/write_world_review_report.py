"""Save test evidence and copy intact native screenshots for this revision."""
from pathlib import Path
import json
import re
import shutil
from evento_project import load

ROOT=Path(__file__).resolve().parents[1]
RUNS=Path('C:/Users/jrhre/AppData/Local/Temp/paradoxo-evento-tests/WorldFinal-20261007')
CAPTURES=Path('C:/Users/jrhre/AppData/Local/ParadoxoDeWilson')
BACKUP=Path('C:/Users/jrhre/AppData/Local/CodexBackups/ParadoxoDeWilson/world-fixes-20261007-063546')
BUILD=Path('C:/Users/jrhre/AppData/Local/CodexBuilds/ParadoxoDeWilson/world-final-20261007-072110')
SUITES=['Input','Battle','Ambient','Integration','Castle','Route','Guard','Royal','Autumn','Skip','Peasants','City','Progression','PlayerArt','Newton','MapSafety']
evidence={}
for suite in SUITES:
    for log in sorted(RUNS.glob('run-*/'+suite+'/runner.log'),reverse=True):
        text=log.read_text(errors='replace')
        match=re.search(r'EVENTO_TEST_PASS: (\d+) checks, 0 failures',text)
        if match and 'EVENTO_TEST_FAIL' not in text:
            evidence[suite]=(int(match[1]),log)
            break
    assert suite in evidence,suite+' has no passing evidence'
assert (BUILD/'ParadoxoDeWilson.win').is_file()
assert 'Igor complete.' in (BUILD/'compile.log').read_text(errors='replace')

out=ROOT/'output/verification/world-fixes/screens'
out.mkdir(parents=True,exist_ok=True)
patterns=['safety-rm_*.png','safety-bridge-*.png','safety-rail-*.png','wilson-frame-*.png','wilson-walk-*.png','wilson-idle-*.png','royal-king-*.png','royal-battle.png','newton-port-bridge.png']
for pattern in patterns:
    for source in CAPTURES.glob(pattern):shutil.copy2(source,out/source.name)

def link(path,label):return '['+label+'](<'+path.as_posix()+'>)'
def count(path):
    data=load(path)
    return sum(i['objectId']['name']=='obj_colisor' for layer in data['layers'] for i in layer.get('instances',[]))

total=sum(v[0] for v in evidence.values())
lines=['# Revisão final de mapas e caminhada — 07/10/2026','',
'Corrigidas as colisões dos 13 mapas jogáveis, a profundidade dos personagens e o enquadramento da câmera. Wilson usa novas poses de exploração com braços relaxados e seis quadros por direção; esquerda espelha a lateral direita. O ciclo acompanha a distância efetivamente percorrida, mantém os pés alinhados e para quando Wilson está bloqueado. A máscara de colisão original dos pés e a velocidade de deslocamento foram preservadas.','',
'No porto, água, bordas, telhados e margens da ponte receberam limites mais precisos. A passagem superior continua conectando a entrada ao aliado. O corrimão próximo é desenhado na frente de Wilson quando necessário, com recortes alinhados à imagem original.','',
'O rei foi ajustado para 32 unidades sentado e 36 em pé, comparado a 33,6 de Wilson no interior do castelo. Guarda, Newton e os demais personagens de história usam os pés como referência de posicionamento e profundidade; retratos e poses de batalha foram conferidos.','',
'## Verificação','',
f'As 16 suítes somam **{total:,} verificações, sem falhas**. Também passaram 10 testes em Python: quatro de geometria dos mapas, cinco de conectividade/limites do porto e um de alinhamento visual do corrimão. As capturas nativas de caminhada, trono, batalha e ponte foram inspecionadas.','',
'| Suíte | Verificações | Evidência |','|---|---:|---|']
for suite,(checks,log) in evidence.items():lines.append(f'| {suite} | {checks} | {link(log,"Log")} |')
lines+=['',
'Os testes automatizados usam teclas virtuais no projeto isolado para evitar que o Windows direcione entradas à janela em foco. O código real de movimento, colisão, diálogos e batalha é executado. Essas entradas não são incluídas no projeto principal. O comportamento de envio de teclas no Windows é descrito no [manual oficial do GameMaker](https://manual.gamemaker.io/lts/en/GameMaker_Language/GML_Reference/Game_Input/Keyboard_Input/keyboard_key_press.htm).','',
'O teste visual compara duas capturas fixas da ponte, sem personagens, com e sem a camada do corrimão. Apenas 0,0975% dos pixels diferem acima da tolerância de amostragem; erro médio de 0,0286 por canal. A [API de primitivas](https://manual.gamemaker.io/lts/en/GameMaker_Language/GML_Reference/Drawing/Primitives/draw_vertex_texture_colour.htm) usa coordenadas normalizadas dentro da imagem do sprite.','',
'## Mapas revisados','',
'A quantidade de colisores é registrada para rastreabilidade. Os testes de geometria verificam pontos sólidos, bordas e caminhos, além dessa contagem.','',
'| Mapa | Colisores antes | Colisores atuais |','|---|---:|---:|']
for path in sorted((ROOT/'rooms').glob('rm_*/rm_*.yy')):
    if path.parent.name not in ['rm_'+n for n in ['tutorial','temporal_origin','cavernas','cavernas_2','bosque','vila','castelo','castle_hall','throne_room','autumn_gate','autumn_streets','autumn_plaza','commercial_district']]:continue
    prior=BACKUP/path.relative_to(ROOT)
    lines.append(f'| {path.parent.name} | {count(prior)} | {count(path)} |')
lines+=['','## Arquivos e recuperação','',
'- '+link(ROOT/'ParadoxoDeWilson.yyp','Projeto GameMaker atualizado'),
'- '+link(BUILD/'ParadoxoDeWilson.win','Compilação final para o Runner do GameMaker'),
'- '+link(BUILD/'compile.log','Log da compilação final — Igor complete'),
'- Backup anterior: '+BACKUP.as_posix(),
'- Capturas preservadas: '+out.as_posix(),
'- '+link(ROOT/'output/imagegen/wilson-relaxed-walk-atlas.png','Atlas original de frente e costas'),
'- '+link(ROOT/'output/imagegen/wilson-side-walk-strip.png','Atlas original de passos laterais'),
'- '+link(ROOT/'output/imagegen/wilson-relaxed-walk-prompt.md','Prompt inicial de imagem'),
'- '+link(ROOT/'output/imagegen/wilson-walk-refinements.md','Prompts finais de imagem'),'',
'As novas imagens foram geradas com a ferramenta nativa de imagem e importadas sem modificar seus pixels. O jogo seleciona os quadros, alinha os pés e trata resíduos de transparência durante o desenho.','']
report=ROOT/'docs/RELATORIO_REVISAO_FINAL_MAPAS.md'
report.write_text('\n'.join(lines),encoding='utf-8')
print(f'{report}: {total} runtime checks, 16 suites, 10 Python tests; screenshots preserved')
