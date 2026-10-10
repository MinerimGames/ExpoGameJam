image_index = 0;
image_speed = 0;
var _escala = 30 / 580;

image_xscale = _escala;
image_yscale = _escala;
depth = -25;

encounter_distance = 32;
encounter_started = false;
dialogue_active = false;
dialogue_page = 0;
dialogue_pages = [
    "Grrá-kh... zhur'mak tal? Vra nokh!",
    "Kra'tun vel... shaa morgh! Tek, tek!",
    "Você não entende nada. Ignorando os sons estranhos," + chr(10)
        + "você se prepara para lutar."
];

battle_name = "Isleide das Cavernas";
battle_victory_room = rm_vila;
battle_victory_portal_x = 576;
battle_victory_portal_y = 156;
var _battle_config = batalha_configuracao();
battle_hp = _battle_config.boss_hp;
battle_math_phase = 1;
battle_math_phase_max = 1;
battle_sprite = spr_isleide_cavernas;
battle_blend = c_white;
battle_scale = 232/(sprite_get_bbox_bottom(battle_sprite)-sprite_get_bbox_top(battle_sprite)+1);
