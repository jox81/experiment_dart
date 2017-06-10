precision mediump float;

attribute vec4 aVertexPosition;
attribute vec3 aNormal;

//uniform mat4 uModelMatrix;
//uniform mat4 uViewMatrix;

uniform mat4 uModelViewMatrix;

uniform mat4 uProjectionMatrix;
uniform mat3 uNormalMatrix;

varying vec3 ecPosition;
varying vec3 ecNormal;

void main() {

    vec4 mp;
    mp = uProjectionMatrix * uModelViewMatrix * aVertexPosition;
//    mp = uProjectionMatrix * uViewMatrix * uModelMatrix * aVertexPosition;
    gl_Position = mp;

    //position du vertex en coordonée de vue
    vec3 ec;
    ec = vec3(uModelViewMatrix * aVertexPosition);
//    ec = vec3(uViewMatrix * uModelMatrix * aVertexPosition);
    ecPosition = ec;

    //norm en coordonée de vue
    ecNormal = uNormalMatrix * aNormal;
}