"""Apply the approved chronological room order without changing resource IDs."""
from pathlib import Path
from evento_project import load, save

ROOT = Path(__file__).resolve().parents[1]
path = ROOT / 'ParadoxoDeWilson.yyp'
project = load(path)
order = ['rm_menu', 'rm_tutorial', 'rm_cavernas', 'rm_cavernas_2',
         'rm_vila', 'rm_bosque', 'rm_castelo', 'rm_castle_hall', 'rm_throne_room',
         'rm_steampunk_foundry', 'rm_autumn_gate', 'rm_autumn_streets',
         'rm_autumn_plaza', 'rm_commercial_district', 'rm_temporal_origin',
         'rm_fatec_classroom', 'rm_demo_end']
nodes = {node['roomId']['name']: node for node in project['RoomOrderNodes']}
assert set(order) == set(nodes), 'Preserve every room in this project.'
project['RoomOrderNodes'] = [nodes[name] for name in order]
save(path, project)
