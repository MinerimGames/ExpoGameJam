tick++;elapsed++;
if(elapsed>700){window_set_fullscreen(original_fullscreen);check(false,"UI scaling timeout");finish_tests();exit;}
switch(stage)
{
case 0:
    if(tick<12)exit;
    m=instance_find(obj_main_menu,0);
    check(array_length(m.menu_options)==4,"native menu includes play, controls, fullscreen and exit");
    check(m.menu_options[2]=="TELA CHEIA" || m.menu_options[2]=="JANELA","fullscreen is visible as a menu action");
    for(var _i=0;_i<array_length(m.menu_options);_i++)
    {
        var _r=m.menu_button(_i);
        check(_r.x>=0 && _r.x+_r.w<=640 && _r.y+_r.h<=374,"every menu action fits the 640 GUI");
        draw_set_font(fnt_ui);
        check(string_width(m.menu_options[_i])<=_r.w-8,"menu label fits inside its button");
    }
    for(var _i=0;_i<2;_i++)
    {
        var _f=_i==0?fnt_ui:fnt_title;
        var _info=font_get_info(_f);
        check(_info.sdfEnabled,"UI font uses the engine's signed distance rendering");
        var _chars="ÁÉÍÓÚÃÕÇáéíóúãõç×+-=0123456789";
        for(var _j=1;_j<=string_length(_chars);_j++)
            check(variable_struct_exists(_info.glyphs,string_char_at(_chars,_j)),"Portuguese/math character exists in compiled font");
        var _small=ui_capture_text(_f,1,false,"ui-font-"+string(_i)+"-1x.png");
        var _large=ui_capture_text(_f,4,false,"ui-font-"+string(_i)+"-4x.png");
        var _outline=ui_capture_text(_f,4,true,"ui-font-"+string(_i)+"-4x-outline.png");
        check(_small.visible>0 && _large.visible>_small.visible*8,"enlarged Portuguese/math text produces legible pixels");
        check(_large.soft>0,"SDF produces smooth edges with pixel-art filtering disabled");
        check(ui_changed(_large,_outline),"SDF outline affects rendered pixels instead of only font metadata");
        buffer_delete(_small.pixels);buffer_delete(_large.pixels);buffer_delete(_outline.pixels);
    }
    menu_before=window_get_fullscreen();m.menu_selected=2;m.activate_option=true;
    stage=1;tick=0;break;
case 1:
    if(tick<14)exit;
    check(window_get_fullscreen()!=menu_before,"fullscreen menu action toggles the real native window");
    check(m.menu_options[2]==(window_get_fullscreen()?"JANELA":"TELA CHEIA"),"menu reflects actual window state");
    keyboard_key_press(vk_f11);stage=2;tick=0;break;
case 2:
    if(tick<3)exit;
    keyboard_key_release(vk_f11);check(window_get_fullscreen()==menu_before,"F11 toggles once while the menu is open");
    room_goto(rm_tutorial);stage=3;tick=0;break;
case 3:
    if(tick<14)exit;
    check(instance_number(obj_game_audio)==1,"one persistent application input owner survives room change");
    keyboard_key_press(vk_f11);stage=4;tick=0;break;
case 4:
    if(tick<3)exit;
    keyboard_key_release(vk_f11);check(window_get_fullscreen()!=menu_before,"F11 remains available outside the main menu");
    window_set_fullscreen(original_fullscreen);stage=5;tick=0;break;
case 5:
    if(tick<14)exit;
    finish_tests();exit;
}
