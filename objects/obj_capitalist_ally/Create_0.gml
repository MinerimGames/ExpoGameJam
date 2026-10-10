depth=-25;image_speed=0;breathing=0;
dialogue_active=false;dialogue_page=0;encounter_started=false;
dialogue_pages=historia_newton_dialogo("revelation");
advance_dialogue=function()
{
    if(!dialogue_active)return;
    if(dialogue_page<array_length(dialogue_pages)-1)dialogue_page++;
    else
    {
        var _destination=asset_get_index("rm_temporal_origin");
        if(_destination==-1)return;
        dialogue_active=false;historia_newton_progresso().stage="exposure";
        historia_newton_bloquear(false);
        var _portal=instance_create_depth(480,180,mundo_profundidade(180),obj_portal);
        _portal.portal_destination=_destination;
    }
};
