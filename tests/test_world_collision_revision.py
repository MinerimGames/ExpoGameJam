"""Every-pixel scenery regressions measured independently from the map art.

The rectangles below describe the visible solid surface/base, not the repair
generator's rectangles. Tests use the native fixed foot mask from its resource.
"""
from pathlib import Path
from collections import deque
from math import ceil
import sys
import unittest

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'tools'))
from evento_project import load

# x0,y0,x1,y1 (exclusive): measured wall faces and physical prop bases.
SOLID_SURFACES = {
    'castle_hall': [(52,448,300,495),(500,448,746,495),
                    (61,282,111,340),(704,245,738,348),
                    (250,438,269,448),(535,388,552,400),
                    (291,269,310,281),(123,274,140,286),
                    (71,385,85,399),(715,394,738,414),
                    (298,363,321,378),(483,363,503,378)],
    'throne_room': [(54,480,337,498),(464,480,746,498),
                    (58,348,82,376),(719,348,740,376),
                    (57,447,81,473),(718,447,740,473),
                    (111,258,126,272),(690,304,710,318),
                    (113,230,122,237),(676,230,688,237),
                    (300,471,318,484),(682,470,703,484)],
    'steampunk_foundry': [(163,321,177,332),(134,386,148,400),
                           (813,357,826,370)],
    'commercial_district':[(10,148,400,157),(560,148,950,157),
                           (10,367,400,378),(560,367,950,378)],
    'autumn_gate':[(50,175,280,210),(560,175,780,210)],
    'autumn_streets':[(335,354,348,408),(482,354,507,408),
                      (263,178,270,232),(554,178,561,232),
                      (228,141,233,149),(348,140,355,144),
                      (447,142,454,150),(473,138,480,146),(559,140,566,148),
                      (284,51,318,57),(482,51,516,57),
                      (244,61,253,68),(545,61,554,68),
                      (357,384,368,392),(461,384,471,392)],
    'autumn_plaza':[(220,108,270,116),(690,108,739,116)],
    'fatec_classroom': [(98,143,135,156),(44,251,59,268),
                       (27,530,51,565),(914,531,939,566),
                       (656,161,680,185),(818,146,863,158),
                       (28,586,413,617),(542,586,932,617)],
}

# Projected upper bodies stay walkable; foreground redraw supplies occlusion.
BEHIND_PROPS = {'castle_hall':[(310,333),(491,333),(77,358)],
                'throne_room':[(70,325),(730,325)],
                'commercial_district':[(350,132),(610,132),(350,390),(610,390)],
                'autumn_gate':[(359,192),(469,192)],
                'autumn_streets':[(363,371),(466,371),(363,407),(466,407)],
                'autumn_plaza':[(380,170),(577,170),(145,228)],
                'fatec_classroom':[(145,214),(145,288),(145,364),(145,438)]}

ROUTES = {'castle_hall':[(400,440),(400,158)],
          'throne_room':[(400,400),(400,238)],
          'steampunk_foundry':[(480,520),(480,110)],
          'fatec_classroom':[(480,560),(480,165)],
          'vila':[(576,608),(576,514),(552,514),(552,210),(504,210),
                  (504,186),(480,186),(480,164),(20,164)],
          'bosque':[(608,214),(608,232),(568,232),(568,248),(536,248),
                    (536,260),(376,260),(376,226),(368,226),(368,210),
                    (328,210),(328,178),(304,178),(304,16)],
          'castelo':[(416,704),(416,610),(416,526)]}

def geometry(name):
    room = load(ROOT / f'rooms/rm_{name}/rm_{name}.yy')
    instances = [i for l in room['layers'] for i in l.get('instances',[])]
    rects = [(i['x'],i['y'],i['x']+32*i['scaleX'],i['y']+32*i['scaleY'])
             for i in instances if i['objectId']['name']=='obj_colisor']
    player = load(ROOT/'objects/obj_player/obj_player.yy')
    mask = load(ROOT/player['spriteMaskId']['path'])
    foot = tuple(mask['bbox_'+edge]-mask['sequence'][axis+'origin']
                 for edge,axis in [('left','x'),('top','y'),('right','x'),('bottom','y')])
    return room,rects,foot

def blocked(rects,foot,x,y):
    l,t,r,b = foot
    return any(x+r>=x0 and x+l<x1 and y+b>=y0 and y+t<y1
               for x0,y0,x1,y1 in rects)

def occupied(room,rects,foot):
    w,h = room['roomSettings']['Width'],room['roomSettings']['Height']
    field = bytearray(w*h)
    l,t,r,b = foot
    for x0,y0,x1,y1 in rects:
        a,c=max(0,ceil(x0-r)),min(w,ceil(x1-l))
        z,d=max(0,ceil(y0-b)),min(h,ceil(y1-t))
        if a>=c or z>=d:continue
        for y in range(z,d):field[y*w+a:y*w+c]=b'\1'*(c-a)
    return field

class CollisionRevision(unittest.TestCase):
    def test_all_fifteen_maps_full_pixel_reachability_and_complete_shells(self):
        from audit_world_geometry import ROOMS,TARGETS,reachable
        for name in ROOMS:
            room,rects,foot=geometry(name);field=occupied(room,rects,foot)
            seen=reachable(room,field);w,h=room['roomSettings']['Width'],room['roomSettings']['Height']
            with self.subTest(room=name):
                self.assertGreater(sum(seen),0,'entry overlaps scenery')
                edge_leaks=sum(not field[x] or not field[(h-1)*w+x] for x in range(w))
                edge_leaks+=sum(not field[y*w] or not field[y*w+w-1] for y in range(h))
                self.assertEqual(edge_leaks,0,'outer wall has an unguarded pixel')
                for x,y in TARGETS[name]:
                    self.assertTrue(seen[y*w+x],f'full foot mask cannot reach {(x,y)} from entry')

    def test_every_pixel_of_wall_faces_and_prop_bases_is_solid(self):
        for name,surfaces in SOLID_SURFACES.items():
            room,rects,foot=geometry(name);field=occupied(room,rects,foot)
            w=room['roomSettings']['Width']
            for surface in surfaces:
                x0,y0,x1,y1=surface
                leaks=[(x,y) for y in range(y0,y1) for x in range(x0,x1) if not field[y*w+x]]
                with self.subTest(room=name,surface=surface):
                    self.assertEqual(len(leaks),0,f'{len(leaks)} solid pixels unguarded, first={leaks[:6]}')

    def test_projected_prop_bodies_allow_walking_behind(self):
        for name,points in BEHIND_PROPS.items():
            _,rects,foot=geometry(name)
            for point in points:
                with self.subTest(room=name,point=point):
                    self.assertFalse(blocked(rects,foot,*point))

    def test_each_complete_route_segment_has_foot_clearance(self):
        for name,points in ROUTES.items():
            _,rects,foot=geometry(name)
            for a,b in zip(points,points[1:]):
                steps=max(1,ceil(2*max(abs(a[0]-b[0]),abs(a[1]-b[1]))))
                leaks=[(a[0]+(b[0]-a[0])*t/steps,a[1]+(b[1]-a[1])*t/steps)
                       for t in range(steps+1)
                       if blocked(rects,foot,a[0]+(b[0]-a[0])*t/steps,a[1]+(b[1]-a[1])*t/steps)]
                with self.subTest(room=name,segment=(a,b)):
                    self.assertEqual(len(leaks),0,f'blocked route samples={leaks[:4]}')

    def test_medieval_exit_order_matches_village_trail_castle(self):
        src=(ROOT/'objects/obj_cavern_exit_right/Step_0.gml').read_text()
        self.assertIn('case rm_vila:\n        _destination = rm_bosque;',src)
        self.assertIn('case rm_bosque:\n        _destination = rm_castelo;',src)

if __name__=='__main__':unittest.main()
