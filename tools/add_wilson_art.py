"""Register transparent Wilson poses, copying original pixels unchanged."""
from pathlib import Path
from PIL import Image
from add_royal_interiors import ROOT, PROJECT, sprite
from evento_project import load, save

sources = {
    "idle_front": Path("C:/Users/jrhre/Downloads/JogadorFrente0 (1).png"),
    "idle_back": Path("C:/Users/jrhre/Downloads/JogadorCostas0.png"),
}
for pose in ("idle_side", "walk_front_a", "walk_front_b", "walk_back_a", "walk_back_b",
             "walk_side_a", "walk_side_b", "attack", "defense", "heal", "dodge"):
    sources[pose] = ROOT / "output/imagegen" / f"wilson-{pose}.png"
missing = [str(source) for source in sources.values() if not source.exists()]
if missing:
    raise SystemExit("Missing artwork: " + ", ".join(missing))

for pose, source in sources.items():
    name = f"spr_wilson_{pose}"
    sprite(name, source)
    # Read opacity only to anchor the feet and ignore faint generated edge noise.
    # The imported bitmap remains byte-for-byte identical to its input.
    alpha = Image.open(source).getchannel("A")
    opaque = alpha.point(lambda value: 255 if value >= 128 else 0)
    left, top, right, bottom = opaque.getbbox()
    foot_top = top + int((bottom-top)*0.82)
    foot_left, _, foot_right, _ = opaque.crop((0, foot_top, alpha.width, bottom)).getbbox()
    path = ROOT / "sprites" / name / f"{name}.yy"
    data = load(path)
    data.update(bbox_left=left, bbox_top=top, bbox_right=right-1, bbox_bottom=bottom-1)
    data["sequence"].update(xorigin=(foot_left+foot_right)//2, yorigin=bottom-1)
    save(path, data)

obj_path = ROOT / "objects/obj_player/obj_player.yy"
obj = load(obj_path)
obj["spriteId"] = {"name": "spr_wilson_idle_front", "path": "sprites/spr_wilson_idle_front/spr_wilson_idle_front.yy"}
# The original foot mask remains independent from the new high-resolution art.
save(obj_path, obj)
save(ROOT / "ParadoxoDeWilson.yyp", PROJECT)
print("Registered thirteen Wilson sprites; original foot mask preserved.")
