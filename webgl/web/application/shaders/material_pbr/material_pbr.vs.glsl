attribute vec4 aVertexPosition;

//vertex normal in the model space
attribute vec3 aNormal;

uniform mat4 uMVMatrix;
uniform mat4 uPMatrix;

uniform mat3 uNormalMatrix;

//user supplied light position
uniform vec3 uLightPos;


varying vec3 ecPosition;  //vertex position in the eye coordinates (view space)
varying vec3 ecNormal;    //normal in the eye coordinates (view space)
varying vec3 ecLightPos;  //light position in the eye coordinates (view space)

void main(void) {
  //transform vertex into the eye space
  vec4 pos = uMVMatrix * aVertexPosition;

  ecPosition = pos.xyz;
  ecNormal = uNormalMatrix * aNormal;
  ecLightPos = vec3(uMVMatrix * vec4(uLightPos, 1.0));

  //project the vertex, the rest is handled by WebGL
  gl_Position = uPMatrix * pos;
}