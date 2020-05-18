precision mediump float;

attribute vec3 a_Position;

#ifdef HAS_NORMALS
attribute vec4 a_Normal;
#endif
#ifdef HAS_UV
attribute vec2 a_UV;
#endif

uniform mat4 u_ModelMatrix;
uniform mat4 u_ViewMatrix;
uniform mat4 u_ProjectionMatrix;

varying vec3 v_Position;

#ifdef HAS_NORMALS
varying vec3 v_Normal;
#endif
#ifdef HAS_UV
varying vec2 v_UV;
#endif

void main(void) {

    #ifdef USE_FLAT_POSITION
    gl_Position = vec4(a_Position, 1.0);
    #else
    gl_Position = u_ProjectionMatrix * u_ViewMatrix * u_ModelMatrix * vec4(a_Position, 1.0);
    #endif

    v_Position = a_Position;

    #ifdef HAS_NORMALS
    v_Normal = normalize(vec3(u_ModelMatrix * vec4(a_Normal.xyz, 0.0)));
    #endif

    #ifdef HAS_UV
    v_UV = a_UV;
    #endif
}