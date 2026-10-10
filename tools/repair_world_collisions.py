"""Idempotent collision repairs authored against the intact room artwork.

Only obj_colisor instances change. Scenery, spawn positions and transition
objects are preserved. Coordinates represent ground footprints; the large
castle fills seal its exterior roof, never the route to its doorway.
"""
from pathlib import Path
import copy
from evento_project import load, save
ROOT=Path(__file__).resolve().parents[1]
# Rectangles are x,y,width,height, measured in room coordinates.
REPAIRS={
 'tutorial':[], 'temporal_origin':[],
 'cavernas':[(304,0,64,160),(304,192,64,168)],
 'cavernas_2':[(0,136,8,64)],
 'bosque':[(632,192,8,48)],
 'vila':[(248,16,172,136),(512,112,80,96),(56,200,128,130),
         (336,312,168,112),(624,432,16,48),
         # Southern river runs: retain the wooded island and the eastern trail.
         (64,480,144,16),(48,496,176,16),(32,512,96,16),(144,512,96,16),
         (0,528,80,16),(176,528,80,16),(336,528,128,16),
         (0,544,64,16),(192,544,64,16),(320,544,160,16),
         (16,560,32,16),(208,560,272,16),(208,576,160,16),(416,576,64,16),
         (224,592,48,16),(304,592,48,16),(432,592,64,16),
         (448,608,48,16),(448,624,64,16)],
 'castelo':[(248,212,344,288),(300,160,88,80),(408,48,136,168)],
 'castle_hall':[(249,430,22,20),(533,389,23,16),(119,276,23,14),(296,273,19,16)],
 'throne_room':[(109,256,20,18),(689,301,24,18),(299,469,21,16),(680,466,24,18)],
 'autumn_gate':[(522,130,80,26),(351,218,16,14),(461,218,16,14)],
 'autumn_streets':[(20,8,100,104),(523,132,31,22),(278,143,33,22),
                   (354,383,18,12),(458,383,18,12),(241,60,18,10),(541,60,18,10)],
 'autumn_plaza':[(137,250,18,18),(802,250,18,18),(371,188,18,18),(571,188,18,18),
                 (371,338,18,18),(571,338,18,18)],
}
# The original rooms have open exteriors beyond their intended trail banks.
# These bars stop foot geometry before the map edge. Transition thresholds
# occur farther inside (cavern x616, forest y24) and stay reachable.
SHELLS={'cavernas','cavernas_2','bosque','castelo'}
# These interiors had wall faces and furniture projections treated as arbitrary
# large boxes. Replace their topology instead of stacking patch rectangles.
# Tall props use their ground bases, and scene foregrounds redraw their bodies.
TOPOLOGY={
 'castle_hall':[(0,0,800,80),(0,80,50,520),(750,80,50,520),
   (50,80,310,121),(440,80,310,121),
   (50,435,257,165),(493,435,257,165),(307,456,53,144),(440,456,53,144),(360,576,80,24),
   (60,282,63,64),(702,244,39,110), # tapestry stand/bookcase physical bodies
   (172,326,65,25),(568,301,85,18),(98,409,89,29),(578,410,125,28), # table/cabinets
   (299,363,25,18),(483,363,23,18), # column bases, floor behind remains clear
   (68,385,22,17),(714,394,29,23), # low plant pots
   (531,273,18,14),(658,321,25,14), # raised plant/globe bases
   (287,209,31,20),(474,209,32,20), # upper stair column bases
   (249,435,22,16),(533,389,23,16),(119,276,23,14),(296,273,19,16)],
 'throne_room':[(0,0,800,95),(0,95,52,505),(748,95,52,505),
   (52,95,285,125),(463,95,285,125),(338,95,124,109),
   (52,475,290,125),(458,475,290,125),(342,576,116,24),
   (110,445,120,26),(574,445,104,26), # couch feet, can walk behind the backs
   (235,274,31,36),(535,274,33,36), # staircase handrail bases
   (58,348,24,29),(719,348,23,29),(57,447,25,29),(718,447,25,29),
   (110,229,17,12),(675,229,17,12),
   (109,256,20,18),(689,301,24,18),(299,469,21,16),(680,466,24,18)],
 'fatec_classroom':[(0,0,960,145),(0,145,26,495),(934,145,26,495),
   (26,580,387,60),(541,580,393,60),(413,620,128,20),
   (98,143,37,16),(682,166,132,32),(656,162,24,24),(818,146,45,12),
   (44,251,16,18),(27,530,25,37),(914,531,20,38)],
}
# Perspective widens furniture down the screen; dimensions must follow each
# row instead of stamping the first row's sprite envelope everywhere.
CLASSROOM_ROWS=[(209,66,43,22,[118,193,269,346,549,627,705,783]),
                (279,73,55,21,[110,189,269,345,549,627,706,786]),
                (355,75,55,21,[104,184,266,347,550,631,713,794]),
                (431,80,60,22,[97,177,261,346,550,633,718,802])]
for y,width,chair_y,chair_height,xs in CLASSROOM_ROWS:
 for x in xs:
  TOPOLOGY['fatec_classroom'] += [(x,y+23,width,15),(x+9,y+chair_y,width-19,chair_height)]
REPAIRS['steampunk_foundry']=[(163,321,15,12),(134,386,15,15),(813,357,14,14),
                            (382,449,16,23),(564,449,16,23)]
REPAIRS['commercial_district']=[(4,148,424,10),(526,148,430,10),
                               (4,366,424,14),(526,366,430,14)]
# The city's lower retaining walls start at their top stone edge, not at
# the water line. Garden side pillars and portable flagstands are solid too.
REPAIRS['autumn_gate'] += [(0,168,300,44),(540,168,260,44)]
REPAIRS['autumn_streets'] += [(330,342,24,70),(480,342,32,70),
    (260,170,14,66),(552,170,14,66),(350,164,8,126),(474,164,6,126),
    (224,141,11,8),(346,139,12,7),(443,142,12,8),(469,139,12,7),(555,140,12,8),
    (281,52,42,7),(480,52,40,7)]
REPAIRS['autumn_plaza'] += [(216,108,60,10),(686,108,58,10)]

# Contacts measured from the seven supplied screenshots. These are the
# machine plinths, outer pipes, garden faces and low street stands, not
# enlarged boxes across the visible walking corridors.
REPAIRS['steampunk_foundry'] += [
    (28,90,16,234),(919,90,13,234),
    (44,310,354,14),(564,310,355,14),
    (28,316,78,194),(872,316,60,194)]
REPAIRS['autumn_gate'] += [(0,134,354,16),(474,134,326,16)]
REPAIRS['autumn_streets'] += [
    (170,164,20,167),(131,150,24,17),
    (182,299,28,17),(210,283,31,33),
    (597,299,54,17),(524,150,36,16),
    (210,321,32,6),(590,321,36,6)]

# Second screenshot batch: standing on candle arms/stems, entrance posts,
# the hall chest and cabinet flowers, and the northwestern fenced garden.
# Use narrow body sections instead of extending a box across the walkway.
TOPOLOGY['castle_hall'] += [
    (246,389,26,25),(253,414,12,21), # lower west candelabrum
    (527,344,31,25),(538,369,13,20), # lower east candelabrum
    (116,238,26,25),(123,263,12,13), # upper west candelabrum
    (289,230,31,25),(300,255,12,18), # upper carpet-side west candelabrum
    (480,230,31,25),(490,255,12,22),(484,277,24,14), # upper east counterpart
    (98,370,34,39), # wooden chest beside the lower left plant
    (50,414,48,21), # angled southwestern wall face
    (578,374,125,36),(599,353,18,21), # cabinet surface and flower vase
]
REPAIRS['steampunk_foundry'] += [
    (135,342,14,44),(813,342,14,51), # both southern workshop torches
    (405,510,31,38),(527,510,31,38), # posts join the sealed rear wall
]
REPAIRS['autumn_streets'] += [(120,95,56,49)] # fenced NW garden/pillar
def repair(root=ROOT):
 result={}
 for short,bounds in {**REPAIRS,**TOPOLOGY}.items():
  name='rm_'+short;path=root/f'rooms/{name}/{name}.yy';room=load(path)
  layers=[l for l in room['layers'] if any(i['objectId']['name']=='obj_colisor' for i in l.get('instances',[]))]
  layer=layers[0];before=sum(len([i for i in l.get('instances',[]) if i['objectId']['name']=='obj_colisor']) for l in room['layers'])
  template=copy.deepcopy(next(i for i in layer['instances'] if i['objectId']['name']=='obj_colisor'))
  remove={'inst_132A5C1F'} if short in ('tutorial','temporal_origin') else set()
  if short in TOPOLOGY:
   remove.update(i['name'] for l in room['layers'] for i in l.get('instances',[]) if i['objectId']['name']=='obj_colisor')
  for l in room['layers']:
   remove.update(i['name'] for i in l.get('instances',[]) if i['name'].startswith('inst_COLLISION_REPAIR_'))
   l['instances']=[i for i in l.get('instances',[]) if i['name'] not in remove] if 'instances' in l else l.get('instances',None)
   if l.get('instances') is None:l.pop('instances',None)
  room['instanceCreationOrder']=[i for i in room['instanceCreationOrder'] if i['name'] not in remove]
  authored=list(bounds)
  if short in SHELLS:
   w=room['roomSettings']['Width'];h=room['roomSettings']['Height']
   authored.extend([(0,0,w,8),(0,h-8,w,8),(0,8,8,h-16),(w-8,8,8,h-16)])
  for index,(x,y,w,h) in enumerate(authored):
   inst=copy.deepcopy(template);instance_name=f'inst_COLLISION_REPAIR_{short}_{index}'
   inst['name']=inst['%Name']=instance_name;inst.update(x=float(x),y=float(y),scaleX=w/32,scaleY=h/32)
   layer['instances'].append(inst);room['instanceCreationOrder'].append({'name':instance_name,'path':f'rooms/{name}/{name}.yy'})
  save(path,room)
  after=sum(len([i for i in l.get('instances',[]) if i['objectId']['name']=='obj_colisor']) for l in room['layers'])
  result[name]=(before,after)
 return result
if __name__=='__main__':
 for name,(before,after) in repair().items():print(f'{name}: {before} -> {after} colliders')
