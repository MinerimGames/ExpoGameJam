tick++;
if (phase=="victory" && tick>=30)
{
    var _p=instance_find(obj_player,0);
    var _enemy=instance_find(obj_cavern_isleide,0);
    check(instance_exists(_p) && instance_exists(_enemy),"boss room actors exist");
    _p.x=_enemy.x; _p.y=_enemy.y; _enemy.encounter_started=true;
    var _battle=batalha_iniciar(_enemy,false);
    _battle.enemy_hp=0; _battle.finish_check(); _battle.leave_after_victory();
    phase="after_victory";tick=0;
}
else if (phase=="after_victory" && tick>=3)
{
    check(room==rm_cavernas_2 && instance_number(obj_portal)==1,"victory creates cave portal");
    var _portal=instance_find(obj_portal,0);
    check(_portal.portal_destination==rm_vila,"victory portal targets vila");
    var _p=instance_find(obj_player,0);_portal.activation_delay=0;_p.x=_portal.x;_p.y=_portal.y-16;
    phase="vila";tick=0;
    game_set_speed(240,gamespeed_fps);
}
else if (phase=="vila" && tick>=3)
{
    var _p=instance_find(obj_player,0);
    check(_p.x>528 && _p.x<592 && _p.y>568,"vila entry follows southern trail");
    transmission=instance_find(obj_newton_cavern_dialogue,0);
    check(instance_exists(transmission),"Newton transmission starts after cave victory portal");
    if(!instance_exists(transmission)){finish_tests();exit;}
    check(instance_number(obj_newton_cavern_dialogue)==1,"medieval arrival has one transmission");
    check(transmission.dialogue_active && transmission.dialogue_page==0
        && array_length(transmission.dialogue_pages)==6 && !_p.movimento_liberado,
        "medieval transmission begins on page one and locks player");
    transmission_origin=[_p.x,_p.y];transmission_page=0;
    keyboard_key_press(vk_right);
    phase="entry_transmission";tick=0;
}
else if (phase=="entry_transmission")
{
    var _p=instance_find(obj_player,0);
    if(tick==3)screen_save((room==rm_vila?"newton-medieval-page-":
        (room==rm_steampunk_foundry?"newton-steampunk-route-page-":"newton-ghost-city-page-"))
        +string(transmission_page)+".png");
    if(tick==5)
    {
        check(_p.x==transmission_origin[0] && _p.y==transmission_origin[1]
            && !_p.movimento_liberado,"movement input does not move player during transmission");
        keyboard_key_release(vk_right);
    }
    var _advance=transmission_page mod 2==0?ord("E"):vk_space;
    if(tick==8)keyboard_key_press(_advance);
    if(tick==10)keyboard_key_release(_advance);
    if(tick>=12)
    {
        if(transmission_page<5)
        {
            transmission_page++;
            check(transmission.dialogue_active && transmission.dialogue_page==transmission_page
                && !_p.movimento_liberado,"E and Space each advance only one transmission page");
            tick=0;
        }
        else
        {
            check(!transmission.dialogue_active && _p.movimento_liberado
                && !instance_exists(obj_battle_controller) && instance_number(obj_portal)==0,
                "final transmission confirmation releases player without another encounter");
            if(room==rm_vila)
                begin_walk(rm_vila,rm_bosque,[[576,608],[576,514],[552,514],[552,210],[504,210],[504,186],[480,186],[480,164],[20,164]]);
            else if(room==rm_steampunk_foundry)
                begin_walk(rm_steampunk_foundry,rm_autumn_gate,[[480,520],[480,224],[480,58]]);
            else begin_walk(rm_autumn_gate,rm_autumn_streets,[[416,248],[416,50]]);
        }
    }
}
else if (phase=="bosque" && tick>=3)
{
    var _p=instance_find(obj_player,0);
    check(_p.x>580 && _p.y>192 && _p.y<240,"trilha entry follows eastern trail from village");
    check(instance_number(obj_newton_cavern_dialogue)==0,"medieval introduction only runs on arrival in village");
    begin_walk(rm_bosque,rm_castelo,[[608,214],[608,232],[568,232],[568,248],[536,248],[536,260],[376,260],[376,226],[368,226],[368,210],[328,210],[328,178],[304,178],[304,16]]);
}
else if (phase=="castelo" && tick>=3)
{
    var _p=instance_find(obj_player,0);
    check(_p.x>=404 && _p.x<=428 && _p.y>=680,"castle entry is aligned with bridge");
    begin_walk(rm_castelo,rm_castle_hall,[[416,704],[416,610],[454,610],[416,610],[416,526]]);
    phase="bridge";
}
else if (phase=="hall" && tick>=3)
{
    check(guard_handled,"castle doorway requires victory against guard");
    begin_walk(rm_castle_hall,rm_throne_room,[[400,440],[400,158]]);
}
else if (phase=="royal")
{
    clear_keys();
    var _king=instance_find(obj_isleide_king,0);
    if (instance_exists(_king) && _king.dialogue_active)
    {
        if (guard_input_pulse) keyboard_key_release(ord("E"));
        else keyboard_key_press(ord("E"));
        guard_input_pulse=!guard_input_pulse;
    }
    if (instance_exists(obj_battle_controller))
    {
        keyboard_key_release(ord("E"));
        var _b=instance_find(obj_battle_controller,0);
        check(_b.enemy_source==_king,"natural route encounters king in throne room");
        for(var _i=0;_i<80 && _b.battle_screen=="actions";_i++)
        {
            var _action="attack";
            if (_b.enemy_intent=="strong") _action="defense";
            else if (_b.enemy_intent=="normal" && _b.player_hp<=60 && _b.heal_cooldown==0) _action="heal";
            _b.request_action(_action);_b.answer_text=string(_b.challenge.resposta);_b.verify_answer();
        }
        check(_b.battle_screen=="victory","king battle on natural route is winnable");
        if (_b.battle_screen!="victory") {finish_tests();exit;}
        _b.leave_after_victory();phase="royal_victory";tick=0;
    }
    if(tick>1500){check(false,"natural royal encounter timeout");finish_tests();exit;}
}
else if (phase=="royal_victory" && tick>=3)
{
    if(instance_number(obj_portal)==1 && instance_find(obj_portal,0).activation_delay>0)exit;
    check(room==rm_throne_room && instance_number(obj_portal)==1
        && !instance_exists(obj_isleide_king) && instance_find(obj_player,0).movimento_liberado,
        "king confirmation keeps the natural route at the throne with a visible portal");
    var _royal_player=instance_find(obj_player,0);var _royal_portal=instance_find(obj_portal,0);
    keyboard_key_press(_royal_player.y<_royal_portal.y-16?vk_down:vk_up);phase="royal_portal";tick=0;
}
else if(phase=="royal_portal")
{
    if(room==rm_throne_room)
    {if(tick>180){clear_keys();check(false,"royal portal walk timed out");finish_tests();}exit;}
    clear_keys();phase="foundry_arrival";tick=0;
}
else if(phase=="foundry_arrival" && tick>=3)
{
    check(room==rm_steampunk_foundry,"royal portal continues into industrial phase before city");
    if(room!=rm_steampunk_foundry){finish_tests();exit;}
    var _p=instance_find(obj_player,0);
    transmission=instance_find(obj_newton_cavern_dialogue,0);
    check(instance_exists(transmission),"natural king victory starts industrial Newton transmission");
    if(!instance_exists(transmission)){finish_tests();exit;}
    check(transmission.dialogue_active && transmission.dialogue_page==0
        && array_length(transmission.dialogue_pages)==6 && !_p.movimento_liberado,
        "industrial transmission locks natural route on first of six pages");
    transmission_origin=[_p.x,_p.y];transmission_page=0;
    keyboard_key_press(vk_right);
    phase="entry_transmission";tick=0;
}
else if(phase=="steam_victory" && tick>=3)
{
    if(instance_number(obj_portal)==1 && instance_find(obj_portal,0).activation_delay>0)exit;
    var _p=instance_find(obj_player,0);
    var _scene=instance_find(obj_steampunk_scene,0);
    check(room==rm_steampunk_foundry && !instance_exists(obj_battle_controller)
        && !instance_exists(obj_isleide_steampunk) && _p.movimento_liberado
        && !instance_exists(_scene.exit_gate) && instance_number(obj_portal)==1,
        "industrial confirmation removes physical gate and permits walking into its portal");
    check(historia_newton_progresso().steampunk_defeated
        && matematica_progresso().xp_total==steam_xp_before+100,
        "industrial progression keeps exactly one 100 XP victory reward");
    steam_victory_confirmed=true;
    var _steam_portal=instance_find(obj_portal,0);
    keyboard_key_press(_p.y<_steam_portal.y-16?vk_down:vk_up);phase="steam_portal";tick=0;
}
else if(phase=="steam_portal")
{
    if(room==rm_steampunk_foundry)
    {if(tick>180){clear_keys();check(false,"industrial portal walk timed out");finish_tests();}exit;}
    clear_keys();check(room==rm_autumn_gate,"walking into industrial portal reaches autumn reality");
    phase="ghost_arrival";tick=0;
}
else if(phase=="ghost_arrival" && tick>=3)
{
    check(steam_victory_confirmed,"city arrival follows industrial victory and a northward walk");
    var _p=instance_find(obj_player,0);
    transmission=instance_find(obj_newton_cavern_dialogue,0);
    check(instance_exists(transmission),"industrial exit starts ghost city transmission");
    if(!instance_exists(transmission)){finish_tests();exit;}
    check(transmission.dialogue_active && transmission.dialogue_page==0
        && array_length(transmission.dialogue_pages)==6 && !_p.movimento_liberado,
        "ghost city transmission locks natural route on its first page");
    transmission_origin=[_p.x,_p.y];transmission_page=0;
    keyboard_key_press(vk_right);phase="entry_transmission";tick=0;
}
else if (phase=="autumn_streets" && tick>=3)
{
    begin_walk(rm_autumn_streets,rm_autumn_plaza,[[416,388],[416,310],[336,310],[336,130],[400,130],[400,70]]);
}
else if (phase=="autumn_plaza" && tick>=3)
{
    begin_walk(rm_autumn_plaza,noone,[[480,516],[480,400],[480,260]]);
}
else if(phase=="city_victory" && tick>=3)
{
    if(instance_number(obj_portal)==1 && instance_find(obj_portal,0).activation_delay>0)exit;
    var _p=instance_find(obj_player,0);
    check(room==rm_autumn_plaza && _p.movimento_liberado && !instance_exists(obj_battle_controller)
        && !instance_exists(obj_isleide_city) && instance_number(obj_portal)==1,
        "complete natural route reaches playable final plaza with its victory portal");
    var _city_portal=instance_find(obj_portal,0);
    keyboard_key_press(_p.y<_city_portal.y-16?vk_down:vk_up);phase="city_portal";tick=0;
}
else if(phase=="city_portal")
{
    if(room==rm_autumn_plaza)
    {if(tick>180){clear_keys();check(false,"city portal walk timed out");finish_tests();}exit;}
    clear_keys();check(room==rm_commercial_district,"city portal continues natural route into commercial reality");
    var _ally=instance_find(obj_capitalist_ally,0);
    check(instance_exists(_ally) && array_length(_ally.dialogue_pages)==16,
        "commercial arrival retains the agent and sixteen revelation pages");
    check(instance_find(obj_player,0).movimento_liberado && !_ally.dialogue_active
        && instance_number(obj_portal)==0,
        "commercial arrival permits walking to the agent before its return portal opens");
    check(global.math_progress.xp_total==500 && global.math_progress.level==6
        && global.math_progress.paradox_unlocked,
        "five natural route victories retain XP comprehension and royal skill across phases");
    finish_tests();exit;
}
else if (phase=="bridge" || phase=="walk")
{
    walk_frames++;
    if (room!=expected_room)
    {
        clear_keys();
        check(room==next_room,"walking reaches next scenario without teleport");
        if (room==rm_vila) phase="vila";
        else if (room==rm_bosque) phase="bosque";
        else if (room==rm_castelo) phase="castelo";
        else if (room==rm_castle_hall) phase="hall";
        else if (room==rm_throne_room) phase="royal";
        else if (room==rm_autumn_gate) phase="ghost_arrival";
        else if (room==rm_autumn_streets) phase="autumn_streets";
        else if (room==rm_autumn_plaza) phase="autumn_plaza";
        else {check(false,"unexpected room on natural route");finish_tests();exit;}
        tick=0;exit;
    }
    if (walk_frames>1800) {clear_keys();check(false,"natural trail blocked in "+room_get_name(room));finish_tests();exit;}
    var _p=instance_find(obj_player,0);
    if(room==rm_steampunk_foundry && instance_exists(obj_isleide_steampunk))
    {
        var _steam=instance_find(obj_isleide_steampunk,0);
        if(_steam.dialogue_active)
        {
            clear_keys();
            if(!steam_dialogue_seen)
            {
                check(array_length(_steam.dialogue_pages)==8 && !_p.movimento_liberado
                    && !instance_exists(obj_battle_controller),
                    "walking through the foundry reaches eight boss pages before combat");
                steam_dialogue_seen=true;
            }
            if(guard_input_pulse)keyboard_key_release(ord("E"));
            else keyboard_key_press(ord("E"));
            guard_input_pulse=!guard_input_pulse;exit;
        }
        if(instance_exists(obj_battle_controller))
        {
            clear_keys();keyboard_key_release(ord("E"));
            var _b=instance_find(obj_battle_controller,0);
            var _scene=instance_find(obj_steampunk_scene,0);
            check(_b.enemy_source==_steam && !_p.movimento_liberado && _b.enemy_hp==205
                && _b.math_profile=="steampunk_alternating" && _b.math_phase==6 && _b.math_phase_max==8,
                "natural route fights the industrial guardian between king and city difficulty");
            check(instance_exists(_scene.exit_gate),"industrial gate remains closed throughout combat");
            steam_xp_before=matematica_progresso().xp_total;
            for(var _i=0;_i<100 && _b.battle_screen=="actions";_i++)
            {
                var _action="attack";
                if(_b.enemy_intent=="strong")_action="defense";
                else if(_b.enemy_intent=="normal" && _b.player_hp<=60 && _b.heal_cooldown==0)_action="heal";
                _b.request_action(_action);_b.answer_text=string(_b.challenge.resposta);_b.verify_answer();
            }
            check(_b.battle_screen=="victory","industrial boss is winnable on the full natural route");
            if(_b.battle_screen!="victory"){finish_tests();exit;}
            _b.reward_victory();
            check(matematica_progresso().xp_total==steam_xp_before+100
                && instance_exists(_scene.exit_gate) && !_p.movimento_liberado,
                "industrial victory rewards once while retaining gate until confirmation");
            _b.leave_after_victory();phase="steam_victory";tick=0;exit;
        }
    }
    if(room==rm_autumn_plaza && instance_exists(obj_isleide_city))
    {
        var _city=instance_find(obj_isleide_city,0);
        if(_city.dialogue_active)
        {
            clear_keys();
            if(guard_input_pulse)keyboard_key_release(ord("E"));
            else keyboard_key_press(ord("E"));
            guard_input_pulse=!guard_input_pulse;exit;
        }
        if(instance_exists(obj_battle_controller))
        {
            clear_keys();keyboard_key_release(ord("E"));
            var _b=instance_find(obj_battle_controller,0);
            check(_b.enemy_source==_city && !_p.movimento_liberado,
                "natural route encounters city leader after royal and industrial victories");
            for(var _i=0;_i<100 && _b.battle_screen=="actions";_i++)
            {
                var _action="attack";
                if(_b.enemy_intent=="strong")_action="defense";
                else if(_b.enemy_intent=="normal" && _b.player_hp<=60 && _b.heal_cooldown==0)_action="heal";
                _b.request_action(_action);_b.answer_text=string(_b.challenge.resposta);_b.verify_answer();
            }
            check(_b.battle_screen=="victory","city boss is winnable on full natural route");
            if(_b.battle_screen!="victory"){finish_tests();exit;}
            _b.leave_after_victory();phase="city_victory";tick=0;exit;
        }
    }
    if (room==rm_castelo && instance_exists(obj_castle_guard))
    {
        var _guard=instance_find(obj_castle_guard,0);
        if (_guard.dialogue_active)
        {
            clear_keys();
            if (guard_input_pulse) keyboard_key_release(ord("E"));
            else keyboard_key_press(ord("E"));
            guard_input_pulse=!guard_input_pulse;
            exit;
        }
        if (instance_exists(obj_battle_controller))
        {
            clear_keys();keyboard_key_release(ord("E"));
            var _b=instance_find(obj_battle_controller,0);
            check(!_p.movimento_liberado && _b.enemy_source==_guard,
                "walking to castle door is interrupted by guard battle");
            for(var _i=0;_i<60 && _b.battle_screen=="actions";_i++)
            {
                var _action="attack";
                if (_b.enemy_intent=="strong") _action="defense";
                else if (_b.enemy_intent=="normal" && _b.player_hp<=60 && _b.heal_cooldown==0) _action="heal";
                _b.request_action(_action);
                _b.answer_text=string(_b.challenge.resposta);
                _b.verify_answer();
            }
            check(_b.battle_screen=="victory","guard battle on natural route is winnable");
            if (_b.battle_screen!="victory") {finish_tests();exit;}
            _b.leave_after_victory();guard_handled=true;exit;
        }
    }
    var _point=waypoints[min(waypoint_index,array_length(waypoints)-1)];
    // Walk into the moat wall and prove it blocks, then continue on the bridge.
    if (phase=="bridge" && waypoint_index==2 && walk_frames>150)
    {
        check(_p.x<436,"castle moat collision stops walking into water");
        waypoint_index++;phase="walk";clear_keys();exit;
    }
    if (abs(_p.x-_point[0])<=1.1 && abs(_p.y-_point[1])<=1.1 && waypoint_index<array_length(waypoints)-1)
    {
        waypoint_index++;_point=waypoints[waypoint_index];
    }
    if (room==rm_autumn_plaza && waypoint_index==array_length(waypoints)-1
        && abs(_p.x-_point[0])<=1.1 && abs(_p.y-_point[1])<=1.1)
    {
        clear_keys();
        check(_p.movimento_liberado && !instance_exists(obj_battle_controller),
            "complete natural route reaches playable final plaza");
        check(global.math_progress.xp_total==500 && global.math_progress.level==6
            && global.math_progress.paradox_unlocked,
            "five natural route victories retain XP comprehension and royal skill across phases");
        finish_tests();exit;
    }
    clear_keys();
    if (abs(_p.x-_point[0])>1.1) keyboard_key_press(_p.x<_point[0]?vk_right:vk_left);
    else if (abs(_p.y-_point[1])>1.1) keyboard_key_press(_p.y<_point[1]?vk_down:vk_up);
}
