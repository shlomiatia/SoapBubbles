shader_type canvas_item;

uniform float wave_count : hint_range(1.0, 20.0, 1.0) = 20.0;
uniform float speed : hint_range(0.0, 10.0, 0.1) = 3.0;
uniform float height : hint_range(0.0, 0.1, 0.001) = 0.003;
uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;

void fragment() {
    // Get the sprite's alpha from its texture
    float sprite_alpha = texture(TEXTURE, UV).a;

    // Only apply the effect where the sprite has opacity
    if (sprite_alpha > 0.0) {
        vec2 cPos = -1.0 + 2.0 * UV;
        float cLength = length(cPos);

        // Convert UV to screen coordinates
        vec2 screen_uv = SCREEN_UV + (cPos/cLength) * cos(cLength * wave_count - TIME * speed) * height;
        vec3 col = texture(SCREEN_TEXTURE, screen_uv).xyz;
        COLOR = vec4(col, sprite_alpha);
    } else {
        // Make the pixel transparent where the sprite is transparent
        COLOR = vec4(0.0);
    }
}