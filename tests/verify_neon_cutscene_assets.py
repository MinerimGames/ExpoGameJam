"""Verify source pixels, native frame order, guide removal and original files."""
from pathlib import Path
import hashlib
import json
import numpy as np
from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
SOURCES = {
    'caminho': 'Aproximação ao Trono Neon.png',
    'guardiao': 'Cavaleiro Mascarado Avança pelo Trono Verde.png',
    'revelacao': 'Spritesheet do cavaleiro removendo a máscara.png',
}

def verify(group=None):
    report=json.loads((ROOT/'output/revision-20261009/neon-cutscene-import.json').read_text())
    project=json.loads((ROOT/'ParadoxoDeWilson.yyp').read_text())
    count=0
    for seq in report['sequences']:
        if group and seq['group']!=group: continue
        directory=ROOT/'datafiles/cutscene_final'/seq['group']
        source=Path('C:/Users/jrhre/Downloads')/SOURCES[seq['group']]
        raw=source.read_bytes()
        assert raw==(directory/'original.png').read_bytes()
        assert hashlib.sha256(raw).hexdigest()==seq['source_sha256']
        sheet=Image.open(source).convert('RGBA')
        name=seq['name']; native_dir=ROOT/'sprites'/name
        sprite=json.loads((native_dir/(name+'.yy')).read_text())
        keys=sprite['sequence']['tracks'][0]['keyframes']['Keyframes']
        expected_count=24 if seq['group']=='revelacao' else 36
        assert len(sprite['frames'])==len(keys)==len(seq['frames'])==expected_count
        assert sprite['sequence']['playbackSpeed']==12 and not sprite['edgeFiltering']
        assert sum(r['id']['name']==name for r in project['resources'])==1
        for i, frame in enumerate(seq['frames']):
            first=37 if seq['group']=='revelacao' else 1
            assert frame['number']==i+first
            crop=np.asarray(sheet.crop(frame['rect']))
            panel=Image.open(directory/f'frame_{i+first:02}.png').convert('RGBA')
            a=np.asarray(panel)
            assert list(panel.size)==frame['size']
            # Every RGB byte is the supplied pixel. Only the printed corner
            # guide and its antialias shadow may become transparent.
            assert np.array_equal(a[:,:,:3],crop[:,:,:3])
            changed=a[:,:,3]!=crop[:,:,3]
            yy,xx=np.where(changed)
            assert len(xx)==frame['guide_pixels'] and len(xx)>0
            assert xx.max()<45 and yy.max()<33
            assert np.all(a[changed,3]==0)
            assert np.all(a[33:,:,3]==255) and np.all(a[:33,45:,3]==255)
            # Printed white labels and their dark shadow live within one
            # excluded rectangle; no character pixels intersect that rectangle.
            corner=crop[:33,:45,:3].astype(int)
            neutral=(corner.max(2)-corner.min(2)<48)&(corner.min(2)>60)
            assert not np.any(a[:33,:45,3][neutral])
            assert np.all(changed[yy.min():yy.max()+1,xx.min():xx.max()+1])
            green=(a[:,:,1]>100)&(a[:,:,0]<75)&(a[:,:,2]<125)&(a[:,:,3]>0)
            assert not np.any(green.mean(axis=0)>.95),f'vertical divider {name}/{i}'
            assert not np.any(green.mean(axis=1)>.95),f'horizontal divider {name}/{i}'
            fid=sprite['frames'][i]['name']; path=native_dir/(fid+'.png')
            packed=np.asarray(Image.open(path).convert('RGBA'))
            assert np.array_equal(packed[:a.shape[0],:a.shape[1]],a)
            assert not np.any(packed[a.shape[0]:,:,3])
            assert not np.any(packed[:a.shape[0],a.shape[1]:,3])
            assert path.read_bytes()==(native_dir/'layers'/fid/(sprite['layers'][0]['name']+'.png')).read_bytes()
            assert keys[i]['Key']==i and keys[i]['Channels']['0']['Id']['name']==fid
            count+=1
    print(f'NEON_ASSETS_PASS: {count} ordered lossless panels, unchanged originals, guides removed, native layers match.')

if __name__=='__main__': verify()
