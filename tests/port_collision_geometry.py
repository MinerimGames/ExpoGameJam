"""Port scenery and complete route regressions using the player's fixed mask."""
from collections import deque
from math import ceil
from pathlib import Path
import re
import sys
import unittest

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "tools"))
from evento_project import load


class PortCollisionGeometry(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        room = load(ROOT / "rooms/rm_commercial_district/rm_commercial_district.yy")
        cls.width = room["roomSettings"]["Width"]
        cls.height = room["roomSettings"]["Height"]
        instances = [i for layer in room["layers"] for i in layer.get("instances", [])]
        cls.spawn = next((i["x"], i["y"]) for i in instances
                         if i["objectId"]["name"] == "obj_player")
        cls.ally = next((i["x"], i["y"]) for i in instances
                        if i["objectId"]["name"] == "obj_capitalist_ally")
        player = load(ROOT / "objects/obj_player/obj_player.yy")
        mask = load(ROOT / player["spriteMaskId"]["path"])
        origin = mask["sequence"]
        cls.foot = (mask["bbox_left"] - origin["xorigin"],
                    mask["bbox_top"] - origin["yorigin"],
                    mask["bbox_right"] - origin["xorigin"],
                    mask["bbox_bottom"] - origin["yorigin"])
        collider = load(ROOT / "sprites/spr_colisor/spr_colisor.yy")
        cls.rectangles = [(i["x"], i["y"],
                           i["x"] + i["scaleX"] * collider["width"],
                           i["y"] + i["scaleY"] * collider["height"])
                          for i in instances if i["objectId"]["name"] == "obj_colisor"]
        # Inflate scenery by the actual mask, producing occupied player centers.
        cls.occupied = bytearray(cls.width * cls.height)
        left, top, right, bottom = cls.foot
        for x0, y0, x1, y1 in cls.rectangles:
            start_x, end_x = max(0, ceil(x0 - right)), min(cls.width, ceil(x1 - left))
            start_y, end_y = max(0, ceil(y0 - bottom)), min(cls.height, ceil(y1 - top))
            fill = b"\1" * (end_x - start_x)
            for y in range(start_y, end_y):
                offset = y * cls.width
                cls.occupied[offset + start_x:offset + end_x] = fill

    def blocked(self, x, y):
        left, top, right, bottom = self.foot
        return any(x + right >= x0 and x + left < x1
                   and y + bottom >= y0 and y + top < y1
                   for x0, y0, x1, y1 in self.rectangles)

    def test_fixed_player_foot_mask(self):
        self.assertEqual(self.foot, (-7, -1, 6, 7))

    def test_spawn_and_ally_are_connected(self):
        self.assertFalse(self.blocked(*self.spawn), "port spawn overlaps scenery")
        self.assertFalse(self.blocked(*self.ally), "ally position overlaps scenery")
        start = round(self.spawn[1]) * self.width + round(self.spawn[0])
        goal = round(self.ally[1]) * self.width + round(self.ally[0])
        queue = deque([start])
        seen = bytearray(self.width * self.height)
        seen[start] = 1
        while queue:
            current = queue.popleft()
            if current == goal:
                return
            y, x = divmod(current, self.width)
            for dx, dy in ((-1, 0), (1, 0), (0, -1), (0, 1),
                           (-1, -1), (-1, 1), (1, -1), (1, 1)):
                nx, ny = x + dx, y + dy
                if not (0 <= nx < self.width and 0 <= ny < self.height):
                    continue
                neighbor = ny * self.width + nx
                if not seen[neighbor] and not self.occupied[neighbor]:
                    seen[neighbor] = 1
                    queue.append(neighbor)
        self.fail("full player foot mask cannot reach the ally from the port spawn")

    def test_every_complete_runtime_waypoint_segment_is_clear(self):
        source = (ROOT / "tests/evento/Newton_Step.gml").read_text(encoding="utf-8")
        match = re.search(r"port_route\s*=\s*(\[.*?\]);", source, re.DOTALL)
        self.assertIsNotNone(match, "runtime port route is missing")
        points = [(int(x), int(y)) for x, y in re.findall(r"\[\s*(\d+)\s*,\s*(\d+)\s*\]", match[1])]
        self.assertGreater(len(points), 2)
        route = [self.spawn, *points, self.ally]
        for start, end in zip(route, route[1:]):
            # Half-pixel samples include both endpoints and diagonal segments.
            steps = max(1, ceil(2 * max(abs(end[0] - start[0]), abs(end[1] - start[1]))))
            for step in range(steps + 1):
                t = step / steps
                x = start[0] + (end[0] - start[0]) * t
                y = start[1] + (end[1] - start[1]) * t
                with self.subTest(segment=(start, end), point=(x, y)):
                    self.assertFalse(self.blocked(x, y), "complete route crosses solid scenery")

    def test_known_bridge_water_and_roof_leaks_are_blocked(self):
        cases = {"western roof": (90, 100), "southern warehouse": (110, 450),
                 "bridge west rail": (410, 270), "bridge east rail": (540, 270),
                 "western canal": (300, 270), "eastern canal": (690, 270),
                 "northwest bank parapet": (350, 170), "northeast bank parapet": (600, 170)}
        for name, point in cases.items():
            with self.subTest(scenery=name, point=point):
                self.assertTrue(self.blocked(*point), "foot mask can enter solid scenery")

    def test_entire_outer_shell_is_blocked(self):
        edges = [(x, y) for x in range(self.width) for y in (0, self.height - 1)]
        edges += [(x, y) for y in range(self.height) for x in (0, self.width - 1)]
        for x, y in edges:
            with self.subTest(edge=(x, y)):
                self.assertTrue(self.occupied[y * self.width + x], "outer shell has an opening")


if __name__ == "__main__":
    unittest.main()
