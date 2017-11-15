precision mediump float;

uniform vec3 u_Color;

varying vec3 v_Normal;
varying vec2 v_UV;

void main(void) {
//    gl_FragColor = vec4(u_Color, 1.0);
//    gl_FragColor = vec4(vec3(v_UV,0.0), 1.0);// show  uv's
    gl_FragColor = vec4(normalize(v_Normal), 1.0);

}