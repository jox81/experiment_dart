//https://threejs.org/examples/webgl_postprocessing_sao.html (voir sourcecode)

attribute vec3 a_Position;

#ifdef HAS_UV
attribute vec2 a_UV;
#endif

uniform mat4 u_ModelViewMatrix;
uniform mat4 u_ProjectionMatrix;

varying vec2 v_UV;

void main() {
    #ifdef HAS_UV
     v_UV = a_UV;
    #else
     v_UV = vec2(0.0,0.0);
    #endif

    gl_Position = u_ProjectionMatrix * u_ModelViewMatrix * vec4( a_Position, 1.0 );
}
