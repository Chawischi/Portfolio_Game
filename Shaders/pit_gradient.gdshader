shader_type canvas_item;

uniform vec4 gradient_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float fade_start : hint_range(0.0, 1.0) = 0.0;

void fragment(){
	float alpha = smoothstep(fade_start,  1.0, UV.y);
	COLOR = vec4(gradient_color.rgb, alpha * gradient_color.a);
}