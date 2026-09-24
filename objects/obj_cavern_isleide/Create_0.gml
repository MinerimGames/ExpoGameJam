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
battle_hp = 75;
battle_math_phase = 1;
battle_math_phase_max = 1;
battle_sprite = spr_isleide_cavernas;
battle_blend = c_white;
battle_scale = 0.45;
