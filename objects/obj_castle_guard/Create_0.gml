image_index = 0;
image_speed = 0;
image_xscale = 30 / 590;
image_yscale = image_xscale;
depth = -25;

encounter_distance = 32;
encounter_started = false;
dialogue_active = false;
dialogue_page = 0;
dialogue_speakers = [
    "GUARDA DO CASTELO", "ISLEIDE WILSON", "ISLEIDE WILSON",
    "GUARDA DO CASTELO", "ISLEIDE WILSON", "GUARDA DO CASTELO"
];
dialogue_portraits = [
    spr_castle_guard, spr_battle_isleide, spr_battle_isleide,
    spr_castle_guard, spr_battle_isleide, spr_castle_guard
];
dialogue_pages = [
    "Alto! O que você quer no castelo?",
    "Sou um viajante de uma realidade alternativa.",
    "Preciso conversar com o rei deste reino para resolver" + chr(10)
        + "as incursões que estão misturando nossos mundos.",
    "Realidade alternativa? Isso é muito suspeito." + chr(10)
        + "Não vou deixar você passar!",
    "Não vim causar problemas. Precisamos deter as incursões.",
    "Não acredito em você. Prepare-se para lutar!"
];

battle_name = "Guarda Medieval";
var _config = batalha_configuracao();
battle_hp = _config.boss_hp;
// As Cavernas usam somas de um dígito; o guarda avança para dois.
battle_math_phase = 4;
battle_math_phase_max = 6;
battle_sprite = spr_castle_guard;
battle_blend = c_white;
battle_scale = 232/(sprite_get_bbox_bottom(battle_sprite)-sprite_get_bbox_top(battle_sprite)+1);
battle_message = "Vença o guarda para entrar no Castelo.";
