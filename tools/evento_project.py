"""Prepare an isolated GameMaker project running the real objects under test."""
import argparse
import json
import re
import shutil
from pathlib import Path


def load(path):
    return json.loads(re.sub(r",\s*([}\]])", r"\1", Path(path).read_text(encoding="utf-8-sig")))


def save(path, value):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(value, ensure_ascii=False, indent=2), encoding="utf-8")


def prepare(root, target, suite):
    for folder in ("objects", "scripts", "rooms", "sprites", "tilesets", "fonts", "options", "shaders", "sounds"):
        if (root / folder).exists():
            shutil.copytree(root / folder, target / folder, dirs_exist_ok=True)
    project = load(root / "ParadoxoDeWilson.yyp")
    project["configs"]["children"].append({"name":"EventoTests","children":[]})
    obj = load(root / "objects/obj_battle_controller/obj_battle_controller.yy")
    obj["name"] = obj["%Name"] = "obj_evento_test"
    obj["persistent"] = suite in ("Ambient", "Integration", "Visual", "Castle", "Route", "Guard", "Royal", "Autumn", "Skip", "Peasants", "City", "Progression", "PlayerArt", "Newton", "MapSafety", "Scenery", "Presentation", "BattleFacing", "EvilNewton", "Audio", "CombatMotion", "MenuPoster", "OnScreenControls", "Epilogue", "Credits", "Steampunk", "CityFlags", "VictoryPortals", "Release", "CombatProgression", "UIScaling")
    obj["eventList"] = []
    testdir = target / "objects/obj_evento_test"
    testdir.mkdir(parents=True, exist_ok=True)
    for filename, eventtype, eventnum in (("Create_0.gml", 0, 0), ("Step_0.gml", 3, 0)):
        source = root / "tests/evento" / f"{suite}_{filename.split('_')[0]}.gml"
        if not source.exists():
            continue
        code = source.read_text(encoding="utf-8")
        if eventtype == 0:
            code = (root / "tests/evento/Common.gml").read_text(encoding="utf-8") + "\n" + code
            if suite == "Visual":
                code = re.sub(r"^#macro keyboard_.*\n", "", code, flags=re.MULTILINE)
        # Windows keyboard_key_press injects into the focused desktop window.
        # Isolated automated runs use deterministic keys in Begin Step, before
        # the unchanged game Step/End Step code consumes them. Production never
        # receives these macros or the test input state.
        if eventtype == 3 and suite != "Visual":
            code = "try {\nevento_test_input_begin();\n" + code + "\n} catch(_test_error) {check(false,\"runtime exception \"+_test_error.message+\" / \"+_test_error.longMessage);finish_tests();}\n"
            eventnum = 1
            filename = "Step_1.gml"
        (testdir / filename).write_text(code, encoding="utf-8")
        obj["eventList"].append({"$GMEvent": "v1", "%Name": "", "collisionObjectId": None,
                                "eventNum": eventnum, "eventType": eventtype, "isDnD": False,
                                "name": "", "resourceType": "GMEvent", "resourceVersion": "2.0"})
    save(testdir / "obj_evento_test.yy", obj)
    room = load(root / "rooms/rm_demo_end/rm_demo_end.yy")
    room["name"] = room["%Name"] = "rm_evento_test"
    room["views"][0]["visible"] = False
    room["viewSettings"]["enableViews"] = False
    layer = room["layers"][0]
    instance = layer["instances"][0]
    instance["name"] = instance["%Name"] = "inst_EVENTO_TEST"
    instance["objectId"] = {"name": "obj_evento_test", "path": "objects/obj_evento_test/obj_evento_test.yy"}
    room["instanceCreationOrder"] = [{"name": "inst_EVENTO_TEST", "path": "rooms/rm_evento_test/rm_evento_test.yy"}]
    save(target / "rooms/rm_evento_test/rm_evento_test.yy", room)
    for name, kind in (("obj_evento_test", "objects"), ("rm_evento_test", "rooms")):
        project["resources"].append({"id": {"name": name, "path": f"{kind}/{name}/{name}.yy"}})
    project["RoomOrderNodes"].insert(0, {"roomId": {"name": "rm_evento_test", "path": "rooms/rm_evento_test/rm_evento_test.yy"}})
    save(target / "ParadoxoDeWilson.yyp", project)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("root", type=Path)
    parser.add_argument("target", type=Path)
    parser.add_argument("suite", choices=("Input", "OnScreenControls", "Battle", "Ambient", "Integration", "Visual", "Castle", "Route", "Guard", "Royal", "Autumn", "Skip", "Peasants", "City", "Progression", "PlayerArt", "Newton", "MapSafety", "Scenery", "Presentation", "BattleFacing", "EvilNewton", "Audio", "CombatMotion", "MenuPoster", "Epilogue", "Credits", "Steampunk", "CityFlags", "VictoryPortals", "Release", "CombatProgression", "UIScaling"))
    args = parser.parse_args()
    prepare(args.root, args.target, args.suite)
