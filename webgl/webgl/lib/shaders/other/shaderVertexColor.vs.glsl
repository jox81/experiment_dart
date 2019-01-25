#version 120

precision mediump float;

attribute vec3 a_Position;
attribute vec3 a_Color;

uniform mat4 u_WorldMatrix;
uniform mat4 u_ViewMatrix;
uniform mat4 u_ProjectionMatrix;

varying vec3 fragColor;

void main()
{
  fragColor = a_Color;
  gl_Position = u_ProjectionMatrix * u_ViewMatrix * mWorld * vec4(a_Position, 1.0);
}
