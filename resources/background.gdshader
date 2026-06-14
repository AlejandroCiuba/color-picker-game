shader_type canvas_item;

uniform vec2 speed = vec2(4.0, 4.0);

uniform float square_width: hint_range(1.0, 64.0, 1.0) = 64.0;
uniform float square_height: hint_range(1.0, 64.0, 1.0) = 64.0;
uniform float rads = 0.5;

uniform vec4 checker_one: source_color;
uniform vec4 checker_two: source_color;

vec4 color(vec2 position, vec2 dim) {
	if(((int(position.x * 100.0) - (int(position.x * 100.0)) % int(dim.x)) / int(dim.x)) % 2 == 0) {
		if(((int(position.y * 100.0) - (int(position.y * 100.0)) % int(dim.y)) / int(dim.y)) % 2 == 0) {
			return checker_one;
		}
		return checker_two;
	}
	else {
		if(((int(position.y * 100.0) - (int(position.y * 100.0)) % int(dim.y)) / int(dim.y)) % 2 == 0) {
			return checker_two;
		}
	}
	return checker_one;
}

void vertex() {
	if (VERTEX.y > 0.0) {
		VERTEX.y += (UV.y * 562.0) - (562.0 / 2.0);
	}
}

void fragment() {
	vec2 sq = vec2(square_width, square_height);
	mat2 rot = mat2(vec2(cos(rads), -sin(rads)), vec2(sin(rads), cos(rads)));
	vec2 uv = UV;
	uv -= 0.5;
	uv *= rot;
	uv += 0.5;
	COLOR = color(vec2(uv.x - (TIME / (1.0 / speed.x)), uv.y + (TIME / (1.0 / speed.y))), vec2(sq));
}
