tick++;elapsed++;
if(elapsed>400){check(false,"menu poster timeout");finish_tests();exit;}
if(stage==0 && tick==12)
{
    m=instance_find(obj_main_menu,0);
    check(asset_get_index("spr_menu_poster")!=-1,"menu contains user's supplied poster");
    check(variable_instance_exists(m,"menu_button"),"menu has explicit horizontal buttons");
    if(!variable_instance_exists(m,"menu_button")){finish_tests();exit;}
    var _prev=-100;
    for(var i=0;i<array_length(m.menu_options);i++)
    {
        var _r=m.menu_button(i);
        check(_r.x>_prev && _r.x+_r.w<=640 && _r.y>=340 && _r.y+_r.h<=374,"button stays below poster title, inside window");
        _prev=_r.x+_r.w;
    }
    check(variable_instance_exists(m,"menu_hover"),"stationary mouse cannot override keyboard selection");
    if(!variable_instance_exists(m,"menu_hover")){finish_tests();exit;}
    m.menu_selected=1;m.menu_hover(80,355,false,false);
    check(m.menu_selected==1,"stationary mouse preserves keyboard-selected option");
    m.menu_hover(80,355,false,true);check(m.menu_selected==0,"moving mouse explicitly selects its button");
    var _second=m.menu_button(1);
    m.menu_hover(_second.x+_second.w*0.5,355,true,false);check(m.menu_selected==1 && m.activate_option,"click uses correct horizontal button");
    m.activate_option=false;m.menu_selected=0;
    keyboard_key_press(vk_right);stage=1;tick=0;
}
if(stage==1 && tick==3)
{
    clear_keys();check(m.menu_selected==1,"right arrow moves to next horizontal option");
    keyboard_key_press(vk_left);stage=2;tick=0;
}
if(stage==2 && tick==3)
{
    clear_keys();check(m.menu_selected==0,"left arrow returns to JOGAR");
    screen_save("menu-poster.png");stage=3;tick=0;
}
if(stage==3 && tick==12)
{
    keyboard_key_press(vk_enter);stage=4;tick=0;
}
if(stage==4 && tick==6)
{
    keyboard_key_release(vk_enter);check(room==rm_tutorial,"poster menu still starts game via keyboard");finish_tests();exit;
}
