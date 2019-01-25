attribute vec3 a_Position;
attribute vec2 a_UV;
attribute vec3 a_Normal;

uniform mat4 u_ModelViewMatrix;
uniform mat4 u_ProjectionMatrix;
uniform mat3 u_NormalMatrix;
uniform vec3 u_AmbientColor;
uniform vec3 u_LightingDirection;
uniform vec3 u_DirectionalColor;
uniform bool u_UseLighting;

varying vec2 v_TextureCoord;
varying vec3 v_LightWeighting;

void main(void) {
  gl_Position = u_ProjectionMatrix * u_ModelViewMatrix * vec4(a_Position, 1.0);
  v_TextureCoord = a_UV;
  if(!u_UseLighting)
  {
     v_LightWeighting = vec3(1.0, 1.0, 1.0);
  } else
  {
     vec3 transformedNormal = u_NormalMatrix * a_Normal;
     float directionalLightWeighting = max(dot(transformedNormal, u_LightingDirection), 0.0);
     v_LightWeighting = u_AmbientColor + u_DirectionalColor*directionalLightWeighting;
  }
}