// Keep the homecoming and every cinematic image visible through loading
// stalls. The existing quote and credits retain their real-time clocks.
var _dt=segredo_trono_delta(phase,max(0,delta_time/1000000));
elapsed+=_dt;
historia_newton_bloquear(true);
var _old_y=professor_y;
if(elapsed<arrival_duration)
{
    phase="arrival";
    // Begin after the portal opens. Traverse the clear middle aisle at a steady pace.
    var _progress=clamp((elapsed-0.7)/(arrival_duration-0.7),0,1);
    professor_y=lerp(560,180,_progress);
    var _travel=abs(professor_y-_old_y);
    walk_travel+=_travel;step_distance+=_travel;
    // The locked exploration actor resets its step accumulator every frame.
    // Feed each complete stride from this cinematic's own distance instead.
    if(step_distance>=40)
    {
        som_passo(step_distance,true,professor_x,professor_y);step_distance=0;
    }
}
else
{
    professor_y=180;
    if(elapsed<showcase_start)phase="home";
    else if(elapsed<home_duration)
    {
        phase="showcase";fatec_apresentacao_atualizar(id);
    }
    else if(elapsed<blackout_time)
    {
        phase="fade";fatec_apresentacao_atualizar(id);
    }
    else if(!secret_complete)segredo_trono_atualizar(id,_dt);
    else phase="COMPLETE";
}
with(obj_player){visible=false;x=other.professor_x;y=other.professor_y;}
depth=mundo_profundidade(professor_y+7);
// A held key from the farewell cannot dismiss the homecoming or end screen.
if(secret_complete || phase=="CREDITS")
{
    var _return_held=keyboard_check(vk_enter) || keyboard_check(ord("E")) || keyboard_check(vk_space) || keyboard_check(vk_escape);
    if(!_return_held)secret_return_armed=true;
    if(secret_return_armed && (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(ord("E"))))room_goto(rm_menu);
}
