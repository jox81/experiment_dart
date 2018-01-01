#version 120
precision highp float;

//geometry
uniform vec4 u_MaterialDiffuse;
uniform vec4 u_MaterialAmbient;

uniform vec4 u_LightAmbient;
uniform vec4 u_LightDiffuse;

//samplers
uniform sampler2D u_Sampler;
uniform sampler2D u_NormalSampler;

//varying
varying vec4 v_Color;
varying vec2 v_TextureCoord;
varying vec3 v_TangentLightDir;
varying vec3 v_TangentEyeDir;

void main(void)
{
    // Unpack tangent-space normal from texture
    vec3 normal = normalize(2.0 * (texture2D(u_NormalSampler, v_TextureCoord).rgb - 0.5));

    // Normalize the light direction and determine how much light is hitting this point
    vec3 lightDirection = normalize(v_TangentLightDir);
    float lambertTerm = max(dot(normal,lightDirection),0.20);

    // Calculate Specular level
    vec3 eyeDirection = normalize(v_TangentEyeDir);
    vec3 reflectDir = reflect(-lightDirection, normal);
    float Is = pow(clamp(dot(reflectDir, eyeDirection), 0.0, 1.0), 8.0);

    // Combine lighting and material colors
    vec4 Ia = u_LightAmbient * uMaterialAmbient;
    vec4 Id = u_LightDiffuse * u_MaterialDiffuse * texture2D(u_Sampler, v_TextureCoord) * lambertTerm;

    gl_FragColor = Ia + Id + Is;
}