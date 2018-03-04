#version 120

//geometry
attribute vec3 a_Position;
attribute vec3 a_Normal;
attribute vec3 a_Tangent;
attribute vec4 a_Color;
attribute vec2 a_UV;

//matrices
uniform mat4 u_ModelViewMatrix;
uniform mat4 u_ProjectionMatrix;
uniform mat4 u_NormalMatrix;

//lights
uniform vec3 u_LightPosition;

//varyings
varying vec2 v_TextureCoord;
varying vec3 v_TangentLightDir;
varying vec3 v_TangentEyeDir;

void main(void) {
    //Transformed vertex position
    vec4 vertex = u_ModelViewMatrix * vec4(a_Position, 1.0);

    //Transformed normal position
    vec3 normal = vec3(uNMatrix * vec4(a_Normal, 1.0));
    vec3 tangent = vec3(uNMatrix * vec4(aVertexTangent, 1.0));
    vec3 bitangent = cross(normal, tangent);

    mat3 tbnMatrix = mat3(
        tangent.x, bitangent.x, normal.x,
        tangent.y, bitangent.y, normal.y,
        tangent.z, bitangent.z, normal.z
    );

    //light direction, from light position to vertex
    vec3 lightDirection = u_LightPosition - vertex.xyz;

    //eye direction, from camera position to vertex
    vec3 eyeDirection = -vertex.xyz;

    //Final vertex position
    gl_Position = u_ProjectionMatrix * u_ModelViewMatrix * vec4(a_Position, 1.0);
    v_TextureCoord = a_UV;
    v_TangentLightDir = lightDirection * tbnMatrix;
    v_TangentEyeDir = eyeDirection * tbnMatrix;
}