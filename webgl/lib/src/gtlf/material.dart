import 'package:gltf/gltf.dart' as glTF;
import 'package:webgl/src/gtlf/normal_texture_info.dart';
import 'package:webgl/src/gtlf/occlusion_texture_info.dart';
import 'package:webgl/src/gtlf/pbr_metallic_roughness.dart';
import 'package:webgl/src/gtlf/texture_info.dart';
import 'package:webgl/src/gtlf/utils_gltf.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';

class GLTFMaterial extends GLTFChildOfRootProperty {
  glTF.Material _gltfSource;
  glTF.Material get gltfSource => _gltfSource;

  int materialId;

  // Todo (jpu) : add other material objects
  final GLTFPbrMetallicRoughness pbrMetallicRoughness;
  final GLTFNormalTextureInfo normalTexture;
  final GLTFOcclusionTextureInfo occlusionTexture;
  final GLTFTextureInfo emissiveTexture;

  //>
  final List<double> emissiveFactor;
  final String alphaMode;
  final double alphaCutoff;
  final bool doubleSided;

  GLTFMaterial._(this._gltfSource, [String name])
      : this.pbrMetallicRoughness = new GLTFPbrMetallicRoughness.fromGltf(
      _gltfSource.pbrMetallicRoughness),
        this.normalTexture = _gltfSource.normalTexture != null
            ? new GLTFNormalTextureInfo.fromGltf(_gltfSource.normalTexture)
            : null,
        this.occlusionTexture = _gltfSource.occlusionTexture != null
            ? new GLTFOcclusionTextureInfo.fromGltf(
            _gltfSource.occlusionTexture)
            : null,
        this.emissiveTexture = _gltfSource.emissiveTexture != null
            ? new GLTFTextureInfo.fromGltf(_gltfSource.emissiveTexture)
            : null,
        this.emissiveFactor = _gltfSource.emissiveFactor,
        this.alphaMode = _gltfSource.alphaMode,
        this.alphaCutoff = _gltfSource.alphaCutoff,
        this.doubleSided = _gltfSource.doubleSided,
        super(_gltfSource.name);

  GLTFMaterial(
      this.pbrMetallicRoughness,
      this.normalTexture,
      this.occlusionTexture,
      this.emissiveTexture,
      this.emissiveFactor,
      this.alphaMode,
      this.alphaCutoff,
      this.doubleSided, [String name]):
        super(name);

  factory GLTFMaterial.fromGltf(glTF.Material gltfSource) {
    if (gltfSource == null) return null;
    return new GLTFMaterial._(gltfSource);
  }

  @override
  String toString() {
    return 'GLTFMaterial{pbrMetallicRoughness: $pbrMetallicRoughness, normalTexture: $normalTexture, occlusionTexture: $occlusionTexture, emissiveTexture: $emissiveTexture, emissiveFactor: $emissiveFactor, alphaMode: $alphaMode, alphaCutoff: $alphaCutoff, doubleSided: $doubleSided}';
  }
}

abstract class ShaderSourceInterface{
  String getSources(ShaderType shaderType);
  String get vertexSource => getSources(ShaderType.VERTEX_SHADER);
  String get fragmentSource => getSources(ShaderType.FRAGMENT_SHADER);
}

class DefaultShader extends ShaderSourceInterface{
  static DefaultShader _instance = new DefaultShader._();

  Map<ShaderType, String> _shaderSources = {
    ShaderType.VERTEX_SHADER :
      '''
        attribute vec3 aPosition;
        attribute vec3 aNormal;
  
        uniform mat4 uModelMatrix;
        uniform mat4 uViewMatrix;
        uniform mat4 uProjectionMatrix;
        
        void main(void) {
            vec3 v = aNormal;//not used actually;
            gl_Position = uProjectionMatrix * uViewMatrix * uModelMatrix * vec4(aPosition, 1.0);
        }
      ''',
    ShaderType.FRAGMENT_SHADER :
      '''
        void main() {
          gl_FragColor = vec4(0.5, 0.5, 0.5, 1.0);
        }
      '''
  };

  DefaultShader._();

  factory DefaultShader(){
    return _instance;
  }

  @override
  String getSources(ShaderType shaderType) => _shaderSources[shaderType];
}

class PBRShader extends ShaderSourceInterface{
  static PBRShader _instance = new PBRShader._();

  Map<ShaderType, String> _shaderSources = {
    ShaderType.VERTEX_SHADER :
    '''
 // From : https://raw.githubusercontent.com/KhronosGroup/glTF-WebGL-PBR/master/shaders/pbr-vert.glsl
//
attribute vec4 a_Position;
#ifdef HAS_NORMALS
attribute vec4 a_Normal;
#endif
#ifdef HAS_TANGENTS
attribute vec4 a_Tangent;
#endif
#ifdef HAS_UV
attribute vec2 a_UV;
#endif

uniform mat4 u_MVPMatrix;
uniform mat4 u_ModelMatrix;

varying vec3 v_Position;
varying vec2 v_UV;

#ifdef HAS_NORMALS
#ifdef HAS_TANGENTS
varying mat3 v_TBN;
#else
varying vec3 v_Normal;
#endif
#endif


void main()
{
  vec4 pos = u_ModelMatrix * a_Position;
  v_Position = vec3(pos.xyz) / pos.w;

  #ifdef HAS_NORMALS
  #ifdef HAS_TANGENTS
  vec3 normalW = normalize(vec3(u_ModelMatrix * vec4(a_Normal.xyz, 0.0)));
  vec3 tangentW = normalize(vec3(u_ModelMatrix * vec4(a_Tangent.xyz, 0.0)));
  vec3 bitangentW = cross(normalW, tangentW) * a_Tangent.w;
  v_TBN = mat3(tangentW, bitangentW, normalW);
  #else // HAS_TANGENTS != 1
  v_Normal = normalize(vec3(u_ModelMatrix * vec4(a_Normal.xyz, 0.0)));
  #endif
  #endif

  #ifdef HAS_UV
  v_UV = a_UV;
  #else
  v_UV = vec2(0.,0.);
  #endif

  gl_Position = u_MVPMatrix * a_Position; // needs w for proper perspective correction
}


    ''',
    ShaderType.FRAGMENT_SHADER :
    '''
        // From : https://github.com/KhronosGroup/glTF-WebGL-PBR/blob/master/shaders/pbr-frag.glsl
//
// This fragment shader defines a reference implementation for Physically Based Shading of
// a microfacet surface material defined by a glTF model.
//
// References:
// [1] Real Shading in Unreal Engine 4
//     http://blog.selfshadow.com/publications/s2013-shading-course/karis/s2013_pbs_epic_notes_v2.pdf
// [2] Physically Based Shading at Disney
//     http://blog.selfshadow.com/publications/s2012-shading-course/burley/s2012_pbs_disney_brdf_notes_v3.pdf
// [3] README.md - Environment Maps
//     https://github.com/KhronosGroup/glTF-WebGL-PBR/#environment-maps
// [4] "An Inexpensive BRDF Model for Physically based Rendering" by Christophe Schlick
//     https://www.cs.virginia.edu/~jdl/bib/appearance/analytic%20models/schlick94b.pdf
#extension GL_EXT_shader_texture_lod: enable
#extension GL_OES_standard_derivatives : enable

precision highp float;

uniform vec3 u_LightDirection;
uniform vec3 u_LightColor;

#ifdef USE_IBL
uniform samplerCube u_DiffuseEnvSampler;
uniform samplerCube u_SpecularEnvSampler;
uniform sampler2D u_brdfLUT;
#endif

#ifdef HAS_BASECOLORMAP
uniform sampler2D u_BaseColorSampler;
#endif
#ifdef HAS_NORMALMAP
uniform sampler2D u_NormalSampler;
uniform float u_NormalScale;
#endif
#ifdef HAS_EMISSIVEMAP
uniform sampler2D u_EmissiveSampler;
uniform vec3 u_EmissiveFactor;
#endif
#ifdef HAS_METALROUGHNESSMAP
uniform sampler2D u_MetallicRoughnessSampler;
#endif
#ifdef HAS_OCCLUSIONMAP
uniform sampler2D u_OcclusionSampler;
uniform float u_OcclusionStrength;
#endif

uniform vec2 u_MetallicRoughnessValues;
uniform vec4 u_BaseColorFactor;

uniform vec3 u_Camera;

// debugging flags used for shader output of intermediate PBR variables
uniform vec4 u_ScaleDiffBaseMR;
uniform vec4 u_ScaleFGDSpec;
uniform vec4 u_ScaleIBLAmbient;

varying vec3 v_Position;

varying vec2 v_UV;

#ifdef HAS_NORMALS
#ifdef HAS_TANGENTS
varying mat3 v_TBN;
#else
varying vec3 v_Normal;
#endif
#endif

// Encapsulate the various inputs used by the various functions in the shading equation
// We store values in this struct to simplify the integration of alternative implementations
// of the shading terms, outlined in the Readme.MD Appendix.
struct PBRInfo
{
    float NdotL;                  // cos angle between normal and light direction
    float NdotV;                  // cos angle between normal and view direction
    float NdotH;                  // cos angle between normal and half vector
    float LdotH;                  // cos angle between light direction and half vector
    float VdotH;                  // cos angle between view direction and half vector
    float perceptualRoughness;    // roughness value, as authored by the model creator (input to shader)
    float metalness;              // metallic value at the surface
    vec3 reflectance0;            // full reflectance color (normal incidence angle)
    vec3 reflectance90;           // reflectance color at grazing angle
    float alphaRoughness;         // roughness mapped to a more linear change in the roughness (proposed by [2])
    vec3 diffuseColor;            // color contribution from diffuse lighting
    vec3 specularColor;           // color contribution from specular lighting
};

const float M_PI = 3.141592653589793;
const float c_MinRoughness = 0.04;

// Find the normal for this fragment, pulling either from a predefined normal map
// or from the interpolated mesh normal and tangent attributes.
vec3 getNormal()
{
    // Retrieve the tangent space matrix
#ifndef HAS_TANGENTS
    vec3 pos_dx = dFdx(v_Position);
    vec3 pos_dy = dFdy(v_Position);
    vec3 tex_dx = dFdx(vec3(v_UV, 0.0));
    vec3 tex_dy = dFdy(vec3(v_UV, 0.0));
    vec3 t = (tex_dy.t * pos_dx - tex_dx.t * pos_dy) / (tex_dx.s * tex_dy.t - tex_dy.s * tex_dx.t);

#ifdef HAS_NORMALS
    vec3 ng = normalize(v_Normal);
#else
    vec3 ng = cross(pos_dx, pos_dy);
#endif

    t = normalize(t - ng * dot(ng, t));
    vec3 b = normalize(cross(ng, t));
    mat3 tbn = mat3(t, b, ng);
#else // HAS_TANGENTS
    mat3 tbn = v_TBN;
#endif

#ifdef HAS_NORMALMAP
    vec3 n = texture2D(u_NormalSampler, v_UV).rgb;
    n = normalize(tbn * ((2.0 * n - 1.0) * vec3(u_NormalScale, u_NormalScale, 1.0)));
#else
    vec3 n = tbn[2].xyz;
#endif

    return n;
}

// Calculation of the lighting contribution from an optional Image Based Light source.
// Precomputed Environment Maps are required uniform inputs and are computed as outlined in [1].
// See our README.md on Environment Maps [3] for additional discussion.
vec3 getIBLContribution(PBRInfo pbrInputs, vec3 n, vec3 reflection)
{
    float mipCount = 9.0; // resolution of 512x512
    float lod = (pbrInputs.perceptualRoughness * mipCount);
    // retrieve a scale and bias to F0. See [1], Figure 3
    vec3 brdf = texture2D(u_brdfLUT, vec2(pbrInputs.NdotV, 1.0 - pbrInputs.perceptualRoughness)).rgb;
    vec3 diffuseLight = textureCube(u_DiffuseEnvSampler, n).rgb;

#ifdef USE_TEX_LOD
    vec3 specularLight = textureCubeLodEXT(u_SpecularEnvSampler, reflection, lod).rgb;
#else
    vec3 specularLight = textureCube(u_SpecularEnvSampler, reflection).rgb;
#endif

    vec3 diffuse = diffuseLight * pbrInputs.diffuseColor;
    vec3 specular = specularLight * (pbrInputs.specularColor * brdf.x + brdf.y);

    // For presentation, this allows us to disable IBL terms
    diffuse *= u_ScaleIBLAmbient.x;
    specular *= u_ScaleIBLAmbient.y;

    return diffuse + specular;
}

// Basic Lambertian diffuse
// Implementation from Lambert's Photometria https://archive.org/details/lambertsphotome00lambgoog
// See also [1], Equation 1
vec3 diffuse(PBRInfo pbrInputs)
{
    return pbrInputs.diffuseColor / M_PI;
}

// The following equation models the Fresnel reflectance term of the spec equation (aka F())
// Implementation of fresnel from [4], Equation 15
vec3 specularReflection(PBRInfo pbrInputs)
{
    return pbrInputs.reflectance0 + (pbrInputs.reflectance90 - pbrInputs.reflectance0) * pow(clamp(1.0 - pbrInputs.VdotH, 0.0, 1.0), 5.0);
}

// This calculates the specular geometric attenuation (aka G()),
// where rougher material will reflect less light back to the viewer.
// This implementation is based on [1] Equation 4, and we adopt their modifications to
// alphaRoughness as input as originally proposed in [2].
float geometricOcclusion(PBRInfo pbrInputs)
{
    float NdotL = pbrInputs.NdotL;
    float NdotV = pbrInputs.NdotV;
    float r = pbrInputs.alphaRoughness;

    float attenuationL = 2.0 * NdotL / (NdotL + sqrt(r * r + (1.0 - r * r) * (NdotL * NdotL)));
    float attenuationV = 2.0 * NdotV / (NdotV + sqrt(r * r + (1.0 - r * r) * (NdotV * NdotV)));
    return attenuationL * attenuationV;
}

// The following equation(s) model the distribution of microfacet normals across the area being drawn (aka D())
// Implementation from "Average Irregularity Representation of a Roughened Surface for Ray Reflection" by T. S. Trowbridge, and K. P. Reitz
// Follows the distribution function recommended in the SIGGRAPH 2013 course notes from EPIC Games [1], Equation 3.
float microfacetDistribution(PBRInfo pbrInputs)
{
    float roughnessSq = pbrInputs.alphaRoughness * pbrInputs.alphaRoughness;
    float f = (pbrInputs.NdotH * roughnessSq - pbrInputs.NdotH) * pbrInputs.NdotH + 1.0;
    return roughnessSq / (M_PI * f * f);
}

void main()
{
    // Metallic and Roughness material properties are packed together
    // In glTF, these factors can be specified by fixed scalar values
    // or from a metallic-roughness map
    float perceptualRoughness = u_MetallicRoughnessValues.y;
    float metallic = u_MetallicRoughnessValues.x;
#ifdef HAS_METALROUGHNESSMAP
    // Roughness is stored in the 'g' channel, metallic is stored in the 'b' channel.
    // This layout intentionally reserves the 'r' channel for (optional) occlusion map data
    vec4 mrSample = texture2D(u_MetallicRoughnessSampler, v_UV);
    perceptualRoughness = mrSample.g * perceptualRoughness;
    metallic = mrSample.b * metallic;
#endif
    perceptualRoughness = clamp(perceptualRoughness, c_MinRoughness, 1.0);
    metallic = clamp(metallic, 0.0, 1.0);
    // Roughness is authored as perceptual roughness; as is convention,
    // convert to material roughness by squaring the perceptual roughness [2].
    float alphaRoughness = perceptualRoughness * perceptualRoughness;

    // The albedo may be defined from a base texture or a flat color
#ifdef HAS_BASECOLORMAP
    vec4 baseColor = texture2D(u_BaseColorSampler, v_UV) * u_BaseColorFactor;
#else
    vec4 baseColor = u_BaseColorFactor;
#endif

    vec3 f0 = vec3(0.04);
    vec3 diffuseColor = baseColor.rgb * (vec3(1.0) - f0);
    diffuseColor *= 1.0 - metallic;
    vec3 specularColor = mix(f0, baseColor.rgb, metallic);

    // Compute reflectance.
    float reflectance = max(max(specularColor.r, specularColor.g), specularColor.b);

    // For typical incident reflectance range (between 4% to 100%) set the grazing reflectance to 100% for typical fresnel effect.
    // For very low reflectance range on highly diffuse objects (below 4%), incrementally reduce grazing reflecance to 0%.
    float reflectance90 = clamp(reflectance * 25.0, 0.0, 1.0);
    vec3 specularEnvironmentR0 = specularColor.rgb;
    vec3 specularEnvironmentR90 = vec3(1.0, 1.0, 1.0) * reflectance90;

    vec3 n = getNormal();                             // normal at surface point
    vec3 v = normalize(u_Camera - v_Position);        // Vector from surface point to camera
    vec3 l = normalize(u_LightDirection);             // Vector from surface point to light
    vec3 h = normalize(l+v);                          // Half vector between both l and v
    vec3 reflection = -normalize(reflect(v, n));

    float NdotL = clamp(dot(n, l), 0.001, 1.0);
    float NdotV = abs(dot(n, v)) + 0.001;
    float NdotH = clamp(dot(n, h), 0.0, 1.0);
    float LdotH = clamp(dot(l, h), 0.0, 1.0);
    float VdotH = clamp(dot(v, h), 0.0, 1.0);

    PBRInfo pbrInputs = PBRInfo(
        NdotL,
        NdotV,
        NdotH,
        LdotH,
        VdotH,
        perceptualRoughness,
        metallic,
        specularEnvironmentR0,
        specularEnvironmentR90,
        alphaRoughness,
        diffuseColor,
        specularColor
    );

    // Calculate the shading terms for the microfacet specular shading model
    vec3 F = specularReflection(pbrInputs);
    float G = geometricOcclusion(pbrInputs);
    float D = microfacetDistribution(pbrInputs);

    // Calculation of analytical lighting contribution
    vec3 diffuseContrib = (1.0 - F) * diffuse(pbrInputs);
    vec3 specContrib = F * G * D / (4.0 * NdotL * NdotV);
    vec3 color = NdotL * u_LightColor * (diffuseContrib + specContrib);

    // Calculate lighting contribution from image based lighting source (IBL)
#ifdef USE_IBL
    color += getIBLContribution(pbrInputs, n, reflection);
#endif

    // Apply optional PBR terms for additional (optional) shading
#ifdef HAS_OCCLUSIONMAP
    float ao = texture2D(u_OcclusionSampler, v_UV).r;
    color = mix(color, color * ao, u_OcclusionStrength);
#endif

#ifdef HAS_EMISSIVEMAP
    vec3 emissive = texture2D(u_EmissiveSampler, v_UV).rgb * u_EmissiveFactor;
    color += emissive;
#endif

    // This section uses mix to override final color for reference app visualization
    // of various parameters in the lighting equation.
    color = mix(color, F, u_ScaleFGDSpec.x);
    color = mix(color, vec3(G), u_ScaleFGDSpec.y);
    color = mix(color, vec3(D), u_ScaleFGDSpec.z);
    color = mix(color, specContrib, u_ScaleFGDSpec.w);

    color = mix(color, diffuseContrib, u_ScaleDiffBaseMR.x);
    color = mix(color, baseColor.rgb, u_ScaleDiffBaseMR.y);
    color = mix(color, vec3(metallic), u_ScaleDiffBaseMR.z);
    color = mix(color, vec3(perceptualRoughness), u_ScaleDiffBaseMR.w);

    gl_FragColor = vec4(color, baseColor.a);
}
    '''
  };

  PBRShader._();

  factory PBRShader(){
    return _instance;
  }

  @override
  String getSources(ShaderType shaderType) => _shaderSources[shaderType];
}