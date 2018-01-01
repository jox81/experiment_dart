attribute vec3 a_Position;
attribute vec2 a_UV;

uniform mat4 u_ModelViewMatrix;
uniform mat4 u_ProjectionMatrix;

varying vec2 v_TextureCoord;

void main(void) {
    gl_Position = u_ProjectionMatrix * u_ModelViewMatrix * vec4(a_Position, 1.0);
    v_TextureCoord = a_UV;
}