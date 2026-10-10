var _story = historia_newton_progresso();
if (variable_struct_exists(_story, "royal_defeated") && _story.royal_defeated)
{
    var _portal = instance_create_depth(400, 280, mundo_profundidade(280), obj_portal);
    _portal.portal_destination = rm_steampunk_foundry;
    instance_destroy();
    exit;
}

image_speed = 0;
depth = -25;
encounter_state = "seated";
state_ticks = 0;
pose_mix = 0;
idle_time = 0;
// Match the throne's seat/back instead of using the outdoor NPC height.
seated_height = 60;
standing_height = 64;
seated_feet_offset = -8;
standing_feet_offset = 16;
seated_scale = seated_height / (sprite_get_bbox_bottom(spr_king_seated)-sprite_get_bbox_top(spr_king_seated)+1);
standing_scale = standing_height / (sprite_get_bbox_bottom(spr_king_standing)-sprite_get_bbox_top(spr_king_standing)+1);
dialogue_active = false;
dialogue_page = 0;
dialogue_speakers = [
    "ISLEIDE REI", "ISLEIDE WILSON", "ISLEIDE WILSON", "ISLEIDE REI",
    "ISLEIDE WILSON", "ISLEIDE REI", "ISLEIDE REI"
];
dialogue_portraits = [
    spr_king_standing, spr_battle_isleide, spr_battle_isleide,
    spr_king_standing, spr_battle_isleide, spr_king_standing, spr_king_standing
];
dialogue_pages = [
    "O que um plebeu faz aqui? Como passou pelos guardas?" + chr(10)
        + "Diga o motivo da sua presença!",
    "Seu guarda tentou me impedir, mas consegui passar." + chr(10)
        + "Sou um viajante de uma realidade alternativa.",
    "As incursões estão misturando nossos mundos." + chr(10)
        + "Preciso da sua ajuda para resolver isso.",
    "As incursões são um segredo de Estado!" + chr(10)
        + "Você não tem o direito de interferir.",
    "Se não fizermos nada, outras realidades também" + chr(10)
        + "serão atingidas. Precisamos impedir as incursões!",
    "Você não pode mexer no destino. Não vou permitir" + chr(10)
        + "que feche esta realidade!",
    "Se insiste em desafiar minha vontade," + chr(10)
        + "então enfrentará o seu rei!"
];
battle_name = "Isleide Rei";
battle_hp = 180;
battle_math_phase = 4;
battle_math_phase_max = 6;
battle_math_profile = "royal_alternating";
battle_sprite = spr_king_standing;
battle_blend = c_white;
battle_scale = 232 / (sprite_get_bbox_bottom(spr_king_standing)-sprite_get_bbox_top(spr_king_standing)+1);
battle_message = "O rei alterna somas e multiplicações. Observe o ataque!";
battle_victory_room = rm_steampunk_foundry;
battle_victory_portal_x = 400;
battle_victory_portal_y = 280;
with (obj_player)
{
    movimento_liberado = false;
    velh = 0;
    velv = 0;
}
