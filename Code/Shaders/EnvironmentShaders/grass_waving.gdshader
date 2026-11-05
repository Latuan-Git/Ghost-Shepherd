shader_type spatial;
render_mode cull_disabled, depth_draw_opaque, shadows_disabled;

uniform sampler2D grass_texture : source_color;

uniform float sway_speed_x = 1.25;
uniform float sway_speed_z = 0.45;
uniform float max_angle_x = 0.15; 
uniform float max_angle_z = 0.25; 
uniform float blade_height = 1.0;

mat3 rot_x(float a) {
	float c = cos(a);
	float s = sin(a);
	return mat3(
		vec3(1.0, 0.0, 0.0),
		vec3(0.0, c, s),
		vec3(0.0, -s, c)
	);
}

mat3 rot_z(float a) {
	float c = cos(a);
	float s = sin(a);
	return mat3(
		vec3(c, s, 0.0),
		vec3(-s, c, 0.0),
		vec3(0.0, 0.0, 1.0)
	);
}

void vertex() {
	float bend = 1.0 - UV.y;
	vec3 world_pos = NODE_POSITION_WORLD;
	float phase_x = world_pos.x + world_pos.z;
	float phase_z = world_pos.z - world_pos.x;

	float angle_x = sin(TIME * sway_speed_x + phase_x) * max_angle_x * bend;
	float angle_z = cos(TIME * sway_speed_z + phase_z) * max_angle_z * bend;

	mat3 rot = rot_z(angle_z) * rot_x(angle_x);
	VERTEX = rot * VERTEX;
	NORMAL = rot * vec3(0.0, 1.0, 0.0);
}

void fragment() {
	vec4 tex = texture(grass_texture, UV);
	ALBEDO = tex.rgb;
	ALPHA = tex.a;
	
//	NORMAL = FRONT_FACING ? NORMAL : -NORMAL;
}

void light() {
	float ndotl = abs(dot(NORMAL, LIGHT));
	DIFFUSE_LIGHT += ndotl * ATTENUATION * LIGHT_COLOR / PI;
}