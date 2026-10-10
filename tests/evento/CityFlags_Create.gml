// Independent inner-cloth measurements on the revised 1448x1086 city art.
// Convex enclosures stop above notched hems and foliage, leaving the gold trim visible.
cloth_limits=[
    [[88,92],[134,92],[134,186],[88,186]],
    [[1370,90],[1416,90],[1416,182],[1370,182]],
    [[11,648],[64,648],[64,753],[11,753]],
    [[1381,649],[1434,649],[1434,758],[1381,758]],
    [[428,191],[471,198],[468,237],[425,231]],
    [[624,192],[648,192],[648,222],[624,222]],
    [[804,211],[829,211],[829,241],[804,241]],
    [[854,192],[877,192],[877,221],[854,221]],
    [[1033,197],[1078,210],[1072,248],[1027,236]],
    [[627,368],[652,368],[652,422],[640,436],[627,422]],
    [[850,368],[874,368],[874,424],[862,437],[850,424]],
    [[387,542],[418,538],[421,572],[390,575]],
    [[1089,539],[1123,547],[1119,575],[1083,568]]
];
inside_cloth=function(_point,_outline)
{
    for(var _edge=0;_edge<array_length(_outline);_edge++)
    {
        var _a=_outline[_edge];var _b=_outline[(_edge+1) mod array_length(_outline)];
        var _cross=(_b[0]-_a[0])*(_point[1]-_a[1])-(_b[1]-_a[1])*(_point[0]-_a[0]);
        if(_cross < -0.01)return false;
    }
    return true;
};
stage=0;tick=0;elapsed=0;game_set_speed(60,gamespeed_fps);
room_goto(rm_autumn_gate);
