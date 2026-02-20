shader_type canvas_item;

uniform float progress : hint_range(0, 1) = 0.0;
uniform float diamond_size = 32.0;

void fragment() {
	float xFraction = fract(FRAGCOORD.x / diamond_size);
	float yFraction = fract(FRAGCOORD.y / diamond_size);
	float xDistance = abs(xFraction - 0.5);
	float yDistance = abs(yFraction - 0.5);
	if (xDistance + yDistance + UV.y * 0.5 > progress * 2.0) {
		discard;
	}
	COLOR = vec4(0, 0, 0, 1);
}
