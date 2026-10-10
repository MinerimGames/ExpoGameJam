varying vec2 v_vTexcoord;
varying vec4 v_vColour;
void main()
{
    vec4 pixel=texture2D(gm_BaseTexture,v_vTexcoord);
    if(pixel.a<0.94)discard;
    gl_FragColor=vec4(pixel.rgb,1.0)*v_vColour;
}
