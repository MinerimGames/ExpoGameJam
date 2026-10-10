varying vec2 v_vTexcoord;
varying vec4 v_vColour;
uniform float u_time;
uniform vec2 u_texel;
void main() {
    // One transform of the already-composited frames: never offset them apart.
    float burst = step(0.965, fract(u_time * 0.83));
    vec2 uv = (v_vTexcoord - 0.5) / 1.008 + 0.5;
    uv += vec2(sin(u_time * 23.0), cos(u_time * 19.0)) * 0.0005;
    float strip = step(0.88, sin(uv.y * 47.0 + floor(u_time * 17.0)));
    uv.x += burst * strip * sin(u_time * 71.0) * 0.003;
    uv = clamp(uv, vec2(0.003), vec2(0.997));
    vec2 soft = u_texel * (0.8 + 1.2 * burst);
    vec4 color = texture2D(gm_BaseTexture, uv) * 0.60;
    color += texture2D(gm_BaseTexture, uv + vec2(soft.x, 0.0)) * 0.10;
    color += texture2D(gm_BaseTexture, uv - vec2(soft.x, 0.0)) * 0.10;
    color += texture2D(gm_BaseTexture, uv + vec2(0.0, soft.y)) * 0.10;
    color += texture2D(gm_BaseTexture, uv - vec2(0.0, soft.y)) * 0.10;
    color.rgb *= 0.992 + 0.008 * sin(uv.y * 760.0);
    // A faint green signal tint; preserve the artwork's original colors.
    float luminance = dot(color.rgb, vec3(0.2126, 0.7152, 0.0722));
    color.rgb = mix(color.rgb, vec3(luminance * 0.72, luminance, luminance * 0.78), 0.035 + burst * 0.09);
    gl_FragColor = v_vColour * color;
}
