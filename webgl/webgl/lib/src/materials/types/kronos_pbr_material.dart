import 'dart:typed_data';
import 'package:vector_math/vector_math.dart';
import 'package:webgl/lights.dart';
import 'package:webgl/src/materials/material.dart';
import 'package:webgl/src/introspection/introspection.dart';
import 'package:webgl/src/shaders/shader_source.dart';
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';
import 'package:webgl/src/webgl_objects/webgl_program.dart';
import 'dart:web_gl' as webgl;

@reflector
class KronosPRBMaterial extends Material {
  ShaderSource get shaderSource => ShaderSource.kronosGltfPBRTest;

  final bool hasNormalAttribut;
  final bool hasTangentAttribut;
  final bool hasUVAttribut;
  final bool hasColorAttribut;
  final bool hasLODExtension;

  bool get useLod => true;

  KronosPRBMaterial(this.hasNormalAttribut, this.hasTangentAttribut,
      this.hasUVAttribut, this.hasColorAttribut, this.hasLODExtension);

  //> BaseColor
  webgl.Texture baseColorMap;
  bool get hasBaseColorMap => baseColorMap != null;
  int _baseColorSamplerSlot;
  int get baseColorSamplerSlot => _baseColorSamplerSlot;
  set baseColorSamplerSlot(int value) {
    _baseColorSamplerSlot = value;
  }

  List<double> _baseColorFactor;
  List<double> get baseColorFactor => _baseColorFactor;
  set baseColorFactor(List<double> value) {
    _baseColorFactor = value;
  }

  //> Normals Map
  webgl.Texture normalMap;
  bool get hasNormalMap => normalMap != null;
  int _normalSamplerSlot;
  int get normalSamplerSlot => _normalSamplerSlot;
  set normalSamplerSlot(int value) {
    _normalSamplerSlot = value;
  }

  double _normalScale;
  double get normalScale => _normalScale;
  set normalScale(double value) {
    _normalScale = value;
  }

  //> Emissive Map
  webgl.Texture emissiveMap;
  bool get hasEmissiveMap => emissiveMap != null;
  int _emissiveSamplerSlot;
  int get emissiveSamplerSlot => _emissiveSamplerSlot;
  set emissiveSamplerSlot(int value) {
    _emissiveSamplerSlot = value;
  }

  List<double> _emissiveFactor;
  List<double> get emissiveFactor => _emissiveFactor;
  set emissiveFactor(List<double> value) {
    _emissiveFactor = value;
  }

  //> Occlusion Map
  webgl.Texture occlusionMap;
  bool get hasOcclusionMap => occlusionMap != null;
  int _occlusionSamplerSlot;
  int get occlusionSamplerSlot => _occlusionSamplerSlot;
  set occlusionSamplerSlot(int value) {
    _occlusionSamplerSlot = value;
  }

  double _occlusionStrength;
  double get occlusionStrength => _occlusionStrength;
  set occlusionStrength(double value) {
    _occlusionStrength = value;
  }

  //> MetallRoughness Map
  webgl.Texture metallicRoughnessMap;
  bool get hasMetallicRoughnessMap => metallicRoughnessMap != null;
  int _metallicRoughnessSamplerSlot;
  int get metallicRoughnessSamplerSlot => _metallicRoughnessSamplerSlot;
  set metallicRoughnessSamplerSlot(int value) {
    _metallicRoughnessSamplerSlot = value;
  }

  double _roughness;
  set roughness(double value) {
    _roughness = value;
  }

  double get roughness => _roughness;

  double _metallic;
  set metallic(double value) {
    _metallic = value;
  }

  double get metallic => _metallic;

  Map<String, bool> getDefines() {
    //debugLog.logCurrentFunction();

    Map<String, bool> defines = new Map();

    defines['USE_IBL'] = useLod;
    defines['USE_TEX_LOD'] = hasLODExtension;

    //primitives infos
    defines['HAS_NORMALS'] = hasNormalAttribut;
    defines['HAS_TANGENTS'] = hasTangentAttribut;
    defines['HAS_UV'] = hasUVAttribut;
    defines['HAS_COLORS'] = hasColorAttribut;

    //Material base infos
    defines['HAS_NORMALMAP'] = hasNormalMap;
    defines['HAS_EMISSIVEMAP'] = hasEmissiveMap;
    defines['HAS_OCCLUSIONMAP'] = hasOcclusionMap;

    //Material pbr infos
    defines['HAS_BASECOLORMAP'] = hasBaseColorMap;
    defines['HAS_METALROUGHNESSMAP'] = hasMetallicRoughnessMap;

    //debug jpu
    defines['DEBUG_VS'] = false;
    defines['DEBUG_FS'] = false;

    return defines;
  }

  Float32List vecData2 = new Float32List(2);
  Float32List vecData3 = new Float32List(3);
  Float32List vecData4 = new Float32List(4);
  Float32List matrixData4 = new Float32List(16);

  void setUniforms(
      WebGLProgram program,
      Matrix4 modelMatrix,
      Matrix4 viewMatrix,
      Matrix4 projectionMatrix,
      Vector3 cameraPosition,
      DirectionalLight directionalLight) {
    //debugLog.logCurrentFunction();

    for (int i = 0; i < matrixData4.length; ++i) {
      matrixData4[i] = modelMatrix[i];
    }
    setUniform(
        program, 'u_ModelMatrix', ShaderVariableType.FLOAT_MAT4, matrixData4);

    setUniform(
        program, 'u_PVMatrix', ShaderVariableType.FLOAT_MAT4, pvMatrix.storage);

    // > camera
    setUniform(
        program,
        'u_Camera',
        ShaderVariableType.FLOAT_VEC3,
        vecData3
          ..setAll(
              0, [cameraPosition[0], cameraPosition[1], cameraPosition[2]]));

    // > Light
    setUniform(
        program,
        'u_LightDirection',
        ShaderVariableType.FLOAT_VEC3,
        vecData3
          ..setAll(0, [
            directionalLight.direction[0],
            directionalLight.direction[1],
            directionalLight.direction[2]
          ]));

    setUniform(
        program,
        'u_LightColor',
        ShaderVariableType.FLOAT_VEC3,
        vecData3
          ..setAll(0, [
            directionalLight.color[0],
            directionalLight.color[1],
            directionalLight.color[2]
          ]));

    // > Material base

    if (useLod) {
      setUniform(program, 'u_brdfLUT', ShaderVariableType.SAMPLER_2D, 0);
      setUniform(
          program, 'u_DiffuseEnvSampler', ShaderVariableType.SAMPLER_CUBE, 1);
      setUniform(
          program, 'u_SpecularEnvSampler', ShaderVariableType.SAMPLER_CUBE, 2);
    }

    if (hasBaseColorMap) {
//      gl.activeTexture(baseColorSamplerSlot);
//      gl.bindTexture(webgl.RenderingContext.TEXTURE_2D, baseColorMap);
      setUniform(program, 'u_BaseColorSampler', ShaderVariableType.SAMPLER_2D,
          baseColorSamplerSlot);
    }

    if (hasNormalMap) {
      setUniform(program, 'u_NormalSampler', ShaderVariableType.SAMPLER_2D,
          normalSamplerSlot);
      setUniform(
          program, 'u_NormalScale', ShaderVariableType.FLOAT, normalScale);
    }

    if (hasEmissiveMap) {
      setUniform(program, 'u_EmissiveSampler', ShaderVariableType.SAMPLER_2D,
          emissiveSamplerSlot);
      setUniform(
          program,
          'u_EmissiveFactor',
          ShaderVariableType.FLOAT_VEC3,
          vecData3
            ..setAll(
                0, [emissiveFactor[0], emissiveFactor[1], emissiveFactor[2]]));
    }

    if (hasOcclusionMap) {
      setUniform(program, 'u_OcclusionSampler', ShaderVariableType.SAMPLER_2D,
          occlusionSamplerSlot);

      setUniform(program, 'u_OcclusionStrength', ShaderVariableType.FLOAT,
          occlusionStrength);
    }

    if (hasMetallicRoughnessMap) {
      setUniform(program, 'u_MetallicRoughnessSampler',
          ShaderVariableType.SAMPLER_2D, metallicRoughnessSamplerSlot);
    }

    setUniform(
        program,
        'u_MetallicRoughnessValues',
        ShaderVariableType.FLOAT_VEC2,
        vecData2..setAll(0, [metallic, roughness]));

    setUniform(program, 'u_BaseColorFactor', ShaderVariableType.FLOAT_VEC4,
        baseColorFactor);

    // > Debug values => see in pbr fragment shader

    double specularReflectionMask = 0.0;
    double geometricOcclusionMask = 0.0;
    double microfacetDistributionMask = 0.0;
    double specularContributionMask = 0.0;
    setUniform(
        program,
        'u_ScaleFGDSpec',
        ShaderVariableType.FLOAT_VEC4,
        vecData4
          ..setAll(0, [
            specularReflectionMask,
            geometricOcclusionMask,
            microfacetDistributionMask,
            specularContributionMask
          ]));

    double diffuseContributionMask = 0.0;
    double colorMask = 0.0;
    double metallicMask = 0.0;
    double roughnessMask = 0.0;
    setUniform(
        program,
        'u_ScaleDiffBaseMR',
        ShaderVariableType.FLOAT_VEC4,
        vecData4
          ..setAll(0, [
            diffuseContributionMask,
            colorMask,
            metallicMask,
            roughnessMask
          ]));

    double diffuseIBLAmbient = 1.0;
    double specularIBLAmbient = 1.0;
    setUniform(program, 'u_ScaleIBLAmbient', ShaderVariableType.FLOAT_VEC4,
        vecData4..setAll(0, [diffuseIBLAmbient, specularIBLAmbient, 1.0, 1.0]));
  }
}