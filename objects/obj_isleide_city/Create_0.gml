battle_victory_room=rm_commercial_district;
battle_victory_portal_x=480;
battle_victory_portal_y=330;
if (historia_newton_progresso().city_defeated)
{
    var _portal = instance_create_depth(battle_victory_portal_x, battle_victory_portal_y,
        mundo_profundidade(battle_victory_portal_y), obj_portal);
    _portal.portal_destination = battle_victory_room;
    instance_destroy();
    exit;
}

image_speed=0;
depth=-25;
image_xscale=32/(sprite_get_bbox_bottom(sprite_index)-sprite_get_bbox_top(sprite_index)+1);
image_yscale=image_xscale;
encounter_distance=32;
encounter_started=false;
dialogue_active=false;
dialogue_page=0;
breathing=0;

var _talk=asset_get_index("spr_city_talk");
var _defense=asset_get_index("spr_city_defense");
var _attack=asset_get_index("spr_city_attack");
battle_poses={peace:spr_city_peace, talk:_talk==-1?spr_city_peace:_talk,
    defense:_defense==-1?spr_city_peace:_defense, attack:_attack==-1?spr_city_peace:_attack};
dialogue_speakers=["ISLEIDE DA CIDADE","ISLEIDE DA CIDADE","ISLEIDE WILSON","ISLEIDE DA CIDADE",
    "ISLEIDE DA CIDADE","ISLEIDE WILSON","ISLEIDE DA CIDADE","ISLEIDE DA CIDADE"];
dialogue_portraits=[battle_poses.peace,battle_poses.talk,spr_battle_isleide,battle_poses.talk,
    battle_poses.peace,spr_battle_isleide,battle_poses.defense,battle_poses.attack];
dialogue_pages=[
    "Meu propósito sempre foi assegurar a paz e a liberdade deste povo. Cada decisão que tomei buscava preservar o direito de todos a viver sem temor.",
    "As incursões abalaram esta realidade. Distorceram acontecimentos, memórias e aquilo que as pessoas acreditavam saber sobre mim.",
    "As ruas estão vazias. Disseram-me que as pessoas vivem sob o domínio de um único homem.",
    "O perigo que as mantém em casa nasceu das rupturas entre os mundos. Minha responsabilidade é protegê-las enquanto procuro restabelecer a paz.",
    "Até minha própria imagem se tornou um paradoxo: o homem que desejava a liberdade passou a ser lembrado como a causa de toda opressão.",
    "Se a realidade alterou a sua imagem, como posso distinguir o que aconteceu daquilo que as incursões fizeram parecer verdadeiro?",
    "Você chega de outro mundo, decide qual realidade merece continuar e chama essa intervenção de salvação. Para o meu povo, você é o invasor.",
    "Não lhe permitirei impor esse destino a quem confia em mim. Se insiste em interferir em nossa realidade, defenderei o direito deste povo de existir."
];
battle_name="Isleide da Cidade";
battle_hp=220;
battle_math_phase=8;
battle_math_phase_max=10;
battle_math_profile="city_alternating";
battle_sprite=spr_city_peace;
battle_blend=c_white;
battle_scale=232/(sprite_get_bbox_bottom(battle_sprite)-sprite_get_bbox_top(battle_sprite)+1);
battle_message="Observe a intenção do líder e preserve sua vida.";
