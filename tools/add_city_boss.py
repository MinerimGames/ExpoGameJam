"""Import the city leader sprites without altering their pixels."""
import copy
from pathlib import Path
from add_royal_interiors import ROOT, PROJECT, sprite, object_resource
from evento_project import load, save

sprite("spr_city_peace", Path("C:/Users/jrhre/Downloads/Comunista0.png"))
for pose in ("talk", "defense", "attack"):
    source = ROOT / "output/imagegen" / f"city-{pose}.png"
    if source.exists():
        sprite(f"spr_city_{pose}", source)
object_resource("obj_isleide_city", "spr_city_peace", [(0, 0), (3, 0), (8, 0), (8, 64)])
room_path=ROOT / "rooms/rm_autumn_plaza/rm_autumn_plaza.yy"
room=load(room_path)
layer=next(layer for layer in room["layers"] if any(i["objectId"]["name"]=="obj_player" for i in layer.get("instances", [])))
name="inst_CITY_LEADER"
if not any(i["name"]==name for i in layer["instances"]):
    instance=copy.deepcopy(next(i for i in layer["instances"] if i["objectId"]["name"]=="obj_player"))
    instance.update(name=name, x=480.0, y=260.0, objectId={"name":"obj_isleide_city", "path":"objects/obj_isleide_city/obj_isleide_city.yy"})
    instance["%Name"]=name
    layer["instances"].append(instance)
    room["instanceCreationOrder"].append({"name":name,"path":"rooms/rm_autumn_plaza/rm_autumn_plaza.yy"})
save(room_path, room)
save(ROOT / "ParadoxoDeWilson.yyp", PROJECT)
print("City boss registered in final plaza.")
