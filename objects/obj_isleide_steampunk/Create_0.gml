image_speed=0;
battle_victory_room=rm_autumn_gate;
battle_victory_portal_x=480;
battle_victory_portal_y=286;
world_height=34;breathing=0;
depth=mundo_profundidade(y+7);
encounter_distance=36;encounter_started=false;dialogue_active=false;dialogue_page=0;
var _story=historia_newton_progresso();
if(variable_struct_exists(_story,"steampunk_defeated") && _story.steampunk_defeated)
{
    var _portal=instance_create_depth(battle_victory_portal_x,battle_victory_portal_y,
        mundo_profundidade(battle_victory_portal_y),obj_portal);
    _portal.portal_destination=battle_victory_room;
    instance_destroy();exit;
}
var _idle=asset_get_index("spr_steampunk_idle");
var _talk=asset_get_index("spr_steampunk_talk");
var _defense=asset_get_index("spr_steampunk_defense");
var _attack=asset_get_index("spr_steampunk_attack");
assets_ready=_idle!=-1 && _talk!=-1 && _defense!=-1 && _attack!=-1;
battle_poses={peace:_idle,talk:_talk,defense:_defense,attack:_attack};
dialogue_speakers=["ISLEIDE STEAMPUNK","ISLEIDE WILSON","ISLEIDE STEAMPUNK","ISLEIDE WILSON",
    "ISLEIDE STEAMPUNK","ISLEIDE STEAMPUNK","ISLEIDE WILSON","ISLEIDE STEAMPUNK"];
dialogue_portraits=[_idle,spr_battle_isleide,_talk,spr_battle_isleide,_talk,_defense,spr_battle_isleide,_attack];
dialogue_pages=[
    "Estas máquinas repetem o mesmo ciclo. O relógio industrial é a âncora que mantém esta realidade estável enquanto as incursões tentam destruí-la.",
    "Newton disse que esse relógio ameaça o equilíbrio dos mundos. Estou aqui para interromper o ciclo antes que a instabilidade alcance outras realidades.",
    "Ele vê o perigo, mas não vive aqui. Eu preservei este mundo suspendendo seu futuro. Nenhuma mudança pode desfazer aquilo que ainda existe.",
    "Manter tudo parado também tem um custo. As pessoas não podem viver para sempre presas ao mesmo instante.",
    "Quando o relógio parar, nossa âncora desaparecerá. Ninguém sabe o que as incursões farão com este lugar sem sua proteção.",
    "Você atravessa nossos limites e decide qual risco devemos correr. Para quem depende dessas máquinas, você é um invasor.",
    "Eu não quero apagar este mundo. Quero que ele volte a ter um futuro, sem espalhar esse ciclo para os outros.",
    "Então terá de enfrentar quem mantém esta realidade de pé. Não deixarei um viajante romper nossa âncora sem resistência."
];
battle_name="Isleide Steampunk";
battle_hp=205;battle_math_phase=6;battle_math_phase_max=8;
battle_math_profile="steampunk_alternating";
battle_sprite=_idle;battle_blend=c_white;
battle_scale=assets_ready?232/(sprite_get_bbox_bottom(_idle)-sprite_get_bbox_top(_idle)+1):1;
battle_message="Observe o ciclo do relógio e a intenção do guardião.";
