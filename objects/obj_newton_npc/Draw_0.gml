var _breath=1+sin(idle_time*2.4)*0.035;
var _sway=sin(idle_time*1.6)*2.5;
mundo_desenhar_personagem(sprite_index,x,y+7,28*_breath,1,_sway);
