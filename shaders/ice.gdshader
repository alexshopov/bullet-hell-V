shader_type canvas_item;

uniform sampler2D noise_texture: hint_default_black;

void fragment() {
	vec4 color_out = vec4(1.0, 0.0, 1.0, 1.0);
	
	vec4 noise_color = texture(noise_texture, UV);
	color_out *= noise_color;
	color_out.a = 0.25;
	
	COLOR = color_out;
}
