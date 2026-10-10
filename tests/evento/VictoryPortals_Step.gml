tick++;elapsed++;
if(elapsed>1800){clear_keys();check(false,"victory portal test timeout");finish_tests();exit;}
if(tick<12)exit;
switch(stage)
{
case 0:
    with(obj_newton_cavern_dialogue)dialogue_active=false;
    n=instance_find(enemies[case_index],0);p=instance_find(obj_player,0);
    check(instance_exists(n) && instance_exists(p),"victory source actors exist");
    n.dialogue_active=false;n.encounter_started=true;
    p.x=n.x;p.y=n.y+42;
    // Approach the cavern leader from the east, where the former portal
    // position appeared under Wilson rather than outside the encounter.
    if(case_index==0){p.x=n.x+32;p.y=n.y;}
    xp_before=matematica_progresso().xp_total;
    b=batalha_iniciar(n,false);b.enemy_hp=0;b.finish_check();b.finish_check();
    check(matematica_progresso().xp_total==xp_before+100,"victory awards XP once before portal");
    check(room==sources[case_index] && instance_number(obj_portal)==0,"battle victory waits for confirmation");
    stage=1;tick=0;break;
case 1:
    b.leave_after_victory();stage=2;tick=0;break;
case 2:
    check(room==sources[case_index],"confirming victory stays in its reality until walking into portal");
    check(instance_number(obj_portal)==1,"confirmed victory exposes one traversable portal");
    if(room!=sources[case_index] || instance_number(obj_portal)!=1){stage=6;tick=0;break;}
    port=instance_find(obj_portal,0);p=instance_find(obj_player,0);
    check(port.portal_destination==destinations[case_index],"portal leads to next story reality");
    check(port.image_alpha>0.1 && !port.portal_activated,"portal visibly opens before travel");
    check(p.movimento_liberado && !instance_exists(n),"defeated boss is removed and player can approach portal");
    check(!point_in_rectangle(p.x,p.y-8,port.x-9,port.y-34,port.x+9,port.y-8),
        "portal opens separately from the player instead of triggering automatically");
    check(collision_rectangle(port.x-7,port.y-25,port.x+6,port.y-9,obj_colisor,false,true)==noone,
        "portal entrance is on unobstructed walkable floor");
    screen_save("victory-portal-"+room_get_name(room)+".png");
    stage=3;tick=0;break;
case 3:
    check(room==sources[case_index] && instance_number(obj_portal)==1,
        "waiting after victory never teleports the player");
    check(matematica_progresso().xp_total==xp_before+100,"portal waiting does not repeat reward");
    // Start immediately south, then traverse using real movement input.
    p.x=port.x;p.y=port.y+8;port.activation_delay=0;
    keyboard_key_press(vk_up);stage=4;tick=0;break;
case 4:
    if(room==sources[case_index])
    {
        if(tick>40){clear_keys();check(false,"walking into visible portal did not travel");stage=6;tick=0;}
        exit;
    }
    clear_keys();check(room==destinations[case_index],"entering portal travels to advertised reality");
    check(matematica_progresso().xp_total==xp_before+100,"portal traversal preserves single XP reward");
    stage=6;tick=0;break;
case 6:
    case_index++;
    if(case_index==array_length(sources)){finish_tests();exit;}
    room_goto(sources[case_index]);stage=0;tick=0;break;
}
