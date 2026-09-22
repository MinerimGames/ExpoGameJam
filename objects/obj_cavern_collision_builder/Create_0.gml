/// Colisores ajustados às bases dos objetos dos cenários.
/// Dividir objetos grandes em partes mantém os corredores transitáveis.

var add_scenery_collider = function(_x, _y, _width, _height)
{
    var _collider = instance_create_layer(_x, _y, "colisores", obj_colisor);
    _collider.image_xscale = _width / 32;
    _collider.image_yscale = _height / 32;
};

if (room == rm_cavernas)
{
    // Raízes, vegetação baixa, pedras e troncos do primeiro cenário.
    add_scenery_collider(16, 232, 145, 24);
    add_scenery_collider(174, 225, 92, 27);
    add_scenery_collider(289, 190, 91, 39);
    add_scenery_collider(438, 231, 105, 50);
    add_scenery_collider(579, 218, 61, 62);
    add_scenery_collider(0, 320, 72, 24);
    add_scenery_collider(272, 332, 151, 12);
    add_scenery_collider(455, 326, 98, 18);
}
else if (room == rm_cavernas_2)
{
    // Ossos são segmentados para seguir melhor suas silhuetas.
    add_scenery_collider(137, 231, 99, 25);
    add_scenery_collider(224, 242, 39, 27);
    add_scenery_collider(292, 272, 36, 32);
    add_scenery_collider(365, 306, 45, 38);

    // Bases da vegetação, pedras e madeira; o caminho central permanece livre.
    add_scenery_collider(18, 315, 78, 29);
    add_scenery_collider(207, 225, 58, 26);
    add_scenery_collider(446, 239, 50, 38);
    add_scenery_collider(572, 225, 68, 64);
    add_scenery_collider(430, 333, 72, 11);
    add_scenery_collider(568, 326, 72, 18);
}

instance_destroy();
