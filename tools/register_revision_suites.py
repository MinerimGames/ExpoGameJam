from pathlib import Path
root=Path(__file__).resolve().parents[1]
p=root/'tools/run_evento_tests.ps1'
s=p.read_text(encoding='utf-8-sig')
s=s.replace("'VictoryPortals','Release','All'", "'VictoryPortals','Release','CombatProgression','UIScaling','All'")
s=s.replace("'VictoryPortals','Release')}", "'VictoryPortals','Release','CombatProgression','UIScaling')}")
p.write_text(s,encoding='utf-8')
p=root/'tools/evento_project.py'
s=p.read_text(encoding='utf-8')
s=s.replace('"VictoryPortals", "Release")','"VictoryPortals", "Release", "CombatProgression", "UIScaling")')
p.write_text(s,encoding='utf-8')
