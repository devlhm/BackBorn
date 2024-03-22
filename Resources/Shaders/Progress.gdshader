shader_type canvas_item;

uniform float progress : hint_range(0,1);
uniform vec2 fill_direction;
uniform vec4 unfilled_color : source_color;
uniform vec4 filled_color : source_color;

void fragment() {
	
	if(fill_direction == vec2(1,0)) {
		COLOR.rgba = UV.x <= progress ? filled_color * COLOR.a : unfilled_color * COLOR.a;
	} else if(fill_direction == vec2(-1,0)) {
		COLOR.rgba = UV.x >= progress ? filled_color * COLOR.a : unfilled_color * COLOR.a;
	} else if(fill_direction == vec2(0,1)) {
		COLOR.rgba = UV.y <= progress ? filled_color * COLOR.a : unfilled_color * COLOR.a;
	} else if(fill_direction == vec2(0,-1)) {
		COLOR.rgba = UV.y >= progress ? filled_color * COLOR.a : unfilled_color * COLOR.a;
	}
}