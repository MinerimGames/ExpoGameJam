"""Royal portal arrival clears the visible southern arch and cannot retreat."""
import unittest
from test_world_collision_revision import geometry, blocked, occupied
from audit_world_geometry import reachable


class SteampunkEntry(unittest.TestCase):
    def test_arrival_is_in_front_of_arch_on_clear_interior_floor(self):
        room, rects, foot = geometry('steampunk_foundry')
        player = next(i for l in room['layers'] for i in l.get('instances', [])
                      if i['objectId']['name'] == 'obj_player')
        # The arch crest starts at world y545; feet must be wholly ahead of it.
        self.assertGreaterEqual(player['y'], 500)
        self.assertLess(player['y'] + 7, 545)
        self.assertFalse(blocked(rects, foot, player['x'], player['y']))

    def test_rear_entrance_cannot_be_reached_while_forward_routes_stay_open(self):
        room, rects, foot = geometry('steampunk_foundry')
        field = occupied(room, rects, foot)
        seen = reachable(room, field)
        width = room['roomSettings']['Width']
        for x in range(405, 559):
            with self.subTest(rear_seal_x=x):
                self.assertTrue(blocked(rects, foot, x, 548))
        self.assertFalse(seen[595 * width + 480], 'player can return behind the entrance')
        for x, y in [(480, 110), (300, 342), (740, 342)]:
            with self.subTest(forward_target=(x, y)):
                self.assertTrue(seen[y * width + x], 'forward exploration was blocked')
