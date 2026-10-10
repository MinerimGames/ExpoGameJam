"""Import intact native-generated classroom/professor art and author final room."""
import copy
import add_royal_interiors as res
from evento_project import load, save


def build_room():
    name = 'rm_fatec_classroom'
    room = load(res.ROOT / 'rooms/rm_castle_hall/rm_castle_hall.yy')
    room['name'] = room['%Name'] = name
    room['roomSettings'].update(Width=960, Height=640)
    room['creationCodeFile'] = ''
    collider, characters, background = room['layers']
    template = copy.deepcopy(characters['instances'][0])
    collider['instances'] = []
    characters['instances'] = []
    room['instanceCreationOrder'] = []

    def instance(obj, suffix, px, py, sx=1, sy=1, layer=characters):
        item = copy.deepcopy(template)
        item['name'] = item['%Name'] = 'inst_FATEC_' + suffix
        item.update(x=px, y=py, scaleX=sx, scaleY=sy,
                    objectId={'name': obj, 'path': f'objects/{obj}/{obj}.yy'})
        layer['instances'].append(item)
        room['instanceCreationOrder'].append({'name': item['name'], 'path': f'rooms/{name}/{name}.yy'})

    bounds = [(0,0,960,145), (0,145,26,495), (934,145,26,495),
              (26,616,908,24), (682,123,132,75), (811,53,57,102)]
    # Orthogonal furniture banks; broad middle aisle is unobstructed.
    for py in (209,279,355,431):
        bounds += [(106,py,306,78), (548,py,320,78)]
    for idx,(px,py,w,h) in enumerate(bounds):
        instance('obj_colisor', f'COLLIDER_{idx}', px, py, w/32, h/32, collider)
    instance('obj_player', 'PLAYER', 480, 560)
    instance('obj_fatec_ending', 'ENDING', 0, 0)
    background.update(spriteId={'name':'spr_fatec_classroom',
                                'path':'sprites/spr_fatec_classroom/spr_fatec_classroom.yy'},
                      stretch=True, x=0, y=0)
    room['views'][0].update(wview=960,hview=640,wport=960,hport=640,
                            xview=0,yview=0,objectId=None,visible=True)
    room['viewSettings']['enableViews'] = True
    save(res.ROOT/f'rooms/{name}/{name}.yy', room)
    res.register(name, 'rooms')
    order={'roomId':{'name':name,'path':f'rooms/{name}/{name}.yy'}}
    if order not in res.PROJECT['RoomOrderNodes']:
        res.PROJECT['RoomOrderNodes'].append(order)


if __name__ == '__main__':
    res.sprite('spr_fatec_classroom',res.ROOT/'output/imagegen/fatec-classroom.png',True)
    res.sprite('spr_wilson_professor',res.ROOT/'output/imagegen/wilson-professor.png')
    res.object_resource('obj_fatec_ending',None,[(0,0),(3,0),(8,0),(8,64)])
    build_room()
    save(res.ROOT/'ParadoxoDeWilson.yyp',res.PROJECT)
    print('Registered classroom, professor and epilogue controller; central aisle clear.')
