shader_type canvas_item;

uniform vec4 color : source_color = vec4(1.0);
uniform vec3 threshold;

void fragment() {
	vec3 closeness = smoothstep(vec3(0.0), vec3(1.0), COLOR.rgb);
	if(all(greaterThan(closeness, threshold)) && COLOR.a - 0.0001 >= 0.0){
		COLOR = vec4(color.rgb, COLOR.a);
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
