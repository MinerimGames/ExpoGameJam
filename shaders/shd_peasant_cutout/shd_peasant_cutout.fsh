varying vec2 v_vTexcoord;
varying vec4 v_vColour;
uniform vec2 u_texel;
uniform vec4 u_bounds;
float neighbour_alpha(vec2 uv)
{
    if (uv.x < u_bounds.x || uv.y < u_bounds.y
        || uv.x >= u_bounds.z || uv.y >= u_bounds.w) return 0.0;
    return texture2D(gm_BaseTexture, uv).a;
}
void main()
{
    vec4 pixel = texture2D(gm_BaseTexture, v_vTexcoord);
    float lightest = max(pixel.r, max(pixel.g, pixel.b));
    float darkest = min(pixel.r, min(pixel.g, pixel.b));
    // Clear pale neutral fringes beside transparency, preserving interior whites.
    if (darkest > 0.72 && lightest - darkest < 0.18)
    {
        float alpha = min(neighbour_alpha(v_vTexcoord+vec2(u_texel.x,0.0)),
                          neighbour_alpha(v_vTexcoord-vec2(u_texel.x,0.0)));
        alpha = min(alpha, neighbour_alpha(v_vTexcoord+vec2(0.0,u_texel.y)));
        alpha = min(alpha, neighbour_alpha(v_vTexcoord-vec2(0.0,u_texel.y)));
        if (alpha < 0.05) pixel.a = 0.0;
    }
    gl_FragColor = v_vColour * pixel;
}
