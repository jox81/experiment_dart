attribute vec3 a_Position;

//#ifdef USE_COLOR_UNIFORM
uniform vec4 u_Color;
//#else
//attribute vec4 aVertexColor;
//#endif

uniform float u_PointSize;
uniform mat4 u_ModelViewMatrix;
uniform mat4 u_ProjectionMatrix;

varying vec4 v_PointColor;

void main(void) {

    gl_Position = u_ProjectionMatrix * u_ModelViewMatrix * vec4(a_Position, 1.0);
    gl_PointSize = u_PointSize;

//    #ifdef USE_COLOR_UNIFORM
    v_PointColor = u_Color;
//    #else
//    v_PointColor = aVertexColor;
//    #endif
}