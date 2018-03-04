attribute vec4 a_Position;

//vertex normal in the model space
attribute vec3 a_Normal;

uniform mat4 u_ModelMatrix;
uniform mat4 u_ViewMatrix;
uniform mat4 u_ProjectionMatrix;
uniform mat4 u_MVPMatrix;

uniform mat3 u_NormalMatrix;

//user supplied light position
uniform vec3 u_LightPos;

varying vec3 ecPosition;  //vertex position in the eye coordinates (view space)
varying vec3 ecNormal;    //normal in the eye coordinates (view space)
varying vec3 ecLightPos;  //light position in the eye coordinates (view space)

void main(void) {
  //transform vertex into the eye space
  vec4 pos = u_ViewMatrix * u_ModelMatrix * a_Position;

  ecPosition = pos.xyz;
  ecNormal = u_NormalMatrix * a_Normal;
  ecLightPos = vec3(u_ViewMatrix * u_ModelMatrix * vec4(u_LightPos, 1.0));

  //project the vertex, the rest is handled by WebGL
  gl_Position = u_ProjectionMatrix * pos;
}