"""Regressions for the second screenshot batch, registered against map art."""
import unittest
from test_world_collision_revision import geometry, blocked, occupied
from audit_world_geometry import reachable


class NewScreenshotContacts(unittest.TestCase):
    def test_reported_solid_contacts_block_the_real_player_footprint(self):
        # Origins are screenshot foot pixels projected into each room minus
        # the player's seven-pixel ground offset. These are independent of
        # the repair generator; removing a repair reopens its reported contact.
        contacts = {
            'steampunk_foundry': [(142,361),(823,349),(551,538),(413,521)],
            'autumn_streets': [(163,120)],
            'castle_hall': [(267,390),(117,373),(57,419),(138,242),
                            (310,258),(545,375),(610,360),(503,274)],
        }
        for name, points in contacts.items():
            _, rects, foot = geometry(name)
            for point in points:
                with self.subTest(room=name, point=point):
                    self.assertTrue(blocked(rects, foot, *point), 'reported prop/wall remains walkable')

    def test_corridors_around_the_repaired_props_remain_reachable(self):
        cases = {
            'steampunk_foundry': [(480,520),(480,110),(200,342),(760,342),
                                  (170,352),(791,352)],
            'castle_hall': [(400,440),(400,158),(281,406),(150,263),
                            (330,255),(520,270),(565,375),(590,352),
                            (141,379),(67,405)],
            'autumn_streets': [(195,125),(336,310),(400,70)],
        }
        for name, points in cases.items():
            room, rects, foot = geometry(name)
            field = occupied(room, rects, foot)
            seen = reachable(room, field)
            width = room['roomSettings']['Width']
            for x,y in points:
                with self.subTest(room=name, point=(x,y)):
                    self.assertFalse(blocked(rects, foot, x,y), 'adjacent floor was overblocked')
                    self.assertTrue(seen[y*width+x], 'adjacent corridor disconnected')

if __name__ == '__main__':
    unittest.main()
