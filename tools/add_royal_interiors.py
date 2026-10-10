"""Import approved castle interior assets and author walkable room geometry."""
from pathlib import Path
import copy
import shutil
import uuid
from PIL import Image
from evento_project import load, save

ROOT = Path(__file__).resolve().parents[1]
PROJECT = load(ROOT / "ParadoxoDeWilson.yyp")


def register(name, kind):
    entry = {"id": {"name": name, "path": f"{kind}/{name}/{name}.yy"}}
    if entry not in PROJECT["resources"]:
        PROJECT["resources"].append(entry)


def sprite(name, source, background=False):
    data = load(ROOT / "sprites/spr_castle_guard/spr_castle_guard.yy")
    old_frame, old_layer = data["frames"][0]["name"], data["layers"][0]["name"]
    frame, layer = str(uuid.uuid4()), str(uuid.uuid4())
    import json
    data = json.loads(json.dumps(data).replace("spr_castle_guard", name)
                      .replace(old_frame, frame).replace(old_layer, layer))
    im = Image.open(source)
    width, height = im.size
    bounds = (0, 0, width, height) if background else im.getchannel("A").getbbox()
    left, top, right, bottom = bounds
    data.update(width=width, height=height, bbox_left=left, bbox_top=top,
                bbox_right=right-1, bbox_bottom=bottom-1)
    data["sequence"]["xorigin"] = 0 if background else (left+right)//2
    data["sequence"]["yorigin"] = 0 if background else bottom
    data["origin"] = 0 if background else 9
    base = ROOT / "sprites" / name
    save(base / f"{name}.yy", data)
    (base / "layers" / frame).mkdir(parents=True, exist_ok=True)
    shutil.copy2(source, base / f"{frame}.png")
    shutil.copy2(source, base / "layers" / frame / f"{layer}.png")
    register(name, "sprites")


def object_resource(name, sprite_name, events):
    data = load(ROOT / "objects/obj_castle_guard/obj_castle_guard.yy")
    data["name"] = data["%Name"] = name
    data["spriteId"] = ({"name": sprite_name, "path": f"sprites/{sprite_name}/{sprite_name}.yy"}
                        if sprite_name else None)
    template = data["eventList"][0]
    data["eventList"] = []
    for event_type, event_num in events:
        event = copy.deepcopy(template)
        event.update(eventType=event_type, eventNum=event_num)
        data["eventList"].append(event)
    save(ROOT / "objects" / name / f"{name}.yy", data)
    register(name, "objects")


def make_room(name, background, spawn, bounds, king=False):
    room = load(ROOT / "rooms/rm_castelo/rm_castelo.yy")
    room["name"] = room["%Name"] = name
    room["roomSettings"].update(Width=800, Height=600)
    room["creationCodeFile"] = ""
    collider_layer, player_layer, scenery = room["layers"]
    template = player_layer["instances"][0]
    collider_layer["instances"] = []
    player_layer["instances"] = []
    room["instanceCreationOrder"] = []

    def instance(obj, instance_name, x, y, sx=1, sy=1, layer=player_layer):
        inst = copy.deepcopy(template)
        inst["name"] = inst["%Name"] = instance_name
        inst.update(x=float(x), y=float(y), scaleX=sx, scaleY=sy,
                    objectId={"name": obj, "path": f"objects/{obj}/{obj}.yy"})
        layer["instances"].append(inst)
        room["instanceCreationOrder"].append({"name": instance_name, "path": f"rooms/{name}/{name}.yy"})

    for index, (x, y, w, h) in enumerate(bounds):
        instance("obj_colisor", f"inst_{name}_WALL_{index}", x, y, w/32, h/32, collider_layer)
    instance("obj_player", f"inst_{name}_PLAYER", *spawn)
    instance("obj_castle_interior", f"inst_{name}_INTERIOR", 0, 0)
    if king:
        instance("obj_isleide_king", "inst_THRONE_KING", 400, 198)
    scenery.update(spriteId={"name": background, "path": f"sprites/{background}/{background}.yy"},
                   stretch=True, x=0, y=0)
    view = room["views"][0]
    view.update(wview=640, hview=360, wport=1280, hport=720,
                xview=80, yview=80 if king else 240, hborder=256, vborder=144)
    if king:
        view["objectId"] = None
    save(ROOT / "rooms" / name / f"{name}.yy", room)
    register(name, "rooms")
    order = {"roomId": {"name": name, "path": f"rooms/{name}/{name}.yy"}}
    if order not in PROJECT["RoomOrderNodes"]:
        PROJECT["RoomOrderNodes"].append(order)


if __name__ == "__main__":
    downloads = Path("C:/Users/jrhre/Downloads")
    generated = Path("C:/Users/jrhre/.codex/generated_images/01a0faa6-48c6-76e2-99aa-fabcdcb85825")
    output = ROOT / "output/imagegen"
    output.mkdir(parents=True, exist_ok=True)
    for original, dest in [("exec-43dbbc87-6e83-42d5-a7ab-0cb8f4508240.png", "king-standing.png"),
                           ("exec-db3979e4-ea06-45b0-85d9-f0d65d7f1a99.png", "king-seated.png")]:
        shutil.copy2(generated / original, output / dest)
        assert Image.open(output / dest).getchannel("A").getextrema() == (0, 255)
    sprite("spr_king_standing", output / "king-standing.png")
    sprite("spr_king_seated", output / "king-seated.png")
    sprite("spr_castle_hall", downloads / "Salão Medieval de Entrada Iluminado por Velas (1).png", True)
    sprite("spr_throne_room", downloads / "Salão do Trono em Pixel Art.png", True)
    object_resource("obj_castle_interior", None, [(0, 0), (3, 0), (8, 64)])
    object_resource("obj_isleide_king", "spr_king_standing", [(0, 0), (3, 0), (8, 0), (8, 64)])
    # Each rectangle follows a wall, column or piece of furniture. The central
    # carpet remains open from the entrance to the upper door/throne staircase.
    hall_bounds = [(0,0,800,80),(0,80,50,520),(750,80,50,520),
                   (50,80,310,120),(440,80,310,120),
                   (50,500,310,100),(440,500,310,100),(360,576,80,24),
                   (80,258,45,145),(135,300,100,70),(110,400,75,64),
                   (280,302,40,80),(480,302,40,80),
                   (520,230,180,100),(690,200,48,152),(578,380,125,65),
                   (287,130,32,98),(474,130,32,98)]
    throne_bounds = [(0,0,800,95),(0,95,52,505),(748,95,52,505),
                     (52,95,285,125),(463,95,285,125),
                     (338,95,124,109),(52,500,290,100),(458,500,290,100),(342,576,116,24),
                     (95,365,142,105),(540,365,148,105),
                     (225,205,40,105),(535,205,40,105)]
    make_room("rm_castle_hall", "spr_castle_hall", (400,440), hall_bounds)
    make_room("rm_throne_room", "spr_throne_room", (400,400), throne_bounds, True)
    save(ROOT / "ParadoxoDeWilson.yyp", PROJECT)
    print("Imported four sprites, two objects, and two castle interior rooms.")
