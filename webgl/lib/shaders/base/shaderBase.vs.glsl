attribute vec3 a_Position;

uniform mat4 u_ModelViewMatrix;
uniform mat4 u_ProjectionMatrix;

void main(void) {
    gl_Position = u_ProjectionMatrix * u_ModelViewMatrix * vec4(a_Position, 1.0);
}