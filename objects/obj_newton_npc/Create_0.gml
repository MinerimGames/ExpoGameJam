sprite_index = spr_battle_newton;

image_index = 0;
image_speed = 0;
// Single-frame artwork still has a live world pose, anchored at the feet.
idle_time = 0;

var _altura_no_mapa = 28;

var _escala = _altura_no_mapa / 630;

image_xscale = _escala;
image_yscale = _escala;
interaction_distance = 78;
interaction_available = false;
dialogue_active = false;
dialogue_page = 0;
dialogue_mode = "intro";
tutorial_started = false;
tutorial_completed = false;
portal_created = false;

dialogue_intro = [
    "Finalmente! Eu estava esperando você. A linha do tempo sofreu uma ruptura, e não foi uma ruptura comum.",
    "Incursões multiversais começaram a acontecer: universos diferentes estão se cruzando e tentando ocupar o mesmo lugar ao mesmo tempo.",
    "O passado, o futuro e as realidades alternativas estão se misturando. Cada incursão distorce as regras deste lugar e torna tudo instável.",
    "A matemática ainda funciona como uma âncora. Números, distâncias e padrões conseguem estabilizar essas distorções.",
    "Quando uma incursão se transformar em combate, cada ação exigirá um cálculo. Se você acertar a conta, sua ação será realizada. Se errar, a anomalia reagirá.",
    "ATAQUE causa dano. CURA recupera vida. DEFESA reduz o dano. Acerte a conta da ESQUIVA para evitar o golpe inteiro; depois, ela recarrega por dois turnos.",
    "Antes de enviá-lo para uma linha do tempo fragmentada, faremos um treinamento. Eu serei seu oponente e o guiarei em cada etapa.",
    "Use as quatro ações e resolva as contas. Observe o aviso do inimigo: se ele atacar forte, defenda ou esquive. Vamos começar!"
];

dialogue_post = [
    "Cada vitória dá 100 XP e aumenta sua compreensão matemática: os números ficam menores. Cada chefe de uma realidade vencido também aumenta sua vida máxima em 30, uma única vez.",
    "Agora, siga em frente e feche os pontos de incursão. Se os universos continuarem se cruzando, a linha do tempo poderá entrar em colapso de uma vez por todas.",
    "Estabilizei um portal atrás de mim. Atravesse-o quando estiver pronto para entrar na primeira realidade fragmentada."
];

dialogue_reminder = [
    "Lembre-se: as incursões distorcem a realidade, e a matemática é a sua âncora. Resolva os cálculos para estabilizar suas ações."
];

npc_current_dialogue = function()
{
    switch (dialogue_mode)
    {
        case "post": return dialogue_post;
        case "reminder": return dialogue_reminder;
        default: return dialogue_intro;
    }
};

npc_lock_player = function(_locked)
{
    with (obj_player)
    {
        movimento_liberado = !_locked;
        velh = 0;
        velv = 0;
    }
};

create_post_portal = function()
{
    if (portal_created) return;

    portal_created = true;

    var _portal = instance_create_layer(
        x + 36,
        y + 12,
        "enemies",
        obj_portal
    );

    _portal.depth = depth + 1;
};

skip_tutorial = function()
{
    if (!dialogue_active || dialogue_mode != "intro") return;

    tutorial_started = true;
    tutorial_completed = true;
    dialogue_mode = "post";
    dialogue_page = 0;
    dialogue_active = false;
    interaction_available = false;
    npc_lock_player(false);
    create_post_portal();
};

start_post_dialogue = function()
{
    tutorial_completed = true;
    dialogue_mode = "post";
    dialogue_page = 0;
    dialogue_active = true;
    interaction_available = false;
    npc_lock_player(true);
};

npc_ui_scale = 1;
npc_ui_offset_x = 0;
npc_ui_offset_y = 0;

npc_update_ui = function()
{
    var _gw = display_get_gui_width();
    var _gh = display_get_gui_height();
    npc_ui_scale = min(_gw / 960, _gh / 540);
    npc_ui_offset_x = (_gw - 960 * npc_ui_scale) * 0.5;
    npc_ui_offset_y = (_gh - 540 * npc_ui_scale) * 0.5;
};

npc_rx = function(_x) { return npc_ui_offset_x + _x * npc_ui_scale; };
npc_ry = function(_y) { return npc_ui_offset_y + _y * npc_ui_scale; };

npc_draw_box = function(_x, _y, _w, _h, _fill, _border, _border_size)
{
    draw_set_color(_border);
    draw_rectangle(npc_rx(_x), npc_ry(_y), npc_rx(_x + _w), npc_ry(_y + _h), false);
    draw_set_color(_fill);
    draw_rectangle(
        npc_rx(_x + _border_size), npc_ry(_y + _border_size),
        npc_rx(_x + _w - _border_size), npc_ry(_y + _h - _border_size), false
    );
};

npc_draw_text = function(_x, _y, _text, _size, _color)
{
    draw_set_color(_color);
    draw_text_transformed(npc_rx(_x), npc_ry(_y), _text, npc_ui_scale * _size, npc_ui_scale * _size, 0);
};

npc_update_ui();
