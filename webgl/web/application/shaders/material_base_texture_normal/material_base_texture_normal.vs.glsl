attribute vec3 aVertexPosition;
attribute vec2 aTextureCoord;
attribute vec3 aVertexNormal;

uniform mat4 uModelViewMatrix;
uniform mat4 uProjectionMatrix;
uniform mat3 uNormalMatrix;
uniform vec3 uAmbientColor;
uniform vec3 uLightingDirection;
uniform vec3 uDirectionalColor;
uniform bool uUseLighting;

varying vec2 vTextureCoord;
varying vec3 vLightWeighting;

void main(void) {
  gl_Position = uProjectionMatrix * uModelViewMatrix * vec4(aVertexPosition, 1.0);
  vTextureCoord = aTextureCoord;
  if(!uUseLighting)
  {
     vLightWeighting = vec3(1.0, 1.0, 1.0);
  } else
  {
     vec3 transformedNormal = uNormalMatrix * aVertexNormal;
     float directionalLightWeighting = max(dot(transformedNormal, uLightingDirection), 0.0);
     vLightWeighting = uAmbientColor + uDirectionalColor*directionalLightWeighting;
  }
}