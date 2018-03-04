precision mediump float;

uniform vec3 u_Color;

varying vec3 v_Position;

#ifdef HAS_NORMALS
varying vec3 v_Normal;
#endif
#ifdef HAS_UV
varying vec2 v_UV;
#endif

void main(void) {
    gl_FragColor = vec4(u_Color, 1.0);

#ifdef DEBUG_FS_POSITION
    gl_FragColor = vec4(v_Position, 1.0);
#endif
#ifdef DEBUG_FS_NORMALS
    gl_FragColor = vec4(normalize(v_Normal), 1.0);
#endif
#ifdef DEBUG_FS_UV
    gl_FragColor = vec4(vec3(v_UV,0.0), 1.0);// show  uv's
#endif

}