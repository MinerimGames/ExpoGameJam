/// Isleide Newton - NPC introdutor da historia e do tutorial.

image_index = 0;
image_speed = 0;
interaction_distance = 78;
interaction_available = false;
dialogue_active = false;
dialogue_page = 0;
dialogue_mode = "intro";
tutorial_started = false;
tutorial_completed = false;
portal_created = false;

// A historia fica em paginas curtas para caber bem no balao.
dialogue_intro = [
    "Finalmente! Eu estava esperando você. A linha do tempo sofreu uma ruptura, e não foi uma ruptura comum.",
    "Incursões multiversais começaram a acontecer: universos diferentes estão se cruzando e tentando ocupar o mesmo lugar ao mesmo tempo.",
    "O passado, o futuro e as realidades alternativas estão se misturando. Cada incursão distorce as regras deste lugar e torna tudo instável.",
    "A matemática ainda funciona como uma âncora. Números, distâncias e padrões conseguem estabilizar essas distorções.",
    "Quando uma incursão se transformar em combate, cada ação exigirá um cálculo. Se você acertar a conta, sua ação será realizada. Se errar, a anomalia reagirá.",
    "ATAQUE causa dano. CURA recupera vida. DEFESA reduz o dano recebido. ESQUIVA pode evitar completamente um ataque.",
    "Antes de enviá-lo para uma linha do tempo fragmentada, faremos um treinamento. Eu serei seu oponente e o guiarei em cada etapa.",
    "Use as quatro ações, resolva as contas e observe como o combate funciona. Depois disso, você estará pronto. Vamos começar!"
];

dialogue_post = [
    "Excelente! Voce entendeu o principio: primeiro raciocine, depois aja. Nas incursoes reais, os calculos ficarao cada vez mais dificeis.",
    "Agora siga em frente e feche os pontos de incursao. Se os universos continuarem se cruzando, a linha do tempo pode colapsar de vez.",
    "Estabilizei um portal atrás de mim. Atravesse-o quando estiver pronto para entrar na primeira realidade fragmentada."
    "Excelente! Você entendeu o princípio: primeiro, raciocine; depois, aja. Nas incursões reais, os cálculos ficarão cada vez mais difíceis.",
    "Agora, siga em frente e feche os pontos de incursão. Se os universos continuarem se cruzando, a linha do tempo poderá entrar em colapso de uma vez por todas.",
    "Estabilizei um portal atrás de mim. Atravesse-o quando estiver pronto para encerrar esta demonstração."
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

start_post_dialogue = function()
{
    tutorial_completed = true;
    dialogue_mode = "post";
    dialogue_page = 0;
    dialogue_active = true;
    interaction_available = false;
    npc_lock_player(true);
};

// Transformacao de GUI baseada na mesma referencia 960x540 da batalha.
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
