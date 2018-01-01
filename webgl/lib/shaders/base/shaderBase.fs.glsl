precision mediump float;

uniform vec3 u_Color;

void main(void) {
    gl_FragColor = vec4(u_Color, 1.0);
}