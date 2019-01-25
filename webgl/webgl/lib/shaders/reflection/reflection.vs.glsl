precision mediump float;

attribute vec4 a_Position;
attribute vec3 a_Normal;

uniform mat4 u_ModelViewMatrix;
uniform mat4 u_ProjectionMatrix;
uniform mat3 u_NormalMatrix;

varying vec3 v_ecPosition;
varying vec3 v_ecNormal;

void main() {
    vec4 mp;
    mp = u_ProjectionMatrix * u_ModelViewMatrix * a_Position;
    gl_Position = mp;

    //position du vertex en coordonée de vue
    vec3 ec;
    ec = vec3(u_ModelViewMatrix * a_Position);
    v_ecPosition = ec;

    //norm en coordonée de vue
    v_ecNormal = u_NormalMatrix * a_Normal;
}