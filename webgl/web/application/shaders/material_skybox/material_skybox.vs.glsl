attribute vec2 attribute_vertex_position;

uniform vec3 uniform_camera_up;
uniform vec3 uniform_camera_right;
uniform vec3 uniform_camera_dir;
uniform float uniform_camera_near;

varying vec3 varying_pixel_position;

void main()
{
	gl_Position = vec4(attribute_vertex_position, 0.0, 1.0);
	varying_pixel_position =
		attribute_vertex_position[0] * uniform_camera_right +
		attribute_vertex_position[1] * uniform_camera_up +
		uniform_camera_near * uniform_camera_dir;
}