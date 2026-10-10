"""Import untouched artwork and author the approved Newton continuation."""
import copy
import json
import re
from pathlib import Path
import add_royal_interiors as res
from evento_project import load, save


def script(name):
    data=load(res.ROOT/'scripts/battle_system/battle_system.yy')
    data['name']=data['%Name']=name
    save(res.ROOT/f'scripts/{name}/{name}.yy',data)
    res.register(name,'scripts')


def dialogue_data():
    spec=(res.ROOT/'docs/superpowers/specs/2026-10-07-revelacao-newton-design.md').read_text(encoding='utf-8')
    groups={}
    for name,start,end in [('revelation','## Diálogo no distrito','## Retorno'),('exposure','## Retorno','## Primeira'),('recovery','## Recuperação','## Segunda')]:
        section=spec.split(start,1)[1].split(end,1)[0]
        pages=[]
        for speaker,text in re.findall(r'\d+\. \*\*(.+?):\*\* “(.+?)”',section):
            sprite='spr_wilson_idle_front'
            label=speaker.upper()
            if speaker=='Aliado':sprite='spr_capitalist_ally';label='ISLEIDE AGENTE'
            elif speaker.startswith('Newton'):sprite='spr_battle_newton';label='NEWTON'
            elif speaker=='Isleide das Cavernas':sprite='spr_isleide_cavernas'
            elif speaker=='Guarda':sprite='spr_castle_guard'
            elif speaker=='Rei':sprite='spr_king_standing'
            elif speaker=='Líder da Cidade':sprite='spr_city_peace'
            pages.append((label,sprite,text))
        groups[name]=pages
    groups['ending']=[('WILSON','spr_wilson_idle_front','O plano de Newton acabou aqui. Ninguém vai decidir sozinho quais realidades merecem existir.'),('ISLEIDE AGENTE','spr_capitalist_ally','Sem o controle de Newton, esta realidade está se desfazendo. Agora todos devem voltar às próprias realidades. Vou abrir uma passagem para cada um.'),('ISLEIDE AGENTE','spr_capitalist_ally','Seu passado voltou a ter uma escolha. Deixe este eco retornar ao início; sua passagem leva você de volta para casa.'),('WILSON','spr_wilson_idle_front','Então chegou a hora de voltar para a minha realidade. Obrigado por me ajudarem a corrigir esse paradoxo.')]
    code='function historia_newton_dialogo(_nome)\n{\n    switch(_nome)\n    {\n'
    for name,pages in groups.items():
        code+='        case '+json.dumps(name)+': return [\n'
        code+=',\n'.join('            {'+('actor:"newton",' if label=='NEWTON' else '')+'speaker:'+json.dumps(label,ensure_ascii=False)+',portrait:'+sprite+',text:'+json.dumps(text,ensure_ascii=False)+'}' for label,sprite,text in pages)
        code+='\n        ];\n'
    code+='    }\n    return [];\n}\n'
    path=res.ROOT/'scripts/newton_story/newton_story.gml'
    original=path.read_text(encoding='utf-8').split('// GENERATED DIALOGUES')[0]
    path.write_text(original+'// GENERATED DIALOGUES\n'+code,encoding='utf-8')


def district():
    # Orthogonal quays match commercial-straight-bridge.png in 960x640.
    # One broad unobstructed bridge replaces the jagged diagonal grid.
    walls=[
        (0,0,960,4),(0,636,960,4),(0,0,4,640),(956,0,4,640),
        (4,158,424,208),(526,158,430,208),
        (4,4,134,142),(138,4,182,120),(320,4,85,77),
        (551,4,110,97),(661,4,295,142),
        (4,382,272,254),(706,382,250,254),
    ]
    res.make_room('rm_commercial_district','spr_commercial_district',(480,600),walls)
    path=res.ROOT/'rooms/rm_commercial_district/rm_commercial_district.yy';data=load(path)
    data['roomSettings'].update(Width=960,Height=640)
    data['layers'][-1].update(spriteId=None,stretch=False)
    layer=data['layers'][1]
    for inst in layer['instances']:
        if inst['objectId']['name']=='obj_castle_interior':
            inst['objectId']={'name':'obj_commercial_scene','path':'objects/obj_commercial_scene/obj_commercial_scene.yy'}
    ally=copy.deepcopy(layer['instances'][0]);ally['name']=ally['%Name']='inst_COMMERCIAL_ALLY'
    ally.update(x=480.0,y=90.0,objectId={'name':'obj_capitalist_ally','path':'objects/obj_capitalist_ally/obj_capitalist_ally.yy'})
    layer['instances'].append(ally)
    data['instanceCreationOrder'].append({'name':ally['name'],'path':'rooms/rm_commercial_district/rm_commercial_district.yy'})
    data['views'][0].update(wview=384,hview=219,hborder=154,vborder=88,xview=288,yview=421)
    save(path,data)


def temporal():
    name='rm_temporal_origin'
    data=load(res.ROOT/'rooms/rm_tutorial/rm_tutorial.yy')
    data['name']=data['%Name']=name
    for order in data['instanceCreationOrder']:order['path']=f'rooms/{name}/{name}.yy'
    for layer in data['layers']:
        for inst in layer.get('instances',[]):
            if inst['objectId']['name']=='obj_newton_npc':inst['objectId']={'name':'obj_newton_final','path':'objects/obj_newton_final/obj_newton_final.yy'}
            if inst['objectId']['name']=='obj_player':inst.update(x=470.0,y=300.0)
    layer=next(l for l in data['layers'] if l['name']=='player')
    template=next(i for i in layer['instances'] if i['objectId']['name']=='obj_player')
    for obj,x,y in [('obj_past_wilson',520,250),('obj_capitalist_ally',430,300),('obj_temporal_scene',0,0)]:
        inst=copy.deepcopy(template);inst['name']=inst['%Name']='inst_TEMPORAL_'+obj.upper()
        inst.update(x=float(x),y=float(y),objectId={'name':obj,'path':f'objects/{obj}/{obj}.yy'})
        layer['instances'].append(inst);data['instanceCreationOrder'].append({'name':inst['name'],'path':f'rooms/{name}/{name}.yy'})
    data['views'][0].update(xview=256,yview=161)
    save(res.ROOT/f'rooms/{name}/{name}.yy',data);res.register(name,'rooms')
    order={'roomId':{'name':name,'path':f'rooms/{name}/{name}.yy'}}
    if order not in res.PROJECT['RoomOrderNodes']:res.PROJECT['RoomOrderNodes'].append(order)


if __name__=='__main__':
    res.sprite('spr_commercial_district',res.ROOT/'output/imagegen/commercial-straight-bridge.png',True)
    res.sprite('spr_capitalist_ally',Path('C:/Users/jrhre/Downloads/Capitalista0.png'))
    if (res.ROOT/'sprites/spr_newton_evil/spr_newton_evil.yy').exists():
        res.register('spr_newton_evil','sprites')
    for name,sprite_name,events in [('obj_commercial_scene',None,[(0,0),(3,0),(8,0),(8,64)]),('obj_capitalist_ally','spr_capitalist_ally',[(0,0),(3,0),(3,2),(8,0),(8,64)])]:
        res.object_resource(name,sprite_name,events)
    script('newton_story');dialogue_data();district()
    if (res.ROOT/'scripts/newton_battle/newton_battle.gml').exists():script('newton_battle')
    if (res.ROOT/'objects/obj_temporal_scene/Create_0.gml').exists():
        for name,sprite_name,events in [('obj_temporal_scene',None,[(0,0),(3,0),(8,0),(8,64)]),('obj_past_wilson','spr_wilson_idle_front',[(0,0),(8,0)]),('obj_newton_final','spr_battle_newton',[(0,0),(3,2),(8,0)])]:res.object_resource(name,sprite_name,events)
        temporal()
    save(res.ROOT/'ParadoxoDeWilson.yyp',res.PROJECT)
    print('Imported commercial district, ally and approved dialogues.')
