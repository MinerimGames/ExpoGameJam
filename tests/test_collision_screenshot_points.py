"""Physical footprints measured from the seven supplied collision screenshots."""
import unittest
from test_world_collision_revision import geometry, blocked, occupied
from audit_world_geometry import reachable


class ScreenshotContacts(unittest.TestCase):
    def test_machine_fronts_and_outer_columns_are_solid_on_both_sides(self):
        _, rects, foot = geometry('steampunk_foundry')
        # The machine plinths project beyond the old y316 box; outer columns
        # also occupy the former slits between those boxes and the room walls.
        for x, y in [(200, 322), (760, 322), (35, 220), (925, 220),
                     (90, 340), (900, 340), (90, 470), (900, 470)]:
            with self.subTest(point=(x, y)):
                self.assertTrue(blocked(rects, foot, x, y))

    def test_gate_garden_and_city_crate_flag_bases_are_solid(self):
        fixtures = {
            'autumn_gate': [(48, 147), (100, 147), (700, 147), (785, 147)],
            'autumn_streets': [(178, 175), (182, 240), (143, 160),
                               (195, 309), (630, 309), (226, 324),
                               (612, 324), (548, 163)],
        }
        for name, points in fixtures.items():
            _, rects, foot = geometry(name)
            for x, y in points:
                with self.subTest(room=name, point=(x, y)):
                    self.assertTrue(blocked(rects, foot, x, y))

    def test_the_visible_corridors_and_all_forward_destinations_stay_open(self):
        cases = {
            'steampunk_foundry': [(480, 520), (200, 342), (760, 342), (480, 110)],
            'autumn_gate': [(48, 158), (785, 158), (416, 248), (416, 50)],
            'autumn_streets': [(180, 150), (237, 334), (591, 334),
                               (571, 162), (336, 310), (400, 70)],
        }
        for name, points in cases.items():
            room, rects, foot = geometry(name)
            seen = reachable(room, occupied(room, rects, foot))
            for x, y in points:
                with self.subTest(room=name, point=(x, y)):
                    self.assertFalse(blocked(rects, foot, x, y))
                    self.assertTrue(seen[y * room['roomSettings']['Width'] + x])
