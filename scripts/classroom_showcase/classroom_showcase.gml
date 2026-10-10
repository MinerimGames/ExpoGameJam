function fatec_apresentacao_foco(_person)
{
    return {x:_person.x-160,y:_person.feet-137,w:320,h:190};
}

// Derive every shot from one clock, so a transition cannot restart or drift.
function fatec_apresentacao_amostra(_ending,_age)
{
    var _people=_ending.showcase_people;
    var _count=array_length(_people);
    var _full=_ending.showcase_full_view;
    var _index=clamp(floor(max(0,_age)/_ending.showcase_slot),0,_count);
    var _local=max(0,_age)-_index*_ending.showcase_slot;
    var _from=_index==0?_full:fatec_apresentacao_foco(_people[_index-1]);
    var _to=_index==_count?_full:fatec_apresentacao_foco(_people[_index]);
    var _duration=_index==_count?_ending.showcase_return:_ending.showcase_pan;
    var _t=clamp(_local/_duration,0,1);
    var _ease=_t*_t*(3-2*_t);
    var _alpha=_index==_count?0:clamp((_local-0.65)/0.25,0,1)
        *clamp((_ending.showcase_slot-_local)/0.25,0,1);
    return {index:_index==_count?-1:_index,alpha:_alpha,
        x:lerp(_from.x,_to.x,_ease),y:lerp(_from.y,_to.y,_ease),
        w:lerp(_from.w,_to.w,_ease),h:lerp(_from.h,_to.h,_ease)};
}

function fatec_apresentacao_layout(_person,_pose,_w,_h)
{
    // Font metrics match the actual game font, including accented letters.
    var _font=draw_get_font();draw_set_font(fnt_ui);
    var _scale=min(_w/640,_h/380);
    var _name_scale=_scale;var _role_scale=0.72*_scale;
    var _role_width=296*_scale/_role_scale;
    var _words=string_split(_person.role," ");var _role="";var _line="";
    for(var _i=0;_i<array_length(_words);_i++)
    {
        var _candidate=_line==""?_words[_i]:_line+" "+_words[_i];
        if(_line!="" && string_width(_candidate)>_role_width)
        {_role+=_line+"\n";_line=_words[_i];}
        else _line=_candidate;
    }
    _role+=_line;
    var _name_height=string_height(_person.name)*_name_scale;
    var _role_height=string_height(_role)*_role_scale;
    var _cx=(_person.x-_pose.x)/_pose.w*_w;
    var _head_y=(_person.feet-_person.height-_pose.y)/_pose.h*_h;
    var _bottom=_head_y-10*_scale;
    var _top=_bottom-(_name_height+6*_scale+_role_height+16*_scale);
    var _width=max(string_width(_person.name)*_name_scale,string_width(_role)*_role_scale)+24*_scale;
    draw_set_font(_font);
    return {cx:_cx,head_y:_head_y,top:_top,bottom:_bottom,
        left:_cx-_width/2,right:_cx+_width/2,
        name_scale:_name_scale,role_scale:_role_scale,role:_role,
        name_y:_top+8*_scale,role_y:_top+8*_scale+_name_height+6*_scale};
}

function fatec_apresentacao_atualizar(_ending)
{
    var _pose=fatec_apresentacao_amostra(_ending,_ending.elapsed-_ending.showcase_start);
    _ending.showcase_pose=_pose;
    if(view_enabled && view_camera[0]!=-1)
    {
        camera_set_view_size(view_camera[0],_pose.w,_pose.h);
        camera_set_view_pos(view_camera[0],_pose.x,_pose.y);
    }
}

function fatec_apresentacao_desenhar(_ending,_w,_h)
{
    var _pose=_ending.showcase_pose;
    if(_pose.index<0 || _pose.alpha<=0)exit;
    var _person=_ending.showcase_people[_pose.index];
    var _layout=fatec_apresentacao_layout(_person,_pose,_w,_h);
    draw_set_alpha(0.86*_pose.alpha);draw_set_color(make_color_rgb(22,18,35));
    draw_rectangle(_layout.left,_layout.top,_layout.right,_layout.bottom,false);
    draw_set_alpha(_pose.alpha);draw_set_color(make_color_rgb(243,203,96));
    draw_text_transformed(_layout.cx,_layout.name_y,_person.name,_layout.name_scale,_layout.name_scale,0);
    draw_set_color(c_white);
    draw_text_transformed(_layout.cx,_layout.role_y,_layout.role,_layout.role_scale,_layout.role_scale,0);
    draw_set_alpha(1);draw_set_color(c_white);
}
