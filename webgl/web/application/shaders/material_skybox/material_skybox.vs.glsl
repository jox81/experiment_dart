attribute vec3 aVertexPosition;

uniform mat4 uProjectionMatrix;
uniform mat4 uViewMatrix;
uniform mat4 uModelMatrix;

varying vec3 vWorldCoordNormal;

void main()
{
    vWorldCoordNormal = aVertexPosition;
    gl_Position = uProjectionMatrix * uViewMatrix * uModelMatrix * vec4(aVertexPosition, 1.0);
}