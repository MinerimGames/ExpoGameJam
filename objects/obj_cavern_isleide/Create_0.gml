/// Primeiro inimigo da realidade quebrada das cavernas.

image_index = 0;
image_speed = 0;
image_xscale = 0.10;
image_yscale = 0.10;
depth = -25;

encounter_distance = 125;
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
