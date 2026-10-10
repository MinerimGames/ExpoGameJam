"""Authored scenery occupancy and routes; no collider-count assertions."""
from pathlib import Path
import sys
import unittest
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'tools'))
from evento_project import load
ROOT=Path(__file__).resolve().parents[1]
ROOMS=['tutorial','temporal_origin','cavernas','cavernas_2','bosque','vila','castelo','castle_hall','throne_room','autumn_gate','autumn_streets','autumn_plaza','steampunk_foundry']
def rectangles(name):
 r=load(ROOT/f'rooms/rm_{name}/rm_{name}.yy')
 return [(i['x'],i['y'],i['x']+i['scaleX']*32,i['y']+i['scaleY']*32) for l in r['layers'] for i in l.get('instances',[]) if i['objectId']['name']=='obj_colisor']
def blocked(rects,x,y):
 # The real player's fixed mask spans x-7..x+6 and y-1..y+7.
 return any(x+6>=a and x-7< c and y+7>=b and y-1<d for a,b,c,d in rects)
class Geometry(unittest.TestCase):
 def test_foundry_machine_roofs_crates_and_entrance_walls_are_solid(self):
  rects=rectangles('steampunk_foundry')
  for point in [(190,150),(310,278),(720,200),(800,290),(230,430),(680,430),(370,450),(582,450),(380,595),(580,595)]:
   with self.subTest(point=point):self.assertTrue(blocked(rects,*point),'player enters a projected machine or wall')
 def test_foundry_entrance_boss_exit_and_crosswalk_are_accessible(self):
  rects=rectangles('steampunk_foundry')
  routes=[((480,520),(480,58)),((300,342),(740,342))]
  for a,b in routes:
   steps=int(max(abs(b[0]-a[0]),abs(b[1]-a[1])))
   for t in range(steps+1):
    point=(a[0]+(b[0]-a[0])*t/steps,a[1]+(b[1]-a[1])*t/steps)
    with self.subTest(point=point):self.assertFalse(blocked(rects,*point),'authored foundry trail is blocked')
 def test_buildings_water_and_furniture_are_solid(self):
  cases={'tutorial':[(568,246)],'temporal_origin':[(568,246)],'cavernas':[(335,136),(335,212)],'cavernas_2':[(448,177),(150,207)],'bosque':[(330,157),(597,251)],'vila':[(340,24),(340,84),(556,120),(556,166),(134,290),(420,348),(120,496),(236,566),(360,550)],'castelo':[(416,100),(416,350),(520,620)],'castle_hall':[(180,330),(603,310),(260,442)],'throne_room':[(160,443),(632,443),(119,265)],'autumn_gate':[(570,149),(296,112),(548,240)],'autumn_streets':[(62,64),(416,252),(539,149)],'autumn_plaza':[(318,196),(638,355),(145,260)]}
  for name,points in cases.items():
   rects=rectangles(name)
   for x,y in points:
    with self.subTest(room=name,point=(x,y)):self.assertTrue(blocked(rects,x,y),'feet can enter solid scenery')
 def test_tree_base_has_no_invisible_tail(self):
  for name in ['tutorial','temporal_origin']:
   self.assertFalse(blocked(rectangles(name),552,274),name+' blocks empty ground below tree')
 def test_outer_edges_cannot_be_crossed(self):
  for name in ROOMS:
   r=load(ROOT/f'rooms/rm_{name}/rm_{name}.yy');w=r['roomSettings']['Width'];h=r['roomSettings']['Height'];rects=rectangles(name)
   edges=[(0,y) for y in range(8,h-8,8)]+[(w-1,y) for y in range(8,h-8,8)]+[(x,0) for x in range(8,w-8,8)]+[(x,h-1) for x in range(8,w-8,8)]
   with self.subTest(room=name):self.assertTrue(all(blocked(rects,x,y) for x,y in edges),'an outer edge is unguarded')
 def test_story_routes_remain_clear(self):
  routes={'tutorial':[(160,185),(400,218)],'temporal_origin':[(400,260),(420,205)],'cavernas':[(80,280),(80,170),(336,170),(616,170)],'cavernas_2':[(48,170),(300,170),(300,140),(390,140),(390,210)],'bosque':[(608,214),(608,232),(568,232),(568,248),(536,248),(536,260),(376,260),(376,226),(368,226),(368,210),(328,210),(328,178),(304,178),(304,16)],'vila':[(576,608),(576,514),(552,514),(552,210),(504,210),(504,186),(480,186),(480,164),(20,164)],'castelo':[(416,704),(416,610),(416,526)],'castle_hall':[(400,440),(400,158)],'throne_room':[(400,400),(400,260)],'autumn_gate':[(416,248),(416,50)],'autumn_streets':[(416,388),(416,310),(336,310),(336,130),(400,130),(400,70)],'autumn_plaza':[(480,516),(480,260),(480,72)]}
  for name,points in routes.items():
   rects=rectangles(name)
   for a,b in zip(points,points[1:]):
    steps=int(max(abs(b[0]-a[0]),abs(b[1]-a[1])))
    for t in range(steps+1):
     x=a[0]+(b[0]-a[0])*t/max(1,steps);y=a[1]+(b[1]-a[1])*t/max(1,steps)
     with self.subTest(room=name,segment=(a,b),point=(x,y)):
      self.assertFalse(blocked(rects,x,y),'story trail is blocked')
if __name__=='__main__':unittest.main()
