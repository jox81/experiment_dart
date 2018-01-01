attribute vec3 a_Position;
attribute vec4 a_Color;

uniform mat4 u_ModelViewMatrix;
uniform mat4 u_ProjectionMatrix;

varying vec4 v_Color;

void main(void) {
  gl_Position = u_ProjectionMatrix * u_ModelViewMatrix * vec4(a_Position, 1.0);
  v_Color = a_Color;
}