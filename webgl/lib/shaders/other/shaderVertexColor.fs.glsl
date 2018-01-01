#version 120

precision mediump float;

varying vec3 v_fragColor;

void main()
{
  gl_v_fragColor = vec4(v_fragColor, 1.0);
}
