precision mediump float;

attribute vec4 aVertexPosition;
attribute vec3 aNormal;

uniform mat4 uProjectionMatrix;
uniform mat4 uViewMatrix;
uniform mat4 uModelMatrix;
uniform mat3 uNormalMatrix;

varying vec3 ecPosition;
varying vec3 ecNormal;

void main() {
    gl_Position = uProjectionMatrix * uViewMatrix * uModelMatrix * aVertexPosition;

    //position du vertex en coordonée de vue
    ecPosition = vec3(uViewMatrix * uModelMatrix * aVertexPosition);

    //norm en coordonée de vue
    ecNormal = uNormalMatrix * aNormal;
}