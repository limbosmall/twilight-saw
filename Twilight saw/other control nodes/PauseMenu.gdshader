shader_type canvas_item;

uniform float blur_amount : hint_range(0, 10) = 0;
uniform float opacity : hint_range(0, 1) = 1;

void fragment() {
    vec4 tex = texture(TEXTURE, UV);
    vec4 blurred_tex = tex;
    
    if (blur_amount > 0.0) {
        float blur_size = blur_amount / 100.0;
        float pi = 3.14159265;
        
        for (float i = -pi; i <= pi; i += pi / 16.0) {
            float x = cos(i) * blur_size;
            float y = sin(i) * blur_size;
            blurred_tex.rgb += texture(TEXTURE, UV + vec2(x, y)).rgb;
        }
        
        blurred_tex.rgb /= 33.0; // 16 * 2 + 1
    }
    
    COLOR = vec4(blurred_tex.rgb, opacity);
}