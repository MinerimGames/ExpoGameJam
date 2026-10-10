"""Verify exported files, delivery manifests, and archive contents without mutation."""
import hashlib
import json
import os
from pathlib import Path
import zipfile

ROOT = Path(__file__).resolve().parents[1]
DIST = Path(os.environ.get('PARADOXO_DIST', str(ROOT / 'dist/ParadoxoDeWilson-Final-20261009')))
FINAL = ROOT.parent / 'Paradoxo de Wilson - Final'
OUT = Path(os.environ.get('PARADOXO_REPORT_HOME', str(ROOT / 'output/revision-20261009')))

def digest(path):
    with path.open('rb') as stream:
        return hashlib.file_digest(stream, 'sha256').hexdigest()

def files(folder):
    return {p.relative_to(folder).as_posix(): p for p in folder.rglob('*') if p.is_file()}

report = {'failures': [], 'targets': {}}
for exported, delivered, archive_name in [
    ('Jogo', 'Windows', 'ParadoxoDeWilson-Windows.zip'),
    ('Web', 'Web', 'ParadoxoDeWilson-Web.zip'),
]:
    source = files(DIST / exported)
    target = files(FINAL / delivered)
    if source.keys() != target.keys():
        report['failures'].append({'target': delivered, 'missing': sorted(source.keys() - target.keys()), 'extra': sorted(target.keys() - source.keys())})
    mismatches = [name for name in source.keys() & target.keys() if digest(source[name]) != digest(target[name])]
    if mismatches:
        report['failures'].append({'target': delivered, 'content_mismatches': mismatches})
    with zipfile.ZipFile(FINAL / archive_name) as archive:
        corrupt = archive.testzip()
        archive_files = {i.filename: i for i in archive.infolist() if not i.is_dir()}
        if corrupt or archive_files.keys() != target.keys():
            report['failures'].append({'archive': archive_name, 'corrupt': corrupt, 'missing': sorted(target.keys() - archive_files.keys()), 'extra': sorted(archive_files.keys() - target.keys())})
        for name in archive_files.keys() & target.keys():
            if hashlib.sha256(archive.read(name)).hexdigest() != digest(target[name]):
                report['failures'].append({'archive_content_mismatch': name})
    report['targets'][delivered] = {'files': len(target), 'bytes': sum(p.stat().st_size for p in target.values()), 'archive': archive_name}

for manifest_name, base in [('source-manifest.json', ROOT), ('package-manifest.json', FINAL)]:
    entries = json.loads((OUT / manifest_name).read_text(encoding='utf-8'))
    for entry in entries:
        path = base / entry['path']
        if not path.is_file() or digest(path) != entry['sha256']:
            report['failures'].append({'manifest': manifest_name, 'mismatch': entry['path']})
    report[manifest_name] = len(entries)
report['passed'] = not report['failures']
(OUT / 'package-verification.json').write_text(json.dumps(report, indent=2), encoding='utf-8')
print(json.dumps(report, indent=2))
raise SystemExit(0 if report['passed'] else 1)
