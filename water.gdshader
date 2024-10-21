//Shader code was followed by tutorial in link below
//https://www.youtube.com/watch?v=7L6ZUYj1hs8
shader_type spatial;
uniform vec3 albedo : source_color;
uniform sampler2D water_noise;
uniform sampler2D water_noise2;
uniform vec2 wave_direction=vec2(2.0,0);
uniform vec2 wave_direction2=vec2(0.0,1.0);
uniform float time_scale : hint_range(0.0,.2,.005)=.025;
void fragment() {
	vec2 time =(TIME*wave_direction)*time_scale;
	vec2 time2=(TIME*wave_direction2)*time_scale;
	vec3 normal_blend=mix(texture(water_noise,UV+time).rgb,texture(water_noise2,UV+time2).rgb,.5);
	ALBEDO=albedo;
	NORMAL_MAP=normal_blend;
}
