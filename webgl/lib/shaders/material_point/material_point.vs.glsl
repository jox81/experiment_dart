attribute vec3 a_Position;

//#ifdef USE_COLOR_UNIFORM
uniform vec4 uColor;
//#else
//attribute vec4 aVertexColor;
//#endif

uniform float pointSize;
uniform mat4 uModelViewMatrix;
uniform mat4 uProjectionMatrix;

varying vec4 vPointColor;

void main(void) {

    gl_Position = uProjectionMatrix * uModelViewMatrix * vec4(a_Position, 1.0);
    gl_PointSize = pointSize;

//    #ifdef USE_COLOR_UNIFORM
    vPointColor = uColor;
//    #else
//    vPointColor = aVertexColor;
//    #endif
}