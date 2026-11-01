shader_type canvas_item;

uniform float onoff : hint_range(0.0, 1.0); // toggle
uniform float amplitude : hint_range(0.0, 500.0) = 10.0; // max height
uniform float speed : hint_range(0.0, 10.0) = 1.0; // speed

void vertex(){
	VERTEX.y += amplitude * sin(TIME*speed) * onoff;
}
