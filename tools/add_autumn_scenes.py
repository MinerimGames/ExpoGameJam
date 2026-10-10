"""Import unmodified autumn art and split the city at its gate and stairs."""
from pathlib import Path
import add_royal_interiors as resources
from evento_project import load, save


def room(name, art, width, height, spawn, walls):
    resources.make_room(name, art, spawn, walls)
    path = resources.ROOT / f"rooms/{name}/{name}.yy"
    data = load(path)
    data["roomSettings"].update(Width=width, Height=height)
    data["layers"][-1].update(spriteId=None, stretch=False)
    for inst in data["layers"][1]["instances"]:
        if inst["objectId"]["name"] == "obj_castle_interior":
            inst["objectId"] = {"name": "obj_autumn_scene", "path": "objects/obj_autumn_scene/obj_autumn_scene.yy"}
    data["views"][0].update(wview=384, hview=219, hborder=154, vborder=88,
                            xview=max(0, min(width-384, spawn[0]-192)),
                            yview=max(0, min(height-219, spawn[1]-110)))
    save(path, data)


if __name__ == "__main__":
    downloads = Path("C:/Users/jrhre/Downloads")
    resources.sprite("spr_autumn_city", downloads / "Praça Cívica de Outono em Pixel Art.png", True)
    resources.sprite("spr_autumn_plaza", downloads / "Praça Cívica Outonal em Pixel Art.png", True)
    resources.object_resource("obj_autumn_scene", None, [(0,0),(3,0),(8,0),(8,64)])
    # Both city sections render the same complete sprite with the same scale.
    # The gate room clips the southern region using a background offset of 336.
    gate_walls = [(0,0,800,8),(0,8,8,256),(792,8,8,256),(8,260,784,4),
                  (0,212,312,48),(528,212,272,48),
                  (300,168,24,92),(516,168,24,92),
                  (50,84,280,50),(330,75,24,65),(474,75,26,65),(500,84,260,50),
                  (90,12,236,58),(500,12,230,58)]
    street_walls = [(0,0,800,8),(0,8,20,436),(780,8,20,436),(20,436,760,8),
                    (358,164,116,126),
                    (0,164,170,160),(188,175,72,100),(562,175,76,100),(638,105,142,120),
                    (120,8,102,87),(575,8,200,87),
                    (185,72,172,33),(442,72,318,33),
                    (266,12,64,36),(454,16,61,32),(266,128,46,38),
                    (0,250,178,110),(628,250,152,110),
                    (144,342,186,70),(512,342,204,70),
                    (50,412,302,24),(480,412,280,24)]
    plaza_walls = [(0,0,960,16),(0,16,12,524),(948,16,12,524),(12,536,936,4),
                   (12,16,388,88),(560,16,388,88),(400,16,160,38),
                   (12,112,120,184),(828,112,120,184),
                   (12,296,156,128),(792,296,156,128),
                   (258,148,112,76),(585,148,114,76),
                   (258,302,112,82),(585,302,114,82),
                   (12,424,388,112),(560,424,388,112)]
    room("rm_autumn_gate", "spr_autumn_city", 800, 264, (416,248), gate_walls)
    room("rm_autumn_streets", "spr_autumn_city", 800, 444, (416,388), street_walls)
    room("rm_autumn_plaza", "spr_autumn_plaza", 960, 540, (480,516), plaza_walls)
    save(resources.ROOT / "ParadoxoDeWilson.yyp", resources.PROJECT)
    print("Imported two intact backgrounds and three autumn route sections.")
