tick++;elapsed++;
if(elapsed>600){check(false,"presentation suite timeout");finish_tests();exit;}
switch(stage)
{
case 0:
    if(tick<12)exit;
    n=instance_find(obj_isleide_king,0);p=instance_find(obj_player,0);
    n.pose_mix=0;
    var _seated=presentation_capture(n);
    var _wilson=presentation_capture(p);
    check(_seated.height>=54 && _seated.height<=68,
        "native seated king fills the throne at an adult visible size");
    check(_seated.bottom>=116 && _seated.bottom<=122,
        "seated king boots align to the throne seat instead of its floor");
    check(_wilson.height>=38 && _wilson.height<=46,
        "castle Wilson has a readable adult scale against the furniture");
    check(_seated.height/_wilson.height>=1.2 && _seated.height/_wilson.height<=1.7,
        "seated king and castle Wilson retain compatible proportions");
    screen_save("presentation-king-seated.png");
    buffer_delete(_seated.pixels);buffer_delete(_wilson.pixels);
    stage=1;tick=0;break;
case 1:
    if(!n.dialogue_active)exit;
    var _standing=presentation_capture(n);
    check(_standing.height>=48 && _standing.height<=72,
        "native standing king remains readable without dwarfing Wilson");
    check(_standing.bottom>=142 && _standing.bottom<=146,
        "standing king steps forward onto the throne dais");
    buffer_delete(_standing.pixels);screen_save("presentation-king-standing.png");
    room_goto(rm_tutorial);stage=2;tick=0;break;
case 2:
    if(tick<12)exit;
    n=instance_find(obj_newton_npc,0);
    n.dialogue_active=true;n.dialogue_mode="intro";
    anchor_x=n.x;anchor_y=n.y;first=presentation_capture(n);
    first_gui=presentation_capture(n,true);
    screen_save("presentation-newton-tutorial-a.png");
    stage=3;tick=0;break;
case 3:
    if(tick<30)exit;
    var _next=presentation_capture(n);
    var _next_gui=presentation_capture(n,true);
    check(first.count>0 && _next.count>0 && presentation_changed(first,_next),
        "tutorial Newton visibly breathes and sways during his dialogue");
    check(n.x==anchor_x && n.y==anchor_y,
        "Newton idle motion preserves the tutorial interaction anchor");
    check(presentation_changed(first_gui,_next_gui),
        "Newton portrait visibly animates while tutorial dialogue covers the world actor");
    buffer_delete(first.pixels);buffer_delete(_next.pixels);
    buffer_delete(first_gui.pixels);buffer_delete(_next_gui.pixels);
    screen_save("presentation-newton-tutorial-b.png");
    room_goto(rm_temporal_origin);stage=4;tick=0;break;
case 4:
    if(tick<12)exit;
    n=instance_find(obj_newton_final,0);
    anchor_x=n.x;anchor_y=n.y;first=presentation_capture(n);
    final_scene=instance_find(obj_temporal_scene,0);
    final_scene.scene_mode="exposure";final_scene.dialogue_active=true;
    final_scene.dialogue_pages=historia_newton_dialogo("exposure");final_scene.dialogue_page=0;
    first_final_gui=presentation_capture(final_scene,true);
    screen_save("presentation-newton-final-a.png");
    stage=5;tick=0;break;
case 5:
    if(tick<30)exit;
    var _next=presentation_capture(n);
    check(first.count>0 && _next.count>0 && presentation_changed(first,_next),
        "final Newton visibly breathes and sways during the origin scene");
    check(n.x==anchor_x && n.y==anchor_y,
        "final Newton idle motion preserves his story scene anchor");
    var _next_final_gui=presentation_capture(final_scene,true);
    check(presentation_changed(first_final_gui,_next_final_gui),
        "final Newton portrait animates during the exposure dialogue");
    buffer_delete(first_final_gui.pixels);buffer_delete(_next_final_gui.pixels);
    buffer_delete(first.pixels);buffer_delete(_next.pixels);
    screen_save("presentation-newton-final-b.png");
    final_scene.dialogue_active=false;
    final_battle=batalha_iniciar(n,false);
    first_battle_gui=presentation_capture(final_battle,true);
    stage=6;tick=0;break;
case 6:
    if(tick<30)exit;
    var _next_battle_gui=presentation_capture(final_battle,true);
    check(presentation_changed(first_battle_gui,_next_battle_gui),
        "Newton remains visibly animated in the battle portrait");
    buffer_delete(first_battle_gui.pixels);buffer_delete(_next_battle_gui.pixels);
    screen_save("presentation-newton-battle.png");
    finish_tests();exit;
}
