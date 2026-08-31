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

// A historia fica em paginas curtas para caber bem no balao.
dialogue_intro = [
    "Finalmente! Eu estava esperando voce. A linha do tempo sofreu uma ruptura, e nao foi uma ruptura comum.",
    "Incursoes multiversais comecaram a acontecer: universos diferentes estao se cruzando e tentando ocupar o mesmo lugar ao mesmo tempo.",
    "Passado, futuro e realidades alternativas estao se misturando. Cada incursao distorce as regras deste lugar e torna tudo instavel.",
    "A matematica ainda funciona como uma ancora. Numeros, distancias e padroes conseguem estabilizar essas distorcoes.",
    "Quando uma incursao virar combate, cada acao exigira um calculo. Se voce acertar a conta, sua acao acontece. Se errar, a anomalia reage.",
    "ATAQUE causa dano. CURA recupera vida. DEFESA reduz o golpe recebido. ESQUIVA pode evitar completamente um ataque.",
    "Antes de enviar voce para uma linha do tempo quebrada, faremos um treinamento. Eu serei seu oponente e vou guiar cada passo.",
    "Use as quatro acoes, resolva as contas e observe como o combate funciona. Depois disso, voce estara pronto. Vamos comecar!"
];

dialogue_post = [
    "Excelente! Voce entendeu o principio: primeiro raciocine, depois aja. Nas incursoes reais, os calculos ficarao cada vez mais dificeis.",
    "Agora siga em frente e feche os pontos de incursao. Se os universos continuarem se cruzando, a linha do tempo pode colapsar de vez."
];

dialogue_reminder = [
    "Lembre-se: as incursoes distorcem a realidade, e a matematica e a sua ancora. Resolva os calculos para estabilizar suas acoes."
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
