shader_type canvas_item;
render_mode blend_mix,unshaded;

uniform vec4 effect_color : hint_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float effect_strength : hint_range(0, 1) = 0.5;
uniform float effect_offset : hint_range(-0.7, 0.7) = 0;
uniform float rotation : hint_range(-90, 90) = 0;
uniform float width : hint_range(0, 1) = 0.2;
uniform float softness : hint_range(0, 1) = 0.5;

void fragment() {
	float a, b, c, powsum;
	if (rotation < 45f && rotation > -45f) {
		a = 1.0;
		b = tan(rotation);
		powsum = (b * b) + 1.0f;
		c = -0.5f * b - (effect_offset) * powsum;
	}
	float d = abs(a * UV.x + b * UV.y + c) / sqrt(powsum);
	float edge = (1.0 - softness) * width;
	if ( d < edge) {
		vec4 color = texture(TEXTURE, UV);
		COLOR = effect_color * effect_strength + color;
		COLOR.a = color.a;
	} else if (d > width) {
		COLOR = texture(TEXTURE, UV);
	} else {
		vec4 color = texture(TEXTURE, UV);
		COLOR = (width - d) / (width - edge) * effect_color * effect_strength + color;
		COLOR.a = color.a;
	} 
}