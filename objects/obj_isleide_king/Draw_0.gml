var _breath = 1 + sin(idle_time * 2.5) * 0.012;
var _foot = y + lerp(seated_feet_offset, standing_feet_offset, pose_mix);
if (pose_mix < 1)
    mundo_desenhar_personagem(spr_king_seated,x,_foot,seated_height*_breath,1-pose_mix);
if (pose_mix > 0)
    mundo_desenhar_personagem(spr_king_standing,x,_foot,standing_height*_breath,pose_mix);
