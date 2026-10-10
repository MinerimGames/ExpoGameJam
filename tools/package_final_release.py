"""Package both verified GameMaker targets and preserve the previous desktop game."""
from pathlib import Path
import hashlib
import json
import os
import re
import shutil
import zipfile
from datetime import datetime

ROOT = Path(__file__).resolve().parents[1]
DIST = Path(os.environ.get('PARADOXO_DIST', str(ROOT / 'dist/ParadoxoDeWilson-Final-20261009')))
FINAL = ROOT.parent / 'Paradoxo de Wilson - Final'
OLD = ROOT.parent / 'Paradoxo de Wilson'
OUT = Path(os.environ.get('PARADOXO_REPORT_HOME', str(ROOT / 'output/revision-20261009')))
OUT.mkdir(parents=True, exist_ok=True)
FINAL.mkdir(parents=True, exist_ok=True)
backup = Path(os.environ.get('PARADOXO_BACKUP_ROOT', str(Path(os.environ['LOCALAPPDATA']) / 'CodexBackups/ParadoxoDeWilson'))) / ('release-before-final-' + datetime.now().strftime('%Y%m%d-%H%M%S'))

def digest(file):
    with file.open('rb') as stream:
        return hashlib.file_digest(stream, 'sha256').hexdigest()

resources = ['objects', 'scripts', 'rooms', 'sprites', 'sounds', 'fonts',
             'shaders', 'tilesets', 'options', 'datafiles']
sources = [ROOT / 'ParadoxoDeWilson.yyp']
for directory in resources:
    if (ROOT / directory).exists():
        sources.extend(file for file in (ROOT / directory).rglob('*') if file.is_file())
(OUT / 'source-manifest.json').write_text(json.dumps([
    {'path': file.relative_to(ROOT).as_posix(), 'sha256': digest(file)}
    for file in sorted(sources)
], indent=2), encoding='utf-8')

for required in ['Jogo/ParadoxoDeWilson.exe', 'Jogo/data.win', 'ParadoxoDeWilson.zip', 'Web/index.html']:
    if not (DIST / required).is_file():
        raise RuntimeError(f'Missing exported product: {required}')
# An earlier compiler run can leave its internal receipt beside the game.
# Preserve it with build records instead of shipping an obsolete output path.
compiler_receipt = DIST / 'Jogo/igor.output.manifest'
if compiler_receipt.is_file():
    receipt_backup = backup / 'build-records/igor.output.manifest'
    receipt_backup.parent.mkdir(parents=True, exist_ok=True)
    shutil.move(str(compiler_receipt), str(receipt_backup))
licenses = [ROOT / 'fonts/fnt_ui/LICENSE-DejaVu.txt',
            ROOT / 'audio_sources/kenney-impact/LICENSE-Kenney.txt']
for target_name in ['Jogo', 'Web']:
    license_dir = DIST / target_name / 'licenses'
    license_dir.mkdir(exist_ok=True)
    for license_file in licenses:
        shutil.copy2(license_file, license_dir / license_file.name)
with zipfile.ZipFile(DIST / 'ParadoxoDeWilson.zip', 'a', zipfile.ZIP_DEFLATED) as archive:
    for license_file in licenses:
        entry = 'licenses/' + license_file.name
        if entry not in archive.namelist():
            archive.write(license_file, entry)
for existing_target in ['Windows', 'Web']:
    previous = FINAL / existing_target
    if previous.is_dir():
        if previous.resolve().parent != FINAL.resolve():
            raise RuntimeError('Unexpected prior delivery target')
        archived = backup / 'previous-final' / existing_target
        archived.parent.mkdir(parents=True, exist_ok=True)
        # Move the exact prior target out before copying the fresh export.
        # Reusing a directory can leave obsolete texture pages in Web.
        shutil.move(str(previous), str(archived))
shutil.copytree(DIST / 'Jogo', FINAL / 'Windows', dirs_exist_ok=True)
web_cache = (FINAL / 'Web/cache').resolve()
if web_cache.exists():
    if web_cache.parent != (FINAL / 'Web').resolve():
        raise RuntimeError('Unexpected web cache path')
    backup.mkdir(parents=True, exist_ok=True)
    shutil.move(str(web_cache), str(backup / 'web-build-cache'))
shutil.copytree(DIST / 'Web', FINAL / 'Web', dirs_exist_ok=True, ignore=shutil.ignore_patterns('cache'))
shutil.copy2(DIST / 'ParadoxoDeWilson.zip', FINAL / 'ParadoxoDeWilson-Windows.zip')
with zipfile.ZipFile(FINAL / 'ParadoxoDeWilson-Web.zip', 'w', zipfile.ZIP_DEFLATED, compresslevel=6) as archive:
    for file in sorted((FINAL / 'Web').rglob('*')):
        if file.is_file():
            archive.write(file, file.relative_to(FINAL / 'Web').as_posix())

readme = '''O PARADOXO DE WILSON — GAME JAM 2026

WINDOWS
Abra Windows/ParadoxoDeWilson.exe. Mantenha data.win e options.ini junto do executável.
O ZIP do Windows contém o mesmo jogo pronto para compartilhar.

NAVEGADOR
Abra Iniciar Web.cmd. O lançador usa o Python já instalado neste computador.
Abra http://localhost:8319/ no navegador e mantenha a janela do servidor aberta enquanto joga.
Não abra Web/index.html diretamente: os sons e outros arquivos precisam do servidor local.
Para publicar em uma plataforma de jogos web, envie ParadoxoDeWilson-Web.zip.
O index.html está na raiz desse ZIP; a versão publicada precisa apenas de um navegador.
O carregamento inicial pode levar alguns instantes, pois inclui todos os cenários e o áudio final.

CONTROLES
Setas ou WASD: andar. E ou Espaço: conversar e avançar o diálogo.
1: ataque. 2: cura. 3: defesa. 4: esquiva.
Digite a resposta da conta e pressione Enter para confirmar.
Q: Quebra de Paradoxo, depois de derrotar o Isleide das Cavernas.
Use uma vez por batalha para trocar a conta atual, ou a próxima, por uma soma simples.
A habilidade facilita a conta; você ainda precisa respondê-la corretamente.
Tela cheia: opção no menu; no Windows, F11 também funciona durante o jogo.
No navegador, clique em Tela Cheia e use Esc para sair.
Para habilitar o áudio no navegador, clique no jogo ou pressione uma tecla.

VERSÃO FINAL
Passos de foley por tipo de piso, com oscilação de tom removida.
Volume geral reduzido em 22%; efeitos de combate mais suaves.
Cenário e poses do Steampunk estáticos, preservando as indicações dos turnos de combate.
Percurso medieval: Vila, Trilha e Castelo.
Na fase steampunk, o portal chega à frente da entrada e a passagem de volta está fechada.
Cada chefe de realidade dá +30 de vida máxima permanente, uma única vez.
Acertar a conta da Esquiva evita o golpe inteiro; recarrega por dois turnos.
Quebra de Paradoxo renova na próxima batalha ou tentativa.
O botão Pular Batalha foi removido da versão final.
Após vencer os chefes de cada realidade, confirme a vitória e atravesse o portal que aparece.
O guarda pertence ao reino medieval; vencê-lo libera a entrada do castelo pelo caminho normal.
O encerramento inclui os portais das variantes e o retorno à sala de aula da Fatec.
Após a chegada do professor: apresentação dos seis personagens com nome e função, FIM, erros verdes, a cena do guardião, citação de Isaac Newton com o nome do autor e créditos.
As dezenove imagens do ZIP corrigido seguem as pastas 01, 02 e 03, com transições suaves, enquadramento centralizado e efeito discreto de câmera danificada e desfoque.
A animação está aproximadamente 22% mais rápida; os erros e a interferência da câmera têm um verde suave.
A música fornecida toca continuamente da tela FIM até o fim dos créditos, com volume moderado e saída suave.
A citação aparece letra a letra; permanece quatro segundos e desaparece.
Os créditos permanecem na tela. Solte as teclas e pressione Enter ou E para voltar ao menu.
Na sala de aula, os quatro personagens ficam à esquerda, perto do quadro verde, observando o professor.
O personagem de barba trançada fica sentado numa cadeira fora da mesa do professor, perto da lixeira. A cadeira e o personagem ficam voltados para a esquerda.
'''
(FINAL / 'LEIA-ME.txt').write_text(readme, encoding='utf-8')
launcher = '''@echo off
title Paradoxo de Wilson - Versao Web
cd /d "%~dp0"
python "Iniciar Web.py"
pause
'''
(FINAL / 'Iniciar Web.cmd').write_text(launcher.replace('\n', '\r\n'), encoding='utf-8')
shutil.copy2(ROOT / 'tools/local_web_launcher.py', FINAL / 'Iniciar Web.py')

old_files = ['ParadoxoDeWilson.exe', 'data.win', 'options.ini', 'ParadoxoDeWilson.zip']
if OLD.exists():
    backup.mkdir(parents=True, exist_ok=True)
    for name in old_files:
        if (OLD / name).is_file():
            shutil.copy2(OLD / name, backup / name)
    for name in old_files:
        source = DIST / 'ParadoxoDeWilson.zip' if name.endswith('.zip') else FINAL / 'Windows' / name
        shutil.copy2(source, OLD / name)
        if digest(source) != digest(OLD / name):
            raise RuntimeError(f'Desktop copy mismatch: {name}')

manifest = []
for file in sorted(FINAL.rglob('*')):
    if file.is_file():
        manifest.append({'path':file.relative_to(FINAL).as_posix(),'bytes':file.stat().st_size,'sha256':digest(file)})
(OUT / 'package-manifest.json').write_text(json.dumps(manifest,indent=2),encoding='utf-8')
native_root = Path(os.environ.get('PARADOXO_NATIVE_TEST_ROOT', str(Path(os.environ['TEMP']) / 'paradoxo-evento-tests/Guardian-20261009')))
native = {}
latest_logs = {log.parent.name: log for log in sorted(native_root.glob('run-*/*/runner.log'))}
for suite, log in sorted(latest_logs.items()):
    text = log.read_text(encoding='utf-8',errors='replace')
    match = re.search(r'EVENTO_TEST_PASS:\s*(\d+) checks,\s*(\d+) failures',text)
    if not match or int(match[2]) != 0 or 'EVENTO_TEST_FAIL' in text:
        raise RuntimeError(f'Latest verification failed or is incomplete: {suite}: {log}')
    native[suite] = {'checks':int(match[1]),'failures':int(match[2]),'log':str(log)}
(OUT / 'native-tests.json').write_text(json.dumps(native,indent=2),encoding='utf-8')
captures = Path(os.environ['LOCALAPPDATA']) / 'ParadoxoDeWilson'
verification = OUT / 'verification'
verification.mkdir(exist_ok=True)
for pattern in ['city-flags-*.png','victory-portal-*.png','newton-agent-return-portal.png',
                'steampunk-arrival-front.png','steampunk-entry-blocked.png','safety-wall-*.png',
                'final-release-battle.png','credits-gamejam-2026.png','epilogue-six-portals.png',
                'epilogue-wilson-last.png','epilogue-fatec-arrival.png',
                'epilogue-fatec-professor.png','epilogue-fatec-students-walk.png','classroom-showcase-*.png',
                'epilogue-fatec-credits.png','epilogue-ending-*.png','secret-throne-*.png','newton-ending-*.png','ending-cinematic-*.png']:
    for file in captures.glob(pattern):
        shutil.copy2(file,verification / file.name)
receipt = {'folder':str(FINAL),'previous_game_backup':str(backup),'configuration':'FinalRelease',
           'files':len(manifest),'bytes':sum(row['bytes'] for row in manifest),
           'native_suites':len(native),'native_checks':sum(row['checks'] for row in native.values())}
(OUT / 'delivery.json').write_text(json.dumps(receipt,indent=2),encoding='utf-8')
print(json.dumps(receipt,indent=2))
