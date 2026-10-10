varying vec2 v_vTexcoord;
varying vec4 v_vColour;
void main()
{
    vec4 c=texture2D(gm_BaseTexture,v_vTexcoord);
    // Generated transparency can contain isolated red and gray fringe pixels.
    // Render only the character palette; its original PNG remains intact.
    if(c.a<0.78 || (c.r>0.70 && c.g<0.36 && c.b<0.36))discard;
    if(c.r<0.70 && abs(c.r-c.g)<0.075 && abs(c.g-c.b)<0.075)discard;
    gl_FragColor=v_vColour*c;
}
