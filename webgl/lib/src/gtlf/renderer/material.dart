import 'dart:typed_data';
import 'package:gltf/gltf.dart' as glTF;
import 'package:vector_math/vector_math.dart';
import 'package:webgl/src/gtlf/mesh_primitive.dart';
import 'package:webgl/src/gtlf/normal_texture_info.dart';
import 'package:webgl/src/gtlf/occlusion_texture_info.dart';
import 'package:webgl/src/gtlf/pbr_metallic_roughness.dart';
import 'package:webgl/src/gtlf/renderer/renderer.dart';
import 'package:webgl/src/gtlf/texture_info.dart';
import 'package:webgl/src/gtlf/utils_gltf.dart';
import 'package:webgl/src/material/shader_source.dart';

import 'dart:web_gl' as webgl;
import 'package:webgl/src/webgl_objects/datas/webgl_enum.dart';

import 'package:webgl/src/utils/utils_debug.dart' as debug;
import 'package:webgl/src/webgl_objects/webgl_program.dart';

class GLTFPBRMaterial extends GLTFChildOfRootProperty {
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

  GLTFPBRMaterial._(this._gltfSource, [String name])
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

  GLTFPBRMaterial(
      this.pbrMetallicRoughness,
      this.normalTexture,
      this.occlusionTexture,
      this.emissiveTexture,
      this.emissiveFactor,
      this.alphaMode,
      this.alphaCutoff,
      this.doubleSided, [String name]):
        super(name);

  factory GLTFPBRMaterial.fromGltf(glTF.Material gltfSource) {
    if (gltfSource == null) return null;
    return new GLTFPBRMaterial._(gltfSource);
  }

  @override
  String toString() {
    return 'GLTFMaterial{pbrMetallicRoughness: $pbrMetallicRoughness, normalTexture: $normalTexture, occlusionTexture: $occlusionTexture, emissiveTexture: $emissiveTexture, emissiveFactor: $emissiveFactor, alphaMode: $alphaMode, alphaCutoff: $alphaCutoff, doubleSided: $doubleSided}';
  }
}


abstract class RawMaterial{
  ShaderSource get shaderSource;

  Map<String, bool> _defines;
  Map<String, bool> get defines => _defines ??= getDefines();

  ShaderSource _definedShaderSource;
  ShaderSource get definedShaderSource {
    //debugLog.logCurrentFunction();
    return _definedShaderSource ??= () {
      String shaderDefines = definesToString(defines);
      ShaderSource shaderSourceDefined = new ShaderSource()
        ..vsCode = shaderDefines + shaderSource.vsCode
        ..fsCode = shaderDefines + shaderSource.fsCode;
      return shaderSourceDefined;
    }();
  }

  /// This builds Preprocessors for glsl shader source
  String definesToString(Map<String, bool> defines) {
    //debugLog.logCurrentFunction();
    String outStr = '';
    if(defines == null) return outStr;

    for (String def in defines.keys) {
      if (defines[def]) {
        outStr += '#define $def ${defines[def]}\n';
      }
    }
    return outStr;
  }

  ///Defines glsl preprocessors
  Map<String, bool> getDefines();

  WebGLProgram getProgram() {
    //debugLog.logCurrentFunction();

    String vsSource = definedShaderSource.vsCode;
    String fsSource = definedShaderSource.fsCode;

    /// ShaderType type
    webgl.Shader createShader(
        int shaderType, String shaderSource) {
      //debugLog.logCurrentFunction();

      webgl.Shader shader = gl.createShader(shaderType);
      gl.shaderSource(shader, shaderSource);
      gl.compileShader(shader);

      if (debug.isDebug) {
        bool compiled =
        gl.getShaderParameter(shader, ShaderParameters.COMPILE_STATUS) as bool;
        if (!compiled) {
          String compilationLog = gl.getShaderInfoLog(shader);
          throw "Could not compile $shaderType shader:\n\n $compilationLog}";
        }
      }

      return shader;
    }

    webgl.Shader vertexShader = createShader(
        ShaderType.VERTEX_SHADER, vsSource);
    webgl.Shader fragmentShader = createShader(
        ShaderType.FRAGMENT_SHADER, fsSource);

    webgl.Program program = gl.createProgram();

    gl.attachShader(program, vertexShader);
    gl.attachShader(program, fragmentShader);
    gl.linkProgram(program);
    if (debug.isDebug) {
      if (gl.getProgramParameter(program, ProgramParameterGlEnum.LINK_STATUS)
      as bool ==
          false) {
        throw "Could not link the shader program! > ${gl.getProgramInfoLog(program)}";
      }
    }
    gl.validateProgram(program);
    if (debug.isDebug) {
      if (gl.getProgramParameter(program, ProgramParameterGlEnum.VALIDATE_STATUS)
      as bool ==
          false) {
        throw "Could not validate program! > ${gl.getProgramInfoLog(program)} > ${gl.getProgramInfoLog(program)}";
      }
    }

    return new WebGLProgram.fromWebGL(program);
  }

  ///Must be called after gl.useProgram
  void setUniforms(WebGLProgram program, Matrix4 modelMatrix, Matrix4 viewMatrix, Matrix4 projectionMatrix);

  /// ShaderVariableType componentType
  void _setUniform(WebGLProgram program, String uniformName, int componentType,
      TypedData data) {
    //debugLog.logCurrentFunction(uniformName);

    program.uniformLocations[uniformName] ??= gl.getUniformLocation(program.webGLProgram, uniformName);
    webgl.UniformLocation uniformLocation = program.uniformLocations[uniformName];

    bool transpose = false;

    switch (componentType) {
      case ShaderVariableType.SAMPLER_CUBE:
      case ShaderVariableType.SAMPLER_2D:
        gl.uniform1i(uniformLocation, (data as Int32List)[0]);
        break;
      case ShaderVariableType.FLOAT:
        gl.uniform1f(uniformLocation, (data as Float32List)[0]);
        break;
      case ShaderVariableType.FLOAT_VEC2:
        gl.uniform2fv(uniformLocation, data as Float32List);
        break;
      case ShaderVariableType.FLOAT_VEC3:
        gl.uniform3fv(uniformLocation, data as Float32List);
        break;
      case ShaderVariableType.FLOAT_VEC4:
        gl.uniform4fv(uniformLocation, data as Float32List);
        break;
      case ShaderVariableType.FLOAT_MAT3:
        gl.uniformMatrix3fv(uniformLocation, transpose, data);
        break;
      case ShaderVariableType.FLOAT_MAT4:
        gl.uniformMatrix4fv(uniformLocation, transpose, data);
        break;
      default:
        throw new Exception(
            'renderer setUnifrom exception : Trying to set a uniform for a not defined component type : $componentType');
        break;
    }
  }
}

class KronosPRBMaterial extends RawMaterial{
  final GLTFPBRMaterial baseMaterial;
  final GLTFMeshPrimitive primitive;

  KronosPRBMaterial(this.baseMaterial, this.primitive);

  ShaderSource get shaderSource => ShaderSource.sources['kronos_gltf_pbr_test'];

  Map<String, bool> getDefines() {
    //debugLog.logCurrentFunction();

    Map<String, bool> defines = new Map();

    defines['USE_IBL'] = true; // Todo (jpu) :
    defines['USE_TEX_LOD'] = false;//globalState.hasLODExtension != null; // Todo (jpu) :

    //primitives infos
    defines['HAS_NORMALS'] = primitive.attributes['NORMAL'] !=
        null;
    defines['HAS_TANGENTS'] = primitive.attributes['TANGENT'] != null;
    defines['HAS_UV'] = primitive.attributes['TEXCOORD_0'] != null;

    //Material base infos
    defines['HAS_NORMALMAP'] = baseMaterial.normalTexture != null;
    defines['HAS_EMISSIVEMAP'] = baseMaterial.emissiveTexture != null;
    defines['HAS_OCCLUSIONMAP'] = baseMaterial.occlusionTexture != null;

    //Material pbr infos
    defines['HAS_BASECOLORMAP'] =
        baseMaterial.pbrMetallicRoughness.baseColorTexture != null;
    defines['HAS_METALROUGHNESSMAP'] =
        baseMaterial.pbrMetallicRoughness.metallicRoughnessTexture != null;

    //debug jpu
    defines['DEBUG_VS'] = false;
    defines['DEBUG_FS'] = false;

    return defines;
  }

  void setUniforms(WebGLProgram program, Matrix4 modelMatrix, Matrix4 viewMatrix, Matrix4 projectionMatrix) {
    //debugLog.logCurrentFunction();

    _setUniform(program, 'u_ModelMatrix', ShaderVariableType.FLOAT_MAT4,
        modelMatrix.storage);
    _setUniform(program, 'u_ViewMatrix', ShaderVariableType.FLOAT_MAT4,
        viewMatrix.storage);
    _setUniform(program, 'u_ProjectionMatrix', ShaderVariableType.FLOAT_MAT4,
        projectionMatrix.storage);

    _setUniform(program, 'u_MVPMatrix', ShaderVariableType.FLOAT_MAT4,
        ((projectionMatrix * viewMatrix * modelMatrix) as Matrix4).storage);

    // > camera
    _setUniform(program, 'u_Camera', ShaderVariableType.FLOAT_VEC3,
        mainCamera.position.storage);

    // > Light
    _setUniform(program, 'u_LightDirection', ShaderVariableType.FLOAT_VEC3,
        lightDirection.storage);

    _setUniform(program, 'u_LightColor', ShaderVariableType.FLOAT_VEC3,
        (lightColor * 2.0).storage);

    // > Material base

    if (defines['USE_IBL']) {
      _setUniform(program, 'u_brdfLUT', ShaderVariableType.SAMPLER_2D,
          new Int32List.fromList([0]));
      _setUniform(program, 'u_DiffuseEnvSampler', ShaderVariableType.SAMPLER_CUBE,
          new Int32List.fromList([1]));
      _setUniform(program, 'u_SpecularEnvSampler', ShaderVariableType.SAMPLER_CUBE,
          new Int32List.fromList([2]));
    }

    if (defines['HAS_NORMALMAP']) {
      _setUniform(program, 'u_NormalSampler', ShaderVariableType.SAMPLER_2D,
          new Int32List.fromList([baseMaterial.normalTexture.texture.textureId + skipTexture]));
      double normalScale = baseMaterial.normalTexture.scale != null
          ? baseMaterial.normalTexture.scale
          : 1.0;
      _setUniform(program, 'u_NormalScale', ShaderVariableType.FLOAT,
          new Float32List.fromList([normalScale]));
    }

    if (defines['HAS_EMISSIVEMAP']) {
      _setUniform(
          program,
          'u_EmissiveSampler',
          ShaderVariableType.SAMPLER_2D,
          new Int32List.fromList(
              [baseMaterial.emissiveTexture.texture.textureId + skipTexture]));
      _setUniform(program, 'u_EmissiveFactor', ShaderVariableType.FLOAT_VEC3,
          new Float32List.fromList(baseMaterial.emissiveFactor));
    }

    if (defines['HAS_OCCLUSIONMAP']) {
      _setUniform(
          program,
          'u_OcclusionSampler',
          ShaderVariableType.SAMPLER_2D,
          new Int32List.fromList(
              [baseMaterial.occlusionTexture.texture.textureId + skipTexture]));
      double occlusionStrength = baseMaterial.occlusionTexture.strength != null
          ? baseMaterial.occlusionTexture.strength
          : 1.0;
      _setUniform(program, 'u_OcclusionStrength', ShaderVariableType.FLOAT,
          new Float32List.fromList([occlusionStrength]));
    }

    // > Material pbr

    if (defines['HAS_BASECOLORMAP']) {
      _setUniform(
          program,
          'u_BaseColorSampler',
          ShaderVariableType.SAMPLER_2D,
          new Int32List.fromList([
            baseMaterial.pbrMetallicRoughness.baseColorTexture.texture.textureId + skipTexture
          ]));
    }

    if (defines['HAS_METALROUGHNESSMAP']) {
      _setUniform(
          program,
          'u_MetallicRoughnessSampler',
          ShaderVariableType.SAMPLER_2D,
          new Int32List.fromList([
            baseMaterial.pbrMetallicRoughness.metallicRoughnessTexture.texture
                .textureId + skipTexture
          ]));
    }

    double roughness = baseMaterial.pbrMetallicRoughness.roughnessFactor;
    double metallic = baseMaterial.pbrMetallicRoughness.metallicFactor;
    _setUniform(
        program,
        'u_MetallicRoughnessValues',
        ShaderVariableType.FLOAT_VEC2,
        new Float32List.fromList([metallic, roughness]));

    _setUniform(program, 'u_BaseColorFactor', ShaderVariableType.FLOAT_VEC4,
        baseMaterial.pbrMetallicRoughness.baseColorFactor);

    // > Debug values => see in pbr fragment shader

    double specularReflectionMask = 0.0;
    double geometricOcclusionMask = 0.0;
    double microfacetDistributionMask = 0.0;
    double specularContributionMask = 0.0;
    _setUniform(
        program,
        'u_ScaleFGDSpec',
        ShaderVariableType.FLOAT_VEC4,
        new Float32List.fromList([
          specularReflectionMask,
          geometricOcclusionMask,
          microfacetDistributionMask,
          specularContributionMask
        ]));

    double diffuseContributionMask = 0.0;
    double colorMask = 0.0;
    double metallicMask = 0.0;
    double roughnessMask = 0.0;
    _setUniform(
        program,
        'u_ScaleDiffBaseMR',
        ShaderVariableType.FLOAT_VEC4,
        new Float32List.fromList([
          diffuseContributionMask,
          colorMask,
          metallicMask,
          roughnessMask
        ]));

    double diffuseIBLAmbient = 1.0;
    double specularIBLAmbient = 1.0;
    _setUniform(program, 'u_ScaleIBLAmbient', ShaderVariableType.FLOAT_VEC4,
        new Float32List.fromList([
          diffuseIBLAmbient,
          specularIBLAmbient,
          1.0,
          1.0
        ]));
  }
}

class KronosDefaultMaterial extends RawMaterial{
  final GLTFDefaultMaterial baseMaterial;
  KronosDefaultMaterial(this.baseMaterial);

  ShaderSource get shaderSource => ShaderSource.sources['kronos_gltf_default'];

  Map<String, bool> getDefines() {
    //debugLog.logCurrentFunction();

    // Todo (jpu) : enable defines if needed

    Map<String, bool> defines = new Map();

    defines['USE_IBL'] = false;
    defines['USE_TEX_LOD'] = false;

    //primitives infos
    defines['HAS_NORMALS'] = false;
    defines['HAS_TANGENTS'] = false;
    defines['HAS_UV'] = false;

    //Material base infos
    defines['HAS_NORMALMAP'] = false;
    defines['HAS_EMISSIVEMAP'] = false;
    defines['HAS_OCCLUSIONMAP'] = false;

    //Material infos
    defines['HAS_BASECOLORMAP'] = false;
    defines['HAS_METALROUGHNESSMAP'] = false;

    //debug jpu
    defines['DEBUG_VS'] = false;
    defines['DEBUG_FS'] = false;

    return defines;
  }

  void setUniforms(WebGLProgram program, Matrix4 modelMatrix, Matrix4 viewMatrix, Matrix4 projectionMatrix) {
    //debugLog.logCurrentFunction();

    _setUniform(program, 'u_ModelMatrix', ShaderVariableType.FLOAT_MAT4,
        modelMatrix.storage);
    _setUniform(program, 'u_ViewMatrix', ShaderVariableType.FLOAT_MAT4,
        viewMatrix.storage);
    _setUniform(program, 'u_ProjectionMatrix', ShaderVariableType.FLOAT_MAT4,
        projectionMatrix.storage);
    _setUniform(program, 'u_MVPMatrix', ShaderVariableType.FLOAT_MAT4,
        ((projectionMatrix * viewMatrix * modelMatrix) as Matrix4).storage);

    Matrix3 normalMatrix = (mainCamera.viewMatrix * modelMatrix).getNormalMatrix() as Matrix3;
    _setUniform(program, 'u_NormalMatrix', ShaderVariableType.FLOAT_MAT3,
        normalMatrix.storage);

    _setUniform(program, 'u_LightPos', ShaderVariableType.FLOAT_VEC3,
        lightPosition.storage);
  }

}

class GLTFDefaultMaterial {
}

class DebugMaterial extends RawMaterial{
  Vector3 color = new Vector3(0.5, 0.5, 0.5);

  DebugMaterial();

  ShaderSource get shaderSource => ShaderSource.sources['debug_shader'];

  Map<String, bool> getDefines() {
    //debugLog.logCurrentFunction();

    Map<String, bool> defines = new Map();

    //primitives infos
    defines['HAS_COLORS'] = false;
    defines['HAS_NORMALS'] = true;
    defines['HAS_TANGENTS'] = false;
    defines['HAS_UV'] = false;

    //debug jpu
    defines['DEBUG_VS'] = false;
    defines['DEBUG_FS_POSITION'] = false;
    defines['DEBUG_FS_NORMALS'] = defines['HAS_NORMALS'] && false;
    defines['DEBUG_FS_UV'] = defines['HAS_UV'] && false;

    return defines;
  }

  void setUniforms(WebGLProgram program, Matrix4 modelMatrix, Matrix4 viewMatrix, Matrix4 projectionMatrix) {
    //debugLog.logCurrentFunction();

    _setUniform(program, 'u_ModelMatrix', ShaderVariableType.FLOAT_MAT4,
        modelMatrix .storage);
    _setUniform(program, 'u_ViewMatrix', ShaderVariableType.FLOAT_MAT4,
        viewMatrix.storage);
    _setUniform(program, 'u_ProjectionMatrix', ShaderVariableType.FLOAT_MAT4,
        projectionMatrix.storage);

    _setUniform(program, 'u_Color', ShaderVariableType.FLOAT_VEC3,
        color.storage);
//    _setUniform(program, 'u_LightPos', ShaderVariableType.FLOAT_VEC3,
//        lightPosition.storage);
  }

}