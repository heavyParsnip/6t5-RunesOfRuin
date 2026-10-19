shader_type canvas_item;

uniform float onoff : hint_range(0.0, 1.0); // toggle
uniform float amplitude : hint_range(0.0, 500.0) = 10.0; // max height
uniform float speed : hint_range(0.0, 10.0) = 1.0; // speed

void fragment() {
	float offset_Y = amplitude * sin(TIME * speed) * onoff;
	COLOR = texture(TEXTURE, UV + vec2(0.0, offset_Y) / (500.0));
}
