tick++;elapsed++;
if(elapsed>500){check(false,"city poster rendering finishes within test budget");finish_tests();exit;}
if(tick<20)exit;
switch(stage)
{
case 0:
    a=instance_find(obj_autumn_scene,0);
    check(variable_instance_exists(a,"flag_posts"),"city has replacement portraits within existing banner geometry");
    if(!variable_instance_exists(a,"flag_posts")){finish_tests();exit;}
    check(array_length(a.flag_posts)==array_length(cloth_limits),"all thirteen existing city banners receive the corrected character art");
    for(var _flag=0;_flag<min(array_length(a.flag_posts),array_length(cloth_limits));_flag++)
    {
        var _f=a.flag_posts[_flag];var _q=_f.points;var _outline=cloth_limits[_flag];
        check(array_length(_q)==array_length(_outline),"banner "+string(_flag)+" follows its original cloth silhouette");
        for(var _corner=0;_corner<array_length(_q);_corner++)
            check(inside_cloth(_q[_corner],_outline),"banner "+string(_flag)+" corner "+string(_corner)+" leaves masonry, frame and pole visible");
        check(variable_struct_exists(_f,"texcoords"),"banner "+string(_flag)+" crops its portrait inside the cloth");
        if(variable_struct_exists(_f,"texcoords"))
        {
            check(array_length(_f.texcoords)==array_length(_q),"banner "+string(_flag)+" gives every cloth corner a portrait coordinate");
            for(var _uv=0;_uv<array_length(_f.texcoords);_uv++)
                check(_f.texcoords[_uv][0]>=0 && _f.texcoords[_uv][0]<=1 && _f.texcoords[_uv][1]>=0 && _f.texcoords[_uv][1]<=1,
                    "banner "+string(_flag)+" crop stays inside the preserved portrait");
        }
    }
    var _art=["spr_city_flag_salute","spr_city_flag_speech","spr_city_flag_resolve"];
    for(var i=0;i<3;i++)check(asset_get_index(_art[i])!=-1,"distinct high-quality banner pose "+_art[i]);
    check(!a.flags_animated,"wall portraits keep their fixed masonry geometry");
    p=instance_find(obj_player,0);p.x=416;p.y=70;screen_save("city-flags-gate.png");
    room_goto(rm_autumn_streets);stage=1;tick=0;break;
case 1:
    a=instance_find(obj_autumn_scene,0);p=instance_find(obj_player,0);
    p.x=416;p.y=240;
    check(array_length(a.flag_posts)>=12 && a.map_offset_y==0,"city sections use the same art and banner positions with their original scroll offset");
    check(instance_number(obj_isleide_city)==0,"banner corrections do not duplicate city boss instances");
    p.movimento_liberado=false;
    camera_set_view_target(view_camera[0],noone);
    camera_set_view_size(view_camera[0],800,600);camera_set_view_pos(view_camera[0],0,0);
    stage=10;tick=0;break;
case 10:
    screen_save("city-flags-streets.png");
    camera_set_view_size(view_camera[0],400,300);camera_set_view_pos(view_camera[0],0,0);
    stage=11;tick=0;break;
case 11:
    screen_save("city-flags-west-top.png");
    camera_set_view_pos(view_camera[0],400,0);stage=12;tick=0;break;
case 12:
    screen_save("city-flags-east-top.png");
    camera_set_view_pos(view_camera[0],0,250);stage=13;tick=0;break;
case 13:
    screen_save("city-flags-west-bottom.png");
    camera_set_view_pos(view_camera[0],400,250);stage=14;tick=0;break;
case 14:
    screen_save("city-flags-east-bottom.png");
    camera_set_view_size(view_camera[0],800,600);
    room_goto(rm_autumn_plaza);stage=2;tick=0;break;
case 2:
    a=instance_find(obj_autumn_scene,0);
    check(array_length(a.flag_posts)==0,"final plaza retains its own original art without misplaced city banners");
    finish_tests();exit;
}
