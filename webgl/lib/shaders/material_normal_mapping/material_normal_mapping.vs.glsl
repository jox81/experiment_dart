#version 120

//geometry
attribute vec3 aVertexPosition;
attribute vec3 aVertexNormal;
attribute vec3 aVertexTangent;
attribute vec4 aVertexColor;
attribute vec2 aVertexTextureCoords;

//matrices
uniform mat4 uMVMatrix;
uniform mat4 uPMatrix;
uniform mat4 uNMatrix;

//lights
uniform vec3 uLightPosition;

//varyings
varying vec2 vTextureCoord;
varying vec3 vTangentLightDir;
varying vec3 vTangentEyeDir;

void main(void) {
    //Transformed vertex position
    vec4 vertex = uMVMatrix * vec4(aVertexPosition, 1.0);

    //Transformed normal position
    vec3 normal = vec3(uNMatrix * vec4(aVertexNormal, 1.0));
    vec3 tangent = vec3(uNMatrix * vec4(aVertexTangent, 1.0));
    vec3 bitangent = cross(normal, tangent);

    mat3 tbnMatrix = mat3(
        tangent.x, bitangent.x, normal.x,
        tangent.y, bitangent.y, normal.y,
        tangent.z, bitangent.z, normal.z
    );

    //light direction, from light position to vertex
    vec3 lightDirection = uLightPosition - vertex.xyz;

    //eye direction, from camera position to vertex
    vec3 eyeDirection = -vertex.xyz;

    //Final vertex position
    gl_Position = uPMatrix * uMVMatrix * vec4(aVertexPosition, 1.0);
    vTextureCoord = aVertexTextureCoords;
    vTangentLightDir = lightDirection * tbnMatrix;
    vTangentEyeDir = eyeDirection * tbnMatrix;
}