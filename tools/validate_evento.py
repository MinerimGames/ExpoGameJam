"""Check real GameMaker references and preservation against the pre-change backup."""
import argparse
import hashlib
import re
from pathlib import Path
from evento_project import load

root = Path(__file__).resolve().parent.parent
parser = argparse.ArgumentParser()
parser.add_argument("--baseline", type=Path, required=True)
args = parser.parse_args()
errors = []
project = load(root / "ParadoxoDeWilson.yyp")
names = [item["id"]["name"] for item in project["resources"]]
if len(names) != len(set(names)):
    errors.append("Duplicate project resource")
if names.count("obj_ambient_controller") != 1:
    errors.append("Ambient resource must be registered exactly once")
for path in list(root.glob("**/*.yy")) + [root / "ParadoxoDeWilson.yyp"]:
    value = load(path)
    for ref in re.findall(r'"path"\s*:\s*"((?:objects|rooms|scripts|sprites|tilesets|fonts)/[^"]+)"', path.read_text(encoding="utf-8-sig")):
        if not (root / ref).is_file():
            errors.append(f"Broken reference: {path.relative_to(root)} -> {ref}")
    if value.get("resourceType") == "GMObject":
        for event in value["eventList"]:
            kinds = {0: "Create", 3: "Step", 8: "Draw", 12: "CleanUp"}
            if event["eventType"] in kinds:
                gml = path.parent / f"{kinds[event['eventType']]}_{event['eventNum']}.gml"
                if not gml.is_file():
                    errors.append(f"Missing event: {gml.relative_to(root)}")
for name in ("rm_menu", "rm_tutorial", "rm_cavernas", "rm_cavernas_2", "rm_demo_end"):
    path = Path("rooms") / name / f"{name}.yy"
    room, before = load(root / path), load(args.baseline / path)
    instances = [i for layer in room["layers"] for i in layer.get("instances", [])]
    expected = 1 if name in ("rm_tutorial", "rm_cavernas", "rm_cavernas_2") else 0
    if sum(i["objectId"]["name"] == "obj_ambient_controller" for i in instances) != expected:
        errors.append(f"Wrong ambient instance count in {name}")
    # Removing only the addition must reconstruct the original room exactly.
    for layer in room["layers"]:
        if "instances" in layer:
            layer["instances"] = [i for i in layer["instances"] if i["objectId"]["name"] != "obj_ambient_controller"]
    room["instanceCreationOrder"] = [i for i in room["instanceCreationOrder"] if not i["name"].startswith("inst_AMBIENT_")]
    if room != before:
        errors.append(f"Original room/tiles/colliders/camera changed: {name}")
protected = ["objects/obj_player/Create_0.gml", "objects/obj_player/Draw_0.gml", "objects/obj_player/Step_2.gml", "scripts/state_machine/state_machine.gml"]
for folder in ("sprites", "tilesets", "fonts", "options", "objects/obj_colisor", "objects/obj_portal", "objects/obj_cavern_exit_right", "objects/obj_newton_cavern_dialogue"):
    protected += [str(p.relative_to(args.baseline)) for p in (args.baseline / folder).rglob("*") if p.is_file()]
for relative in protected:
    relative = str(relative).replace("\\", "/")
    now, old = root / relative, args.baseline / relative
    if not now.is_file() or hashlib.sha256(now.read_bytes()).digest() != hashlib.sha256(old.read_bytes()).digest():
        errors.append(f"Protected original changed: {relative}")
def math_body(path):
    text = path.read_text(encoding="utf-8-sig")
    return text[text.index("function batalha_gerar_desafio"):text.index("function batalha_iniciar")].replace("\r\n", "\n")
if math_body(root / "scripts/battle_system/battle_system.gml") != math_body(args.baseline / "scripts/battle_system/battle_system.gml"):
    errors.append("Math generator changed")
if errors:
    print("\n".join(errors))
    raise SystemExit(1)
print(f"PASS: {len(names)} registered resources, references/events valid; original rooms, colliders, sprites, tiles, input state machine and math preserved.")
