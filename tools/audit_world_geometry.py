"""Read-only art/contact/reachability diagnostics; never changes source art.

Reconstructs native room tile/background layers, then annotates a disposable
diagnostic copy. Pixel flood fill uses the actual player mask and room geometry.
"""
from pathlib import Path
from collections import deque
import json
import sys
from PIL import Image, ImageDraw

ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT/'tests'))
from test_world_collision_revision import geometry,occupied,ROUTES,BEHIND_PROPS
from evento_project import load

ROOMS=['tutorial','cavernas','cavernas_2','vila','bosque','castelo',
       'castle_hall','throne_room','steampunk_foundry','autumn_gate',
       'autumn_streets','autumn_plaza','commercial_district','temporal_origin','fatec_classroom']
TARGETS={'tutorial':[(400,218)],'cavernas':[(616,170)],'cavernas_2':[(390,210)],
         'vila':[(20,164)],'bosque':[(304,16)],'castelo':[(416,526)],
         'castle_hall':[(400,158),(310,333),(491,333),(77,358)],
         'throne_room':[(400,238),(70,325),(730,325)],
         'steampunk_foundry':[(480,110),(740,342),(300,342)],
         'autumn_gate':[(416,50)],'autumn_streets':[(400,70)],
         'autumn_plaza':[(480,260),(480,72)],'commercial_district':[(480,90)],
         'temporal_origin':[(420,205),(560,272)],
         'fatec_classroom':[(480,165),(145,214),(145,288),(145,364),(145,438)]}
for _name,_points in BEHIND_PROPS.items():
    TARGETS[_name]=list(dict.fromkeys(TARGETS[_name]+_points))

def reachable(room,field):
    w,h=room['roomSettings']['Width'],room['roomSettings']['Height']
    player=next(i for layer in room['layers'] for i in layer.get('instances',[])
                if i['objectId']['name']=='obj_player')
    start=round(player['y'])*w+round(player['x']);seen=bytearray(w*h)
    if field[start]:return seen
    seen[start]=1;queue=deque([start])
    while queue:
        p=queue.popleft();y,x=divmod(p,w)
        # Four-connected unit steps cannot tunnel through a diagonal corner.
        for nx,ny in ((x-1,y),(x+1,y),(x,y-1),(x,y+1)):
            if 0<=nx<w and 0<=ny<h:
                n=ny*w+nx
                if not field[n] and not seen[n]:seen[n]=1;queue.append(n)
    return seen

def sprite_image(name):
    data=load(ROOT/f'sprites/{name}/{name}.yy')
    return Image.open(ROOT/f"sprites/{name}/{data['frames'][0]['name']}.png").convert('RGBA')

def tiles(data):
    if 'TileSerialiseData' in data:return data['TileSerialiseData']
    values=data['TileCompressedData'];out=[];i=0
    while i<len(values):
        count=values[i];i+=1
        if count<0:out.extend([values[i]]*(-count));i+=1
        else:out.extend(values[i:i+count]);i+=count
    return out

def render(name,room):
    w,h=room['roomSettings']['Width'],room['roomSettings']['Height']
    canvas=Image.new('RGBA',(w,h),(45,55,45,255))
    for layer in sorted(room['layers'],key=lambda l:l['depth'],reverse=True):
        if not layer.get('visible',True):continue
        if layer['resourceType']=='GMRBackgroundLayer' and layer.get('spriteId'):
            image=sprite_image(layer['spriteId']['name'])
            if layer.get('stretch'):image=image.resize((w,h),Image.Resampling.NEAREST)
            canvas.alpha_composite(image,(round(layer.get('x',0)),round(layer.get('y',0))))
        if layer['resourceType']=='GMRTileLayer':
            ts=load(ROOT/layer['tilesetId']['path']);image=sprite_image(ts['spriteId']['name'])
            tw,th=ts['tileWidth'],ts['tileHeight'];cols=(image.width-ts['tilexoff'])//(tw+ts['tilehsep'])
            sw=layer['tiles']['SerialiseWidth']
            for k,value in enumerate(tiles(layer['tiles'])):
                if value<0 or value==0:continue
                index=value&0x7ffff;cx=index%cols;cy=index//cols
                sx=ts['tilexoff']+cx*(tw+ts['tilehsep']);sy=ts['tileyoff']+cy*(th+ts['tilevsep'])
                tile=image.crop((sx,sy,sx+tw,sy+th))
                if value&0x80000:tile=tile.transpose(Image.Transpose.FLIP_LEFT_RIGHT)
                if value&0x100000:tile=tile.transpose(Image.Transpose.FLIP_TOP_BOTTOM)
                if value&0x200000:tile=tile.transpose(Image.Transpose.ROTATE_90)
                canvas.alpha_composite(tile,(k%sw*tw+round(layer.get('x',0)),k//sw*th+round(layer.get('y',0))))
    scenes={'steampunk_foundry':'spr_steampunk_foundry','commercial_district':'spr_commercial_district',
            'autumn_gate':'spr_autumn_city','autumn_streets':'spr_autumn_city','autumn_plaza':'spr_autumn_plaza'}
    if name in scenes:
        image=sprite_image(scenes[name]);image=image.resize((800,600) if name.startswith('autumn_') and name!='autumn_plaza' else (w,h),Image.Resampling.NEAREST)
        canvas.alpha_composite(image,(0,-336 if name=='autumn_gate' else 0))
    return canvas

def audit(out=ROOT/'output/diagnostics/revision-20261009'):
    out.mkdir(parents=True,exist_ok=True);summary={}
    for name in ROOMS:
        room,rects,foot=geometry(name);w,h=room['roomSettings']['Width'],room['roomSettings']['Height']
        field=occupied(room,rects,foot);seen=reachable(room,field)
        edges=[x for x in range(w)]+[(h-1)*w+x for x in range(w)]+[y*w for y in range(h)]+[y*w+w-1 for y in range(h)]
        targets=[{'x':x,'y':y,'clear':not bool(field[y*w+x]),'reachable':bool(seen[y*w+x])}
                 for x,y in TARGETS[name]]
        summary[name]={'dimensions':[w,h],'foot_mask':foot,'colliders':len(rects),'pixels':w*h,
                       'occupied_pixels':sum(field),'reachable_pixels':sum(seen),
                       'unguarded_edge_pixels':sum(not field[p] for p in edges),'targets':targets}
        image=render(name,room);draw=ImageDraw.Draw(image)
        for x0,y0,x1,y1 in rects:draw.rectangle((x0,y0,x1-1,y1-1),outline=(255,65,65,255),width=1)
        route=ROUTES.get(name,[])
        if route:draw.line(route,fill=(60,255,235,255),width=2)
        for t in targets:
            x,y=t['x'],t['y'];draw.ellipse((x-4,y-4,x+4,y+4),outline='lime' if t['reachable'] else 'magenta',width=2)
        for x in range(0,w,40):draw.text((x,0),str(x),fill='white',stroke_width=1,stroke_fill='black')
        for y in range(0,h,40):draw.text((0,y),str(y),fill='white',stroke_width=1,stroke_fill='black')
        image.convert('RGB').save(out/f'{name}-geometry.png')
        print(name,summary[name]['reachable_pixels'],'reachable pixels; edge leaks:',summary[name]['unguarded_edge_pixels'],
              '; unreachable targets:',[(t['x'],t['y']) for t in targets if not t['reachable']])
    (out/'geometry-audit.json').write_text(json.dumps(summary,indent=2),encoding='utf-8')
    return summary

if __name__=='__main__':audit()
