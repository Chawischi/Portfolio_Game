shader_type canvas_item;

uniform vec2 center = vec2(0.5, 0.5);
uniform float radius : hint_range(0.0, 2.0) = 1.5;
uniform float aspect = 1.2228;
uniform float edge_softness: hint_range(0.0, 0.2) = 0.03;

void fragment(){
	vec2 uv = UV;
	uv.x *= aspect;
	
	vec2 c = center;
	c.x *= aspect;
	
	float dist = distance(uv, c);
	float alpha = smoothstep(radius - edge_softness, radius + edge_softness, dist);
	
	COLOR = vec4(0.0, 0.0, 0.0, alpha);
}