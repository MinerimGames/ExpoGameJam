"""Import 96 supplied precomposed panels without resampling their pixels."""
import copy
import hashlib
import json
import shutil
import uuid
from pathlib import Path
import numpy as np
from PIL import Image, ImageDraw, ImageFont
from evento_project import load, save
from import_guardian_throne import XS as GUARD_XS, YS as GUARD_YS

ROOT = Path(__file__).resolve().parents[1]
DOWNLOADS = Path('C:/Users/jrhre/Downloads')
PATH_XS = [[(5,232),(237,467),(472,693),(698,896),(901,1086),(1092,1252)]]*6
MASK_XS = [[(4,226),(232,435),(441,635),(640,838),(844,1042),(1047,1250)]]*4
MASK_YS = [(3,310),(316,624),(630,934),(940,1250)]
SHEETS = [
 ('caminho','Aproximação ao Trono Neon.png','spr_secret_path_approach',PATH_XS,GUARD_YS,1),
 ('guardiao','Cavaleiro Mascarado Avança pelo Trono Verde.png','spr_secret_guardian_approach',GUARD_XS,GUARD_YS,1),
 ('revelacao','Spritesheet do cavaleiro removendo a máscara.png','spr_secret_mask_reveal',MASK_XS,MASK_YS,37)]

def label_mask(panel):
    a=np.asarray(panel).astype(int)
    neutral=(a[:33,:45,:3].max(2)-a[:33,:45,:3].min(2)<48)&(a[:33,:45,:3].min(2)>60)
    result=np.zeros(a.shape[:2],dtype=bool)
    yy,xx=np.where(neutral)
    if len(xx):
        # Include dark antialias fringes around the printed guide. The guide's
        # tiny corner bounds contain no figure; background pixels are not repainted.
        result[max(0,yy.min()-3):min(33,yy.max()+4),max(0,xx.min()-3):min(45,xx.max()+4)]=True
    return result

def main():
    template=load(ROOT/'sprites/spr_secret_throne_01/spr_secret_throne_01.yy')
    project=load(ROOT/'ParadoxoDeWilson.yyp')
    report={'sequences':[]}
    for group,filename,name,xs,ys,first in SHEETS:
        source=DOWNLOADS/filename
        raw=source.read_bytes()
        sheet=Image.open(source).convert('RGBA')
        assert sheet.size==(1254,1254)
        folder=ROOT/'datafiles/cutscene_final'/group
        folder.mkdir(parents=True,exist_ok=True)
        shutil.copy2(source,folder/'original.png')
        panels=[];entry={'name':name,'group':group,'source_sha256':hashlib.sha256(raw).hexdigest(),'frames':[]}
        for i in range(len(ys)*6):
            x0,x1=xs[i//6][i%6];y0,y1=ys[i//6]
            rect=[x0,y0,x1,y1]
            panel=sheet.crop(rect)
            pixels=np.asarray(panel).copy();guide=label_mask(panel)
            # Exclude the printed guide corner and shadow without repainting it.
            pixels[guide,3]=0
            panel=Image.fromarray(pixels)
            panel.save(folder/f'frame_{i+first:02}.png')
            panels.append(panel)
            entry['frames'].append({'number':i+first,'rect':rect,'size':list(panel.size),'guide_pixels':int(guide.sum())})
        width=max(p.width for p in panels);height=max(p.height for p in panels)
        target=ROOT/'sprites'/name;yy=target/(name+'.yy')
        previous=load(yy) if yy.exists() else None
        data=json.loads(json.dumps(template).replace(template['name'],name))
        data.update(width=width,height=height,bbox_left=0,bbox_top=0,bbox_right=width-1,bbox_bottom=height-1,origin=0,edgeFiltering=False)
        data['sequence'].update(length=float(len(panels)),playbackSpeed=12.0,xorigin=0,yorigin=0)
        layer=previous['layers'][0]['name'] if previous else str(uuid.uuid4())
        data['layers'][0].update(name=layer,**{'%Name':layer})
        data['frames']=[];keys=[]
        for i,panel in enumerate(panels):
            fid=previous['frames'][i]['name'] if previous else str(uuid.uuid4())
            frame=copy.deepcopy(template['frames'][0]);frame.update(name=fid,**{'%Name':fid})
            data['frames'].append(frame)
            key=copy.deepcopy(template['sequence']['tracks'][0]['keyframes']['Keyframes'][0])
            key.update(id=str(uuid.uuid4()),Key=float(i))
            key['Channels']['0']['Id']={'name':fid,'path':f'sprites/{name}/{name}.yy'}
            keys.append(key)
            # Native sprites need one storage size. Draw clips to each panel's
            # real bounds; this transparent packing is never presented on screen.
            native=Image.new('RGBA',(width,height))
            native.paste(panel,(0,0))
            (target/'layers'/fid).mkdir(parents=True,exist_ok=True)
            native.save(target/(fid+'.png'));native.save(target/'layers'/fid/(layer+'.png'))
            entry['frames'][i]['frame']=fid
        data['sequence']['tracks'][0]['keyframes']['Keyframes']=keys
        save(yy,data)
        ref={'id':{'name':name,'path':f'sprites/{name}/{name}.yy'}}
        if ref not in project['resources']:project['resources'].append(ref)
        report['sequences'].append(entry)
        assert source.read_bytes()==raw
    # A separate monochrome bitmap font changes only the final quote.
    font_name='fnt_ending_pixel';font_dir=ROOT/'fonts'/font_name
    font_dir.mkdir(parents=True,exist_ok=True)
    old=load(ROOT/'fonts/fnt_ui/fnt_ui.yy')
    font=json.loads(json.dumps(old).replace('fnt_ui',font_name))
    face=ImageFont.truetype(str(ROOT/'fonts/fnt_ui/DejaVuSansMono-Bold.ttf'),12)
    atlas=Image.new('RGBA',(256,256),(255,255,255,0));glyphs={}
    for i,code in enumerate(range(32,256)):
        x=2+(i%25)*10;y=2+(i//25)*20
        tile=Image.new('L',(8,16));ImageDraw.Draw(tile).text((0,0),chr(code),font=face,fill=255)
        tile=tile.point(lambda v:255 if v>=96 else 0)
        alpha=atlas.getchannel('A');alpha.paste(tile,(x,y));atlas.putalpha(alpha)
        glyphs[str(code)]={'character':code,'h':16,'offset':0,'shift':8,'w':8,'x':x,'y':y}
    font.update(glyphs=glyphs,AntiAlias=0,usesSDF=False,size=9.0,lineHeight=16,ascender=12,ascenderOffset=0,regenerateBitmap=False,TTFName='DejaVuSansMono-Bold.ttf')
    atlas.save(font_dir/(font_name+'.png'));save(font_dir/(font_name+'.yy'),font)
    shutil.copy2(ROOT/'fonts/fnt_ui/DejaVuSansMono-Bold.ttf',font_dir/'DejaVuSansMono-Bold.ttf')
    shutil.copy2(ROOT/'fonts/fnt_ui/LICENSE-DejaVu.txt',font_dir/'LICENSE-DejaVu.txt')
    ref={'id':{'name':font_name,'path':f'fonts/{font_name}/{font_name}.yy'}}
    if ref not in project['resources']:project['resources'].append(ref)
    save(ROOT/'ParadoxoDeWilson.yyp',project)
    save(ROOT/'output/revision-20261009/neon-cutscene-import.json',report)
    print('NEON_IMPORT: 96 original panels, guides excluded, exact-size sequential PNGs and native sprites.')

if __name__=='__main__':main()
