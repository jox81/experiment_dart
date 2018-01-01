precision mediump float;

attribute vec3 a_Position;
attribute vec2 a_UV;
attribute vec3 a_Normal;

uniform mat4 u_WorldMatrix;
uniform mat4 u_ViewMatrix;
uniform mat4 u_ProjectionMatrix;

varying vec2 v_FragTexCoord;
varying vec3 v_FragNormal;

void main()
{
  v_FragTexCoord = a_UV;
  v_FragNormal = (u_WorldMatrix * vec4(a_Normal, 0.0)).xyz;

  gl_Position = u_ProjectionMatrix * u_ViewMatrix * u_WorldMatrix * vec4(a_Position, 1.0);
}