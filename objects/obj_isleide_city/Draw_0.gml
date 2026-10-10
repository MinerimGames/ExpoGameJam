var _sprite=dialogue_active && dialogue_speakers[dialogue_page]=="ISLEIDE DA CIDADE"
    ?dialogue_portraits[dialogue_page]:spr_city_peace;
mundo_desenhar_personagem(_sprite,x,y+7,32*(1+0.01*sin(breathing)));
