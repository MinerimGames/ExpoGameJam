tick += 1;
if (tick == 10) {
    clear_keys();
    p.x = 120; p.y = 120; p.movimento_liberado = case_index != 12;
    p.velh = 0; p.velv = 0;
    with (p) inicia_estado(estado_idle);
    wall.x = case_index >= 13 ? 140 : 400;
    var _keys = cases[case_index];
    for (var _i = 0; _i < array_length(_keys); _i++) keyboard_key_press(_keys[_i]);
}
if (tick == (case_index >= 13 ? 50 : 20)) {
    if (case_index < 8) check(sign(p.velh)==dx[case_index] && sign(p.velv)==dy[case_index], "direction " + string(case_index));
    if (case_index == 8) {
        check(abs(point_distance(0,0,p.velh,p.velv)-2)<0.001, "diagonal normalized");
        check(p.velh>0 && p.velv<0 && p.facing_sign==1, "mixed diagonal facing");
    }
    if (case_index == 9) check(p.velv==-2 && p.velh==0, "same direction no acceleration");
    if (case_index == 10 || case_index == 11) check(p.velh==0 && p.velv==0, "mixed opposites cancel");
    if (case_index == 12) check(p.velh==0 && p.velv==0 && p.x==120 && p.y==120, "locked input remains still");
    if (case_index >= 13) {
        check(p.x < 140, "collision scheme " + string(case_index));
        with (p) other.check(!place_meeting(x,y,obj_colisor), "not inside wall");
    }
    clear_keys(); case_index += 1; tick = 0;
    if (case_index == array_length(cases)) finish_tests();
}
