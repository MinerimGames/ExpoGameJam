"""Verify that a resource merge preserves both supplied GameMaker versions."""
import argparse
import hashlib
from pathlib import Path
from evento_project import load

parser = argparse.ArgumentParser()
parser.add_argument("--context", type=Path, required=True)
args = parser.parse_args()
context = load(args.context)
root, source, backup = (Path(context[key]) for key in ("workspace", "source", "backup"))
current = load(root / "ParadoxoDeWilson.yyp")
original = load(backup / "ParadoxoDeWilson.yyp")
incoming = load(source / "ParadoxoDeWilson.yyp")
errors = []

def digest(path):
    return hashlib.sha256(path.read_bytes()).digest()

def resource_map(project):
    return {item["id"]["name"]: item for item in project["resources"]}

expected = resource_map(original) | resource_map(incoming)
actual = resource_map(current)
if len(actual) != len(current["resources"]):
    errors.append("Duplicate resource registration")
for name, item in expected.items():
    if actual.get(name) != item:
        errors.append("Missing or altered registration: " + name)
if actual.keys() != expected.keys():
    errors.append("Unexpected project resource set")

for relative in context["new_files"]:
    file = root / relative
    if not file.is_file() or digest(file) != digest(source / relative):
        errors.append("New asset missing or modified: " + relative)

# Protect every pre-existing production file, including all scripts/maps/pixels.
for folder in ("objects", "scripts", "rooms", "sprites", "tilesets", "fonts", "options"):
    for before in (backup / folder).rglob("*"):
        if not before.is_file():
            continue
        relative = before.relative_to(backup)
        after = root / relative
        if not after.is_file() or digest(after) != digest(before):
            errors.append("Existing production file changed: " + relative.as_posix())

for key, before in original.items():
    if key not in ("resources", "Folders", "RoomOrderNodes") and current.get(key) != before:
        errors.append("Project setting changed: " + key)
for key, identity in (("Folders", "folderPath"), ("RoomOrderNodes", "roomId")):
    entries = current[key]
    ids = [entry[identity] if isinstance(entry[identity], str) else entry[identity]["name"] for entry in entries]
    if len(ids) != len(set(ids)):
        errors.append("Duplicate " + key)
    for entry in original[key] + incoming[key]:
        if entry not in entries:
            errors.append("Missing " + key + " entry: " + str(entry[identity]))
if current["RoomOrderNodes"][:len(original["RoomOrderNodes"])] != original["RoomOrderNodes"]:
    errors.append("Original room order changed")

# Resolve actual references and event files, including the imported room layers.
def references(value):
    if isinstance(value, dict):
        path = value.get("path")
        if isinstance(path, str) and path.startswith(("objects/", "scripts/", "rooms/", "sprites/", "tilesets/", "fonts/")):
            if not (root / path).is_file():
                errors.append("Broken resource reference: " + path)
        for child in value.values():
            references(child)
    elif isinstance(value, list):
        for child in value:
            references(child)

for resource in current["resources"]:
    path = root / resource["id"]["path"]
    if not path.is_file():
        errors.append("Registered file missing: " + str(path))
        continue
    data = load(path)
    references(data)
    if data.get("resourceType") == "GMObject":
        for event in data["eventList"]:
            kind = {0: "Create", 3: "Step", 8: "Draw", 12: "CleanUp"}.get(event["eventType"])
            if kind and not (path.parent / f"{kind}_{event['eventNum']}.gml").is_file():
                errors.append("Event file missing: " + str(path))

if any("cutscene" in name.lower() for name in actual):
    errors.append("Removed cutscene was reintroduced")
if errors:
    print("\n".join(errors))
    raise SystemExit(1)
print(f"PASS: {len(actual)} resources; {len(context['new_files'])} new files intact; all existing production files/settings preserved.")
