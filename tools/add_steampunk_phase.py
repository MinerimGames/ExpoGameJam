"""Register the approved industrial phase after the native sprite imports.

Run this helper only after the final sprites have been registered in the YYP.
It loads the current project at execution time, preserves existing sprite UUIDs,
and leaves production GML, other rooms, progression and audio untouched.
"""
from pathlib import Path
import copy

ROOM_NAME = "rm_steampunk_foundry"
WIDTH, HEIGHT = 960, 640
SPAWN = (480, 520)
BOSS_POSITION = (480, 188)
EXIT_POSITION = (480, 58)
# Full projected machine/box footprints are solid, including their roofs.
# The central walking strip remains free; the runtime gate is removable.
WALLS = [
    (0, 0, 960, 20), (0, 20, 28, 604), (932, 20, 28, 604), (0, 624, 960, 16),
    (28, 20, 386, 92), (547, 20, 385, 92),
    (44, 90, 354, 226), (564, 90, 355, 226),
    (110, 374, 247, 126), (600, 374, 260, 126),
    (357, 366, 41, 148), (564, 366, 36, 148),
    (0, 510, 405, 114), (558, 510, 402, 114),
    (405, 548, 153, 76),  # Seal the rear arch after the royal portal arrival.
]


def main():
    # Import inside main: an imported helper must not hold an old YYP snapshot.
    import add_royal_interiors as resources
    from evento_project import load, save

    source = resources.ROOT / "output/steampunk/foundry.png"
    required = ["spr_steampunk_idle", "spr_steampunk_talk", "spr_steampunk_attack", "spr_steampunk_defense"]
    missing = [name for name in required if not (resources.ROOT / f"sprites/{name}/{name}.yy").exists()]
    if missing:
        raise FileNotFoundError("Import approved character sprites first: " + ", ".join(missing))
    background = "spr_steampunk_foundry"
    if not (resources.ROOT / f"sprites/{background}/{background}.yy").exists():
        resources.sprite(background, source, background=True)
    for name in required + [background]:
        resources.register(name, "sprites")
    events = [(0, 0), (3, 0), (8, 0), (8, 64)]
    resources.object_resource("obj_steampunk_scene", None, events)
    resources.object_resource("obj_isleide_steampunk", "spr_steampunk_idle", events)
    resources.make_room(ROOM_NAME, background, SPAWN, WALLS)
    path = resources.ROOT / f"rooms/{ROOM_NAME}/{ROOM_NAME}.yy"
    data = load(path)
    data["roomSettings"].update(Width=WIDTH, Height=HEIGHT)
    collider_layer, actor_layer, scenery = data["layers"]
    scenery.update(spriteId=None, depth=300, stretch=False, x=0, y=0)
    for actor in actor_layer["instances"]:
        if actor["objectId"]["name"] == "obj_castle_interior":
            actor["objectId"] = {"name": "obj_steampunk_scene", "path": "objects/obj_steampunk_scene/obj_steampunk_scene.yy"}
    template = actor_layer["instances"][0]

    def add_actor(name, suffix, position):
        actor = copy.deepcopy(template)
        actor["name"] = actor["%Name"] = f"inst_STEAMPUNK_{suffix}"
        actor.update(x=float(position[0]), y=float(position[1]), scaleX=1, scaleY=1,
                     objectId={"name": name, "path": f"objects/{name}/{name}.yy"})
        actor_layer["instances"].append(actor)
        data["instanceCreationOrder"].append({"name": actor["name"], "path": f"rooms/{ROOM_NAME}/{ROOM_NAME}.yy"})

    add_actor("obj_isleide_steampunk", "BOSS", BOSS_POSITION)
    add_actor("obj_newton_cavern_dialogue", "NEWTON", (480, 570))
    data["viewSettings"].update(enableViews=True)
    data["views"][0].update(visible=True, wview=480, hview=320, wport=960, hport=640,
                            xview=240, yview=320, hborder=192, vborder=128,
                            objectId={"name": "obj_player", "path": "objects/obj_player/obj_player.yy"})
    save(path, data)
    save(resources.ROOT / "ParadoxoDeWilson.yyp", resources.PROJECT)
    print("Registered the industrial foundry, scene and 205 HP boss; existing sprites preserved.")


if __name__ == "__main__":
    main()
