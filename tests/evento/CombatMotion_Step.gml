tick++;elapsed++;
if(elapsed>1800){check(false,"combat motion timeout");finish_tests();exit;}
if(stage==0 && tick>=12)
{
    with(obj_newton_npc)dialogue_active=false;
    b=batalha_iniciar(noone,false);b.enemy_battle_poses=undefined;
    stage=1;tick=0;
}
if(stage==1 && tick==12)
{
    b.enemy_battle_sprite=sprites[case_index];
    b.enemy_battle_scale=232/(sprite_get_bbox_bottom(sprites[case_index])-sprite_get_bbox_top(sprites[case_index])+1);
    first=presentation_capture(b,true);stage=2;tick=0;
}
if(stage==2 && tick==30)
{
    var _next=presentation_capture(b,true);
    if(sprites[case_index]==spr_steampunk_idle)check(!portrait_changed(first,_next,377,53,535,214),"Steampunk portrait stays still in combat");
    else check(portrait_changed(first,_next,377,53,535,214),"enemy visibly breathes/sways: "+sprite_get_name(sprites[case_index]));
    check(portrait_changed(first,_next,160,124,270,286),"Wilson visibly breathes with each opponent");
    buffer_delete(first.pixels);buffer_delete(_next.pixels);
    case_index++;stage=1;tick=0;
    if(case_index==array_length(sprites))
    {
        check(variable_instance_exists(b,"motion_visual"),"combat has reusable action reactions");
        if(!variable_instance_exists(b,"motion_visual")){finish_tests();exit;}
        b.story_battle=true;b.story_stage=2;
        stage=3;tick=0;
    }
}
if(stage==3 && tick==12){first=presentation_capture(b,true);stage=4;tick=0;}
if(stage==4 && tick==30)
{
    var _next=presentation_capture(b,true);
    check(portrait_changed(first,_next,225,145,310,286),"Agente ally visibly animates alongside Wilson");
    check(portrait_changed(first,_next,190,121,410,153),"all four returning supporters visibly animate");
    buffer_delete(first.pixels);buffer_delete(_next.pixels);
    b.enemy_hp=999;b.enemy_hp_max=999;b.enemy_intent="normal";
    b.execute_attack();check(b.motion_visual("player").kind=="attack","player action starts attack movement");
    check(b.motion_visual("enemy").kind=="hurt","attack starts enemy impact reaction before counterattack");
    b.restart_battle();b.player_hp=70;b.execute_heal();
    check(b.motion_visual("player").kind=="heal","heal retains its glow even when enemy responds");
    b.execute_defense();check(b.motion_visual("player").kind=="defense","defense holds its protection stance");
    b.execute_dodge();check(b.motion_visual("player").kind=="dodge","dodge uses a visible sidestep");
    var _v=b.motion_visual("player");check(abs(_v.x)<=32 && abs(_v.y)<=12,"reaction stays inside existing UI portrait bounds");
    stage=5;tick=0;
}
if(stage==5 && tick==75)
{
    check(b.motion_visual("player").kind=="idle" && b.motion_visual("enemy").kind=="idle","reactions return to living idle after bounded duration");
    check(b.player_visual().facing==-1,"animated idle keeps Wilson facing enemy");
    b.restart_battle();check(b.motion_visual("player").kind=="idle","retry clears action offsets");
    screen_save("combat-motion-supported.png");finish_tests();exit;
}
