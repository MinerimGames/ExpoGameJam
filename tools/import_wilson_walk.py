"""Import intact generated atlases; derive frame/anchor metadata only."""
from pathlib import Path
import json
import numpy as np
from PIL import Image
from scipy.ndimage import label, find_objects
import add_royal_interiors as res
from evento_project import load, save

def cells(source,cols,rows,name):
    res.sprite(name,source,True)
    pixels=np.array(Image.open(source).convert('RGBA'));height,width=pixels.shape[:2]
    frames=[]
    for row in range(rows):
        for col in range(cols):
            x0,x1=round(col*width/cols),round((col+1)*width/cols)
            y0,y1=round(row*height/rows),round((row+1)*height/rows)
            p=pixels[y0:y1,x0:x1];rgb=p[:,:,:3].astype(float)/255
            red=(rgb[:,:,0]>.70)&(rgb[:,:,1]<.36)&(rgb[:,:,2]<.36)
            gray=(rgb[:,:,0]<.70)&(abs(rgb[:,:,0]-rgb[:,:,1])<.075)&(abs(rgb[:,:,1]-rgb[:,:,2])<.075)
            valid=(p[:,:,3]>=200)&~red&~gray
            components,count=label(valid);sizes=np.bincount(components.ravel());sizes[0]=0
            assert count and sizes.max()>100,f'Missing full-body sprite {name} {row},{col}'
            body=find_objects(components)[sizes.argmax()-1];top,bottom=body[0].start,body[0].stop
            left,right=body[1].start,body[1].stop
            # Cyan torso gives a stable pivot even as feet and arms change pose.
            cyan=valid&(p[:,:,2]>140)&(p[:,:,1]>100)&(p[:,:,0]<110)
            cyan[:top]=False;cyan[top+int((bottom-top)*.73):]=False
            xs=np.where(cyan)[1]
            pivot=(xs.min()+xs.max())/2 if len(xs) else (left+right)/2
            frames.append(dict(x=x0+left,y=y0+top,w=right-left,h=bottom-top,
                anchor=round(float(pivot-left),2),height=bottom-top,art=name))
    return frames

def run():
    root=res.ROOT;out=root/'output/imagegen'
    frames=cells(out/'wilson-relaxed-walk-atlas.png',6,3,'spr_wilson_walk_atlas')
    side=out/'wilson-side-walk-strip.png'
    if side.exists():frames[12:]=cells(side,6,1,'spr_wilson_side_walk')
    for row in range(3):
        common=float(np.median([f['h'] for f in frames[row*6:row*6+6]]))
        for frame in frames[row*6:row*6+6]:frame['height']=common
    path=root/'scripts/world_render/world_render.gml'
    head=path.read_text(encoding='utf-8').split('// GENERATED WALKING METADATA')[0]
    records=[]
    for f in frames:
        records.append('{'+','.join(k+':'+(v if k=='art' else json.dumps(v)) for k,v in f.items())+'}')
    path.write_text(head+'// GENERATED WALKING METADATA (source atlases remain untouched)\n'
        +'function wilson_quadros(){static _frames=[\n    '+',\n    '.join(records)+'\n];return _frames;}\n',encoding='utf-8')
    (out/'wilson-walk-metadata.json').write_text(json.dumps(frames,indent=2),encoding='utf-8')
    save(root/'ParadoxoDeWilson.yyp',res.PROJECT)
    print('Imported 18 relaxed frames with aligned torso pivots and foot baselines.')

if __name__=='__main__':run()
