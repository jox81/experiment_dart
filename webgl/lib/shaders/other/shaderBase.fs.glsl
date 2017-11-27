#version 120

precision mediump float;

vec3 color;

void main(void) {
    color = vec3(1.0, 1.0, 1.0);
    gl_FragColor = vec4(color, 1.0);
}