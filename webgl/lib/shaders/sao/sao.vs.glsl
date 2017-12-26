//https://threejs.org/examples/webgl_postprocessing_sao.html (voir sourcecode)

#ifdef HAS_UV
attribute vec2 a_UV;
#endif

varying vec2 v_UV;

void main() {
#ifdef HAS_UV
    vUv = uv;
#else
    v_UV = vec2(0.0,0.0);
#endif
    gl_Position = projectionMatrix * modelViewMatrix * vec4( position, 1.0 );
}