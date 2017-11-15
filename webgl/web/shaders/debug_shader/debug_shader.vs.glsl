attribute vec3 a_Position;
attribute vec3 a_Normal;
attribute vec2 a_UV;

uniform mat4 u_ModelMatrix;
uniform mat4 u_ModelViewMatrix;
uniform mat4 u_ProjectionMatrix;

varying vec3 v_Normal;
varying vec2 v_UV;

void main(void) {
    gl_Position = u_ProjectionMatrix * u_ModelViewMatrix * vec4(a_Position, 1.0);
    v_Normal = normalize(vec3(u_ModelMatrix * vec4(a_Normal.xyz, 0.0)));
    v_UV = a_UV;
}