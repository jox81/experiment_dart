attribute vec4 a_Position;

//vertex normal in the model space
attribute vec3 a_Normal;

uniform mat4 u_ModelViewMatrix;
uniform mat4 u_ProjectionMatrix;

uniform mat3 u_NormalMatrix;

//user supplied light position
uniform vec3 u_LightPos;

varying vec3 v_ecPosition;  //vertex position in the eye coordinates (view space)
varying vec3 v_ecNormal;    //normal in the eye coordinates (view space)
varying vec3 v_ecLightPos;  //light position in the eye coordinates (view space)

void main(void) {
  //transform vertex into the eye space
  vec4 pos = u_ModelViewMatrix * a_Position;

  ecPosition = pos.xyz;
  ecNormal = u_NormalMatrix * a_Normal;
  v_ecLightPos = vec3(u_ModelViewMatrix * vec4(u_LightPos, 1.0));

  //project the vertex, the rest is handled by WebGL
  gl_Position = u_ProjectionMatrix * pos;
}