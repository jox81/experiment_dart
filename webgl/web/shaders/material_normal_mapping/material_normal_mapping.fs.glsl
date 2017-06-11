#version 120
precision highp float;

//geometry
uniform vec4 uMaterialDiffuse;
uniform vec4 uMaterialAmbient;

uniform vec4 uLightAmbient;
uniform vec4 uLightDiffuse;

//samplers
uniform sampler2D uSampler;
uniform sampler2D uNormalSampler;

//varying
varying vec4 vColor;
varying vec2 vTextureCoord;
varying vec3 vTangentLightDir;
varying vec3 vTangentEyeDir;

void main(void)
{
    // Unpack tangent-space normal from texture
    vec3 normal = normalize(2.0 * (texture2D(uNormalSampler, vTextureCoord).rgb - 0.5));

    // Normalize the light direction and determine how much light is hitting this point
    vec3 lightDirection = normalize(vTangentLightDir);
    float lambertTerm = max(dot(normal,lightDirection),0.20);

    // Calculate Specular level
    vec3 eyeDirection = normalize(vTangentEyeDir);
    vec3 reflectDir = reflect(-lightDirection, normal);
    float Is = pow(clamp(dot(reflectDir, eyeDirection), 0.0, 1.0), 8.0);

    // Combine lighting and material colors
    vec4 Ia = uLightAmbient * uMaterialAmbient;
    vec4 Id = uLightDiffuse * uMaterialDiffuse * texture2D(uSampler, vTextureCoord) * lambertTerm;

    gl_FragColor = Ia + Id + Is;
}