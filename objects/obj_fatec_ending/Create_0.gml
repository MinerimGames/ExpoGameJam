display_set_gui_size(640,380);
elapsed=0;phase="arrival";arrival_duration=4.2;
// Only the room's first controller may own the cinematic and its audio.
if(instance_number(obj_fatec_ending)>1){instance_destroy();exit;}
showcase_start=5.6;showcase_slot=3.2;showcase_pan=0.8;showcase_return=0.9;
home_duration=showcase_start+6*showcase_slot+showcase_return;
showcase_full_view={x:0,y:0,w:room_width,h:room_height};
showcase_pose={index:-1,alpha:0,x:0,y:0,w:room_width,h:room_height};
secret_config=segredo_trono_config();
ending_quote=secret_config.quote;ending_author=secret_config.author;
blackout_time=home_duration+1;quote_start=blackout_time;
credits_time=blackout_time;
for(var _i=0;_i<array_length(secret_config.scenes);_i++)
{
    if(secret_config.scenes[_i].key=="NEWTON_QUOTE")quote_start=credits_time;
    credits_time+=secret_config.scenes[_i].duration;
}
secret_active=false;secret_complete=false;secret_skipped=false;secret_index=-1;secret_time=0;
secret_skip_armed=false;secret_skip_hold=0;secret_history=[];secret_sound_ids=[];
secret_cue=-1;secret_type_group=0;secret_quote_chars=0;
secret_reveal_started=false;
secret_reveal_frame=0;secret_face_cued=false;
secret_approach_frame=0;secret_armor_cued=false;secret_step_cue=0;
secret_path_frame=0;secret_return_armed=false;
secret_surface=-1;secret_frame=0;secret_next_frame=0;secret_frame_blend=0;
secret_music_gain=0;secret_ambient_gain=0;
terminal_visible=0;terminal_lines=secret_config.errors;
professor_x=480;professor_y=560;professor_height=76;walk_travel=0;step_distance=0;
historia_newton_progresso().stage="classroom";
historia_newton_bloquear(true);
with(obj_player){visible=false;x=480;y=560;dir=1;image_angle=0;}
depth=mundo_profundidade(professor_y+7);
// Four observers stand on the left, between the green board and first desks.
var _student_spots=[[228,204],[286,204],[344,204],[402,204]];
students=[];
for(var _si=0;_si<4;_si++)
{
    var _spot=_student_spots[_si];
    var _student=instance_create_depth(_spot[0],_spot[1],mundo_profundidade(_spot[1]),obj_fatec_student);
    _student.photo_index=_si;
    _student.sprite_index=asset_get_index("spr_fatec_student_0"+string(_si+1));
    array_push(students,_student);
}
// The seated observer stays outside the desk, beside the bin on its left.
desk_guest=instance_create_depth(634,196,mundo_profundidade(196),obj_fatec_desk_guest);
desk_guest.student_height=76;
showcase_people=[
    {name:"Guilherme Batistela",role:"Gestor do projeto",x:students[0].x,feet:students[0].y,height:students[0].student_height},
    {name:"Jahel",role:"Design de background e dev",x:students[1].x,feet:students[1].y,height:students[1].student_height},
    {name:"Matheus Silva",role:"Dev geral",x:students[2].x,feet:students[2].y,height:students[2].student_height},
    {name:"Thiago Kodaira",role:"Design de personagem e direção artística",x:students[3].x,feet:students[3].y,height:students[3].student_height},
    {name:"Professor Isleide Wilson",role:"Personagem principal",x:professor_x,feet:187,height:professor_height},
    {name:"Adriano",role:"Professor responsável pelo GameJam",x:desk_guest.x,feet:desk_guest.y,height:desk_guest.student_height}
];
var _teacher_desk=instance_create_depth(0,0,mundo_profundidade(195),obj_world_foreground);
_teacher_desk.art=spr_fatec_classroom;
_teacher_desk.points=[[682,151],[809,151],[809,195],[682,195]];
_teacher_desk.source_world_width=960;_teacher_desk.source_world_height=640;
som_garantir();som_efeito("portal");

credits_heading="JOGO PARA A GAMEJAM 2026";
credits=[
    {role:"Artes de personagens e design",names:["Thiago Kodaira"]},
    {role:"Artes de background",names:["Jahel Boaventura","Matheus Conceição da Silva"]},
    {role:"Sonoplastia geral",names:["Guilherme Batistela"]},
    {role:"Desenvolvimento",names:["Matheus Conceição da Silva","Jahel Boaventura"]},
    {role:"Gestão geral do projeto",names:["Guilherme Batistela"]},
    {role:"Auxiliares do projeto",names:["Guilherme Hashish"]},
    {role:"Menção honrosa",names:["Professor Isleide Wilson"]}
];
credits_bottom=74;
// Desks and chairs occupy their feet; preserve the view of Wilson behind
// the upper furniture instead of treating a complete row as a solid bank.
var _desk_rows=[
    {y:209,w:66,h:65,xs:[118,193,269,346,549,627,705,783]},
    {y:279,w:73,h:76,xs:[110,189,269,345,549,627,706,786]},
    {y:355,w:75,h:76,xs:[104,184,266,347,550,631,713,794]},
    {y:431,w:80,h:82,xs:[97,177,261,346,550,633,718,802]}
];
for(var _row=0;_row<array_length(_desk_rows);_row++)
for(var _col=0;_col<array_length(_desk_rows[_row].xs);_col++)
{
    var _desk=_desk_rows[_row];var _x=_desk.xs[_col];var _y=_desk.y;
    var _front=instance_create_depth(0,0,mundo_profundidade(_y+_desk.h),obj_world_foreground);
    _front.art=spr_fatec_classroom;
    _front.points=[[_x,_y],[_x+_desk.w,_y],[_x+_desk.w,_y+35],[_x+_desk.w-8,_y+38],
        [_x+_desk.w-8,_y+_desk.h],[_x+9,_y+_desk.h],[_x+9,_y+38],[_x,_y+35]];
    _front.source_world_width=960;_front.source_world_height=640;
}
for(var i=0;i<array_length(credits);i++)credits_bottom+=12+14*array_length(credits[i].names)+7;
credit_variants=[
    {sprite:asset_get_index("spr_credit_cabeludo"),x:82,feet:184,height:116},
    {sprite:asset_get_index("spr_credit_adao"),x:82,feet:339,height:116},
    {sprite:asset_get_index("spr_credit_akatsuki"),x:557,feet:184,height:116},
    {sprite:asset_get_index("spr_credit_yandere"),x:557,feet:339,height:116}
];
