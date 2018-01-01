attribute vec4 a_Position;
attribute vec2 a_UV;

uniform mat4 u_ModelViewMatrix;
uniform mat4 u_ProjectionMatrix;
uniform mat4 u_TextureMatrix;

varying vec2 v_TextureCoord;

void main(void) {
  gl_Position = u_ProjectionMatrix * u_ModelViewMatrix * a_Position;
  v_TextureCoord = (u_TextureMatrix * vec4(a_UV, 0, 1)).xy;
}