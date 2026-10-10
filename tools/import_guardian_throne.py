"""Import supplied cinema panels; retain originals and exclude only printed labels."""
import copy
import hashlib
import json
import shutil
import uuid
from pathlib import Path
from PIL import Image
from evento_project import load, save

ROOT = Path(__file__).resolve().parents[1]
DOWNLOADS = Path('C:/Users/jrhre/Downloads')
THRONE = DOWNLOADS / 'Gemini_Generated_Image_8utihd8utihd8uti.jpg'
SHEET = DOWNLOADS / 'Cavaleiro Mascarado Avança pelo Trono Verde.png'
# Independently inspected green dividers: this generated sheet is not uniform.
XS = [
 [(3,230),(235,424),(430,636),(641,845),(850,1046),(1052,1251)],
 [(3,232),(238,434),(439,636),(641,841),(847,1049),(1054,1251)],
 [(3,225),(230,434),(439,635),(641,842),(847,1049),(1054,1251)],
 [(3,224),(229,433),(438,636),(641,841),(847,1048),(1053,1251)],
 [(3,224),(229,433),(438,636),(641,841),(847,1048),(1053,1251)],
 [(3,224),(229,433),(438,636),(641,841),(847,1047),(1052,1251)]]
YS = [(2,215),(221,430),(435,627),(633,820),(825,1016),(1022,1252)]
LABEL = (4,4,43,31)
NAME = 'spr_secret_guardian_approach'


def main():
    original_throne, original_sheet = THRONE.read_bytes(), SHEET.read_bytes()
    throne = Image.open(THRONE).convert('RGBA')
    sheet = Image.open(SHEET).convert('RGBA')
    assert throne.size == (2390,1792) and sheet.size == (1254,1254)
    shutil.copy2(THRONE, ROOT/'datafiles/secret_throne/05_Trono_Refatorado.jpg')
    shutil.copy2(SHEET, ROOT/'datafiles/secret_throne/07_Guardiao_Aproximacao.png')
    # Keep the original JPEG too; this PNG is a lossless decode for the native sprite.
    throne.save(ROOT/'datafiles/secret_throne/05_Trono_Vazio.png')
    yy = ROOT/'sprites/spr_secret_throne_05/spr_secret_throne_05.yy'
    template = load(yy)
    template.update(width=throne.width,height=throne.height,
                    bbox_right=throne.width-1,bbox_bottom=throne.height-1)
    frame, layer = template['frames'][0]['name'], template['layers'][0]['name']
    folder=yy.parent
    throne.save(folder/(frame+'.png'))
    throne.save(folder/'layers'/frame/(layer+'.png'))
    save(yy,template)

    data=json.loads(json.dumps(template).replace('spr_secret_throne_05',NAME))
    data.update(width=256,height=256,bbox_right=255,bbox_bottom=255,origin=0)
    data['sequence'].update(length=36.0,playbackSpeed=12.0,xorigin=0,yorigin=0)
    previous=ROOT/'sprites'/NAME/(NAME+'.yy')
    old=load(previous) if previous.exists() else None
    layer=old['layers'][0]['name'] if old else str(uuid.uuid4())
    data['layers'][0].update(name=layer,**{'%Name':layer})
    data['frames']=[]; keys=[]
    report={'sheet_size':list(sheet.size),'grid':[6,6],
            'source_sha256':hashlib.sha256(original_sheet).hexdigest(),
            'throne_sha256':hashlib.sha256(original_throne).hexdigest(),'frames':[]}
    for i in range(36):
        x0,x1=XS[i//6][i%6];y0,y1=YS[i//6]
        panel=sheet.crop((x0,y0,x1,y1))
        # A cropped corner excludes the numbering, never any character pixels.
        # The untouched original remains in datafiles; no background/pose is redrawn.
        panel.paste((0,0,0,0),LABEL)
        image=Image.new('RGBA',(256,256),(0,0,0,255))
        dest=((256-panel.width)//2,(256-panel.height)//2)
        image.paste(panel,dest)
        fid=old['frames'][i]['name'] if old else str(uuid.uuid4())
        frame=copy.deepcopy(template['frames'][0]);frame.update(name=fid,**{'%Name':fid})
        data['frames'].append(frame)
        key=copy.deepcopy(template['sequence']['tracks'][0]['keyframes']['Keyframes'][0])
        key.update(id=str(uuid.uuid4()),Key=float(i))
        key['Channels']['0']['Id']={'name':fid,'path':f'sprites/{NAME}/{NAME}.yy'}
        keys.append(key)
        target=ROOT/'sprites'/NAME
        (target/'layers'/fid).mkdir(parents=True,exist_ok=True)
        image.save(target/(fid+'.png'));image.save(target/'layers'/fid/(layer+'.png'))
        report['frames'].append({'number':i+1,'frame':fid,'rect':[x0,y0,x1,y1],
                                 'destination':list(dest),'label_exclusion':list(LABEL)})
    data['sequence']['tracks'][0]['keyframes']['Keyframes']=keys
    save(previous,data)
    project=load(ROOT/'ParadoxoDeWilson.yyp')
    entry={'id':{'name':NAME,'path':f'sprites/{NAME}/{NAME}.yy'}}
    if entry not in project['resources']:project['resources'].append(entry)
    save(ROOT/'ParadoxoDeWilson.yyp',project)
    save(ROOT/'output/revision-20261009/guardian-approach-import.json',report)
    assert THRONE.read_bytes()==original_throne and SHEET.read_bytes()==original_sheet
    print('GUARDIAN_IMPORT: original throne decoded losslessly; 36 native panels in reading order.')


if __name__=='__main__':main()
